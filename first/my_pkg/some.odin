package my_pkg

import "core:fmt"

Interval :: union {
	Never,
	Once,
	EveryMilliSeconds,
	int,
}

Never :: struct {}
Once :: struct {}
EveryMilliSeconds :: struct {
	interval: int,
}

Configuration :: struct {
	filename:         string,
	interval:         Interval,
	url:              string,
	calculated_later: f32,
}

fantastic_func :: proc(x: int) -> (a: int) {
	// some comment
	a = x + 1
	return
}

read_config :: proc(filename: string, interval: Interval) -> (config: Configuration) {
	config.filename = filename
	config.interval = interval

	switch i in interval {
	case Never, Once:
		fmt.printf("never or once: %v\n", i)

	case int:
		fmt.printf("got int: %v\n", i)

	case EveryMilliSeconds:
		fmt.printf("every milliseconds: %v\n", i)
	}

	if every, is_every_milliseconds := interval.(EveryMilliSeconds); is_every_milliseconds {
		fmt.println("yes it is struct =", every)
	}

	if every, is_every_milliseconds := interval.(int); is_every_milliseconds {
		fmt.println("yes it is int =", every)
	}

	return config
}
