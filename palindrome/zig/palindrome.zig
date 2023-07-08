const std = @import("std");
const Mutex = std.Thread.Mutex;

fn is_palindrome(number: u32) bool {
    var reversed_number: u32 = 0;
    var original_number = number;

    var n = number;
    while (n != 0) : (n = n / 10) {
        var digit = n % 10;
        reversed_number = reversed_number * 10 + digit;
    }

    return original_number == reversed_number;
}

fn calculate_sum(start: u32, end: u32, sum: *u64, m: *Mutex) void {
    var local_sum: u64 = 0;
    var x = start;
    while (x <= end) {
        if (is_palindrome(x)) {
            local_sum += x;
        }
        x += 1;
    }

    m.lock();
    sum.* += local_sum;
    m.unlock();
}

pub fn main() !void {
    const start = 100_000_000;
    const end = 999_999_999;
    const range = end - start;

    const cores = 4;
    const chunk = range / cores;

    var m = Mutex{};
    var sum: u64 = 0;

    var handles: [cores]std.Thread = undefined;
    var i: u32 = 0;
    while (i < cores) {
        const thread_start = start + (chunk * i);
        const thread_end = if (i == cores - 1) end else (thread_start + chunk - 1);
        //calculate_sum(thread_start, thread_end, &sum, &m);
        handles[i] = try std.Thread.spawn(.{}, calculate_sum, .{ thread_start, thread_end, &sum, &m });
        i += 1;
    }

    for (handles) |handle| {
        handle.join();
    }

    m.lock();
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{sum});
    m.unlock();
}
