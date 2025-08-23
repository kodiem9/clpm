package main

import "core:fmt"

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

