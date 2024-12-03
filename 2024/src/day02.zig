const std = @import("std");
const util = @import("util.zig");
const gpa = util.gpa;

const List = std.ArrayList;

const print = std.debug.print;

const parseInt = std.fmt.parseInt;

const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;

const asc = std.sort.asc(i32);
const desc = std.sort.desc(i32);

const expect = std.testing.expect;

pub fn main() !void {
    const input = try parse("input/day02.txt");
    defer input.deinit();

    print("safe: {d}", .{try countSafeReports(input)});
}

test "02a" {
    const input = try parse("examples/day02.txt");
    defer input.deinit();

    try expect(try countSafeReports(input) == 2);
}

pub fn countSafeReports(input: List([]i32)) !i32 {
    var count: i32 = 0;
    for (input.items) |report| {
        count += if (isValid(report)) 1 else 0;
    }

    return count;
}

test "isValid" {
    const valid = [5]i32{ 7, 6, 4, 2, 1 };
    try expect(isValid(&valid) == true);
    const unsortedDesc = [5]i32{ 7, 4, 6, 2, 1 };
    try expect(isValid(&unsortedDesc) == false);
    const unsortedAsc = [5]i32{ 7, 8, 6, 2, 1 };
    try expect(isValid(&unsortedAsc) == false);
    const tooMuchDiff = [4]i32{ 7, 6, 2, 1 };
    try expect(isValid(&tooMuchDiff) == false);
    const notEnoughDiff = [4]i32{ 7, 6, 6, 5 };
    try expect(isValid(&notEnoughDiff) == false);
}

pub fn isValid(report: []const i32) bool {
    const sorter: *const fn (void, i32, i32) bool = if (report[0] < report[1]) desc else asc;
    var i: usize = 1;
    while (i < report.len) : (i += 1) {
        if (sorter({}, report[i - 1], report[i])) {
            return false;
        }
        const diff = @abs(report[i - 1] - report[i]);
        if (diff < 1 or diff > 3) {
            return false;
        }
    }

    return true;
}

pub fn parse(puzzle: []const u8) !List([]i32) {
    var reports = List([]i32).init(gpa);

    var lines = splitSca(u8, try util.readInputFile(puzzle), '\n');
    while (lines.next()) |line| {
        if (line.len == 0) break;
        var levels = List(i32).init(gpa);

        var it = splitSeq(u8, line, " ");
        while (it.next()) |level| {
            _ = try levels.append(try parseInt(i32, level, 10));
        }

        _ = try reports.append(try levels.toOwnedSlice());
    }

    return reports;
}
