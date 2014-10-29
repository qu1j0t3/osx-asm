all : hello

hello : hello.o

hellold : hellold.o
	$(LD) -o $@ $<
