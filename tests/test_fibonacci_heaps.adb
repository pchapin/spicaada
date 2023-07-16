with Ada.Text_IO; use Ada.Text_IO;

with Spica.Heaps;
with Spica.Fibonacci_Heaps;
with Generic_Heap_Tests;

procedure Test_Fibonacci_Heaps is

   package Integer_Heaps is new Spica.Heaps(Integer);
   package Integer_Fibonacci_Heaps is new Spica.Fibonacci_Heaps(Integer, Integer_Heaps);

   package Heap_Tests is new Generic_Heap_Tests(Integer_Heaps, Integer_Fibonacci_Heaps.Heap);
   use Heap_Tests;

begin
   Put("Fibonacci_Heaps: Constructor... ");
   Test_Heap_Constructor;
   Put_Line("ok");

   Put("Fibonacci_Heaps: Insert...");
   Test_Heap_Insert;
   Put_Line("ok");

   Put("Fibonacci_Heaps: Delete...");
   Test_Heap_Delete;
   Put_Line("ok");
end Test_Fibonacci_Heaps;
