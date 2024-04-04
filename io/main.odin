package main

import "base:runtime"
import "core:bufio"
import "core:fmt"
import "core:io"
import "core:log"
import "core:mem"
import "core:os"
import "core:testing"

ReadFileError :: union {
	OpenError,
	ReaderCreationError,
	mem.Allocator_Error,
	io.Error,
}

OpenError :: struct {
	filename: string,
	error:    os.Errno,
}

ReaderCreationError :: struct {
	filename: string,
	stream:   io.Stream,
}

read_lines_from_file :: proc(
	filename: string,
	allocator := context.allocator,
) -> (
	lines: [][]byte,
	error: ReadFileError,
) {
	handle, open_error := os.open(filename, os.O_RDONLY)

	if open_error != os.ERROR_NONE {
		return nil, OpenError{filename, open_error}
	}

	stream := os.stream_from_handle(handle)
	file_reader, ok := io.to_reader(stream)

	if !ok {
		return nil, ReaderCreationError{filename, stream}
	}

	log_data: LogData

	reader := add_logging_to_reader(&file_reader, &log_data)

	bufio_reader: bufio.Reader
	bufio.reader_init(&bufio_reader, reader, 256, allocator)

	bufio_reader.max_consecutive_empty_reads = 1 // pointless with my implementation?? I'm not sure

	_lines := make([dynamic][]byte, 0, 0, allocator) or_return

	for {
		line, read_error := bufio.reader_read_bytes(&bufio_reader, '\n', allocator)

		// No_Progress does not work as intended on my machine
		// I'm getting infinite loop with log "[2024-04-04 08:54:14] [main.odin:51:read_lines_from_file()] Read 0 bytes | Error: EOF"
		// if read_error == io.Error.No_Progress do break

		append(&_lines, line)

		// instead I've added these and it works as expected
		if read_error == io.Error.EOF do break
		else if read_error != io.Error.None do return nil, read_error
	}

	return _lines[:], nil
}

add_logging_to_reader :: proc(
	base_reader: ^io.Reader,
	data: ^LogData,
	loc := #caller_location,
) -> (
	r: io.Reader,
) {
	data^ = LogData{base_reader, loc}

	return io.Reader{procedure = _logging_stream_proc, data = data}
}

LogData :: struct {
	base_reader: ^io.Reader,
	location:    runtime.Source_Code_Location,
}

@(private = "file")
_logging_stream_proc :: proc(
	stream_data: rawptr,
	mode: io.Stream_Mode,
	p: []byte,
	offset: i64,
	whence: io.Seek_From,
) -> (
	n: i64,
	err: io.Error,
) {
	if stream_data == nil {
		panic("stream_data is nil")
		// return 0, nil // or this maybe!?
	}

	data := transmute(^LogData)stream_data

	n, err = data.base_reader.procedure(data.base_reader.data, mode, p, offset, whence)

	log.debugf("Read %d bytes | Error: %v", n, err, location = data.location)

	return n, err
}

@(test, private = "package")
test_read_file_by_lines :: proc(t: ^testing.T) {
	context.logger = log.create_console_logger()

	lines, read_lines_error := read_lines_from_file("odinfmt.json")

	testing.expect_value(t, read_lines_error, nil)
	testing.expect_value(t, len(lines), 6)

	for l in lines {
		fmt.printf("%s", l)
	}

	fmt.printf("\n")
}
