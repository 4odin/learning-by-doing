package main

import "core:fmt"
import "my_pkg"

NAME :: "Navid Dezashibi"

main :: proc() {
	fmt.printfln("Hello {}", NAME)

	x := 10
	y: int

	fmt.printfln("x is {} and y is {}", x, y)

	msg := some_info()
	defer delete(msg)

	fmt.println(msg, "and x =", other_func(42, 12), "\nsum of 1 to 10 = ", for_loop_text(10))

	fmt.println("the result of my fantastic_func for 20 is", my_pkg.fantastic_func(20))

	config := my_pkg.read_config("my_file.txt", my_pkg.EveryMilliSeconds{100})
	fmt.printfln("%v", config)

	config = my_pkg.read_config("my_file.txt", 100)
	fmt.printfln("%v", config)
}
