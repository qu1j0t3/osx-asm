all : hello

clean : ; $(RM) -f hello.o hello

hello : hello.o
