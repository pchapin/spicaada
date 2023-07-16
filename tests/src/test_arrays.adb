
with Ada.Assertions;
with Ada.Text_IO;
with Spica.Integer_Arrays;

use Ada.Assertions;
use Ada.Text_IO;

package body Test_Arrays is

   -- Define a suitable array type.
   type Array_Type is array(Positive range <>) of Integer;

   -- Instantiate the generic package. The instance is named "Subarrays."
   -- The 'use' statement makes the members of Subarrays directly visible.
   package Subarrays is new Spica.Integer_Arrays(Integer, Array_Type);
   use Subarrays;

   procedure Test_Maximum_Subarray is
      -- Just a single test case from CLRS (page 70).
      My_Array : Array_Type(1 .. 16) :=
        (13, -3, -25, 20, -3, -16, -23, 18, 20, -7, 12, -5, -22, 15, -4, -7);
      Result : Subarray_Summary;
   begin
      Result := Find_Maximum_Subarray(My_Array);
      Assert(Result = (8, 11, 43),
             "Find_Maximum_Subarray failed on the book's example!");
   end Test_Maximum_Subarray;

end Test_Arrays;
