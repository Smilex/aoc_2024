package day_5

import "core:strconv"
import "core:fmt"

input_data := #load("input", string)
test_data := `47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
`

order_list :: proc(list: []int, rules: map[int][dynamic]int) {
    passed := false

    for !passed {
        passed = true
        for i := 0; i < len(list) - 1; i += 1 {
            lhs := list[i]
            rhs := list[i + 1]

            if lhs in rules {
                for r in rules[lhs] {
                    if rhs == r {
                        temp := list[i]
                        list[i] = list[i + 1]
                        list[i + 1] = temp
                        passed = false
                        break
                    }
                }
            }
        }
    }
}

main :: proc () {
    //data := test_data
    //length := len(test_data)
    data := input_data
    length := len(input_data)
    solution_1_sum := 0
    solution_2_sum := 0

    list := make([]int, 100)
    defer delete(list)
    list_used := 0

    rules := make(map[int][dynamic]int)
    // defer delete(rules)   -- I can iterate over the map and delete child arrays

    lhs_idx := 0
    rhs_idx := -1
    is_rules := true
    for idx := 0; idx < length; idx += 1 {
        if is_rules {
            if data[idx] == '|' {
                rhs_idx = idx + 1
            } else if data[idx] == '\n' {
                lhs, lhs_ok := strconv.parse_int(data[lhs_idx:rhs_idx - 1])
                assert(lhs_ok)
                assert(rhs_idx != -1)
                rhs, rhs_ok := strconv.parse_int(data[rhs_idx:idx])
                assert(rhs_ok)

                if rhs not_in rules {
                    arr := make([dynamic]int) // Intentionally not deleted

                    rules[rhs] = arr
                }

                append(&rules[rhs], lhs)

                lhs_idx = idx + 1

                if data[idx + 1] == '\n' {
                    is_rules = false
                    idx += 1
                    lhs_idx = idx + 1
                }
            }
        } else {
            num := -1
            num_ok: bool
            if data[idx] == '\n' {
                num, num_ok = strconv.parse_int(data[lhs_idx:idx])
                assert(num_ok)

                list[list_used] = num
                list_used += 1

                breaks_rule := false
                list_loop: for i := 0; i < list_used; i += 1 {
                    num = list[i]
                    if num in rules {
                        for j := i + 1; j < list_used; j += 1 {
                            val := list[j]
                            for v in rules[num] {
                                if val == v {
                                    breaks_rule = true;
                                    break list_loop
                                }
                            }
                        }
                    }
                }

                if !breaks_rule {
                    //fmt.println(list[:list_used])

                    solution_1_sum += list[list_used / 2]
                } else {
                    order_list(list[:list_used], rules)

                    solution_2_sum += list[list_used / 2]
                }

                lhs_idx = idx + 1
                list_used = 0
            } else if data[idx] == ',' {
                num, num_ok = strconv.parse_int(data[lhs_idx:idx])
                assert(num_ok)
                lhs_idx = idx + 1

                list[list_used] = num
                list_used += 1
            }
        }
    }

    fmt.println("Solution 1 is", solution_1_sum)
    fmt.println("Solution 2 is", solution_2_sum)
}
