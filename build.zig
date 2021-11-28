const std = @import("std");

const Sdk = @import("Sdk.zig");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const static_lib = Sdk.createStaticLibrary(b, target, mode);
    static_lib.install();

    const dynamic_lib = Sdk.createSharedLibrary(b, target, mode);
    dynamic_lib.install();

    const common_targets = [_]std.zig.CrossTarget{
        std.zig.CrossTarget.parse(.{ .arch_os_abi = "x86_64-windows-gnu" }) catch unreachable,
        std.zig.CrossTarget.parse(.{ .arch_os_abi = "x86_64-linux-gnu" }) catch unreachable,
        std.zig.CrossTarget.parse(.{ .arch_os_abi = "x86_64-linux-musl" }) catch unreachable,
        std.zig.CrossTarget.parse(.{ .arch_os_abi = "x86_64-macos" }) catch unreachable,
        std.zig.CrossTarget.parse(.{ .arch_os_abi = "aarch64-linux" }) catch unreachable,
        std.zig.CrossTarget.parse(.{ .arch_os_abi = "aarch64-macos" }) catch unreachable,
    };
    const build_all = b.step("all", "Builds the libraries for a set of common targets");
    for (common_targets) |cross_target| {
        const slib = Sdk.createStaticLibrary(b, cross_target, mode);
        const dlib = Sdk.createSharedLibrary(b, cross_target, mode);

        build_all.dependOn(&slib.step);
        build_all.dependOn(&dlib.step);
    }
}
