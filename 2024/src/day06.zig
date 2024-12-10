const std = @import("std");
const util = @import("util.zig");
const gpa = util.gpa;

const List = std.ArrayList;
const Map = std.AutoHashMap;

pub fn main() !void {
    var input = try parse("input/day06.txt");
    defer input.deinit();

    const result = try analyzeGuardPathing(&input);
    std.debug.print("distinct positions: {d}\n", .{result[0]});
    std.debug.print("possible loops: {d}\n", .{result[1]});
}

test "06" {
    var input = try parse("examples/day06.txt");
    defer input.deinit();

    const result = try analyzeGuardPathing(&input);
    try std.testing.expectEqual(41, result[0]);
    try std.testing.expectEqual(6, result[1]);
}

fn analyzeGuardPathing(input: *const Input) !struct { usize, usize } {
    var positions = Map(usize, void).init(gpa);
    defer positions.deinit();
    try positions.put(input.origin, {});

    var possibleLoops: usize = 0;
    var lastPositions = try List(usize).initCapacity(gpa, 3);
    defer lastPositions.deinit();

    var currentPosition = input.origin;
    var currentDirection = input.direction;
    while (move(currentPosition, currentDirection, input)) |movement| {
        currentPosition = movement.newPosition;
        if (movement.newDirection) |newDir| {
            currentDirection = newDir;
            if (lastPositions.items.len == 2) {
                const candidate = intersection(lastPositions.items[0], currentPosition, currentDirection, input.width);
                if (isFreePath(currentPosition, candidate, currentDirection, input)) {
                    // std.debug.print("current: {d}, candidate: {d}\n", .{ currentPosition, candidate });
                    possibleLoops += 1;
                }
                _ = lastPositions.orderedRemove(0);
            }
            try lastPositions.append(currentPosition);
            // check loop
        }
        _ = try positions.getOrPut(currentPosition);
    }

    return .{ positions.count(), possibleLoops };
}

fn move(from: usize, direction: Direction, input: *const Input) ?struct { newPosition: usize, newDirection: ?Direction } {
    var dir = direction;

    while (nextPosition(from, dir, input.width, input.total)) |newPos| {
        if (!input.obstacles.contains(newPos)) {
            return .{ .newPosition = newPos, .newDirection = if (dir != direction) dir else null };
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

fn intersection(firstPoint: usize, secondPoint: usize, direction: Direction, width: usize) usize {
    const isVertical = direction.isVertical();
    const columnPoint = if (isVertical) secondPoint else firstPoint;
    const rowPoint = if (isVertical) firstPoint else secondPoint;

    return (rowPoint / width) * width + @mod(columnPoint, width);
}

fn isFreePath(from: usize, to: usize, direction: Direction, input: *const Input) bool {
    var obstacles = input.obstacles.keyIterator();
    while (obstacles.next()) |obstacle| {
        if (!isBetween(from, to, obstacle.*)) continue;
        if (!direction.isVertical()) return false;
        if (sharesColumn(from, obstacle.*, input.width)) return false;
    }

    return true;
}

fn isBetween(first: usize, second: usize, point: usize) bool {
    return (point > first) != (point > second); // XOR
}

fn sharesColumn(first: usize, second: usize, width: usize) bool {
    return (first / width) == (second / width);
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

    pub fn isVertical(self: Direction) bool {
        return @mod(@intFromEnum(self), 2) == 0;
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
