package main

import "core:fmt"

import SDL "vendor:sdl2"

State :: struct {
	window:   ^SDL.Window,
	renderer: ^SDL.Renderer,
}

main :: proc() {
	state: State

	state.window = SDL.CreateWindow("GAME", 100, 200, 1280, 720, {})

	if state.window == nil {
		fmt.eprintln("Window creation has been failed")
		return
	}
	defer SDL.DestroyWindow(state.window)

	state.renderer = SDL.CreateRenderer(state.window, -1, {.ACCELERATED})

	if state.renderer == nil {
		fmt.eprintln("Renderer creation has been failed")
		return
	}
	defer SDL.DestroyRenderer(state.renderer)

	event: SDL.Event
	loop: for {
		for SDL.PollEvent(&event) {
			#partial switch event.type {
			case .QUIT:
				break loop
			}
		}

		SDL.SetRenderDrawColor(state.renderer, 0, 0, 0, 0xff)
		SDL.RenderClear(state.renderer)

		SDL.SetRenderDrawColor(state.renderer, 0xff, 0, 0xff, 0xff)
		SDL.RenderFillRect(state.renderer, &SDL.Rect{0, 0, 10, 10})

		SDL.RenderPresent(state.renderer)
	}
}
