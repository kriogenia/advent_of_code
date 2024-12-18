const std = @import("std");
const util = @import("util.zig");
const gpa = util.gpa;

pub fn main() !void {
    var input = try parse("input/day08.txt");
    defer input.deinit();

    std.debug.print("antinodes: {d}\n", .{try countAntiNodes(&input)});
}

test "08" {
    var input = try parse("examples/day08.txt");
    defer input.deinit();

    try std.testing.expectEqual(14, try countAntiNodes(&input));
}

fn countAntiNodes(input: *const Input) !usize {
    var validAntinodes = Indices.init(gpa);

    var keys = input.nodes.keyIterator();
    while (keys.next()) |k| {
        const placedNodes = input.nodes.get(k.*).?.items;
        for (0..placedNodes.len - 1) |i| {
            for ((try generateAntiNodes(placedNodes[i], placedNodes[i + 1 ..], input.width, input.height)).items) |an| {
                const index = an.index(input.width);
                if (containsIndex(validAntinodes.items, index)) continue;
                try validAntinodes.append(index);
            }
        }
    }

    return validAntinodes.items.len;
}

fn containsIndex(slice: []const usize, index: usize) bool {
    return std.mem.indexOfScalar(usize, slice, index) != null;
}

fn generateAntiNodes(node: Coords, pairs: []const Coords, width: usize, height: usize) !Placements {
    var antinodes = Placements.init(gpa);
    errdefer antinodes.deinit();

    for (pairs) |pair| {
        const ans = if (node.isLeftOf(&pair)) antiNodesOf(node, pair, width, height) else antiNodesOf(pair, node, width, height);
        if (ans[0]) |leftAN| {
            try antinodes.append(leftAN);
        }
        if (ans[1]) |rightAN| {
            try antinodes.append(rightAN);
        }
    }

    return antinodes;
}

test "antiNodesOf" {
    const left = Coords{ .x = 5, .y = 2 };
    const right = Coords{ .x = 8, .y = 1 };
    const antinodes = antiNodesOf(left, right, 12, 12);
    try std.testing.expect(antinodes[0].?.eql(&Coords{ .x = 2, .y = 3 }));
    try std.testing.expect(antinodes[1].?.eql(&Coords{ .x = 11, .y = 0 }));
}

fn antiNodesOf(left: Coords, right: Coords, width: usize, height: usize) struct { ?Coords, ?Coords } {
    const iLeft = toSignedCoords(left);
    const iRight = toSignedCoords(right);

    const leftAN = ICoords{ .x = iLeft.x + iLeft.x - iRight.x, .y = iLeft.y + iLeft.y - iRight.y };
    const rightAN = ICoords{ .x = iRight.x + iRight.x - iLeft.x, .y = iRight.y + iRight.y - iLeft.y };

    return .{ toCoords(leftAN, width, height), toCoords(rightAN, width, height) };
}

fn toSignedCoords(coords: Coords) ICoords {
    return .{
        .x = @as(isize, @intCast(coords.x)),
        .y = @as(isize, @intCast(coords.y)),
    };
}

fn toCoords(coords: ICoords, width: usize, height: usize) ?Coords {
    if (coords.x < 0 or coords.y < 0) return null;
    const x: usize = @intCast(coords.x);
    const y: usize = @intCast(coords.y);
    if (x >= width or y >= height) return null;

    return Coords{ .x = x, .y = y };
}

const Coords = util.Coords;
const ICoords = util.Coordinates(isize);

const Indices = std.ArrayList(usize);
const Placements = std.ArrayList(Coords);
const Nodes = std.AutoHashMap(u8, Placements);

const Input = struct {
    nodes: Nodes,
    occupiedIndices: Indices,
    width: usize,
    height: usize,

    fn isOccupied(self: *const @This(), index: usize) bool {
        return std.mem.indexOfScalar(usize, self.occupiedIndices.items, index) != null;
    }

    fn deinit(self: *@This()) void {
        self.nodes.deinit();
        self.occupiedIndices.deinit();
    }
};

fn parse(filename: []const u8) !Input {
    const input = try util.readInputFile(filename);

    var width: usize = undefined;
    var nodes = Nodes.init(gpa);
    var occupied = Indices.init(gpa);
    errdefer nodes.deinit();
    errdefer occupied.deinit();

    var rows: usize = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| : (rows += 1) {
        if (line.len == 0) break;
        width = line.len;

        for (line, 0..) |char, col| {
            if (char == '.') continue;
            const coords = Coords{ .x = col, .y = rows };
            try occupied.append(coords.index(width));

            const sameFreq = try nodes.getOrPut(char);
            if (sameFreq.found_existing) {
                try sameFreq.value_ptr.*.append(coords);
            } else {
                var list = Placements.init(gpa);
                errdefer list.deinit();

                try list.append(coords);
                sameFreq.value_ptr.* = list;
            }
        }
    }

    return Input{
        .nodes = nodes,
        .occupiedIndices = occupied,
        .width = width,
        .height = rows,
    };
}
