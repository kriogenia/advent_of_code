const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

pub fn main() !void {
    const input = try parse("input/day01.txt");
    defer input[0].deinit();
    defer input[1].deinit();

    const a = try run_a(input);
    std.debug.print("a: {d}\n", .{a});
    const b = try run_b(input);
    std.debug.print("b: {d}\n", .{b});
}

test "01-a" {
    const input = try parse("examples/day01.txt");
    defer input[0].deinit();
    defer input[1].deinit();

    try expect(try run_a(input) == 11);
    try expect(try run_b(input) == 31);
}

pub fn run_a(input: [2]List(i32)) !i32 {
    for (input) |list| {
        sort(i32, list.items, {}, comptime asc(i32));
    }

    var sum: i32 = 0;
    for (input[0].items, input[1].items) |left, right| {
        const diff = if (left <= right) right - left else left - right;
        sum += diff;
    }

    return sum;
}

pub fn run_b(input: [2]List(i32)) !i32 {
    var cache = Map(i32, i32).init(gpa);

    var sum: i32 = 0;
    for (input[0].items) |item| {
        var total = cache.get(item);
        if (total == null) {
            const occurrences: i32 = @intCast(count(i32, input[1].items, &[_]i32{item}));
            _ = try cache.put(item, occurrences);
            total = occurrences;
        }
        sum += item * total.?;
    }

    return sum;
}

pub fn parse(puzzle: []const u8) !struct { List(i32), List(i32) } {
    var leftList = List(i32).init(gpa);
    var rightList = List(i32).init(gpa);

    var it = splitSca(u8, try util.readInputFile(puzzle), '\n');
    while (it.next()) |line| {
        if (line.len == 0) break;
        var parts = splitSeq(u8, line, "   ");
        const left = try parseInt(i32, parts.next().?, 10);
        try leftList.append(left);
        const right = try parseInt(i32, parts.next().?, 10);
        try rightList.append(right);
    }

    return .{ leftList, rightList };
}

// Useful stdlib functions
const tokenizeAny = std.mem.tokenizeAny;
const tokenizeSeq = std.mem.tokenizeSequence;
const tokenizeSca = std.mem.tokenizeScalar;
const splitAny = std.mem.splitAny;
const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;
const indexOf = std.mem.indexOfScalar;
const count = std.mem.count;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.block;
const asc = std.sort.asc;
const desc = std.sort.desc;

const expect = std.testing.expect;

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
