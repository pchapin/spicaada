with Ada.Text_IO; use Ada.Text_IO;

with Spica.Heaps;
with Spica.Leftist_Heaps;
with Generic_Heap_Tests;

procedure Test_Leftist_Heaps is

   package Integer_Heaps is new Spica.Heaps(Integer);
   package Integer_Leftist_Heaps is new Spica.Leftist_Heaps(Integer, Integer_Heaps);

   package Heap_Tests is new Generic_Heap_Tests(Integer_Heaps, Integer_Leftist_Heaps.Heap);
   use Heap_Tests;

begin
   Put("Leftist_Heaps: Constructor... ");
   Test_Heap_Constructor;
   Put_Line("ok");

   Put("Leftist_Heaps: Insert...");
   Test_Heap_Insert;
   Put_Line("ok");

   Put("Leftist_Heaps: Delete...");
   Test_Heap_Delete;
   Put_Line("ok");
end Test_Leftist_Heaps;
