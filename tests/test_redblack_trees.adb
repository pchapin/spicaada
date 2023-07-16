with Ada.Text_IO;
with Spica.RedBlack_Trees;
with Test_Data;

use Ada.Text_IO;

procedure Test_RedBlack_Trees is

   -- Finally instantiate the Skip_Lists package.
   package Integer_RedBlack_Trees is
     new Spica.RedBlack_Trees
       (Key_Type   => Integer,
        Value_Type => Integer,
        KV_Package => Test_Data.Integer_Stores);

   Tree_1 : Integer_RedBlack_Trees.RedBlack_Tree;
   Tree_2 : Integer_RedBlack_Trees.RedBlack_Tree;
   Tree_3 : Integer_RedBlack_Trees.RedBlack_Tree;
   Tree_4 : Integer_RedBlack_Trees.RedBlack_Tree;

begin
   Put("RedBlack_Trees: Insert sorted data... ");
   Test_Data.Integer_Stores_Check.Check_Insert(Tree_1, Test_Data.Insert_1);
   Put_Line("ok");

   Put("RedBlack_Trees: Insert reverse sorted data... ");
   Test_Data.Integer_Stores_Check.Check_Insert(Tree_2, Test_Data.Insert_2);
   Put_Line("ok");

   Put("RedBlack_Trees: Insert arbitrary data... ");
   Test_Data.Integer_Stores_Check.Check_Insert(Tree_3, Test_Data.Insert_3);
   Put_Line("ok");

   Put("RedBlack_Trees: Delete arbitrary data... ");
   Test_Data.Integer_Stores_Check.Check_Delete(Tree_4, Test_Data.Insert_3, Test_Data.Delete_3);
   Put_Line("ok");
end Test_RedBlack_Trees;
