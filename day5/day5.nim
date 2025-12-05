import os
import std/algorithm
import std/strutils
import std/sequtils
import std/sugar

proc to_range(input: string): (int, int) =
    let range = input.split("-");
    return (range[0].parseInt, range[1].parseInt)

proc part1(ranges: seq[(int, int)], ids: seq[int]): int =
    result = 0

    for id in ids:
        let i = id
        if any(ranges, proc (range: (int, int)): bool = i in range[0]..range[1]):
            result += 1
    
    return result

proc part2(ranges: seq[(int, int)]): int =
    result = 0

    var input_ranges = ranges;
    input_ranges.sort()

    var all_ranges: seq[(int, int)] = newSeq[(int, int)]()
    var (currentStart, currentEnd) = input_ranges[0]

    for (nextStart, nextEnd) in input_ranges[1..^1]:
        if currentStart <= nextStart and nextEnd <= currentEnd:
            continue

        if nextStart <= currentEnd:
            currentEnd = nextEnd
        else:
            all_ranges.add((currentStart, currentEnd))
            (currentStart, currentEnd) = (nextStart, nextEnd)

    all_ranges.add((currentStart, currentEnd))

    for range in all_ranges:
        result += len(range[0]..range[1])

    return result


let filepath = paramStr(1)
let input = readFile(filepath).split("\n\n")

let ranges = input[0].split("\n").map(to_range)
let ids = input[1].split("\n").map(id => id.parseInt)

echo "Part 1 result is ", part1(ranges, ids)
echo "Part 2 result is ", part2(ranges)
