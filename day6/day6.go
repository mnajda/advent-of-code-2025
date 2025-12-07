package main

import (
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
)

type row struct {
	nums []int64
	op   byte
}

func LoadFile(path string) (inputs []string) {
	file, _ := os.ReadFile("input.txt")
	input := string(file[:])

	inputs = strings.Split(input, "\n")

	return
}

func Parse(input []string) (rows []row) {
	rowsNum := len(strings.Fields(input[0]))
	rows = make([]row, rowsNum)

	for _, in := range input[:len(input)-1] {
		row := strings.Fields(in)

		for idx, strNum := range row {
			num, _ := strconv.ParseInt(strNum, 10, 64)
			rows[idx].nums = append(rows[idx].nums, num)
		}
	}

	ops := strings.Fields(input[len(input)-1])
	for idx, op := range ops {
		rows[idx].op = op[0]
	}

	return
}

func ConstructNumbers(input []string) (numbers []int64) {
	maxCol := 0
	for _, line := range input {
		if len(line) > maxCol {
			maxCol = len(line)
		}
	}

	padded := make([]string, len(input))
	for i, line := range input {
		padded[i] = line + strings.Repeat(" ", maxCol-len(line))
	}

	for j := 0; j < maxCol; j++ {
		numStr := strings.Builder{}
		for i := 0; i < len(padded); i++ {
			if j < len(padded[i]) && padded[i][j] != ' ' {
				numStr.WriteByte(padded[i][j])
			}
		}
		if numStr.Len() > 0 {
			number, _ := strconv.ParseInt(numStr.String(), 10, 64)
			numbers = append(numbers, number)
		}
	}

	return
}

func ParseAsCephalopodMath(input []string) (rows []row) {
	rowsNum := len(strings.Fields(input[0]))
	rows = make([]row, rowsNum)

	nums := ConstructNumbers(input[:len(input)-1])

	nbOfOps := len(input) - 1

	i := 0
	previousIdx := 0
	for idx := nbOfOps; idx <= len(nums); idx += (nbOfOps) {
		rows[i].nums = append(rows[i].nums, nums[previousIdx:idx]...)
		i += 1
		previousIdx = idx
	}

	ops := strings.Fields(input[nbOfOps])
	idx := 0
	for _, op := range slices.Backward(ops) {
		rows[idx].op = op[0]
		idx += 1
	}

	return
}

func Solve(input []row) (result int64) {
	for _, row := range input {
		var partialResult int64 = 0

		if row.op == '*' {
			partialResult = 1
		}

		for _, num := range row.nums {
			if row.op == '*' {
				partialResult *= num
			} else {
				partialResult += num
			}
		}

		result += partialResult
	}

	return
}

func main() {
	path := os.Args[1]
	input := LoadFile(path)

	fmt.Printf("Part 1 result is %v\n", Solve(Parse(input)))
	fmt.Printf("Part 2 result is %v\n", Solve(ParseAsCephalopodMath(input)))
}
