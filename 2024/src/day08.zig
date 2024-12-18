const std = @import("std");
const util = @import("util.zig");
const gpa = util.gpa;

pub fn main() !void {
    var input = try parse("input/day08.txt");
    defer input.deinit();

    const result = try countAntiNodes(&input);
    std.debug.print("antinodes: {d}\n", .{result[0]});
    std.debug.print("resonant antinodes: {d}\n", .{result[1]});
}

test "08" {
    var input = try parse("examples/day08.txt");
    defer input.deinit();

    const result = try countAntiNodes(&input);
    try std.testing.expectEqual(14, result[0]);
    try std.testing.expectEqual(34, result[1]);
}

fn countAntiNodes(input: *const Input) !struct { usize, usize } {
    var closeAntinodes = Indices.init(gpa);
    var resonantAntinodes = Indices.init(gpa);
    defer closeAntinodes.deinit();
    defer resonantAntinodes.deinit();

    var keys = input.nodes.keyIterator();
    while (keys.next()) |k| {
        const placedNodes = input.nodes.get(k.*).?.items;
        if (placedNodes.len > 1) {
            for (placedNodes) |node| {
                try appendIfNew(&resonantAntinodes, node, input.width);
            }
        }

        for (0..placedNodes.len - 1) |i| {
            const antinodes = try generateAntiNodes(placedNodes[i], placedNodes[i + 1 ..], input.width, input.height);

            for (antinodes.close) |an| {
                try appendIfNew(&closeAntinodes, an, input.width);
            }

            for (antinodes.recursive) |an| {
                try appendIfNew(&resonantAntinodes, an, input.width);
            }
        }
    }

    return .{ closeAntinodes.items.len, resonantAntinodes.items.len };
}

fn appendIfNew(list: *Indices, node: Vec, width: isize) !void {
    const index = node.index(width);
    if (std.mem.indexOfScalar(isize, list.items, index) == null) {
        try list.append(index);
    }
}

fn generateAntiNodes(node: Vec, pairs: []const Vec, width: isize, height: isize) !struct { close: []Vec, recursive: []Vec } {
    var close = Placements.init(gpa);
    var recursive = Placements.init(gpa);
    errdefer close.deinit();
    errdefer recursive.deinit();

    for (pairs) |pair| {
        const ans = try antiNodesOf(node, pair, width, height);

        if (ans.left.len > 0) try close.appendSlice(ans.left[0..1]);
        if (ans.right.len > 0) try close.appendSlice(ans.right[0..1]);

        try recursive.appendSlice(ans.left);
        try recursive.appendSlice(ans.right);
    }

    return .{
        .close = try close.toOwnedSlice(),
        .recursive = try recursive.toOwnedSlice(),
    };
}

test "antinodesOf" {
    const left = Vec{ .x = 4, .y = 4 };
    const right = Vec{ .x = 5, .y = 2 };

    const ans = try antiNodesOf(left, right, 12, 12);
    try std.testing.expect(ans.left[0].eql(&Vec{ .x = 3, .y = 6 }));
    try std.testing.expect(ans.right[0].eql(&Vec{ .x = 6, .y = 0 }));
    try std.testing.expectEqual(3, ans.left.len);
    try std.testing.expectEqual(1, ans.right.len);
}

fn antiNodesOf(left: Vec, right: Vec, width: isize, height: isize) !struct { left: []Vec, right: []Vec } {
    const vecLR = Vec{ .x = right.x - left.x, .y = right.y - left.y };
    const vecRL = Vec{ .x = -vecLR.x, .y = -vecLR.y };

    var leftANs = Placements.init(gpa);
    var rightANs = Placements.init(gpa);
    errdefer leftANs.deinit();
    errdefer rightANs.deinit();

    var leftVec = left;
    while (move(leftVec, vecRL, width, height)) |an| : (leftVec = an) {
        try leftANs.append(an);
    }

    var rightVec = right;
    while (move(rightVec, vecLR, width, height)) |an| : (rightVec = an) {
        try rightANs.append(an);
    }

    return .{
        .left = try leftANs.toOwnedSlice(),
        .right = try rightANs.toOwnedSlice(),
    };
}

fn move(from: Vec, movement: Vec, width: isize, height: isize) ?Vec {
    const newVec = Vec{ .x = from.x + movement.x, .y = from.y + movement.y };
    if (newVec.x < 0 or newVec.x >= width or newVec.y < 0 or newVec.y >= height) return null;
    return newVec;
}

const Vec = util.Coordinates(isize);
const Indices = std.ArrayList(isize);
const Placements = std.ArrayList(Vec);
const Nodes = std.AutoHashMap(u8, Placements);

const Input = struct {
    nodes: Nodes,
    width: isize,
    height: isize,

    fn deinit(self: *@This()) void {
        self.nodes.deinit();
    }
};

fn parse(filename: []const u8) !Input {
    const input = try util.readInputFile(filename);

    var width: isize = undefined;
    var nodes = Nodes.init(gpa);
    errdefer nodes.deinit();

    var rows: isize = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| : (rows += 1) {
        if (line.len == 0) break;
        width = @as(isize, @intCast(line.len));

        for (line, 0..) |char, col| {
            if (char == '.') continue;
            const coords = Vec{ .x = @as(isize, @intCast(col)), .y = rows };

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
        .width = width,
        .height = rows,
    };
}
