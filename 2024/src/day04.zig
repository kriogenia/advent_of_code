const std = @import("std");
const util = @import("util.zig");
const gpa = util.gpa;

const List = std.ArrayList;
const expectEq = std.testing.expectEqual;

const letters = [4]u8{ 'X', 'M', 'A', 'S' };

pub fn main() !void {
    const matrix = try parse("input/day04.txt");
    std.debug.print("xmas: {d}\n", .{try findXMas(&matrix)});
    std.debug.print("x-mas: {d}\n", .{try findCrossMas(&matrix)});
}

test "04" {
    const matrix = try parse("examples/day04.txt");
    try expectEq(18, try findXMas(&matrix));
    try expectEq(9, try findCrossMas(&matrix));
}

fn findXMas(matrix: *const Matrix) !u32 {
    var sum: u32 = 0;

    var global: usize = 0;
    while (nextX(matrix.buffer[global..])) |local| {
        global = global + local + 1;
        sum += try countWords(matrix, global - 1);
    }
    return sum;
}

fn findCrossMas(matrix: *const Matrix) !u32 {
    var global = matrix.width + 1;
    const end = matrix.total - matrix.width - 1; // skip edge lines

    var sum: u32 = 0;
    while (nextA(matrix.buffer[global..end], matrix.width, global)) |local| {
        global = global + local + 1;
        sum += if (isCrossMass(matrix, global - 1)) 1 else 0;
    }
    return sum;
}

fn countWords(matrix: *const Matrix, index: usize) !u32 {
    var count: u32 = 0;
    for (std.enums.values(Direction)) |path| {
        count += if (findNext(matrix, 1, index, path)) 1 else 0;
    }
    return count;
}

const ms: u8 = 'M' + 'S';

fn isCrossMass(matrix: *const Matrix, index: usize) bool {
    const iindex = @as(isize, @intCast(index));

    const upleft = diagonal(matrix, iindex, Direction.upleft) orelse return false;
    const upright = diagonal(matrix, iindex, Direction.upright) orelse return false;
    const downleft = diagonal(matrix, iindex, Direction.downleft) orelse return false;
    const downright = diagonal(matrix, iindex, Direction.downright) orelse return false;

    return (upleft + downright == ms) and (upright + downleft == ms);
}

const Direction = enum(u8) {
    upleft = 7,
    up = 8,
    upright = 9,
    left = 4,
    right = 6,
    downleft = 1,
    down = 2,
    downright = 3,

    var vertical: isize = 0;
};

fn movement(direction: Direction) isize {
    return switch (direction) {
        .upleft => -Direction.vertical - 1,
        .up => -Direction.vertical,
        .upright => -Direction.vertical + 1,
        .left => -1,
        .right => 1,
        .downleft => Direction.vertical - 1,
        .down => Direction.vertical,
        .downright => Direction.vertical + 1,
    };
}

fn findNext(matrix: *const Matrix, letter: usize, current: usize, direction: Direction) bool {
    if (letter >= letters.len) {
        return true;
    }

    const next = neighbourIndex(matrix, current, direction) orelse return false;
    return matrix.*.buffer[next] == letters[letter] and findNext(matrix, letter + 1, next, direction);
}

/// Returns the position of the next neighbour following the direction only if there's more path that way
fn neighbourIndex(matrix: *const Matrix, current: usize, direction: Direction) ?usize {
    const idir = @intFromEnum(direction);
    if (@mod(current, matrix.width) == 0 and (@mod(idir, 3) == 1)) return null; // no path left
    if (@mod(current, matrix.width) == (matrix.width - 1) and (@mod(idir, 3) == 0)) return null; // no path right
    if (current < matrix.width and idir >= 7) return null; // no path up
    if (current >= matrix.total - matrix.width and idir <= 3) return null; // no path down

    const inext = @as(isize, @intCast(current)) + movement(direction);
    return @intCast(inext);
}

fn diagonal(matrix: *const Matrix, origin: isize, direction: Direction) ?u8 {
    const value = matrix.buffer[@as(usize, @intCast(origin + movement(direction)))];
    return if (value == 'M' or value == 'S') value else null;
}

fn nextX(slice: []const u8) ?usize {
    return std.mem.indexOfScalar(u8, slice, 'X');
}

fn nextA(slice: []const u8, width: usize, offset: usize) ?usize {
    var global: usize = 0;
    while (std.mem.indexOfScalar(u8, slice[global..], 'A')) |index| {
        global += index;
        const column = @mod(global + offset, width);
        if (column > 0 and column < width - 1) {
            return global;
        }
        global += 1;
    }
    return null;
}

const Matrix = struct { buffer: []u8, width: usize, height: usize, total: usize };

fn parse(filename: []const u8) !Matrix {
    var buffer = List(u8).init(gpa);

    var lines = std.mem.splitScalar(u8, try util.readInputFile(filename), '\n');
    const first = lines.next().?;
    const width: usize = first.len;
    try buffer.appendSlice(first);

    var height: usize = 1;
    while (lines.next()) |line| {
        if (line.len == 0) break;
        try buffer.appendSlice(line);
        height += 1;
    }
    Direction.vertical = @intCast(width);

    return Matrix{ .buffer = try buffer.toOwnedSlice(), .width = width, .height = height, .total = height * width };
}
