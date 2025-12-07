import { readFileSync } from 'fs';

function part1(grid: string[]) {
    var beams: Set<number> = new Set<number>();
    beams.add(grid[0].indexOf('S'));

    var result = 0;
    grid.slice(1).forEach(row => {
        var splits: Set<number> = new Set();
        for (var i = 0; i < row.length; i++) {
            if (row[i] == '^' && beams.has(i)) {
                splits.add(i);
            }
        }

        result += splits.size;
        beams = new Set<number>([...beams].filter(x => !splits.has(x)));
        
        splits.forEach(split => {
            beams.add(split + 1);
            beams.add(split - 1);
        });
    });

    console.log("Part 1 solution is", result);
}

function part2(grid: string[]) {
    var beams: Map<number, number> = new Map<number, number>();
    beams.set(grid[0].indexOf('S'), 1);

    grid.slice(1).forEach(row => {
        for (var i = 0; i < row.length; i++) {
            if (row[i] == '^' && beams.get(i) > 0) {
                if (beams.has(i - 1)) {
                    beams.set(i - 1, beams.get(i) + beams.get(i - 1));
                } else {
                    beams.set(i - 1, beams.get(i));
                }

                if (beams.has(i + 1)) {
                    beams.set(i + 1, beams.get(i) + beams.get(i + 1));
                } else {
                    beams.set(i + 1, beams.get(i));
                }

                beams.set(i, 0);
            }
        }
    });

    var result = 0;
    for (const value of beams.values()) {
        result += value;
    }

    console.log("Part 2 solution is", result);
}

let path = process.argv[2];
let input = readFileSync(path, 'utf-8').trim().split("\n");

part1(input);
part2(input);
