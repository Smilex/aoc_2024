package day_3

import "core:strconv"
import "core:unicode"
import "core:fmt"
import "core:strings"

file_data := #load("input", string)

parser_state :: enum {
    INST,
    LHS,
    RHS
}

solution_2 :: proc () {
    sum := 0
    st := parser_state(.INST)
    lhs_start: int
    rhs_start: int
    lhs: int
    rhs: int
    lhs_ok: bool
    rhs_ok: bool
    length := len(file_data)
    enabled := true
    for idx := 0; idx < length - 7; idx += 1 {
        ch := file_data[idx]
        switch st {
            case .INST:
                if enabled {
                    if strings.compare(file_data[idx: idx + 4], "mul(") == 0 {
                        st = .LHS
                        idx += 4 - 1
                        lhs_start = idx + 1
                    } else if strings.compare(file_data[idx: idx + 7], "don't()") == 0 {
                        enabled = false
                        idx += 7 - 1
                    }
                } else {
                    if strings.compare(file_data[idx: idx + 4], "do()") == 0 {
                        enabled = true
                        idx += 4 - 1
                    }
                }
            case .LHS:
                if !(ch >= '0' && ch <= '9') {
                    if ch == ',' {
                        lhs, lhs_ok = strconv.parse_int(file_data[lhs_start:idx]) 
                        if lhs_ok {
                            st = .RHS
                            rhs_start = idx + 1
                        } else {
                            st = .INST
                        }
                    } else {
                        st = .INST
                    }
                }
            case .RHS:
                if !(ch >= '0' && ch <= '9') {
                    if ch == ')' {
                        rhs, rhs_ok = strconv.parse_int(file_data[rhs_start:idx]) 
                        if rhs_ok {
                            sum += lhs * rhs
                        }
                    }
                    st = .INST
                }
        }
    }

    fmt.println("Solution 2 is", sum)

}

solution_1 :: proc () {
    sum := 0
    st := parser_state(.INST)
    lhs_start: int
    rhs_start: int
    lhs: int
    rhs: int
    lhs_ok: bool
    rhs_ok: bool
    length := len(file_data)
    for idx := 0; idx < length - 4; idx += 1 {
        ch := file_data[idx]
        switch st {
            case .INST:
                if strings.compare(file_data[idx: idx + 4], "mul(") == 0 {
                    st = .LHS
                    idx += 4 - 1
                    lhs_start = idx + 1
                }
            case .LHS:
                if !(ch >= '0' && ch <= '9') {
                    if ch == ',' {
                        lhs, lhs_ok = strconv.parse_int(file_data[lhs_start:idx]) 
                        if lhs_ok {
                            st = .RHS
                            rhs_start = idx + 1
                        } else {
                            st = .INST
                        }
                    } else {
                        st = .INST
                    }
                }
            case .RHS:
                if !(ch >= '0' && ch <= '9') {
                    if ch == ')' {
                        rhs, rhs_ok = strconv.parse_int(file_data[rhs_start:idx]) 
                        if rhs_ok {
                            sum += lhs * rhs
                        }
                    }
                    st = .INST
                }
        }
    }

    fmt.println("Solution 1 is", sum)

}

main :: proc() {
    solution_1()
    solution_2()
}
