const std = @import("std");
const util = @import("util.zig");
const gpa = util.gpa;

const List = std.ArrayList;

const print = std.debug.print;

const parseInt = std.fmt.parseInt;

const eql = std.mem.eql;
const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;

const asc = std.sort.asc(i32);
const desc = std.sort.desc(i32);

const expect = std.testing.expect;

pub fn main() !void {
    const input = try parse("input/day02.txt");
    defer input.deinit();

    print("safe: {d}\n", .{try countSafeReports(input)});
    print("tolerated: {d}\n", .{try countSafeReportsWithDampener(input)});
}

test "02" {
    const input = try parse("examples/day02.txt");
    defer input.deinit();

    try expect(try countSafeReports(input) == 2);
    try expect(try countSafeReportsWithDampener(input) == 4);
}

pub fn countSafeReports(input: List([]i32)) !i32 {
    var count: i32 = 0;
    for (input.items) |report| {
        count += if (findBadWindow(report) == null) 1 else 0;
    }

    return count;
}

pub fn countSafeReportsWithDampener(input: List([]i32)) !i32 {
    var count: i32 = 0;
    for (input.items) |report| {
        var isValid = true;
        if (findBadWindow(report)) |badLevel| {
            const tolerationCandidates = try dampenReport(report, badLevel);
            isValid = findBadWindow(tolerationCandidates[0]) == null or findBadWindow(tolerationCandidates[1]) == null;
        }
        count += if (isValid) 1 else 0;
    }

    return count;
}

test "findBadWindow" {
    const valid = [5]i32{ 7, 6, 4, 2, 1 };
    try expect(findBadWindow(&valid) == null);
    const unsortedDesc = [5]i32{ 7, 4, 6, 2, 1 };
    try expect(findBadWindow(&unsortedDesc) == 1);
    const unsortedAsc = [5]i32{ 7, 8, 6, 9, 10 };
    try expect(findBadWindow(&unsortedAsc) == 1);
    const tooMuchDiff = [4]i32{ 7, 6, 2, 1 };
    try expect(findBadWindow(&tooMuchDiff) == 1);
    const notEnoughDiff = [4]i32{ 7, 6, 6, 5 };
    try expect(findBadWindow(&notEnoughDiff) == 1);
}

/// Checks the given slice and finds the index of the window that makes the level bad, if any
pub fn findBadWindow(report: []const i32) ?usize {
    const sorter = decideSortOrder(report);
    for (0..report.len - 1, 1..report.len) |i, j| {
        if (!sorter({}, report[i], report[j])) {
            return i;
        }
        const diff = @abs(report[i] - report[j]);
        if (diff < 1 or diff > 3) {
            return i;
        }
    }

    return null;
}

test "decideSortOrder" {
    const wrongFirstLevel = [_]i32{ 86, 87, 86, 84, 81 };
    try expect(decideSortOrder(&wrongFirstLevel) == desc);
    const allOrdered = [_]i32{ 87, 86, 84, 81 };
    try expect(decideSortOrder(&allOrdered) == desc);
    const secondDiffWrong = [_]i32{ 86, 87, 86, 88 };
    try expect(decideSortOrder(&secondDiffWrong) == asc);
}

/// Queries the report windows in order until two gaps follow the same order.
/// This evades the first two levels defining the whole order, allowing to find if the first level is the one in the wrong direction
pub fn decideSortOrder(report: []const i32) *const fn (void, i32, i32) bool {
    var asc_n: i32 = 0;
    var desc_n: i32 = 0;
    for (report[0 .. report.len - 1], report[1..report.len]) |i, j| {
        if (i < j) {
            asc_n += 1;
        } else if (j < i) {
            desc_n += 1;
        }
        if (asc_n == 2 or desc_n == 2) {
            break;
        }
    }
    return if (asc_n == 2) asc else desc;
}

test "dampenReport" {
    const slice = [_]i32{ 16, 19, 22, 21, 25 };
    const subslices = try dampenReport(&slice, 2);
    try expect(std.mem.eql(i32, subslices[0], &[_]i32{ 16, 19, 21, 25 }));
    try expect(std.mem.eql(i32, subslices[1], &[_]i32{ 16, 19, 22, 25 }));
}

/// Generates two lists copied from the given slice, one missing the index and the other the index+1
pub fn dampenReport(report: []const i32, start: usize) !struct { []i32, []i32 } {
    const missingStart = try gpa.alloc(i32, report.len - 1);
    const missingEnd = try gpa.alloc(i32, report.len - 1);
    const end = start + 1;

    @memcpy(missingStart[0..start], report[0..start]);
    @memcpy(missingEnd[0..end], report[0..end]);
    @memcpy(missingStart[start..], report[end..]);
    @memcpy(missingEnd[end..], report[end + 1 ..]);

    return .{ missingStart, missingEnd };
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
