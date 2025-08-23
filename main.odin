package main

import "core:fmt"
import "core:mem"
import "core:os"
import "core:path/filepath"
import "core:strings"

command_help :: proc() {
	exe_path: string
	{
		exe_path_raw := os.args[0]
		exe_path_raw_len := len(exe_path_raw)
		exe_path_base_len := len(filepath.base(exe_path_raw))

		// Basically what this part does: it ignores the two first characters and the length of the executable name. For example: ./path/to/folder/main -> path/to/folder
		end_point := exe_path_raw_len - exe_path_base_len
		exe_path = exe_path_raw[2:end_point]
	}

	file_path: string
	{
		file_path_raw := "data/info/help.txt"
		if len(exe_path) == 0 {
			file_path = file_path_raw
		} else {
			file_path = strings.concatenate([]string{exe_path, file_path_raw})
		}
	}

	// Reads the file
	file, ok := os.read_entire_file(file_path, context.allocator)
	if !ok {
		log_message(.ERROR, "Could not find path `%s`.", file_path)
	}
	defer delete(file, context.allocator)

	// Prints the file
	it := string(file)
	for line in strings.split_lines_iterator(&it) {
		fmt.println(line)
	}
}

command_init :: proc() {
	fmt.println("command init")
}

Log_Type :: enum {
	INFO,
	WARNING,
	ERROR,
}

log_message :: proc(type: Log_Type, msg: string, args: ..any) {
	switch type {
	case .INFO:
		fmt.print("[INFO]: ")
	case .WARNING:
		fmt.print("[WARNING]: ")
	case .ERROR:
		fmt.print("[ERROR]: ")
	case:
		fmt.print("[UNKNOWN]: ")
	}

	fmt.printfln(msg, ..args)
}

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

