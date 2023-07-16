
package Spica.Sorters is

   generic
      type Element_Type is private;
      type Array_Type is array(Positive range <>) of Element_Type;
      with function "<"(L, R : Element_Type) return Boolean is <>;
   procedure Insertion_Sort(A : in out Array_Type)
     with Pre => A'First = 1;

   generic
      type Element_Type is private;
      type Array_Type is array(Positive range <>) of Element_Type;
      Infinity : Element_Type;  -- Larger than any "legitimate" element.
      with function "<"(L, R : Element_Type) return Boolean is <>;
   procedure Merge_Sort(A : in out Array_Type; P, R : Positive)
     with Pre => A'First = 1;

end Spica.Sorters;
