const std = @import("std");
const ArgParse = @import("ArgParse.zig");

pub const CommandRunOpts = struct {
    pub fn init(alloc: std.mem.Allocator) CommandRunOpts {
        _ = alloc;
        return CommandRunOpts{};
    }
    pub fn deinit(self: CommandRunOpts) void {
        _ = self;
    }
    version: bool = false,
    dry_run: bool = false,
    @"test": bool = false,
    port: ?isize = null,
};

const definition = ArgParse.ProgDef{
    .name = "command_run",
    .opts = &.{
        .{
            .field_name = "version",
            .long_opt = "--version",
            .short_opt = 'v',
        },
        .{
            .field_name = "dry_run",
            .long_opt = "--dry-run",
        },
        .{
            .field_name = "test",
            .long_opt = "--test",
            .short_opt = 't',
        },
        //.{
        //.field_name = "port",
        //.long_opt = "--port",
        //.short_opt = 'p',
        //},
    },
    .T = CommandRunOpts,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();
    const opts = try ArgParse.runOpt(definition, alloc);
    defer opts.deinit();
    std.log.info("[{}]", .{opts});
}
