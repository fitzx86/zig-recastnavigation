const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const zignav = b.dependency("zignav", .{});

    const exe = b.addExecutable(.{
        .name = "ZigNavDemo",
        .root_module = b.createModule(.{
            .root_source_file = b.path("demo.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "zignav", .module = zignav.module("zignav") },
            },
        }),
    });

    exe.linkLibrary(zignav.artifact("zignav_c_cpp"));

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
