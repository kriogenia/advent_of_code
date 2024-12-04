const std = @import("std");
const util = @import("util.zig");
const gpa = util.gpa;

const r = @import("mvzr");

const regex = r.compile("mul\\x28\\d{1,3},\\d{1,3}\\x29").?; // /mul\(\d{1,3},\d{1,3}\)/

pub fn main() !void {
    const input = try util.readInputFile("input/day03.txt");
    print("mult sum: {d}\n", .{try calculateMulSum(input)});
}

test "03" {
    const input = try util.readInputFile("examples/day03.txt");
    try expect(try calculateMulSum(input) == 161);
}

pub fn calculateMulSum(memory: []const u8) !i32 {
    var it = regex.iterator(memory);
    var sum: i32 = 0;
    while (it.next()) |match| {
        // no groups, so let's just split the match
        var numbers = std.mem.splitScalar(u8, match.slice[4 .. match.slice.len - 1], ',');
        const left = try parseInt(i32, numbers.next().?, 10);
        const right = try parseInt(i32, numbers.next().?, 10);
        sum += left * right;
    }

    return sum;
}

const expect = std.testing.expect;
const print = std.debug.print;
const parseInt = std.fmt.parseInt;
