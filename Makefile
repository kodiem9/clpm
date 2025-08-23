default:
	odin run .

debug:
	odin build . -out=main -debug

build:
	odin build . -out=main

test:
	make build
	( cd .. && ./clpm/main )

test_dbg:
	make debug
	( cd .. && ./clpm/main )
