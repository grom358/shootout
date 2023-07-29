public class Program {
  public class Random {
    private const int IM = 139968;
    private const double IMF = IM;
    private const int IA = 3877;
    private const int IC = 29573;
    private int seed = 42;

    public int Next(int max) {
      seed = (seed * IA + IC) % IM;
      return (int)(max * (seed / IMF));
    }
  }

  public static void Main(string[] args) {
    Random rand = new Random();
    List<int> numbers = new List<int>(16);
    const int MAX = 100;
    const int SIZE = 200_000_000;

    for (int i = 0; i < SIZE; i++) {
      numbers.Add(rand.Next(MAX));
    }

    int sum = 0;
    for (int i = 0; i < 1_000; i++) {
      sum += numbers[rand.Next(SIZE)];
    }

    Console.WriteLine(sum);
  }
}
