package my_pkg

import "core:encoding/json"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:testing"

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

ConfigurationJson :: struct {
	filename: string,
	interval: string,
	url:      string,
}

fantastic_func :: proc(x: int) -> (a: int) {
	// some comment
	a = x + 1
	return
}

ParsingError :: union {
	InvalidSyntax,
	InvalidValue,
	json.Unmarshal_Error,
	json.Error,
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
	value:  json.Value,
	field:  string,
}

parse_configuration :: proc(data: []byte) -> (config: Configuration, err: ParsingError) {
	// config_json: ConfigurationJson
	// json.unmarshal(data, &config_json) or_return

	// config.filename = config_json.filename
	// config.url = config_json.url

	// switch config_json.interval {
	// case "never":
	// 	config.interval = Never{}

	// case "once":
	// 	config.interval = Once{}

	// case:
	// 	i, parse_success := strconv.parse_int(config_json.interval)

	// 	if parse_success do config.interval = EveryMilliSeconds {
	// 		interval = i,
	// 	}
	// }

	json_value := json.parse(data) or_return

	object, is_object := json_value.(json.Object)

	if !is_object {
		return Configuration{}, InvalidValue{value = json_value}
	}

	filename, filename_is_string := object["filename"].(json.String)
	if !filename_is_string && object["filename"] != nil {
		return Configuration{}, InvalidValue{value = object["filename"], field = "filename"}
	}

	url, url_is_string := object["url"].(json.String)
	if !url_is_string && object["url"] != nil {
		return Configuration{}, InvalidValue{value = object["url"], field = "url"}
	}

	interval: Interval
	interval_string, interval_is_string := object["interval"].(json.String)
	interval_int, interval_is_int := object["interval"].(json.Integer)

	if interval_is_string {
		switch interval_string {
		case "never":
			interval = Never{}

		case "once":
			interval = Once{}

		case:
			return Configuration{}, InvalidValue{value = object["interval"], field = "interval"}
		}
	} else if interval_is_int {
		interval = EveryMilliSeconds {
			interval = int(interval_int),
		}
	} else if object["interval"] == nil {
		interval = nil
	} else {
		return Configuration{}, InvalidValue{value = object["interval"], field = "interval"}
	}

	config.filename = filename
	config.url = url
	config.interval = interval

	return config, nil
}

@(test)
test_parse_configuration :: proc(t: ^testing.T) {
	testing.expect_value(t, 1, 1)

	expected := 1
	actual := 1
	testing.expect(t, actual == expected, fmt.tprintf("Expected=%v, got=%v", expected, actual))
}

@(test)
test_json :: proc(t: ^testing.T) {
	expected := Configuration{}
	actual, parsing_error := parse_configuration([]byte{'{', '}'})

	testing.expect(
		t,
		parsing_error == nil,
		fmt.tprintf("Expected no parse_error but got='%v'", parsing_error),
	)
	testing.expect(t, expected == actual, fmt.tprintf("Expected=%v, got=%v", expected, actual))

	expected2 := Configuration {
		filename = "some_file.txt",
		interval = Once{},
		url      = "some_url",
	}
	data2 := transmute([]byte)string(
		`
        {"filename": "some_file.txt", "interval": "once", "url": "some_url"}
    `,
	)

	actual2, parsing_error2 := parse_configuration(data2)

	testing.expect(
		t,
		parsing_error2 == nil,
		fmt.tprintf("Expected no parse_error2 but got='%v'", parsing_error2),
	)
	testing.expect(t, expected2 == actual2, fmt.tprintf("Expected=%v, got=%v", expected2, actual2))
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
