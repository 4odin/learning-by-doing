package main

import "core:fmt"

NAME :: "Navid Dezashibi"

main :: proc() {
	fmt.printfln("Hello {}", NAME)

	x := 10
	y: int

	fmt.printfln("x is {} and y is {}", x, y)
}
