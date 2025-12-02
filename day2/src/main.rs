use std::env;
use std::fs;

type Range = std::ops::Range<usize>;

fn load_file(path: &String) -> Vec<Range> {
    let contents = fs::read_to_string(path).expect("Error reading file");
    contents
        .split(',')
        .map(|row| row.split('-').collect::<Vec<_>>())
        .map(|row| {
            let numbers = row
                .iter()
                .map(|num| num.parse::<usize>().unwrap())
                .collect::<Vec<usize>>();
            Range {
                start: numbers[0],
                end: numbers[1],
            }
        })
        .collect()
}

fn repeats_exactly_twice(num_str: &String) -> bool {
    let length = num_str.len();
    if (length % 2) != 0 {
        return false;
    }
    num_str[..(length / 2)] == num_str[(length / 2)..]
}

fn repeats_at_least_twice(num_str: &String) -> bool {
    for i in 1..num_str.len() {
        let is_invalid = num_str
            .as_bytes()
            .chunks(i)
            .collect::<Vec<&[u8]>>()
            .windows(2)
            .all(|w| w[0] == w[1]);

        if is_invalid {
            return true;
        }
    }

    false
}

fn get_in_range(range: &Range, condition: fn(&String) -> bool) -> Vec<usize> {
    (range.start..=range.end)
        .into_iter()
        .map(|num| num.to_string())
        .filter(condition)
        .map(|num_str| num_str.parse::<usize>().unwrap())
        .collect()
}

fn part1(input: &Vec<Range>) -> usize {
    input
        .iter()
        .map(|range| get_in_range(range, repeats_exactly_twice))
        .flatten()
        .sum()
}

fn part2(input: &Vec<Range>) -> usize {
    input
        .iter()
        .map(|range| get_in_range(range, repeats_at_least_twice))
        .flatten()
        .sum()
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        panic!("No file provided");
    }

    let input = load_file(&args[1]);
    println!("Part 1 solution is {}", part1(&input));
    println!("Part 2 solution is {}", part2(&input));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn part1_test() {
        let input = vec![
            Range { start: 11, end: 22 },
            Range {
                start: 99,
                end: 115,
            },
            Range {
                start: 998,
                end: 1012,
            },
            Range {
                start: 1188511880,
                end: 1188511890,
            },
            Range {
                start: 222220,
                end: 222224,
            },
            Range {
                start: 1698522,
                end: 1698528,
            },
            Range {
                start: 446443,
                end: 446449,
            },
            Range {
                start: 38593856,
                end: 38593862,
            },
            Range {
                start: 565653,
                end: 565659,
            },
            Range {
                start: 824824821,
                end: 824824827,
            },
            Range {
                start: 2121212118,
                end: 2121212124,
            },
        ];
        assert_eq!(part1(&input), 1227775554);
    }

    #[test]
    fn part2_test() {
        let input = vec![
            Range { start: 11, end: 22 },
            Range {
                start: 99,
                end: 115,
            },
            Range {
                start: 998,
                end: 1012,
            },
            Range {
                start: 1188511880,
                end: 1188511890,
            },
            Range {
                start: 222220,
                end: 222224,
            },
            Range {
                start: 1698522,
                end: 1698528,
            },
            Range {
                start: 446443,
                end: 446449,
            },
            Range {
                start: 38593856,
                end: 38593862,
            },
            Range {
                start: 565653,
                end: 565659,
            },
            Range {
                start: 824824821,
                end: 824824827,
            },
            Range {
                start: 2121212118,
                end: 2121212124,
            },
        ];
        assert_eq!(part2(&input), 4174379265);
    }
}
