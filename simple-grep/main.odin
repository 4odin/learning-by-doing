package main

import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import "core:strings"

import "cli"

GrepError :: union {
	UnableToOpenFile,
	UnableToReadFromFile,
	mem.Allocator_Error,
}

UnableToOpenFile :: struct {
	filename: string,
	error:    os.Errno,
}

UnableToReadFromFile :: struct {
	filename: string,
	error:    os.Errno,
}

Arguments :: struct {
	inverted: bool `cli:"i,inverted"`,
}

main :: proc() {
	context.logger = log.create_console_logger()

	arguments := os.args[1:]
	fmt.printf("%v\n", arguments)

	if len(arguments) < 2 {
		fmt.printf("Usage: simple-grep <pattern> <file> [arguments]\n")
		cli.print_help_for_struct_type_and_exit(Arguments)
	}

	pattern := arguments[0]
	filename := arguments[1]

	rest_of_arguments := arguments[2:]
	parsed_arguments := Arguments{}

	if len(rest_of_arguments) > 0 {
		cli_parse, _, parsing_error := cli.parse_arguments_as_type(rest_of_arguments, Arguments)

		if parsing_error != nil {
			fmt.printf("Error while parsing optional arguments: %v\n", parsing_error)
			os.exit(1)
		}

		parsed_arguments = cli_parse
	}

	grep_error := grep_file(pattern, filename, parsed_arguments)
	if grep_error != nil {
		fmt.printf("Error while grepping file '%s': %v\n", filename, grep_error, parsed_arguments)
		os.exit(1)
	}
}

grep_file :: proc(pattern, filename: string, arguments: Arguments) -> GrepError {
	log.debugf(
		"Grep file: '%s' for pattern '%s' with arguments: %v\n",
		filename,
		pattern,
		arguments,
	)

	file_handle, open_error := os.open(filename, os.O_RDONLY)
	if open_error != os.ERROR_NONE {
		return UnableToOpenFile{filename = filename, error = open_error}
	}

	read_buffer: [mem.Kilobyte]byte
	for {
		bytes_read, read_error := os.read(file_handle, read_buffer[:])
		if bytes_read == 0 && read_error == os.ERROR_HANDLE_EOF {
			break
		}
		if read_error != os.ERROR_NONE {
			return UnableToReadFromFile{filename = filename, error = read_error}
		}

		s := string(read_buffer[:bytes_read])
		lines := strings.split_lines(s) or_return

		for l in lines {
			if arguments.inverted {
				if !strings.contains(l, pattern) {
					fmt.printf("%s\n", l)
				}
			} else {
				if strings.contains(l, pattern) {
					fmt.printf("%s\n", l)
				}
			}

		}
	}

	return nil
}