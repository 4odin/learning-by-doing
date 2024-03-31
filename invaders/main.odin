package main

import "core:fmt"

import SDL "vendor:sdl2"

State :: struct {
	window:   ^SDL.Window,
	renderer: ^SDL.Renderer,
	texture:  ^SDL.Texture,
}

main :: proc() {
	state: State

	// Create Window
	state.window = SDL.CreateWindow("GAME: ODIN SPACE INVADERS", 100, 200, 1280, 720, {})
	if state.window == nil {
		fmt.eprintln("Window creation has been failed")
		return
	}
	defer SDL.DestroyWindow(state.window)

	// Create Renderer
	state.renderer = SDL.CreateRenderer(state.window, -1, {.ACCELERATED})
	if state.renderer == nil {
		fmt.eprintln("Renderer creation has been failed")
		return
	}
	defer SDL.DestroyRenderer(state.renderer)

	// Create Back Buffer
	state.texture = SDL.CreateTexture(
		state.renderer,
		transmute(u32)SDL.PixelFormatEnum.ARGB8888,
		.STREAMING,
		256,
		144,
	)
	if state.texture == nil {
		fmt.eprintln("Texture creation has been failed")
		return
	}
	defer SDL.DestroyTexture(state.texture)

	event: SDL.Event
	loop: for {
		for SDL.PollEvent(&event) {
			#partial switch event.type {
			case .QUIT:
				break loop
			}
		}

		SDL.SetRenderTarget(state.renderer, state.texture)

		SDL.SetRenderDrawColor(state.renderer, 0, 0, 0, 0xff)
		SDL.RenderClear(state.renderer)

		SDL.SetRenderDrawColor(state.renderer, 0xff, 0, 0xff, 0xff)
		SDL.RenderFillRect(state.renderer, &SDL.Rect{0, 0, 10, 10})

		// draw texture to screen
		SDL.SetRenderTarget(state.renderer, nil)
		SDL.RenderCopy(state.renderer, state.texture, nil, nil)

		SDL.RenderPresent(state.renderer)
	}
}
