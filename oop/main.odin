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
}
