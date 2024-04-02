package ffi_pkg

import "core:fmt"

import c "core:c/libc"

CurlEasy :: distinct rawptr

foreign import libcurl "system:curl"
@(default_calling_convention = "c", link_prefix = "curl_")
foreign libcurl {
	global_init :: proc(flags: c.int) -> int ---
	easy_init :: proc() -> CurlEasy ---
}

main :: proc() {
	global_init(0)
}
