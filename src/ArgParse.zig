const std = @import("std");

pub const ProgDef = struct {
    //name: []const u8,
    //opts: []const ArgOpt,
};

pub fn genOpt(comptime T: type) ProgDef {
    const info = @typeInfo(T).Struct;
    for (info.fields) |f| {
        _ = f;
        //std.log.err("{}", .{f});
    }

    return .{};
}

const testProg = struct {
    file: []const u8 = "/tmp/testProg.thing",
    level: usize = 0,
};

test {
    _ = comptime genOpt(testProg);
}
