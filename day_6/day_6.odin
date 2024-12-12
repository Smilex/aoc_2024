package day_6

import "core:fmt"

input_data := #load("input", string)

vec2 :: [2]int

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

    start_pos := vec2{-1, -1}

    for h in 0..<height {
        for w in 0..<width {
            ch := input_data[h * width + w]
            if ch == '^' {
                start_pos = vec2{w,h}
                break
            }
        }
    }

    assert(start_pos != vec2{-1, -1})

    guard_pos := start_pos
    guard_vel := vec2{0,-1}
    rot := matrix[2,2]int{0, -1, 1, 0}
    visited := make(map[vec2]bool)
    visited[guard_pos] = true

    for {
        new_pos := guard_pos + guard_vel
        if new_pos.x < 0 || new_pos.x > width - 1 || new_pos.y < 0 || new_pos.y > height - 1 {
            break
        } else {
            ch := input_data[new_pos.y * width + new_pos.x]
            if ch == '#' {
                guard_vel = rot * guard_vel
            } else {
                guard_pos = new_pos
                visited[guard_pos] = true
            }
        }
    }


    fmt.println("Solution 1 is", len(visited))

    ghost := guard_pos
    ghost_vel := vec2{0, -1}
    num_loops := 0
    for h in 0..<height {
        fmt.println(h)
        for w in 0..<width {
            clear(&visited)
            visited[guard_pos] = true
            is_loop := true
            guard_pos := start_pos
            guard_vel := vec2{0,-1}
            num_visited := 0
            for {
                new_pos := guard_pos + guard_vel
                
                if new_pos.x < 0 || new_pos.x > width - 1 || new_pos.y < 0 || new_pos.y > height - 1 {
                    is_loop = false
                    break
                } else {
                    ch := input_data[new_pos.y * width + new_pos.x]
                    if (new_pos.x == w && new_pos.y == h) || ch == '#' {
                        guard_vel = rot * guard_vel
                    } else {
                        if new_pos in visited {
                            num_visited += 1
                        } else {
                            num_visited = 0
                        }

                        if num_visited >= 200 {
                            break
                        }
                        guard_pos = new_pos
                        visited[guard_pos] = true
                    }
                }
            }

            if is_loop {
                num_loops += 1
            }
        }
    }


    fmt.println("Solution 2 is", num_loops)
}
