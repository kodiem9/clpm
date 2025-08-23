package main

import "core:fmt"
import "core:os"
import "core:strings"

command_help :: proc() {
	fmt.println("command help")

	// THIS IS NOT FINISHED!
	file_path := "data/info/help.txt"
	file, ok := os.read_entire_file(file_path, context.allocator)
	if !ok {
		fmt.println("")
	}
	defer delete(file, context.allocator)
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

