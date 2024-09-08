const std = @import("std");
const Dict = @import("Dict.zig").Dict;

pub const String = struct {
    data: std.ArrayList(u8),

    pub fn init(alloc: std.mem.Allocator) String {
        return String{
            .data = std.ArrayList(u8).init(alloc),
        };
    }
    pub fn deinit(self: String) void {
        self.data.deinit();
    }
};

const fmtIter = struct {
    text: []const u8,
    index: usize = 0,

    const Value = union(enum) {
        txt: []const u8,
        fmt: []const u8,
        pub fn format(self: Value, _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
            switch (self) {
                .txt => |t| try std.fmt.format(writer, "txt:[{s}]", .{t}),
                .fmt => |t| try std.fmt.format(writer, "fmt:[{s}]", .{t}),
            }
        }
    };
    pub fn next(self: *fmtIter) !?Value {
        if (self.index >= self.text.len) return null;
        if (self.text[self.index] == '{') {
            if (std.mem.indexOf(u8, self.text[self.index..], "}")) |end_index| {
                defer self.index += end_index + 1;
                return .{ .fmt = self.text[self.index..][1..end_index] };
            } else {
                return error.missing_end_brace;
            }
        }
        if (std.mem.indexOf(u8, self.text[self.index..], "{")) |index| {
            defer self.index += index;
            return .{ .txt = self.text[self.index..][0..index] };
        } else {
            defer self.index += self.text[self.index..].len;
            return .{ .txt = self.text[self.index..] };
        }
    }
};

pub fn format(fmtStr: []const u8, alloc: std.mem.Allocator, dict: Dict) !String {
    var str = String.init(alloc);
    errdefer str.deinit();
    var iter = fmtIter{ .text = fmtStr };
    while (try iter.next()) |item| {
        switch (item) {
            .fmt => |f| {
                if (dict.get(f)) |d| {
                    try str.data.appendSlice(d);
                } else {
                    return error.MissingKey;
                }
            },
            .txt => |t| {
                try str.data.appendSlice(t);
            },
        }
    }
    return str;
}

test {
    const fmtstrs = [_][]const u8{
        "Hello {name}",
        "Hello {name} ",
        "{name}Hello {name} ",
        "{name}{name} ",
    };
    var dict = Dict.init(std.testing.allocator);
    defer dict.deinit();
    try dict.push("name", "Test1");
    for (fmtstrs) |f| {
        var str = try format(f, std.testing.allocator, dict);
        defer str.deinit();
        std.log.err("{s}", .{str.data.items});
    }
}
