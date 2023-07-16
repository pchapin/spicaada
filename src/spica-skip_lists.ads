
with Spica.KV_Stores;
private with Ada.Finalization;

generic
   type Key_Type is private;
   type Value_Type is private;
   Max_Level : Positive;
   with package KV_Package is new KV_Stores(Key_Type, Value_Type);
   with function "<"(L, R : Key_Type) return Boolean is <>;
package Spica.Skip_Lists is

   type Skip_List is limited new KV_Package.KV_Store with private;

   overriding procedure Insert(List : in out Skip_List; Key : in Key_Type; Value : in Value_Type);
   overriding function  Search(List : in out Skip_List; Key : in Key_Type) return Value_Type;
   overriding procedure Delete(List : in out Skip_List; Key : in Key_Type);
   overriding function  Size(List : Skip_List) return Natural;
   overriding procedure Check_Sanity(List : in Skip_List; Message : in String);

private

   type Node;
   type Node_Access is access Node;
   type Node_Access_Array is array(1 .. Max_Level) of Node_Access;
   type Node is
      record
         Key     : Key_Type;
         Value   : Value_Type;
         Forward : Node_Access_Array;
      end record;


   -- A Skip_List contains a special "header" node where the Key and Value components are not
   -- used. This is because attempting to use just a Node_Access_Array instance as the header
   -- leads to type problems (pointing at just the arrays makes it difficult to access the keys
   -- and values in the other nodes)
   type Skip_List is limited new Ada.Finalization.Limited_Controlled and KV_Package.KV_Store with
      record
         Header : Node_Access;
         Count  : Natural;
      end record;

   overriding procedure Initialize(List : in out Skip_List);
   overriding procedure Finalize(List : in out Skip_List);

end Spica.Skip_Lists;
