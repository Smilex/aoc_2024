package day_4

import "core:math/linalg"
import "core:fmt"
import "core:strings"

input_data := #load("input", string)
test_data := `.M.S......
..A..MSMS.
.M.S.MAA..
..A.ASMSM.
.M.S.M....
..........
S.S.S.S.S.
.A.A.A.A..
M.M.M.M.M.
..........
`

horizontal :: proc(data: string, width, height: int) -> int {
    rv := 0
    for h in 0..<height {
        for w in 0..<width - 3 {
            if strings.compare(data[h * width + w:h * width + w + 4], "XMAS") == 0 {
                rv += 1
            }
        }
    }

    return rv
}

vertical :: proc(data: string, width, height: int) -> int {
    rv := 0
    for w in 0..<width {
        for h in 0..<height - 3 {
            vert: [4]u8
            vert[0] = data[h * width + w]
            vert[1] = data[(h + 1) * width + w]
            vert[2] = data[(h + 2) * width + w]
            vert[3] = data[(h + 3) * width + w]
            if strings.compare(string(vert[:]), "XMAS") == 0 {
                rv += 1
            }
        }
    }

    return rv
}

diagonal :: proc(data: string, width, height: int) -> int {
    rv := 0
    for w in 0..<width - 3 {
        for h in 0..<height - 3 {
            diag: [4]u8
            diag[0] = data[h * width + w]
            diag[1] = data[(h + 1) * width + (w + 1)]
            diag[2] = data[(h + 2) * width + (w + 2)]
            diag[3] = data[(h + 3) * width + (w + 3)]
            if strings.compare(string(diag[:]), "XMAS") == 0 {
                rv += 1
            }
        }
    }

    return rv
}

box :: proc(data: string, width, height: int) -> int {
    rv := 0
    for w in 0..<width - 2 {
        for h in 0..<height - 2 {
            num_diag := 0
            diag: [3]u8
            diag[0] = data[h * width + w]
            diag[1] = data[(h + 1) * width + (w + 1)]
            diag[2] = data[(h + 2) * width + (w + 2)]
            if strings.compare(string(diag[:]), "MAS") == 0 {
                num_diag += 1
            }

            if strings.compare(string(diag[:]), "SAM") == 0 {
                num_diag += 1
            }
            
            diag[0] = data[(h + 2) * width + w]
            diag[1] = data[(h + 2 - 1) * width + (w + 1)]
            diag[2] = data[(h + 2 - 2) * width + (w + 2)]
            if strings.compare(string(diag[:]), "MAS") == 0 {
                num_diag += 1
            }

            if strings.compare(string(diag[:]), "SAM") == 0 {
                num_diag += 1
            }

            if num_diag >= 2 {
                rv += 1
            }
        }
    }

    return rv
}

solution_1 :: proc (width, height: int, reversed_column, reversed_row, reversed_row_column: string) {
    sum := 0

    sum += horizontal(input_data, width, height)
    sum += vertical(input_data, width, height)


    sum += horizontal(reversed_column, width, height)
    sum += vertical(reversed_row, width, height)

    sum += diagonal(input_data, width, height)
    sum += diagonal(reversed_column, width, height)
    sum += diagonal(reversed_row, width, height)
    sum += diagonal(reversed_row_column, width, height)

    fmt.println("Solution 1 is", sum)
}

solution_2 :: proc (width, height: int, reversed_column, reversed_row, reversed_row_column: string) {
    sum := 0

    //sum += box(test_data, 11, 10)
    sum += box(input_data, width, height)

    fmt.println("Solution 2 is", sum)
}

main :: proc () {
    found_newline := false
    width := 0
    height := 0
    for ch in input_data {
        if ch == '\n' {
            found_newline = true
            height += 1
        }
        if !found_newline {
            width += 1
        }
    }

    width += 1

    assert(width * height == len(input_data))

    fmt.println("Input width is", width, "and height is", height)

    reversed_column := make([]u8, width * height)
    defer delete(reversed_column)
    reversed_row := make([]u8, width * height)
    defer delete(reversed_row)
    reversed_row_column := make([]u8, width * height)
    defer delete(reversed_row_column)
    for h in 0..<height {
        for w in 0..<width {
            reversed_column[h * width + w] = input_data[h * width + width - w - 1]
        }
    }

    for h in 0..<height {
        for w in 0..<width {
            reversed_row[h * width + w] = input_data[(height - h - 1) * width + w]
        }
    }

    for h in 0..<height {
        for w in 0..<width {
            reversed_row_column[h * width + w] = input_data[(height - h - 1) * width + width - w - 1]
        }
    }

    reversed_column_string := string(reversed_column[:])
    reversed_row_string := string(reversed_row[:])
    reversed_row_column_string := string(reversed_row_column[:])


    solution_1(width, height, reversed_column_string, reversed_row_string, reversed_row_column_string)
    solution_2(width, height, reversed_column_string, reversed_row_string, reversed_row_column_string)
}
