const std = @import("std");

fn sdkRoot() []const u8 {
    return std.fs.path.dirname(@src().file) orelse unreachable;
}

const sdk_root = sdkRoot();

pub fn getIncludePaths() []const []const u8 {
    const paths = [_][]const u8{
        sdk_root ++ "/include",
        sdk_root ++ "/vendor/mbedtls/include",
    };
    return &paths;
}

pub fn createStaticLibrary(b: *std.build.Builder, target: std.zig.CrossTarget, build_mode: std.builtin.Mode) *std.build.LibExeObjStep {
    const lib = b.addStaticLibrary("mbedtls", null);
    lib.setTarget(target);
    lib.setBuildMode(build_mode);
    initialize(lib);
    return lib;
}

pub fn createSharedLibrary(b: *std.build.Builder, target: std.zig.CrossTarget, build_mode: std.builtin.Mode) *std.build.LibExeObjStep {
    const lib = b.addSharedLibrary("mbedtls", null, .{ .versioned = .{ .major = 3, .minor = 0, .patch = 0 } });
    lib.setTarget(target);
    lib.setBuildMode(build_mode);
    initialize(lib);
    return lib;
}

fn initialize(lib: *std.build.LibExeObjStep) void {
    // assume we have the target already set

    if (lib.target.isWindows()) {
        lib.linkSystemLibrary("ws2_32");
    }

    lib.linkLibC();
    for (getIncludePaths()) |path| {
        lib.addIncludeDir(path);
    }
    lib.addIncludeDir(sdk_root ++ "/vendor/mbedtls/library"); // required for some files
    lib.addCSourceFiles(&src_crypto, &cflags);
    lib.addCSourceFiles(&src_x509, &cflags);
    lib.addCSourceFiles(&src_tls, &cflags);
}

const cflags = [_][]const u8{
    "-Wmissing-declarations", "-Wmissing-prototypes", "-Wdocumentation", "-Wno-documentation-deprecated-sync", "-Wunreachable-code",
};

const src_crypto = [_][]const u8{
    sdk_root ++ "/vendor/mbedtls/library/aes.c",
    sdk_root ++ "/vendor/mbedtls/library/aesni.c",
    sdk_root ++ "/vendor/mbedtls/library/aria.c",
    sdk_root ++ "/vendor/mbedtls/library/asn1parse.c",
    sdk_root ++ "/vendor/mbedtls/library/asn1write.c",
    sdk_root ++ "/vendor/mbedtls/library/base64.c",
    sdk_root ++ "/vendor/mbedtls/library/bignum.c",
    sdk_root ++ "/vendor/mbedtls/library/camellia.c",
    sdk_root ++ "/vendor/mbedtls/library/ccm.c",
    sdk_root ++ "/vendor/mbedtls/library/chacha20.c",
    sdk_root ++ "/vendor/mbedtls/library/chachapoly.c",
    sdk_root ++ "/vendor/mbedtls/library/cipher.c",
    sdk_root ++ "/vendor/mbedtls/library/cipher_wrap.c",
    // sdk_root ++ "/vendor/mbedtls/library/constant_time.c",
    sdk_root ++ "/vendor/mbedtls/library/cmac.c",
    sdk_root ++ "/vendor/mbedtls/library/ctr_drbg.c",
    sdk_root ++ "/vendor/mbedtls/library/des.c",
    sdk_root ++ "/vendor/mbedtls/library/dhm.c",
    sdk_root ++ "/vendor/mbedtls/library/ecdh.c",
    sdk_root ++ "/vendor/mbedtls/library/ecdsa.c",
    sdk_root ++ "/vendor/mbedtls/library/ecjpake.c",
    sdk_root ++ "/vendor/mbedtls/library/ecp.c",
    sdk_root ++ "/vendor/mbedtls/library/ecp_curves.c",
    sdk_root ++ "/vendor/mbedtls/library/entropy.c",
    sdk_root ++ "/vendor/mbedtls/library/entropy_poll.c",
    sdk_root ++ "/vendor/mbedtls/library/error.c",
    sdk_root ++ "/vendor/mbedtls/library/gcm.c",
    sdk_root ++ "/vendor/mbedtls/library/hkdf.c",
    sdk_root ++ "/vendor/mbedtls/library/hmac_drbg.c",
    sdk_root ++ "/vendor/mbedtls/library/md.c",
    sdk_root ++ "/vendor/mbedtls/library/md5.c",
    sdk_root ++ "/vendor/mbedtls/library/memory_buffer_alloc.c",
    sdk_root ++ "/vendor/mbedtls/library/mps_reader.c",
    sdk_root ++ "/vendor/mbedtls/library/mps_trace.c",
    sdk_root ++ "/vendor/mbedtls/library/nist_kw.c",
    sdk_root ++ "/vendor/mbedtls/library/oid.c",
    sdk_root ++ "/vendor/mbedtls/library/padlock.c",
    sdk_root ++ "/vendor/mbedtls/library/pem.c",
    sdk_root ++ "/vendor/mbedtls/library/pk.c",
    sdk_root ++ "/vendor/mbedtls/library/pk_wrap.c",
    sdk_root ++ "/vendor/mbedtls/library/pkcs12.c",
    sdk_root ++ "/vendor/mbedtls/library/pkcs5.c",
    sdk_root ++ "/vendor/mbedtls/library/pkparse.c",
    sdk_root ++ "/vendor/mbedtls/library/pkwrite.c",
    sdk_root ++ "/vendor/mbedtls/library/platform.c",
    sdk_root ++ "/vendor/mbedtls/library/platform_util.c",
    sdk_root ++ "/vendor/mbedtls/library/poly1305.c",
    sdk_root ++ "/vendor/mbedtls/library/psa_crypto.c",
    sdk_root ++ "/vendor/mbedtls/library/psa_crypto_aead.c",
    sdk_root ++ "/vendor/mbedtls/library/psa_crypto_cipher.c",
    sdk_root ++ "/vendor/mbedtls/library/psa_crypto_client.c",
    sdk_root ++ "/vendor/mbedtls/library/psa_crypto_driver_wrappers.c",
    sdk_root ++ "/vendor/mbedtls/library/psa_crypto_ecp.c",
    sdk_root ++ "/vendor/mbedtls/library/psa_crypto_hash.c",
    sdk_root ++ "/vendor/mbedtls/library/psa_crypto_mac.c",
    sdk_root ++ "/vendor/mbedtls/library/psa_crypto_rsa.c",
    sdk_root ++ "/vendor/mbedtls/library/psa_crypto_se.c",
    sdk_root ++ "/vendor/mbedtls/library/psa_crypto_slot_management.c",
    sdk_root ++ "/vendor/mbedtls/library/psa_crypto_storage.c",
    sdk_root ++ "/vendor/mbedtls/library/psa_its_file.c",
    sdk_root ++ "/vendor/mbedtls/library/ripemd160.c",
    sdk_root ++ "/vendor/mbedtls/library/rsa.c",
    sdk_root ++ "/vendor/mbedtls/library/rsa_alt_helpers.c",
    sdk_root ++ "/vendor/mbedtls/library/sha1.c",
    sdk_root ++ "/vendor/mbedtls/library/sha256.c",
    sdk_root ++ "/vendor/mbedtls/library/sha512.c",
    sdk_root ++ "/vendor/mbedtls/library/threading.c",
    sdk_root ++ "/vendor/mbedtls/library/timing.c",
    sdk_root ++ "/vendor/mbedtls/library/version.c",
    sdk_root ++ "/vendor/mbedtls/library/version_features.c",
};

const src_x509 = [_][]const u8{
    sdk_root ++ "/vendor/mbedtls/library/x509.c",
    sdk_root ++ "/vendor/mbedtls/library/x509_create.c",
    sdk_root ++ "/vendor/mbedtls/library/x509_crl.c",
    sdk_root ++ "/vendor/mbedtls/library/x509_crt.c",
    sdk_root ++ "/vendor/mbedtls/library/x509_csr.c",
    sdk_root ++ "/vendor/mbedtls/library/x509write_crt.c",
    sdk_root ++ "/vendor/mbedtls/library/x509write_csr.c",
};

const src_tls = [_][]const u8{
    sdk_root ++ "/vendor/mbedtls/library/debug.c",
    sdk_root ++ "/vendor/mbedtls/library/net_sockets.c",
    sdk_root ++ "/vendor/mbedtls/library/ssl_cache.c",
    sdk_root ++ "/vendor/mbedtls/library/ssl_ciphersuites.c",
    sdk_root ++ "/vendor/mbedtls/library/ssl_cli.c",
    sdk_root ++ "/vendor/mbedtls/library/ssl_cookie.c",
    sdk_root ++ "/vendor/mbedtls/library/ssl_msg.c",
    sdk_root ++ "/vendor/mbedtls/library/ssl_srv.c",
    sdk_root ++ "/vendor/mbedtls/library/ssl_ticket.c",
    sdk_root ++ "/vendor/mbedtls/library/ssl_tls.c",
    sdk_root ++ "/vendor/mbedtls/library/ssl_tls13_keys.c",
    // sdk_root ++ "/vendor/mbedtls/library/ssl_tls13_server.c",
    // sdk_root ++ "/vendor/mbedtls/library/ssl_tls13_client.c",
    // sdk_root ++ "/vendor/mbedtls/library/ssl_tls13_generic.c",
};
