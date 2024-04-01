package main

import "core:fmt"

A :: struct {
	a: int,
}

B :: struct {
	b: f64,
}

U :: union {
	A,
	B,
}

main :: proc() {
	a := A {
		a = 0,
	}

	b := B {
		b = 0.5,
	}

	u: U = a

	up := &u

	fmt.println(rawptr(up))
	fmt.println(rawptr(&up.(A)))

	switch &t in up {
	case A:
		fmt.println(rawptr(&t))

	case B:
		fmt.println(rawptr(&t))

	}

	u = b
	fmt.println(rawptr(&up^.(B)))

	switch &t in up {
	case A:
		fmt.println(rawptr(&t))

	case B:
		fmt.println(rawptr(&t))
	}
}
