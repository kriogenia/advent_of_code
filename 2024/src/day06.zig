const std = @import("std");
const util = @import("util.zig");
const gpa = util.gpa;

const List = std.ArrayList;
const Map = std.AutoHashMap;

pub fn main() !void {
    var input = try parse("input/day06.txt");
    defer input.deinit();

    std.debug.print("distinct positions: {d}\n", .{try countPositions(&input)});
}

test "06" {
    var input = try .parse("examples/day06.txt");
    defer input.deinit();

    std.testing.expectEqual(41, try countPositions(&input));
}

fn countPositions(input: *const Input) !usize {
    var positions = Map(usize, void).init(gpa);
    try positions.put(input.origin, {});

    var currentPosition = input.origin;
    var currentDirection = input.direction;
    while (move(currentPosition, currentDirection, input)) |movement| {
        currentPosition = movement[0];
        currentDirection = movement[1];
        _ = try positions.getOrPut(currentPosition);
    }

    return positions.count();
}

fn move(from: usize, direction: Direction, input: *const Input) ?struct { usize, Direction } {
    var dir = direction;

    while (nextPosition(from, dir, input.width, input.total)) |newPos| {
        if (!input.obstacles.contains(newPos)) {
            return .{ newPos, dir };
        }
        dir = dir.turn();
    }

    return null;
}

/// Returns the next position of the guard following the direction if it's still in the matrix
fn nextPosition(from: usize, direction: Direction, width: usize, total: usize) ?usize {
    if (from < width and direction == Direction.up) return null;
    if (@mod(from, width) == 0 and direction == Direction.left) return null;
    if (@mod(from, width) == width - 1 and direction == Direction.right) return null;
    if (from >= (total - width) and direction == Direction.down) return null;

    return direction.move(from, width);
}

const Direction = enum(u8) {
    up,
    right,
    down,
    left,

    pub fn move(self: Direction, from: usize, width: usize) usize {
        return switch (self) {
            Direction.up => from - width,
            Direction.left => from - 1,
            Direction.right => from + 1,
            Direction.down => from + width,
        };
    }

    pub fn turn(self: Direction) Direction {
        const next = @mod(@intFromEnum(self) + 1, @typeInfo(Direction).Enum.fields.len);
        return @enumFromInt(next);
    }

    const chars = [@typeInfo(Direction).Enum.fields.len]u8{ '^', '>', '<', 'v' };
};

const Input = struct {
    obstacles: Map(usize, void),
    origin: usize,
    direction: Direction,
    width: usize,
    total: usize,

    pub fn deinit(self: *@This()) void {
        self.obstacles.deinit();
    }
};

fn parse(filename: []const u8) !Input {
    const input = try util.readInputFile(filename);

    var lines = std.mem.splitScalar(u8, input, '\n');
    const width = lines.next().?.len;

    var direction: Direction = undefined;
    var origin: usize = undefined;

    var obstacles = Map(usize, void).init(gpa);
    var jumpLines: usize = 0;
    for (input, 0..) |char, i| {
        if (char == '\n') {
            jumpLines += 1;
        } else if (char == '#') {
            try obstacles.put(i - jumpLines, {});
        } else if (std.mem.indexOfAnyPos(u8, &Direction.chars, 0, &[1]u8{char})) |dirChar| {
            direction = @enumFromInt(dirChar);
            origin = i - jumpLines;
        }
    }
    const total = input.len - jumpLines;

    return Input{
        .obstacles = obstacles,
        .origin = origin,
        .direction = direction,
        .width = width,
        .total = total,
    };
}
