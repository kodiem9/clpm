package main

import "core:fmt"
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
		file_path_raw := "source/data/info/help.txt"
		if len(exe_path) == 0 {
			file_path = file_path_raw
		} else {
			file_path = strings.concatenate([]string{exe_path, file_path_raw})
		}
	}
	fmt.println("file_path:", file_path)

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

