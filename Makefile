all : hello az

clean : ; $(RM) -f hello.o hello az.o az

hello : hello.o

az : az.o
