package main

import "core:fmt"
import "pkg1"

main :: proc() {
	fmt.println("hello there")

	msg := pkg1.say_hello("Navid")

	fmt.println(msg)

	// pkg1.say_goodbye() // it's not exported
}
