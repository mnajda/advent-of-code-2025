const std = @import("std");
const day4 = @import("day4");

fn readFile(allocator: std.mem.Allocator, filepath: []u8) ![]u8 {
    var file = try std.fs.cwd().openFile(
        filepath,
        .{ .mode = .read_only },
    );
    defer file.close();

    const stat = try file.stat();

    const contents = try file.readToEndAlloc(allocator, stat.size);
    return contents;
}

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const filepath = args[1];

    const contents = try readFile(allocator, filepath);
    defer allocator.free(contents);

    var lines: std.ArrayList(std.ArrayList(u8)) = .empty;
    defer lines.deinit(allocator);

    var readIter = std.mem.tokenizeSequence(u8, contents, "\n");
    while (readIter.next()) |seq| {
        var line: std.ArrayList(u8) = .empty;
        for (seq) |c| {
            try line.append(allocator, c);
        }
        try lines.append(allocator, line);
    }

    try day4.part1(allocator, lines);
    try day4.part2(allocator, lines);

    for (lines.items) |*line| {
        line.deinit(allocator);
    }
}
