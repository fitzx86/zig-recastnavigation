pub const packages = struct {
    pub const @".." = struct {
        pub const build_root = "/home/fitzy/fun/zig-recastnavigation/zigsrc/..";
        pub const build_zig = @import("..");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "zignav", ".." },
};
