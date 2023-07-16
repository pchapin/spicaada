with Ada.Assertions;
with Ada.Text_IO;
with Spica.Splay_Trees;
with Test_Data;

use Ada.Assertions;
use Ada.Text_IO;

procedure Test_Splay_Trees is

   -- Finally instantiate the Skip_Lists package.
   package Integer_Splay_Trees is
     new Spica.Splay_Trees
       (Key_Type   => Integer,
        Value_Type => Integer,
        KV_Package => Test_Data.Integer_Stores);
   use Integer_Splay_Trees;

   Tree_1 : Tree;
   Tree_2 : Tree;
   Tree_3 : Tree;


   -- This test only exercises 5 of 6 possible reconfigurations. Also not all possible
   -- arrangements of non-null subtrees is checked.
   --
   procedure Test_Splay_Insert is
      T : Tree;
      subtype Test_Index is Natural range 0 .. 6;
      Test_Key : array(Test_Index) of Integer := (5, 3, 7, 4, 6, 2, 8);

      Dump_Results : array(Test_Index) of Dump_Type(Test_Index) :=
        (
         ((5, 0, 1), others => (0, 0, 0)),
         ((3, 0, 1), (5, 0, 2), others => (0, 0, 0)),
         ((3, 0, 3), (5, 0, 2), (7, 0, 1), others => (0, 0, 0)),
         ((3, 0, 2), (4, 0, 1), (5, 0, 3), (7, 0, 2), others => (0, 0, 0)),
         ((3, 0, 3), (4, 0, 2), (5, 0, 3), (6, 0, 1), (7, 0, 2), others => (0, 0, 0)),
         ((2, 0, 1), (3, 0, 3), (4, 0, 4), (5, 0, 5), (6, 0, 2), (7, 0, 3), others => (0, 0, 0)),
         ((2, 0, 2), (3, 0, 5), (4, 0, 6), (5, 0, 7), (6, 0, 4), (7, 0, 3), (8, 0, 1))
        );

   begin
      for I in Test_Index loop
         Insert(T => T, Key => Test_Key(I), Value => 0);
         Check_Sanity(T, "Bad tree in Test_Splay_Insert at key index " & Natural'Image(I));

         -- Verify the tree's structure to make sure splaying is right.
         declare
            Result : Dump_Type := Dump(T);
         begin
            for J in Result'Range loop
               Assert
                 (Dump_Results(I)(J) = Result(J),
                  "Bad structure in Test_Splay_Tree at key index " & Natural'Image(I));
            end loop;
         end;
      end loop;
   end Test_Splay_Insert;


   -- Verify that each lookup operation reconfigures the tree properly.
   procedure Test_Splay_Lookup is
      T : Tree;

      Test_Keys : array(0 .. 7) of Integer := (4, 6, 3, 1, 4, 2, 8, 5);

      subtype Test_Index is Natural range 1 .. 3;
      Search_Keys : array(Test_Index) of Integer := (3, 3, 6);
      Result : Integer;

      Dump_Results : array(Test_Index) of Dump_Type(0 .. 6) :=
        (
         ((1, 0, 3), (2, 0, 2), (3, 0, 1), (4, 0, 3), (5, 0, 2), (6, 0, 4), (8, 0, 3)),
         ((1, 0, 3), (2, 0, 2), (3, 0, 1), (4, 0, 3), (5, 0, 2), (6, 0, 4), (8, 0, 3)),
         ((1, 0, 4), (2, 0, 3), (3, 0, 2), (4, 0, 4), (5, 0, 3), (6, 0, 1), (8, 0, 2))
        );

   begin
      -- Populate tree.
      for I in Test_Keys'Range loop
         Insert(T => T, Key => Test_Keys(I), Value => 0);
         Check_Sanity(T, "Bad tree in Test_Splay_Lookup at key index " & Natural'Image(I));
      end loop;

      -- Look for things.
      for I in Test_Index loop
         Result := Search(T, Search_Keys(I));
         Assert
           (Result = 0,
            "Found wrong value in Test_Splay_Lookup at key index " & Natural'Image(I));
         Check_Sanity(T, "Bad tree after lookup in Test_Splay_Lookup at key index " & Natural'Image(I));

         -- Verify the tree's structure to make sure splaying is right.
         declare
            Result : Dump_Type := Dump(T);
         begin
            for J in Result'Range loop
               Assert
                 (Dump_Results(I)(J) = Result(J),
                  "Bad structure in Test_Splay_Lookup at key index " & Natural'Image(I));
            end loop;
         end;

      end loop;

      -- Verify that Not_Found is raised when appropriate.
      begin
         Result := Search(T => T, Key => 0);
         Assert(False, "Not_Found not raised in Test_Splay_Lookup");
      exception
         when Test_Data.Integer_Stores.Not_Found =>
            Check_Sanity(T, "Bad tree in Test_Splay_Lookup after not found");
      end;
   end Test_Splay_Lookup;


begin -- Test_Splay_Trees
   Put("Splay_Trees: Insert sorted data... ");
   Test_Data.Integer_Stores_Check.Check_Insert(Tree_1, Test_Data.Insert_1);
   Put_Line("ok");

   Put("Splay_Trees: Insert reverse sorted data... ");
   Test_Data.Integer_Stores_Check.Check_Insert(Tree_2, Test_Data.Insert_2);
   Put_Line("ok");

   Put("Splay_Trees: Insert arbitrary data... ");
   Test_Data.Integer_Stores_Check.Check_Insert(Tree_3, Test_Data.Insert_3);
   Put_Line("ok");

   Put("Splay_Trees: Test_Splay_Insert... ");
   Test_Splay_Insert;
   Put_Line("ok");

   Put("Splay_Trees: Test_Splay_Lookup... ");
   Test_Splay_Lookup;
   Put_Line("ok");
end Test_Splay_Trees;
