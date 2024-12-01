package day_1

import "core:os"
import "core:fmt"
import "core:bufio"
import "core:strconv"
import "core:sort"
import "core:math"

// NOTES(ian)
//  Every line is 5 + 3 + 5 = 13 characters long, without newline
//  There are 1000 lines
WORD_LEN :: 5
NUM_LINES :: 1000

solution_1 :: proc(firsts: []u32, seconds: []u32) {
    sum := 0
    for i in 0..<len(firsts)  {
        distance := math.abs(int(seconds[i]) - int(firsts[i]))
        sum += distance
    }

    fmt.printf("Solution 1: The total distance is %v\n", sum)

}

solution_2 :: proc(firsts: []u32, seconds: []u32) {
    sum := 0
    first_idx := 0
    second_idx := 0

    for {
        first_loop: for ; first_idx < len(firsts); first_idx += 1 {
            first := firsts[first_idx]
            for ; second_idx < len(seconds); second_idx += 1 {
                second := seconds[second_idx]
                if first == second {
                    break first_loop
                } else if first < second {
                    break
                }
            }
        }

        if first_idx >= len(firsts) {
            break
        }

        first := firsts[first_idx]
        mul := 1
        second_idx += 1
        for ; second_idx < len(seconds); second_idx += 1 {
            second := seconds[second_idx]
            if first == second {
                mul += 1
            } else {
                break
            }
        }

        sum += int(first) * mul

    }

    fmt.printf("Solution 2: The total sum is %v\n", sum)
}

main :: proc() {
    base_dir := os.args[0]
    base_dir_len := len(base_dir)

    for base_dir_len > 0 {
        base_dir_len -= 1
        if base_dir[base_dir_len] == '/' || base_dir[base_dir_len] == '\\' {
            base_dir_len += 1
            break
        }
    }

    input_path := "input"
    if base_dir_len > 0 {
        input_path = fmt.aprint(base_dir[:base_dir_len], "input", sep="")
    }

    fmt.printf("Opening '%s' as our input\n", input_path)
    fh, fh_err := os.open(input_path)
    delete(input_path)
    assert(fh_err == nil)

    firsts: [NUM_LINES]u32
    seconds: [NUM_LINES]u32
    it := 0

    scanner: bufio.Scanner
    bufio.scanner_init(&scanner, os.stream_from_handle(fh), context.temp_allocator)
    defer bufio.scanner_destroy(&scanner)

    for bufio.scanner_scan(&scanner) {
        line := bufio.scanner_text(&scanner)

        first, first_ok := strconv.parse_u64(string(line[:WORD_LEN]))
        assert(first_ok)
        second, second_ok := strconv.parse_u64(string(line[WORD_LEN + 3:]))
        assert(second_ok)


        firsts[it] = u32(first)
        seconds[it] = u32(second)

        it += 1
    }

    assert(it == NUM_LINES)

    sort.quick_sort(firsts[:])
    sort.quick_sort(seconds[:])

    solution_1(firsts[:], seconds[:])
    solution_2(firsts[:], seconds[:])
}
