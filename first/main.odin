package main

import "core:fmt"
import "core:log"
import "core:mem"
import "core:mem/virtual"
import "core:os"
import "my_pkg"

NAME :: "Navid Dezashibi"

main :: proc() {
	fmt.printfln("Hello {}", NAME)

	x := 10
	y: int

	fmt.printfln("x is {} and y is {}", x, y)

	msg := some_info()
	defer delete(msg)

	fmt.println(msg, "and x =", other_func(42, 12), "\nsum of 1 to 10 = ", for_loop_text(10))

	fmt.println("the result of my fantastic_func for 20 is", my_pkg.fantastic_func(20))

	// definition of a stack based memory arena
	// we use this memory in our program (256 bytes of memory block)
	arena: virtual.Arena
	arena_buffer: [256]u8
	arena_init_error := virtual.arena_init_buffer(&arena, arena_buffer[:])
	if arena_init_error != nil {
		fmt.panicf("Error initializing arena: %v\n", arena_init_error)
	}

	// create a new allocator
	arena_allocator := virtual.arena_allocator(&arena)
	// defer the deletion of the memory at the end of the scope
	// in this case the []byte is stack and will be deleted and this is not needed
	defer virtual.arena_destroy(&arena)

	// context.allocator = arena_allocator
	// config, err := my_pkg.read_config("file1.txt", my_pkg.EveryMilliSeconds{100})

	// context.logger = log.create_console_logger()

	log_file_handle, log_file_open_error := os.open("log.txt", os.O_APPEND)
	if log_file_open_error != 0 {
		fmt.panicf("Error creating log file: %v\n", log_file_open_error)
	}
	context.logger = log.create_multi_logger(
		log.create_console_logger(),
		log.create_file_logger(log_file_handle),
	)

	config, err := my_pkg.read_config("file1.txt", my_pkg.EveryMilliSeconds{100}, arena_allocator)
	if err == nil do fmt.printfln("%v", config)
	else do fmt.eprintln("Error:", err)

	// config, err = my_pkg.read_config("file_that_does_not_exist.txt", 100)
	config, err = my_pkg.read_config("file_that_does_not_exist.txt", 100, arena_allocator)
	if err == nil do fmt.printfln("%v", config)
	else do fmt.eprintln("Error:", err)
}
