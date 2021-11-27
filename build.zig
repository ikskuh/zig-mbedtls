const std = @import("std");

const Sdk = @import("Sdk.zig");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const static_lib = Sdk.createStaticLibrary(b, target, mode);
    static_lib.install();

    const dynamic_lib = Sdk.createSharedLibrary(b, target, mode);
    dynamic_lib.install();
}
