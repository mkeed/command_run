const std = @import("std");

pub const Dict = struct {
    const Item = struct {
        name: std.ArrayList(u8),
        value: std.ArrayList(u8),
        pub fn init(alloc: std.mem.Allocator) Item {
            return .{
                .name = std.ArrayList(u8).init(alloc),
                .value = std.ArrayList(u8).init(alloc),
            };
        }
        pub fn deinit(self: Item) void {
            self.value.deinit();
            self.name.deinit();
        }
    };
    alloc: std.mem.Allocator,
    items: std.ArrayList(Item),

    pub fn init(alloc: std.mem.Allocator) Dict {
        return .{
            .alloc = alloc,
            .items = std.ArrayList(Item).init(alloc),
        };
    }
    pub fn deinit(self: Dict) void {
        for (self.items.items) |i| i.deinit();
        self.items.deinit();
    }

    pub fn push(self: *Dict, name: []const u8, value: []const u8) !void {
        if (self.findMut(name)) |val| {
            val.value.clearRetainingCapacity();
            try val.value.appendSlice(value);
        } else {
            var item = Item.init(self.alloc);
            errdefer item.deinit();
            try item.name.appendSlice(name);
            try item.value.appendSlice(value);
            try self.items.append(item);
        }
    }
    pub fn findMut(self: *Dict, name: []const u8) ?*Item {
        for (self.items.items) |*i| {
            if (std.mem.eql(u8, i.name.items, name)) {
                return i;
            }
        }
        return null;
    }
    pub fn get(self: Dict, key: []const u8) ?[]const u8 {
        for (self.items.items) |i| {
            if (std.mem.eql(u8, i.name.items, key)) {
                return i.value.items;
            }
        }
        return null;
    }
};

test {
    var dict = Dict.init(std.testing.allocator);
    defer dict.deinit();
    try dict.push("name", "Test1");
    try dict.push("name2", "Test2");

    if (dict.get("name")) |n| {
        std.log.err("name:[{s}]", .{n});
    }
    try dict.push("name", "Test12");
    if (dict.get("name")) |n| {
        std.log.err("name:[{s}]", .{n});
    }
}
