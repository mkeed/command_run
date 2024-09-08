const test1 = Command{
    .pipeline = &.{
        .{
            .cmd = "grep",
            .args = &.{ raw("-RIn"), fmtStr("{grep_pattern}"), fmtStr("{location}") },
        },
    },
    .in = .dev_null,
    .err = .dev_null,
};
