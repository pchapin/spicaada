
generic
   type Element_Type is private;
   Max_Size        : Natural;
   Default_Element : Element_Type;

package Spica.Double_List
  with Abstract_State => Internal_List
is
   type Status_Type is (Success, Insufficient_Space);
   type Iterator is private;

   procedure Clear
     with
       Global => (Output => Internal_List),
       Depends => (Internal_List => null),
       Post => Size = 0;

   procedure Insert_Before(It : in Iterator; Item : in Element_Type; Status : out Status_Type)
     with
       Global => (In_Out => Internal_List),
       Depends => (Internal_List =>+ (It, Item), Status => Internal_List),
       Post =>
         (if Size'Old = Max_Size then Status = Insufficient_Space else Status = Success) and
         Size'Old = (if Size'Old = Max_Size then Size else Size - 1);

   function Front return Iterator
     with
       Global => (Input => Internal_List);

   function Back return Iterator
     with
       Global => (Input => Internal_List);

   procedure Forward(It : in out Iterator)
     with
       Global => (Input => Internal_List),
       Depends => (It =>+ Internal_List),
       Pre => Is_Dereferencable(It);

   procedure Backward(It : in out Iterator)
     with
       Global => (Input => Internal_List),
       Depends => (It =>+ Internal_List),
       Pre => Is_Dereferencable(It);

   function Is_Dereferencable(It : Iterator) return Boolean
     with
       Global => null;

   function Is_Null(It : Iterator) return Boolean is (not Is_Dereferencable(It))
     with Inline;

   procedure Get_Value(It : in Iterator; Item : out Element_Type)
     with
       Global => (Input => Internal_List),
       Depends => (Item => (It, Internal_List)),
       Pre => Is_Dereferencable(It);

   procedure Put_Value(It : in Iterator; Item : in Element_Type)
     with
       Global => (In_Out => Internal_List),
       Depends => (Internal_List =>+ (It, Item)),
       Pre => Is_Dereferencable(It);

   function Size return Natural
     with
       Global => (Input => Internal_List);

private
   -- Position zero is a sentinel node.
   subtype Index_Type is Natural range 0 .. Max_Size;

   type Iterator is
      record
         Pointer : Index_Type;
      end record;

end Spica.Double_List;
