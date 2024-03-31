package pkg1

import "core:fmt"
import "core:strings"

@(private)
say_goodbye :: proc() {}

say_hello :: proc(name: string) -> string {
	return strings.join({"hello", name}, " ")
}
