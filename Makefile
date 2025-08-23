default:
	odin run source

debug:
	odin build source -out=main -debug

build:
	odin build source -out=main

test:
	make build
	( cd .. && ./clpm/main )

test_dbg:
	make debug
	( cd .. && ./clpm/main )
