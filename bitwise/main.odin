package main

import "core:fmt"

main :: proc() {
	x := 0b110_0110 // 0x66
	mask := 0x0f

	fmt.printf("x        = %d (%#02x, %#08b)\n", x, x, x)

	fmt.printf("x >> 1   = %d  (%#02x, %#08b)\n", x >> 1, x >> 1, x >> 1)
	fmt.printf("x >> 2   = %d  (%#02x, %#08b)\n", x >> 2, x >> 2, x >> 2)

	// masking and get the upper half of the byte
	fmt.printf("mask     = %d  (%#02x, %#08b)\n", mask, mask, mask)
	fmt.printf("x & mask = %d   (%#02x, %#08b)\n", x & mask, x & mask, x & mask)

	x = 0b1110_0110
	upper_2_bits := x >> 5
	fmt.printf("x        = %d (%#02x, %#08b)\n", x, x, x)
	fmt.printf("upper    = %d   (%#02x, %#08b)\n", upper_2_bits, upper_2_bits, upper_2_bits) // shifting is not enough here
	upper_2_bits = (x & 0x060) >> 5
	fmt.printf("upper    = %d   (%#02x, %#08b)\n", upper_2_bits, upper_2_bits, upper_2_bits)

	x = 0b1000_0110
	upper_2_bits = x | 0x60
	fmt.printf("x        = %d (%#02x, %#08b)\n", x, x, x)
	fmt.printf("upper    = %d (%#02x, %#08b)\n", upper_2_bits, upper_2_bits, upper_2_bits)

	// Flag extraction, shifting and bitwise and
	flags := 0b1001_1010
	fmt.printf("flags    = %d (%#02x, %#08b)\n", flags, flags, flags)
	version := int(flags >> 6)
	fmt.printf("version  = %d\n", version)
	blocking_independence := flags & 0x20 != 0
	fmt.printf("blocking = %v\n", blocking_independence)
	has_block_checksum := flags & 0x10 != 0
	fmt.printf("checksum = %v\n", has_block_checksum)
	has_content_size := flags & 0x08 != 0
	fmt.printf("content  = %v\n", has_content_size)
}
