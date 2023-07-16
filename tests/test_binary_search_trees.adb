with Ada.Text_IO;
with Spica.Binary_Search_Trees;
with Test_Data;

use Ada.Text_IO;

procedure Test_Binary_Search_Trees is

   -- Finally instantiate the Skip_Lists package.
   package Integer_Binary_Search_Trees is
     new Spica.Binary_Search_Trees
       (Key_Type   => Integer,
        Value_Type => Integer,
        KV_Package => Test_Data.Integer_Stores);

   Tree_1 : Integer_Binary_Search_Trees.Tree;
   Tree_2 : Integer_Binary_Search_Trees.Tree;
   Tree_3 : Integer_Binary_Search_Trees.Tree;
   Tree_4 : Integer_Binary_Search_Trees.Tree;

begin
   Put("Binary_Search_Trees: Insert sorted data... ");
   Test_Data.Integer_Stores_Check.Check_Insert(Tree_1, Test_Data.Insert_1);
   Put_Line("ok");

   Put("Binary_Search_Trees: Insert reverse sorted data... ");
   Test_Data.Integer_Stores_Check.Check_Insert(Tree_2, Test_Data.Insert_2);
   Put_Line("ok");

   Put("Binary_Search_Trees: Insert arbitrary data... ");
   Test_Data.Integer_Stores_Check.Check_Insert(Tree_3, Test_Data.Insert_3);
   Put_Line("ok");

   Put("Binary_Search_Trees: Delete arbitrary data... ");
   Test_Data.Integer_Stores_Check.Check_Delete(Tree_4, Test_Data.Insert_3, Test_Data.Delete_3);
   Put_Line("ok");
end Test_Binary_Search_Trees;
