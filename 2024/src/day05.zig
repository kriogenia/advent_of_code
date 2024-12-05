const std = @import("std");
const util = @import("util.zig");
const gpa = util.gpa;

const List = std.ArrayList;
const Map = std.AutoHashMap;

pub fn main() !void {
    const input = try parse("input/day05.txt");
    std.debug.print("ordered: {d}\n", .{try sumValidUpdateMedian(&input[0], &input[1])});
}

test "05" {
    const input = try parse("examples/day05.txt");
    try std.testing.expectEqual(143, try sumValidUpdateMedian(&input[0], &input[1]));
}

fn sumValidUpdateMedian(rules: *const Map(u8, List(u8)), updates: *const List([]u8)) !u32 {
    var sum: u32 = 0;
    for (updates.items) |update| {
        if (try validateUpdate(rules, update)) {
            sum += update[update.len / 2];
        }
    }
    return sum;
}

fn validateUpdate(rules: *const Map(u8, List(u8)), update: []u8) !bool {
    var validated = Map(u8, void).init(gpa);
    for (update) |page| {
        try validated.put(page, {});
        const followers = rules.*.get(page) orelse continue;
        for (followers.items) |follower| {
            if (validated.contains(follower)) {
                return false;
            }
        }
    }
    return true;
}

fn parse(filename: []const u8) !struct { Map(u8, List(u8)), List([]u8) } {
    var rules = Map(u8, List(u8)).init(gpa);
    var updates = List([]u8).init(gpa);

    var lines = std.mem.splitScalar(u8, try util.readInputFile(filename), '\n');
    while (lines.next()) |rule| {
        if (rule.len == 0) break;

        var pages = std.mem.splitScalar(u8, rule, '|');
        const before = try parsePage(pages.next().?);
        const after = try parsePage(pages.next().?);

        const result = try rules.getOrPut(before);
        if (result.found_existing) {
            try result.value_ptr.*.append(after);
        } else {
            var list = List(u8).init(gpa);
            try list.append(after);
            result.value_ptr.* = list;
        }
    }

    while (lines.next()) |update| {
        if (update.len == 0) break;

        var pages = std.mem.splitScalar(u8, update, ',');

        var sequence = List(u8).init(gpa);
        while (pages.next()) |page| {
            try sequence.append(try parsePage(page));
        }

        try updates.append(try sequence.toOwnedSlice());
    }

    return .{ rules, updates };
}

fn parsePage(slice: []const u8) !u8 {
    return std.fmt.parseInt(u8, slice, 10);
}
