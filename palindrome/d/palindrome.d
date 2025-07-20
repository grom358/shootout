import std.stdio;
import std.parallelism;

bool isPalindrome(int number) {
    int reversed = 0;
    int original = number;

    int n = number;
    while (n != 0) {
        int digit = n % 10;
        reversed = reversed * 10 + digit;
        n /= 10;
    }

    return original == reversed;
}

long calculateSum(int start, int end) {
    long sum = 0;
    foreach (x; start .. end + 1) {
        if (isPalindrome(x))
            sum += x;
    }
    return sum;
}

void main() {
    int start = 100_000_000;
    int end = 999_999_999;
    int range = end - start + 1;
    int cores = 4;
    int chunk = range / cores;

    // Create tasks
    auto tasks = new Task!(calculateSum, int, int)*[cores];
    for (int i = 0; i < cores; i++) {
        int t_start = start + i * chunk;
        int t_end = (i == cores - 1) ? end : t_start + chunk - 1;
        tasks[i] = task!calculateSum(t_start, t_end);
    }

    // Run tasks in parallel
    foreach (t; tasks)
        t.executeInNewThread();

    // Wait and reduce
    long result = 0;
    foreach (t; tasks)
        result += t.yieldForce();

    writeln(result);
}
