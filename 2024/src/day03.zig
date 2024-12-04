const std = @import("std");
const util = @import("util.zig");
const gpa = util.gpa;

const r = @import("mvzr");

const mul_regex = r.compile("mul\\x28\\d{1,3},\\d{1,3}\\x29").?; // /mul\(\d{1,3},\d{1,3}\)/
const do_mul_regex = r.compile("mul\\x28\\d{1,3},\\d{1,3}\\x29|do\\x28\\x29|don't\\x28\\x29").?; // /mul\(\d{1,3},\d{1,3}\)|do\(\)\don't\(\)/

pub fn main() !void {
    const input = try util.readInputFile("input/day03.txt");
    print("mult sum: {d}\n", .{try calculateMulSum(input)});
    print("mult sum with do: {d}\n", .{try calculateMulSumWithDo(input)});
}

test "03 - a" {
    const input = try util.readInputFile("examples/day03a.txt");
    try expect(try calculateMulSum(input) == 161);
}

test "03 - b" {
    const input = try util.readInputFile("examples/day03b.txt");
    try expect(try calculateMulSumWithDo(input) == 48);
}

pub fn calculateMulSum(memory: []const u8) !i32 {
    var it = mul_regex.iterator(memory);

    var sum: i32 = 0;
    while (it.next()) |match| {
        sum += try doMult(match);
    }
    return sum;
}

pub fn calculateMulSumWithDo(memory: []const u8) !i32 {
    var it = do_mul_regex.iterator(memory);
    var sum: i32 = 0;
    var enabled = true;

    while (it.next()) |match| {
        const code = match.slice[0..3];
        if (enabled and eql(u8, code, "don")) {
            enabled = false;
        } else if (enabled and eql(u8, code, "mul")) {
            sum += try doMult(match);
        } else if (!enabled and eql(u8, code, "do(")) {
            enabled = true;
        }
    }

    return sum;
}

pub fn doMult(match: r.Match) !i32 {
    // no groups, so let's just split the match
    var numbers = std.mem.splitScalar(u8, match.slice[4 .. match.slice.len - 1], ',');
    const left = try parseInt(i32, numbers.next().?, 10);
    const right = try parseInt(i32, numbers.next().?, 10);
    return left * right;
}

const print = std.debug.print;
const parseInt = std.fmt.parseInt;
const eql = std.mem.eql;
const expect = std.testing.expect;
