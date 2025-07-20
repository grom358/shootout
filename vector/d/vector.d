import std.stdio;

enum int IM = 139_968;
enum double IMF = cast(double) IM;
enum int IA = 3_877;
enum int IC = 29_573;

struct Random {
    int seed = 42;

    int next(int max) {
        seed = (seed * IA + IC) % IM;
        return cast(int)(max * (seed / IMF));
    }
}

void main() {
    Random rand;
    int[] numbers;
    numbers.reserve(16);

    enum int MAX = 100;
    enum int SIZE = 200_000_000;

    numbers.length = SIZE;
    foreach (i; 0 .. SIZE) {
        numbers[i] = rand.next(MAX);
    }

    int sum = 0;
    foreach (i; 0 .. 1000) {
        int index = rand.next(SIZE) % SIZE;
        sum += numbers[index];
    }

    writeln(sum);
}
