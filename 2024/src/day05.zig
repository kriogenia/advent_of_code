const std = @import("std");
const util = @import("util.zig");
const gpa = util.gpa;

const List = std.ArrayList;
const Map = std.AutoHashMap;

pub fn main() !void {
    const input = try parse("input/day05.txt");
    std.debug.print("valid: {d}\ninvalid: {d}\n", try sumUpdateMedian(&input[0], &input[1]));
}

test "05" {
    const input = try parse("examples/day05.txt");
    const result = try sumUpdateMedian(&input[0], &input[1]);
    try std.testing.expectEqual(143, result.valid);
    try std.testing.expectEqual(123, result.invalid);
}

fn sumUpdateMedian(rules: *const Map(u8, List(u8)), updates: *const List([]u8)) !struct { valid: u32, invalid: u32 } {
    var valid: u32 = 0;
    var invalid: u32 = 0;
    for (updates.items) |update| {
        if (try validateUpdate(rules, update)) {
            valid += update[update.len / 2];
        } else {
            invalid += (try orderUpdate(rules, update))[update.len / 2];
        }
    }
    return .{ .valid = valid, .invalid = invalid };
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

fn orderUpdate(rules: *const Map(u8, List(u8)), update: []u8) ![]u8 {
    var slice = update;
    var i: usize = 1;
    while (i < slice.len) : (i += 1) {
        const followers = rules.*.get(slice[i]) orelse continue;
        for (followers.items) |follower| {
            const wrong = std.mem.indexOfScalar(u8, slice[0..i], follower) orelse continue;
            std.mem.swap(u8, &slice[wrong], &slice[i]);
            i = wrong;
        }
    }
    return slice;
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
