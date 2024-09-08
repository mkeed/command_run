const std = @import("std");
const Proc = @import("Proc");

pub const File = union(enum) {
    std_in: void,
    std_out: void,
    std_err: void,
};

pub const Command = struct {
    pipeline: []const Proc,
    in: File = .std_in,
    out: File = .std_out,
    err: File = .std_err,
};
