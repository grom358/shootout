using NBody;

if (args.Length != 1) {
  Console.Error.WriteLine("Usage: nbody <num_steps>");
  Environment.Exit(1);
}

int n = int.Parse(args[0]);

NBodySystem system = new NBodySystem();
Console.WriteLine(system.Energy().ToString("F9"));
for (int i = 0; i < n; ++i) {
  system.Advance(0.01);
}
Console.WriteLine(system.Energy().ToString("F9"));
