package main

import "core:fmt"
import "core:strings"
import "core:unicode/utf8"
import "pkg1"

main :: proc() {
	fmt.println("hello there")

	msg := pkg1.say_hello("Navid")
	defer delete(msg)

	fmt.println(msg)

	// pkg1.say_goodbye() // it's not exported

	fmt.println(sep = "_", args = {"a", "b", "c"})

	text: string = "این یک پیغام است ✅👍🌍😅 This is a message"
	defer delete(text)

	fmt.println("'", text, "' has", strings.rune_count(text), "rune(s).")

	for codepoint, index in text {
		fmt.println(index, "-", codepoint)
	}

	// this works
	text2 := utf8.string_to_runes(text)

	fmt.println("'", text, "' has", len(text2), "rune(s).")

	for codepoint, index in text2 {
		fmt.print(index, "-", codepoint)

		switch codepoint {
		case '😅':
			fmt.print(" - that's shy laughping")
		case 'ا':
			fmt.print(" - that's A")
		}

		fmt.println("")
	}
}
