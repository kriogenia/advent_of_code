const std = @import("std");
const util = @import("util.zig");
const gpa = util.gpa;

const List = std.ArrayList;
const Map = std.AutoHashMap;

const parseInt = std.fmt.parseInt;
const split = std.mem.splitScalar;

pub fn main() !void {
    std.debug.print("total calibration: {d}\n", .{try sumFeasible("input/day07.txt")});
}

test "07" {
    try std.testing.expectEqual(3749, try sumFeasible("examples/day07.txt"));
}

fn sumFeasible(filename: []const u8) !u64 {
    const input = try util.readInputFile(filename);
    var sum: u64 = 0;

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
        }
    }

    return sum;
}

fn canMakeGoal(operands: []u64, acc: u64, goal: u64) bool {
    // std.debug.print("{d}: {d} + {any}\n", .{ goal, acc, operands });
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
