
with Spica.KV_Stores;
private with Ada.Finalization;

generic
   type Key_Type is private;
   type Value_Type is private;
   with package KV_Package is new KV_Stores(Key_Type, Value_Type);
   with function "<"(Left, Right : Key_Type) return Boolean is <>;
package Spica.RedBlack_Trees is

   type RedBlack_Tree is limited new KV_Package.KV_Store with private;

   overriding procedure Insert(T : in out RedBlack_Tree; Key : in Key_Type; Value : in Value_Type);
   overriding function  Search(T : in out RedBlack_Tree; Key : in Key_Type) return Value_Type;
   overriding procedure Delete(T : in out RedBlack_Tree; Key : in Key_Type);
   overriding function  Size(T : RedBlack_Tree) return Natural;
   overriding procedure Check_Sanity(T : in RedBlack_Tree; Message : in String);

private

   type Color_Type is (Red, Black);

   type Tree_Node;
   type Tree_Node_Access is access Tree_Node;
   type Tree_Node is
      record
         Key         : Key_Type;
         Value       : Value_Type;
         Color       : Color_Type;
         Parent      : Tree_Node_Access := null;
         Left_Child  : Tree_Node_Access := null;
         Right_Child : Tree_Node_Access := null;
      end record;

   type RedBlack_Tree is limited new Ada.Finalization.Limited_Controlled and KV_Package.KV_Store with
      record
         Root  : Tree_Node_Access := null;
         Nil   : Tree_Node_Access := null;
         Count : Natural          := 0;
      end record;

   overriding procedure Initialize(T : in out RedBlack_Tree);
   overriding procedure Finalize(T : in out RedBlack_Tree);

end Spica.RedBlack_Trees;
