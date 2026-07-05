TARGET = binarytree
SRC = $(TARGET).zig

$(TARGET): $(SRC)
	zig build-exe -O ReleaseFast -femit-bin=$@ $<
