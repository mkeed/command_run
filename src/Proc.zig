const std = @import("std");

pub const LaunchOpts = struct {
    progs: []const LaunchProg,
    in: ?std.posix.fd_t,
    out: ?std.posix.fd_t,
    err: ?union(enum) {
        per_proc: []const std.posix.fd_t,
        one: std.posix.fd_t,
    },
};

//fn setup_fds(opts: LaunchOpts,

pub fn launch(opts: LaunchOpts, alloc: std.mem.Allocator) !LaunchReult {
    if (opts.err) |e| {
        switch (e) {
            .per_proc => |p| std.debug.assert(p.len == opts.progs.len),
            else => {},
        }
    }

    for (opts.progs, 0..) |p, idx| {
        try setup_fds(opts, idx);
    }
}
