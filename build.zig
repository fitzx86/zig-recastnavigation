const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Create the C/C++ module for the recastnavigation library
    const c_module = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = true,
    });

    c_module.addIncludePath(b.path("Recast/Include"));
    c_module.addIncludePath(b.path("Detour/Include"));
    c_module.addIncludePath(b.path("DetourTileCache/Include"));
    c_module.addIncludePath(b.path("DetourCrowd/Include"));

    c_module.addCSourceFiles(.{
        .files = &.{
            // Recast
            "Recast/Include/Recast_glue.cpp",
            "Recast/Source/Recast.cpp",
            "Recast/Source/RecastAlloc.cpp",
            "Recast/Source/RecastArea.cpp",
            "Recast/Source/RecastAssert.cpp",
            "Recast/Source/RecastContour.cpp",
            "Recast/Source/RecastFilter.cpp",
            "Recast/Source/RecastLayers.cpp",
            "Recast/Source/RecastMesh.cpp",
            "Recast/Source/RecastMeshDetail.cpp",
            "Recast/Source/RecastRasterization.cpp",
            "Recast/Source/RecastRegion.cpp",
            // Detour
            "Detour/Include/DetourAlloc_glue.cpp",
            "Detour/Include/DetourAssert_glue.cpp",
            "Detour/Include/DetourCommon_glue.cpp",
            "Detour/Include/DetourNavMesh_glue.cpp",
            "Detour/Include/DetourNavMeshBuilder_glue.cpp",
            "Detour/Include/DetourNavMeshQuery_glue.cpp",
            "Detour/Include/DetourNode_glue.cpp",
            "Detour/Include/DetourStatus_glue.cpp",
            "Detour/Source/DetourAlloc.cpp",
            "Detour/Source/DetourAssert.cpp",
            "Detour/Source/DetourCommon.cpp",
            "Detour/Source/DetourNavMesh.cpp",
            "Detour/Source/DetourNavMeshBuilder.cpp",
            "Detour/Source/DetourNavMeshQuery.cpp",
            "Detour/Source/DetourNode.cpp",
            // Detour Tile Cache
            "DetourTileCache/Include/DetourTileCache_glue.cpp",
            "DetourTileCache/Include/DetourTileCacheBuilder_glue.cpp",
            "DetourTileCache/Source/DetourTileCache.cpp",
            "DetourTileCache/Source/DetourTileCacheBuilder.cpp",
            // Detour Crowd
            "DetourCrowd/Include/DetourPathCorridor_glue.cpp",
            "DetourCrowd/Source/DetourPathCorridor.cpp",
        },
        .flags = &.{},
    });

    // Create the static library from the C module
    const zignav_c_cpp = b.addLibrary(.{
        .name = "zignav_c_cpp",
        .root_module = c_module,
        .linkage = .static,
    });

    b.installArtifact(zignav_c_cpp);

    // Create the Zig module that wraps the C library
    const zignav = b.addModule("zignav", .{
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
    });

    zignav.linkLibrary(zignav_c_cpp);
}
