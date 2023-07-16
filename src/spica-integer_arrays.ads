
generic
   type Element_Type is range <>;
   type Array_Type is array(Positive range <>) of Element_Type;
package Spica.Integer_Arrays is

   type Subarray_Summary is
      record
         Low_Index  : Positive;
         High_Index : Positive;
         Sum        : Element_Type;
      end record;

   function Find_Maximum_Subarray(A : Array_Type) return Subarray_Summary;

end Spica.Integer_Arrays;
