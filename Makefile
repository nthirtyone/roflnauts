TOOL=love-release
FLAGS=-x Makefile -x .md

windows:
	$(TOOL) -W 32 $(FLAGS)

love:
	$(TOOL) $(FLAGS)

mac:
	$(TOOL) -M $(FLAGS)

all: windows love mac

clean:
	rm releases/*
