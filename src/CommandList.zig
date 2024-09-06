const std = @import("std");
const Proc = @import("Proc");

pub const CommandList = struct {
    cmds: []const Command,
};

pub const Command = struct {
    procs: []const Proc,
    input: File,
    output: File,
    err: []const ?File,
};

pub const File = union(enum) {
    stderr: void,
    stdin: void,
    stdout: void,
    file: std.posix.fd_t,
};
