with Ada.Assertions;
with Ada.Text_IO;

with Spica.Sorters;

use Ada.Assertions;
use Ada.Text_IO;

package body Test_Sorters is

   -- Define a suitable array type.
   type Integer_Array is array(Positive range <>) of Integer;

   -- Instatiate the required procedures...
   procedure Integer_Insertion_Sort is
     new Spica.Sorters.Insertion_Sort
       (Element_Type => Integer, Array_Type => Integer_Array);

   -- ... note that all legitimate elements have to be smaller than Integer'Last.
   procedure Integer_Merge_Sort is
     new Spica.Sorters.Merge_Sort
       (Element_Type => Integer, Array_Type => Integer_Array, Infinity => Integer'Last);

   subtype Degenerate_Array is Integer_Array(1 .. 1);
   subtype Integer_Test_Array is Integer_Array(1 .. 10);

   type Test_Case is
      record
         Input    : Integer_Test_Array;
         Expected : Integer_Test_Array;
      end record;

   type Test_Cases_Type is array(1 .. 4) of Test_Case;

   Original_Test_Cases : constant Test_Cases_Type :=
     (1 => (Input    => (0, 1, 2, 3, 4, 5, 6, 7, 8, 9),
            Expected => (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)),
      2 => (Input    => (9, 8, 7, 6, 5, 4, 3, 2, 1, 0),
            Expected => (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)),
      3 => (Input    => (2, 2, 2, 2, 2, 1, 1, 1, 1, 1),
            Expected => (1, 1, 1, 1, 1, 2, 2, 2, 2, 2)),
      4 => (Input    => (0, 2, 4, 6, 8, 1, 3, 5, 7, 9),
            Expected => (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)));

   Test_Cases : Test_Cases_Type;

   procedure Test_Insertion_Sort is
      Degenerate : Degenerate_Array := (Degenerate_Array'First => 42);
   begin
      Test_Cases := Original_Test_Cases;
      for I in Test_Cases'Range loop
         Integer_Insertion_Sort(Test_Cases(I).Input);
         Assert(Test_Cases(I).Input = Test_Cases(I).Expected,
                "Insertion_Sort fails: #" & Integer'Image(I));
      end loop;
      Integer_Insertion_Sort(Degenerate);
      Assert(Degenerate = (Degenerate_Array'First => 42),
             "Insertion_Sort fails: degenerate case");
   end Test_Insertion_Sort;


   procedure Test_Merge_Sort is
      Degenerate : Degenerate_Array := (Degenerate_Array'First => 42);
   begin
      Test_Cases := Original_Test_Cases;
      for I in Test_Cases'Range loop
         Integer_Merge_Sort(Test_Cases(I).Input, 1, Test_Cases(I).Input'Length);
         Assert(Test_Cases(I).Input = Test_Cases(I).Expected,
                "Merge_Sort fails: #" & Integer'Image(I));
      end loop;
      Integer_Merge_Sort(Degenerate, 1, Degenerate'Length);
      Assert(Degenerate = (Degenerate_Array'First => 42),
             "Merge_Sort fails: degenerate case");
   end Test_Merge_Sort;

   -- Other tests to consider:
   --
   -- * Two element arrays.
   -- * Three element arrays (particularly interesting for Merge_Sort).
   -- * Normal length arrays with an odd number of elements.
   -- * Arrays with two duplicate elements originally in different locations.
   -- * Arrays with three duplicate elements (check for issues with odd/even duplicate counts).

end Test_Sorters;
