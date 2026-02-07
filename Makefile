CC = gcc
CFLAGS = -std=c11 -Wall -Wextra -O2 -g
LDFLAGS = -pthread

SRC = pool.c test_pool.c
OBJS = pool.o test_pool.o
TARGET = test_pool

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(LDFLAGS)

pool.o: pool.c pool.h pool_internal.h
	$(CC) $(CFLAGS) -c pool.c

test_pool.o: test_pool.c pool.h pool_internal.h
	$(CC) $(CFLAGS) -c test_pool.c

clean:
	rm -f $(TARGET) $(OBJS)

run: $(TARGET)
	./$(TARGET)
