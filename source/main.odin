package main

import "core:fmt"
import "core:mem"
import "core:os"

main :: proc() {
	when ODIN_DEBUG {
		fmt.println("DEBUG MODE")

		// Taken from `odin-lang.org/docs/overview/`
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	if len(os.args) == 1 {
		command_help()
		return
	}

	main_argument := os.args[1]

	switch main_argument {
	case "help":
		command_help()
	case "init":
		command_init()
	case:
		log_message(
			.ERROR,
			"Argument `%s` does not exist! Type `help` to see valid arguments.",
			main_argument,
		)
	}
}

