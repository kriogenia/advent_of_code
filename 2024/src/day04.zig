const std = @import("std");
const util = @import("util.zig");
const gpa = util.gpa;

const List = std.ArrayList;
const expectEq = std.testing.expectEqual;

const letters = [4]u8{ 'X', 'M', 'A', 'S' };

pub fn main() !void {
    const matrix = try parse("input/day04.txt");
    std.debug.print("{d}", .{try findXMas(matrix)});
}

test "findXMas" {
    const matrix = try parse("examples/day04.txt");
    try expectEq(18, try findXMas(matrix));
}

fn findXMas(matrix: Matrix) !u32 {
    var sum: u32 = 0;

    var global: usize = 0;
    while (nextX(matrix.buffer[global..])) |local| {
        global = global + local + 1;
        sum += try countWords(&matrix, global - 1);
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

/// /// Returns the valid movements for a given index based on its position on the grid
/// fn candidatePaths(matrix: *const Matrix, index: usize) ![]Direction {
///     var paths = List(Direction).init(gpa);
///     if (@mod(index, matrix.width) > 0) { // not in the left column
///         try paths.append(Direction.left);
///         if (index >= matrix.width) try paths.append(Direction.upleft);
///         if (index < matrix.width * (matrix.height - 1)) try paths.append(Direction.downright);
///     }
///     if (@mod(index, matrix.width) < matrix.width - 1) { // not in the right column
///         try paths.append(Direction.right);
///         if (index >= matrix.width) try paths.append(Direction.upright);
///         if (index < matrix.width * (matrix.height - 1)) try paths.append(Direction.upleft);
///     }
///     if (index >= matrix.width) try paths.append(Direction.up);
///     if (index < matrix.width * (matrix.height - 1)) try paths.append(Direction.down);
///
///     return paths.toOwnedSlice();
/// }
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
    if (current >= matrix.width * (matrix.height - 1) and idir <= 3) return null; // no path down

    const inext = @as(isize, @intCast(current)) + movement(direction);
    return @intCast(inext);
}

fn nextX(slice: []const u8) ?usize {
    return std.mem.indexOfScalar(u8, slice, 'X');
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
