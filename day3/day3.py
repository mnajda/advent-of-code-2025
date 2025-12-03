import sys
from functools import reduce

def window(arr, k):
    for i in range(len(arr) - k + 1):
        yield arr[i : i + k]

def calculate_joltage(batteries, num_to_enable):
    turned_on_batteries = batteries[:num_to_enable]
    for w in window(batteries, num_to_enable):
        for i in range(len(w)):
            if w[i] > turned_on_batteries[i]:
                turned_on_batteries = turned_on_batteries[:i] + w[i:]
    
    return reduce(lambda acc, x: acc * 10 + int(x), turned_on_batteries, 0)

def part1(input):
    batteries_to_enable = 2
    result = reduce(lambda acc, line: acc + calculate_joltage(line, batteries_to_enable), input.splitlines(), 0)

    print(f"Part 1 result is {result}")

def part2(input):
    batteries_to_enable = 12
    result = reduce(lambda acc, line: acc + calculate_joltage(line, batteries_to_enable), input.splitlines(), 0)

    print(f"Part 2 result is {result}")

if __name__ == "__main__":
    path = sys.argv[1]
    with open(path, "r") as file:
        input = file.read()

        part1(input)
        part2(input)
