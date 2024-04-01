package main

import "core:fmt"

Interval :: union {
	Never,
	Once,
	EveryMilliSeconds,
}

Never :: struct {}
Once :: struct {}
EveryMilliSeconds :: struct {}

Configuration :: struct {
	filename:         string,
	interval:         Interval,
	url:              string,
	calculated_later: f32,
}

read_config :: proc(filename: string, interval: Interval) -> (config: Configuration) {
	config.filename = filename
	config.interval = interval

	return config
}

main :: proc() {
	config := read_config("my_file.txt", Never{})

	fmt.println(config)
}
