with Spica.Heaps;

generic
   with package Heap_Package is new Spica.Heaps(Key_Type => Integer);
   type Heap is limited new Heap_Package.Heap with private;
package Generic_Heap_Tests is

   procedure Test_Heap_Constructor;
   procedure Test_Heap_Insert;
   procedure Test_Heap_Delete;

end Generic_Heap_Tests;
