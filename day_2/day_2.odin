package day_2

import "core:os"
import "core:fmt"
import "core:bufio"
import "core:strconv"
import "core:sort"
import "core:math"
import "core:strings"

mode_name :: enum {
    NOT_FOUND_YET,
    INCREASING,
    DECREASING
}

solution_1 :: proc(words: []string) -> int {
    num_words := len(words)
    assert(num_words > 1)

    safe := true
    mode: mode_name = .NOT_FOUND_YET
    for i := 1; i < num_words; i += 1 {
        lhs, lhs_ok := strconv.parse_u64(words[i - 1])
        assert(lhs_ok)
        rhs, rhs_ok := strconv.parse_u64(words[i])
        assert(rhs_ok)

        diff := int(rhs) - int(lhs)
        a := math.abs(diff)
        if a > 0 && a < 4 {
            switch mode {
            case .NOT_FOUND_YET:
                if diff < 0 {
                    mode = .DECREASING
                } else {
                    mode = .INCREASING
                }
            case .INCREASING:
                if diff < 0 {
                    safe = false
                    break
                }
            case .DECREASING:
                if diff > 0 {
                    safe = false
                    break
                }
            }
        } else {
            safe = false
            break
        }
    }

    if safe {
        return 1
    }

    return 0
}

solution_2 :: proc(words: []string) -> int {
    if solution_1(words) > 0 {
        return 1
    }

    num_words := len(words)
    assert(num_words > 1)

    lists := make([]string, num_words * (num_words - 1))
    defer delete(lists)

    for i := 0; i < num_words; i += 1 {
        it := 0
        for j := 0; j < num_words; j += 1 {
            if i != j {
                lists[i * (num_words - 1) + it] = words[j]
                it += 1
            }
        }
    }

    for l_idx := 0; l_idx < num_words; l_idx += 1 {
        mode: mode_name = .NOT_FOUND_YET
        list_len := num_words - 1
        assert(list_len > 1)
        safe := true
        for i := 1; i < list_len; i += 1 {
            lhs, lhs_ok := strconv.parse_u64(lists[list_len * l_idx + i - 1])
            assert(lhs_ok)
            rhs, rhs_ok := strconv.parse_u64(lists[list_len * l_idx + i])
            assert(rhs_ok)

            diff := int(rhs) - int(lhs)
            a := math.abs(diff)
            if a > 0 && a < 4 {
                switch mode {
                case .NOT_FOUND_YET:
                    if diff < 0 {
                        mode = .DECREASING
                    } else {
                        mode = .INCREASING
                    }
                case .INCREASING:
                    if diff < 0 {
                        safe = false
                        break
                    }
                case .DECREASING:
                    if diff > 0 {
                        safe = false
                        break
                    }
                }
            } else {
                safe = false
                break
            }
        }

        if safe {
            return 1
        }
    }

    return 0
}

main :: proc () {
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

    scanner: bufio.Scanner
    bufio.scanner_init(&scanner, os.stream_from_handle(fh), context.temp_allocator)
    defer bufio.scanner_destroy(&scanner)

    problem_1_sum := 0
    problem_2_sum := 0
    for bufio.scanner_scan(&scanner) {
        line := bufio.scanner_text(&scanner)

        words := strings.split(line, " ")
        defer delete(words)

        problem_1_sum += solution_1(words[:])
        problem_2_sum += solution_2(words[:])
    }

    fmt.printf("Solution 1: %v are safe\n", problem_1_sum)
    fmt.printf("Solution 2: %v are safe\n", problem_2_sum)
}
