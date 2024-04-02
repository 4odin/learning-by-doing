package main

import "core:c"
import "core:fmt"

@(export)
number :: proc "c" (x: c.int) -> c.int {
	return x + 12
}

Config :: struct {
	x:         c.int,
	init_hook: proc "c" (config: ^Config, x: c.int),
}


@(export)
init_config :: proc "c" (config: ^Config, x: c.int) {
	// many other things to do

	if config.init_hook == nil do default_init_config(config, x)
	else do config.init_hook(config, x)

	// many other things to do
}

default_init_config :: proc "c" (config: ^Config, x: c.int) {
	config.x = x + 12
}


@(export)
my_init_config :: proc "c" (config: ^Config, x: c.int) {
	config.x = x + 45
}
