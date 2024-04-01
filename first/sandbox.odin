package main

some_info :: proc() -> string {
	return "My name is Navid"
}

other_func :: proc(x, y: int) -> int {
	return x + y + 1
}

for_loop_text :: proc(x: int) -> int {
	sum: int

	for i in 1 ..= x {
		sum += i
	}

	return sum
}
