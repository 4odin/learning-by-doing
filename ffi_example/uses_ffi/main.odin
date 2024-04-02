package uses_ffi

import "../ffi_pkg"

main :: proc() {
	ffi_pkg.global_init(0)
}
