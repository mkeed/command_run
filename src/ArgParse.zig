const std = @import("std");

pub const ArgOpt = struct {
    field_name: []const u8,
    long_opt: []const u8,
    short_opt: ?u8 = null,
};

pub const ProgDef = struct {
    name: []const u8,
    opts: []const ArgOpt,
    T: type,
};
const SplitField = struct {
    opt: []const u8,
    value: ?[]const u8,
};

fn split_field(data: []const u8) SplitField {
    if (std.mem.indexOfScalar(u8, data, '=')) |idx| {
        return .{ .opt = data[0..idx], .value = data[idx + 1 ..] };
    } else {
        return .{ .opt = data, .value = null };
    }
}

fn handleField(comptime T: type, val: *T, comptime opt: ArgOpt, field: SplitField) !void {}

pub fn runOpt(comptime def: ProgDef, alloc: std.mem.Allocator) !def.T {
    var ret = def.T.init(alloc);
    errdefer ret.deinit();
    const args = try std.process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, args);
    var iter = argIter{ .args = args };
    while (iter.next()) |item| {
        inline for (def.opts) |opt| {
            const split = split_field(item);
            if (std.mem.eql(u8, opt.long_opt, split.opt)) {
                std.log.info("long[{s}|{?s}] {s}", .{ split.opt, split.value, opt.field_name });

                @field(ret, opt.field_name) = true;
            }
            if (opt.short_opt) |shopt| {
                const shopt_str = [2]u8{ '-', shopt };
                if (std.mem.eql(u8, &shopt_str, split.opt)) {
                    std.log.info("short[{s}] {s}", .{ item, opt.field_name });
                    @field(ret, opt.field_name) = true;
                }
            }
        }
    }

    return ret;
}

const argIter = struct {
    args: []const [:0]const u8,
    idx: usize = 0,
    shortIdx: ?usize = null,
    shortBuffer: [2]u8 = [2]u8{ 0, 0 },
    pub fn next(self: *argIter) ?[]const u8 {
        if (self.idx >= self.args.len) return null;
        if (self.shortIdx) |idx| {
            if (idx >= self.args[self.idx].len) {
                self.shortIdx = null;
                self.idx += 1;
            } else {
                defer self.shortIdx = idx + 1;
                self.shortBuffer[0] = '-';
                self.shortBuffer[1] = self.args[self.idx][idx];
                return self.shortBuffer[0..];
            }
        }
        if (self.idx >= self.args.len) return null;

        if (self.args[self.idx].len == 0) {
            defer self.idx += 1;
            return self.args[self.idx];
        } else if (self.args[self.idx][0] == '-') {
            if (self.args[self.idx][1] == '-') {
                defer self.idx += 1;
                return self.args[self.idx];
            } else {
                defer self.shortIdx = 2;
                self.shortBuffer[0] = '-';
                self.shortBuffer[1] = self.args[self.idx][1];
                return self.shortBuffer[0..];
            }
        } else {
            defer self.idx += 1;
            return self.args[self.idx];
        }
    }
};

test {
    var iter = argIter{
        .args = &.{
            "test",
            "--help",
            "-asd",
            "-a",
        },
    };
    while (iter.next()) |val| {
        std.log.err("{s}", .{val});
    }
}
