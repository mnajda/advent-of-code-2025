const std = @import("std");

const Point = struct {
    x: i32,
    y: i32,
};

fn isValid(p: Point, size: i32) bool {
    if (p.x >= size) return false;
    if (p.x < 0) return false;
    if (p.y >= size) return false;
    if (p.y < 0) return false;
    return true;
}

fn getAdjacentPoints(allocator: std.mem.Allocator, p: Point, size: i32) !std.ArrayList(Point) {
    const points = [_]Point{
        .{ .x = p.x + 1, .y = p.y },
        .{ .x = p.x - 1, .y = p.y },
        .{ .x = p.x, .y = p.y + 1 },
        .{ .x = p.x, .y = p.y - 1 },
        .{ .x = p.x + 1, .y = p.y + 1 },
        .{ .x = p.x - 1, .y = p.y - 1 },
        .{ .x = p.x + 1, .y = p.y - 1 },
        .{ .x = p.x - 1, .y = p.y + 1 },
    };

    var result: std.ArrayList(Point) = .empty;
    for (points) |item| {
        if (isValid(item, size)) {
            try result.append(allocator, item);
        }
    }
    return result;
}

fn countRolls(pointsToCheck: std.ArrayList(Point), input: std.ArrayList(std.ArrayList(u8))) i32 {
    var count: i32 = 0;
    for (pointsToCheck.items) |point| {
        if (input.items[@intCast(point.x)].items[@intCast(point.y)] == '@') {
            count += 1;
        }
    }
    return count;
}

pub fn part1(allocator: std.mem.Allocator, input: std.ArrayList(std.ArrayList(u8))) !void {
    var result: i32 = 0;

    for (input.items, 0..) |line, i| {
        for (line.items, 0..) |_, k| {
            if (line.items[k] != '@') {
                continue;
            }

            const point = Point{
                .x = @intCast(i),
                .y = @intCast(k),
            };

            var adjacentPoints = try getAdjacentPoints(allocator, point, @intCast(input.items.len));
            const rolls = countRolls(adjacentPoints, input);
            if (rolls < 4) {
                result += 1;
            }
            adjacentPoints.deinit(allocator);
        }
    }

    std.debug.print("Part 1 result is {d}\n", .{result});
}

pub fn part2(allocator: std.mem.Allocator, input: std.ArrayList(std.ArrayList(u8))) !void {
    var wasRemoved: bool = true;
    var result: i32 = 0;

    while (wasRemoved) {
        var toRemove: std.ArrayList(Point) = .empty;

        for (input.items, 0..) |line, i| {
            for (line.items, 0..) |_, k| {
                if (line.items[k] != '@') continue;

                const point = Point{
                    .x = @intCast(i),
                    .y = @intCast(k),
                };

                var adjacentPoints = try getAdjacentPoints(allocator, point, @intCast(input.items.len));
                const rolls = countRolls(adjacentPoints, input);
                if (rolls < 4) {
                    try toRemove.append(allocator, point);
                    result += 1;
                }
                adjacentPoints.deinit(allocator);
            }
        }

        if (toRemove.items.len == 0) {
            wasRemoved = false;
        } else {
            for (toRemove.items) |point| {
                input.items[@intCast(point.x)].items[@intCast(point.y)] = '.';
            }
        }

        toRemove.deinit(allocator);
    }

    std.debug.print("Part 2 result is {d}\n", .{result});
}
