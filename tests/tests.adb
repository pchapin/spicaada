with Ada.Exceptions;
with Ada.Text_IO;

with Test_Arrays;
with Test_Binary_Search_Trees;
with Test_Double_List;
with Test_Fibonacci_Heaps;
with Test_Leftist_Heaps;
with Test_Longest_Common_Subsequence;
with Test_RedBlack_Trees;
with Test_Skip_Lists;
with Test_Splay_Trees;
with Test_Sorters;
with Test_Very_Longs;

use Ada.Exceptions;
use Ada.Text_IO;

procedure Tests is

   procedure Execute_Test(Header : in String; Test_Procedure : access procedure) is
      Decoration : String(1 .. Header'Length) := (others => '=');
   begin
      New_Line;
      Put_Line(Header);
      Put_Line(Decoration);
      begin
         Test_Procedure.all;
      exception
         when Ex : others =>
            New_Line;
            Put_Line(Exception_Information(Ex));
      end;
   end Execute_Test;

begin
   New_Line;
   Put_Line("Sorters");
   Put_Line("=======");
   begin
      Put("Insertion_Sort.... "); Test_Sorters.Test_Insertion_Sort;  Put_Line("ok");
      Put("Merge_Sort........ "); Test_Sorters.Test_Merge_Sort;      Put_Line("ok");
   exception
      when Ex : others =>
         New_Line;
         Put_Line(Exception_Information(Ex));
   end;

   -- Arrays
   New_Line;
   Put_Line("Arrays");
   Put_Line("======");
   begin
      Put("Maximum_Subarray.. "); Test_Arrays.Test_Maximum_Subarray; Put_Line("ok");
   exception
      when Ex : others =>
         New_Line;
         Put_Line(Exception_Information(Ex));
   end;

   -- Number Theory
   Execute_Test("Very Longs", Test_Very_Longs'Access);

   -- List Data Structures
   Execute_Test("Double List", Test_Double_List'Access);
   Execute_Test("Skip Lists", Test_Skip_Lists'Access);

   -- Heaps
   Execute_Test("Leftist Heaps", Test_Leftist_Heaps'Access);
   Execute_Test("Fibonacci Heaps", Test_Fibonacci_Heaps'Access);

   -- Tree Data Structures
   Execute_Test("Binary Search Trees", Test_Binary_Search_Trees'Access);
   Execute_Test("Splay Trees", Test_Splay_Trees'Access);
   Execute_Test("RedBlack Trees", Test_RedBlack_Trees'Access);

   -- Longest Commong Subsequence
   Execute_Test("Longest Common Subsequence", Test_Longest_Common_Subsequence'Access);
end Tests;
