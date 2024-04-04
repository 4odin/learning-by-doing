package main

import "core:fmt"

LoggableThings :: union {
	int,
	string,
	f64,
}

Redactable :: struct {
	redact: proc(r: ^Redactable),
}

Loggable :: struct {
	using Redactable: Redactable,
	format:           proc(l: ^Loggable) -> string,
}

log_redacted :: proc(l: ^Loggable) {
	assert(l.format != nil, "format is nil")
	// assert(l.redact != nil, "redact is nil")

	if l.redact == nil do l.redact = nil_redact

	l->redact() // identical to l.redact(l)
	fmt.printf("%s\n", l->format()) // instead of l.format(l)

	// rule
	// thing.method(pointer_to_thing) can be replaced with thing->method()
}

User :: struct {
	using loggable:         Loggable, // IMPORTANT: using should not happen at the end of the struct, this is because of the similarities in the form of the so called proc pointer fields that should be the same between Loggable and User so that we can use pointer to User instead of pointer to Loggable (see in main proc call to log_redacted proc)
	name:                   string,
	age:                    int,
	social_security_number: string,
}

user_redact :: proc(r: ^Redactable) {
	u := cast(^User)r
	u.social_security_number = "REDACTED"
}

nil_redact :: proc(r: ^Redactable) {}

user_format :: proc(l: ^Loggable) -> string {
	return fmt.tprintf("%v", cast(^User)l)
}

main :: proc() {
	u := User {
		name                   = "Navid",
		age                    = 36,
		social_security_number = "123456",
		// loggable = Loggable{redact = user_redact, format = user_format},
		// redact                 = nil_redact, // because we have used the using modifier
		format                 = user_format, // same as above
	}

	// log_redacted(&u.loggable)
	log_redacted(&u) // because of "using" modifier


	/////////// Class Example

	e1: Container
	defer container_delete(e1)

	{
		e2 := container_make(1)
		defer container_delete(e2)
	}

	{
		e2 := container_make(2)
		defer container_delete(e2)

		e3 := container_copy(e2)

		fmt.printf("e2.value = %d\n", e2.value)
		fmt.printf("e3.value = %d\n", e3.value)

		fmt.printf("e2.values: ")
		container_print_vector(&e2)
		fmt.printf("e3.values: ")
		container_print_vector(&e3)

		e4 := container_move(e3)
		defer container_delete(e4)

		container_print_vector(&e3)

		assert(&e3 == nil, "e3 must be moved now")
	}
}

////////// A C++ Class to Odin Example

Element :: struct {
	value: int,
}

element_delete :: proc(element: Element) {
	fmt.printf("element_delete: %d\n", element.value)
}

Container :: struct {
	value:  int,
	values: [dynamic]Element,
}

container_make :: proc(value: int, allocator := context.allocator) -> Container {
	fmt.printf("container_make: %d\n", value)
	values := make([dynamic]Element, 0, 3, allocator)

	append(&values, Element{1}, Element{2}, Element{3})

	return Container{value = value, values = values}
}

container_delete :: proc(container: Container) {
	fmt.printf("container_delete: %d\n", container.value)

	// delete individual elements first
	for e in container.values {
		element_delete(e)
	}

	// delete the container at the end
	delete(container.values)
}

container_copy :: proc(other: Container, allocator := context.allocator) -> Container {
	values := make([dynamic]Element, 0, len(other.values) + 1, allocator)

	append(&values, ..other.values[:])
	append(&values, Element{4})

	return Container{value = other.value, values = values}
}

container_move :: proc(other: Container, allocator := context.allocator) -> Container {
	fmt.printf("container_move: %d\n", other.value)

	copy := container_copy(other, allocator)
	container_delete(other)

	return copy
}

container_print_vector :: proc(container: ^Container, allocator := context.allocator) {
	fmt.printf("%p = ", &container.values)
	for e, i in container.values {
		if i != 0 {
			fmt.printf(", ")
		}
		fmt.printf("%d", e.value)
	}
	fmt.printf("\n")
}
