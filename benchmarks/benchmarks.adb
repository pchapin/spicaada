with Ada.Calendar;
with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;

use  Ada.Calendar;
use  Ada.Text_IO;

with Spica.Binary_Search_Trees;
with Spica.KV_Stores;
with Spica.RedBlack_Trees;
with Spica.Splay_Trees;

procedure Benchmarks is

   -- How many iterations?
   Iteration_Count : constant := 1_000_000;

   -- We will need this to print Durations.
   package Duration_IO is
     new Ada.Text_IO.Fixed_IO(Duration);
   use Duration_IO;

   -- We will need this for random number generation.
   subtype Random_Result_Type is Positive range 1 .. 1_000_000_000;
   package Random_Package is
     new Ada.Numerics.Discrete_Random(Random_Result_Type);
   Random_Generator : Random_Package.Generator;
   type Random_Array_Type is array(1 .. Iteration_Count) of Random_Result_Type;
   type Random_Array_Access is access Random_Array_Type;
   Random_Data : Random_Array_Access := new Random_Array_Type;

   -- We need to instantiate KV_Stores for the Key_Type, Value_Type of interest.
   package Positive_Stores is
     new Spica.KV_Stores(Key_Type => Positive, Value_Type => Positive);

   -- Now we can write general purpose benchmark subprograms.

   function Pad_String(S : String; Width : Positive) return String is
      Result : String(1 .. Width) := (others => ' ');
   begin
      Result(1 .. S'Length) := S;
      return Result;
   end Pad_String;

   procedure Random_Insert(Store : in out Positive_Stores.KV_Store'Class; Title : in String) is
      Start, Stop  : Time;
      Random_Value : Random_Result_Type;
   begin
      Put(Pad_String(Title & "... ", 25));
      Start := Clock;
      for I in 1 .. Iteration_Count loop
         Random_Value := Random_Data(I);
         Store.Insert(Key => Random_Value, Value => Random_Value);
      end loop;
      Stop := Clock;
      Put(Stop - Start);
      New_Line;
   end Random_Insert;


   procedure Ordered_Insert(Store : in out Positive_Stores.KV_Store'Class; Title : in String) is
      Start, Stop : Time;
   begin
      Put(Pad_String(Title & "... ", 25));
      Start := Clock;
      for I in 1 .. Iteration_Count loop
         Store.Insert(Key => I, Value => I);
      end loop;
      Stop := Clock;
      Put(Stop - Start);
      New_Line;
   end Ordered_Insert;

   -- Instantiate specific KV_Stores packages.

   package Positive_BSTs is
     new Spica.Binary_Search_Trees
       (Key_Type => Positive, Value_Type => Positive, KV_Package => Positive_Stores);

   package Positive_Splay_Trees is
     new Spica.Splay_Trees
       (Key_Type => Positive, Value_Type => Positive, KV_Package => Positive_Stores);

   package Positive_RB_Trees is
     new Spica.RedBlack_Trees
       (Key_Type => Positive, Value_Type => Positive, KV_Package => Positive_Stores);

   -- Create instances of the specific KV_Stores types.
   BST_1        : Positive_BSTs.Tree;
   Splay_Tree_1 : Positive_Splay_Trees.Tree;
   RB_Tree_1    : Positive_RB_Trees.RedBlack_Tree;

   BST_2        : Positive_BSTs.Tree;
   Splay_Tree_2 : Positive_Splay_Trees.Tree;
   RB_Tree_2    : Positive_RB_Trees.RedBlack_Tree;

begin
   -- Let's precalculate the random numbers.
   for I in Random_Data'Range loop
      Random_Data(I) := Random_Package.Random(Random_Generator);
   end loop;

   Ada.Text_IO.Put_Line("Random Insert");
   Random_Insert(Splay_Tree_1, "  Splay Tree");
   Random_Insert(BST_1, "  Binary Search Tree");
   -- Random_Insert(RB_Tree_1, "  RedBlack Tree");

   New_Line;
   Ada.Text_IO.Put_Line("Ordered Insert");
   Ordered_Insert(Splay_Tree_2, "  Splay Tree");
   Ordered_Insert(BST_2, "  Binary Search Tree");
   -- Ordered_Insert(RB_Tree_2, "  RedBlack Tree");
end Benchmarks;
