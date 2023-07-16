
with Ada.Assertions;
with Ada.Text_IO;
with Spica.Double_List;

use Ada.Assertions;
use Ada.Text_IO;

procedure Test_Double_List is

   package Integer_Double_List is
     new Spica.Double_List(Element_Type => Integer, Max_Size => 16, Default_Element => 0);
   use Integer_Double_List;

   subtype Test_Index_Type is Integer range 1 .. 10;
   Test_Sequence : array(Test_Index_Type) of Integer :=
     (10, 20, 30, 40, 50, 60, 70, 80, 90, 100);

   It     : Integer_Double_List.Iterator;
   Status : Integer_Double_List.Status_Type;
   Index  : Test_Index_Type;
   Item   : Integer;
begin
   Put("Double_List... ");
   Clear;

   It := Front;
   for I in Test_Sequence'Range loop
      Insert_Before(It, Test_Sequence(I), Status);
      Assert(Status = Success, "Bad Status during Insert_Before");
   end loop;

   It := Front;
   Index := Test_Sequence'First;
   while Is_Dereferencable(It) loop
      Get_Value(It, Item);
      Assert(Item = Test_Sequence(Index), "Bad Item from Get_Value");
      Forward(It);
      if Index < Test_Index_Type'Last then
         Index := Index + 1;
      end if;
   end loop;

   -- If we get here, everything worked.
   Put_Line("ok");

end Test_Double_List;
