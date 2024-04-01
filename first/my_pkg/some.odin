package my_pkg

import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import "core:strings"

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

ParsingError :: union {
	InvalidSyntax,
	InvalidValue,
}

InvalidSyntax :: struct {
	line:   int,
	column: int,
	data:   []byte,
}

InvalidValue :: struct {
	line:   int,
	column: int,
	data:   []byte,
	value:  string,
}

parse_configuration :: proc(data: []byte) -> (config: Configuration, err: ParsingError) {

	return config, nil
}

ConfigurationError :: union {
	ParsingError,
	FileReadFailure,
	mem.Allocator_Error,
}

FileReadFailure :: struct {
	filename: string,
	errno:    os.Errno,
}


read_config :: proc(
	filename: string,
	interval: Interval,
	allocator := context.allocator,
) -> (
	config: Configuration,
	err: ConfigurationError,
) {
	file_data, read_successful := os.read_entire_file_from_filename(filename, allocator)
	if !read_successful {
		return Configuration{}, FileReadFailure{filename = filename}
	}

	// parse_error: ParsingError
	// config, parse_error = parse_configuration(file_data)
	// if parse_error != nil {
	// 	return Configuration{}, parse_error
	// }
	config = parse_configuration(file_data) or_return

	log.debugf("Parsed config: %v\n", config)

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

	config.url = strings.concatenate({"prefix://", config.filename}, allocator) or_return

	return config, nil
}
