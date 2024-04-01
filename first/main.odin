package main

import "core:fmt"

NAME :: "Navid Dezashibi"

main :: proc() {
	fmt.printfln("Hello {}", NAME)

	x := 10
	y: int

	fmt.printfln("x is {} and y is {}", x, y)

	msg := some_info()
	defer delete(msg)

	fmt.println(msg, "and x =", other_func(42, 12), "\nsum of 1 to 10 = ", for_loop_text(10))
}
