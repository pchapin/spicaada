with Ada.Text_IO;
with Spica.Skip_Lists;
with Test_Data;

use Ada.Text_IO;

procedure Test_Skip_Lists is

   -- Finally instantiate the Skip_Lists package.
   package Integer_Skip_Lists is
     new Spica.Skip_Lists
       (Key_Type   => Integer,
        Value_Type => Integer,
        Max_Level  => 3,
        KV_Package => Test_Data.Integer_Stores);

   Skip_List_1 : Integer_Skip_Lists.Skip_List;
   Skip_List_2 : Integer_Skip_Lists.Skip_List;
   Skip_List_3 : Integer_Skip_Lists.Skip_List;
   Skip_List_4 : Integer_Skip_Lists.Skip_List;

begin
   Put("Skip_Lists: Insert sorted data... ");
   Test_Data.Integer_Stores_Check.Check_Insert(Skip_List_1, Test_Data.Insert_1);
   Put_Line("ok");

   Put("Skip_Lists: Insert reverse sorted data... ");
   Test_Data.Integer_Stores_Check.Check_Insert(Skip_List_2, Test_Data.Insert_2);
   Put_Line("ok");

   Put("Skip_Lists: Insert arbitrary data... ");
   Test_Data.Integer_Stores_Check.Check_Insert(Skip_List_3, Test_Data.Insert_3);
   Put_Line("ok");

   Put("Skip_Lists: Delete arbitrary data... ");
   Test_Data.Integer_Stores_Check.Check_Delete(Skip_List_4, Test_Data.Insert_3, Test_Data.Delete_3);
   Put_Line("ok");
end Test_Skip_Lists;
