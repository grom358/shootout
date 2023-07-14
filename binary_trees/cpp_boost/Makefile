CXX=clang++
CXXFLAGS=-O3 -Wall -pedantic -std=c++20

binarytree: binarytree.cpp
	$(CXX) -o $@ $^ $(CXXFLAGS)

clean:
	rm -f binarytree $(OBJ)
