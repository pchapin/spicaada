
with Spica.KV_Stores;
private with Ada.Finalization;

generic
   type Key_Type is private;
   type Value_Type is private;
   with package KV_Package is new KV_Stores(Key_Type, Value_Type);
   with function "<"(Left, Right : Key_Type) return Boolean is <>;
package Spica.Splay_Trees is

   type Tree is limited new KV_Package.KV_Store with private;

   overriding procedure Insert(T : in out Tree; Key : in Key_Type; Value : in Value_Type);
   overriding function  Search(T : in out Tree; Key : in Key_Type) return Value_Type;
   overriding procedure Delete(T : in out Tree; Key : in Key_Type);
   overriding function  Size(T : Tree) return Natural;
   overriding procedure Check_Sanity(T : in Tree; Message : in String);

   -------------------------------
   -- The following is for testing
   -------------------------------

   -- The return type of Dump is an array of Dump_Items.
   type Dump_Item is record
      Key   : Key_Type;
      Value : Value_Type;
      Level : Natural;
   end record;
   type Dump_Type is array(Natural range <>) of Dump_Item;

   -- Return an array of tree items with structural information.
   function Dump(T : in Tree) return Dump_Type;

private
   type Node;
   type Node_Access is access Node;
   type Node is
      record
         Key    : Key_Type;
         Value  : Value_Type;
         Parent : Node_Access := null;
         Left   : Node_Access := null;
         Right  : Node_Access := null;
      end record;

   type Tree is limited new Ada.Finalization.Limited_Controlled and KV_Package.KV_Store with
      record
         Root  : Node_Access := null;
         Count : Natural     := 0;
      end record;

   procedure Finalize(T : in out Tree);

end Spica.Splay_Trees;
