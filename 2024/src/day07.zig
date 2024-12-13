const std = @import("std");
const util = @import("util.zig");
const gpa = util.gpa;

const List = std.ArrayList;
const Map = std.AutoHashMap;

const parseInt = std.fmt.parseInt;
const split = std.mem.splitScalar;

pub fn main() !void {
    const result = try sumFeasible("input/day07.txt");
    std.debug.print("total calibration: {d}\n", .{result[0]});
    std.debug.print("total calibration with concat: {d}\n", .{result[1]});
}

test "07" {
    const result = try sumFeasible("examples/day07.txt");
    try std.testing.expectEqual(3749, result[0]);
    try std.testing.expectEqual(11387, result[1]);
}

fn sumFeasible(filename: []const u8) !struct { u64, u64 } {
    const input = try util.readInputFile(filename);
    var sum: u64 = 0;
    var sumWithConcat: u64 = 0;

    var lines = split(u8, input, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) break;

        var lineSplit = split(u8, line, ':');
        const left = try parseInt(u64, lineSplit.next().?, 10);
        var right = std.mem.tokenizeScalar(u8, lineSplit.next().?, ' ');

        var operands = List(u64).init(gpa);
        while (right.next()) |value| {
            try operands.append(try parseInt(u64, value, 10));
        }

        var slice = try operands.toOwnedSlice();
        if (canMakeGoal(slice[1..], slice[0], left)) {
            sum += left;
            sumWithConcat += left;
        } else if (canMakeGoalWithConcat(slice[1..], slice[0], left)) {
            sumWithConcat += left;
        }
    }

    return .{ sum, sumWithConcat };
}

fn canMakeGoal(operands: []u64, acc: u64, goal: u64) bool {
    if (acc > goal) return false;
    if (operands.len == 0) return acc == goal;

    const rest = operands[1..];
    return canMakeGoal(rest, acc * operands[0], goal) or canMakeGoal(rest, acc + operands[0], goal);
}

test "canMakeGoal" {
    var operands = List(u64).init(gpa);
    try operands.appendSlice(&[_]u64{ 6, 1, 5, 2, 15 });
    const slice = try operands.toOwnedSlice();
    try std.testing.expect(canMakeGoal(slice[1..], slice[0], 360));
}

fn canMakeGoalWithConcat(operands: []u64, acc: u64, goal: u64) bool {
    if (acc > goal) return false;
    if (operands.len == 0) return acc == goal;

    const rest = operands[1..];
    return canMakeGoalWithConcat(rest, acc * operands[0], goal) or canMakeGoalWithConcat(rest, acc + operands[0], goal) or canMakeGoalWithConcat(rest, concat(acc, operands[0]), goal);
}

fn concat(left: u64, right: u64) u64 {
    const join = std.fmt.allocPrint(gpa, "{d}{d}", .{ left, right }) catch "";
    return parseInt(u64, join, 10) catch 0;
}
