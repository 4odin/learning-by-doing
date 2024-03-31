package main

import "core:fmt"

import SDL "vendor:sdl2"

main :: proc() {
	fmt.println("Hello Odin!")

	window := SDL.CreateWindow(
		"SAMPLE WINDOW",
		SDL.WINDOWPOS_UNDEFINED,
		SDL.WINDOWPOS_UNDEFINED,
		800,
		600,
		{},
	)

	if window == nil {
		fmt.eprintln("Window creation has been failed")
		return
	}

	defer SDL.DestroyWindow(window)

	event: SDL.Event

	loop: for {
		for SDL.PollEvent(&event) {
			#partial switch event.type {
			case .QUIT:
				break loop
			}
		}
	}
}
