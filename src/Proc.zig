const std = @import("std");

pub const LaunchOpts = struct {
    prog: []const u8,
    args: []const [:0]const u8,
    stdin: ?std.posix.fd_t = null,
    stdout: ?std.posix.fd_t = null,
    stderr: ?std.posix.fd_t = null,
};

pub const LaunchResult = struct {};

pub fn launch(
    opts: LaunchOpts,
    alloc: std.mem.Allocator,
) !LaunchResult {}
