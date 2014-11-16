all : hello az primes

clean : ; $(RM) -f hello.o hello az.o az primes.o primes

hello : hello.o

primes : primes.o

az : az.o
