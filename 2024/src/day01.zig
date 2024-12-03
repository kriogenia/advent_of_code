const std = @import("std");
const List = std.ArrayList;
const Map = std.AutoHashMap;

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

test "01" {
    const input = try parse("examples/day01.txt");
    defer input[0].deinit();
    defer input[1].deinit();

    try expect(try run_a(input) == 11);
    try expect(try run_b(input) == 31);
}

pub fn run_a(input: [2]List(i32)) !u32 {
    for (input) |list| {
        sort(i32, list.items, {}, comptime asc(i32));
    }

    var sum: u32 = 0;
    for (input[0].items, input[1].items) |left, right| {
        sum += @abs(left - right);
    }

    return sum;
}

pub fn run_b(input: [2]List(i32)) !i32 {
    var cache = Map(i32, i32).init(gpa);

    var sum: i32 = 0;
    for (input[0].items) |item| {
        const total = try cache.getOrPut(item);
        if (!total.found_existing) {
            total.value_ptr.* = @intCast(count(i32, input[1].items, &[1]i32{item}));
        }
        sum += item * total.value_ptr.*;
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

const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;
const count = std.mem.count;

const parseInt = std.fmt.parseInt;

const print = std.debug.print;

const sort = std.sort.block;
const asc = std.sort.asc;

const expect = std.testing.expect;
