const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

pub fn main() !void {
    const result = try run("input/day01.txt");
    std.debug.print("{d}\n", .{result});
}

test "01-a" {
    try expect(try run("examples/day01.txt") == 11);
}

pub fn run(filename: []const u8) !i32 {
    const file = try util.readInputFile(filename);
    const input = try parse(file);
    for (input) |list| {
        sort(i32, list.items, {}, comptime asc(i32));
    }

    var sum: i32 = 0;
    for (input[0].items, input[1].items) |left, right| {
        const diff = if (left <= right) right - left else left - right;
        sum += diff;
    }

    input[0].deinit();
    input[1].deinit();
    return sum;
}

pub fn parse(puzzle: []const u8) ![2]List(i32) {
    var leftList = List(i32).init(gpa);
    var rightList = List(i32).init(gpa);

    var it = splitSca(u8, puzzle, '\n');
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
