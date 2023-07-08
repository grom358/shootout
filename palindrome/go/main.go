package main

import (
        "fmt"
        "math"
        "sync"
)

func main() {
        start := 100_000_000
        end := 999_999_999
        rangeSize := end - start

        result := make(chan int)
        var wg sync.WaitGroup

        cores := 4 
        chunk := int(math.Ceil(float64(rangeSize) / float64(cores)))

        for i := 0; i < cores; i++ {
                tStart := start + (chunk * i)
                tEnd := tStart + chunk - 1
                if tEnd > end {
                        tEnd = end
                }

                wg.Add(1)
                go func(start, end int) {
                        defer wg.Done()

                        sum := 0
                        for x := start; x <= end; x++ {
                                if isPalindrome(x) {
                                        sum += x
                                }
                        }

                        result <- sum
                }(tStart, tEnd)
        }

        go func() {
                wg.Wait()
                close(result)
        }()

        totalSum := 0
        for sum := range result {
                totalSum += sum
        }

        fmt.Println(totalSum)
}

func isPalindrome(number int) bool {
        reversedNumber := 0
        originalNumber := number

        for number != 0 {
                digit := number % 10
                reversedNumber = reversedNumber*10 + digit
                number /= 10
        }

        return originalNumber == reversedNumber
}
