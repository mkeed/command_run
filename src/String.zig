const std = @import("std");

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
    };
    pub fn next(self: *fmtIter) !?Value {
        if (self.index >= self.text.len) return null;
        if (std.mem.indexOf(u8, self.text[self.index..], "{")) |index| {
            //
        } else {
            defer self.index += self.text[self.index..].len;
            return .{ .txt = self.text[self.index..] };
        }
    }
};

pub fn format(fmtStr: []const u8, alloc: std.mem.Allocator, dict: Dict) !String {
    var str = String.init(alloc);
    errdefer str.deinit();

    return str;
}

test {
    const fmtstrs = [_][]const u8{
        "Hello {name}",
    };
}
