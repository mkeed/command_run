const std = @import("std");
const String = std.ArrayList(u8);

pub const Proc = struct {
    path: String,
    args: std.ArrayList(String),

    pub fn init(path: []const u8, args: []const []const u8) !Proc {
        var self = Proc{
            .path = String.init(alloc),
            .args = std.ArrayList(String).init(alloc),
        };
        errdefer self.deinit();
        try self.path.append(path);
        for (args) |a| {
            var s = String.init(alloc);
            errdefer s.deinit();
            try s.append(a);
            try self.args.append(s);
        }
        return self;
    }
    pub fn deinit(self: *Proc) void {
        self.path.deinit();
        for (self.args.items) |a| a.deinit();
        self.args.deinit();
    }

    pub const SpawnOpts = struct {
        stdin: std.posix.fd_t,
        stdout: std.posix.fd_t,
        stderr: std.posix.fd_t,
    };

    pub fn spawn(
        self: Proc,
        opts: SpawnOpts,
    ) !void {
        const pid = try std.posix.fork();
    }
};
