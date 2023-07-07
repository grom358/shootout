# this is a comment

# datatypes
let age = 42;
let name = "grom";
let pie = 3.141592653589793238;
let a_float = 3.14e-04;
let is_email = true;
let flag = false;
let one_hour = 36_000;
# comment with " character
let string_with_quote = "test\"me";

# operators
let concat_str = "hello" ~ " world!";
let fav_str = 3 ~ " is my fav number";
let result = 1 + 2 - 1 * 5 / 3.2 + 2^2;
let condition = not is_email and (len(concat_str) > 0) or flag
    # comment mid statement
    xor name == "grom";
let mod3 = 43 % 3;

# if control flow
if age < 3 {
    print("number less than 3");
} else if age == 3 {
    print("number is 3");
} else {
    print("number greater then 3");
}

# while loop
let counter = 1;
let length = 9;
while counter <= length {
    counter += 1;
}

# arrays
let my_list = ["apple", "banana", "orange"];
my_list[1] = "pear";
assert(my_list[1] == "pear");

# foreach loop
foreach my_list as item {
    print(item);
}

# maps
let dict = {"fruit": "apple", "veggie": "pumpkin"};
dict["fruit"] = "orange";
assert(dict["fruit"] == "orange");
foreach dict as key : value {
    print(key ~ ": " ~ value);
}

# functions
let sum = function(numbers) {
    total = 0;
    foreach numbers as number {
        total += number;
    }
}

let range = function(start, end, step = 1) {
    result = [];
    number = start;
    while number <= end {
        append(result, number);
        number += step;
    }
    return result;
}

# calling functions
print(sum(range(1, 9)));

