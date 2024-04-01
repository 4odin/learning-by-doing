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

	config, err := my_pkg.read_config("main.odin", my_pkg.EveryMilliSeconds{100})

	if err == nil do fmt.printfln("%v", config)
	else do fmt.eprintln(err)

	config, err = my_pkg.read_config("nothing.txt", 100)
	if err == nil do fmt.printfln("%v", config)
	else do fmt.eprintln(err)
}
