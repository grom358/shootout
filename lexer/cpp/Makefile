CXX=g++
CXXFLAGS=-I. -O3 -W -Wall -pedantic -ansi -std=c++20
DEPS = lexer.h
OBJ = lexer.o zscript.o

%.o: %.c $(DEPS)
	$(CXX) -c -o $@ $< $(CXXFLAGS)

zscript: $(OBJ)
	$(CXX) -o $@ $^ $(CXXFLAGS)

clean:
	rm -f zscript $(OBJ)
