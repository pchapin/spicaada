private with Ada.Finalization;

generic
   type Element_Type is private;
package Spica.Double_Lists is

   type Double_List is tagged private;

   function Size(List : Double_List) return Natural
     with Inline;

   -- Returns (a copy of) an item at the front/back of a list.
   function Front(List : Double_List) return Element_Type
     with Pre => Size(List) > 0;

   function Back(List : Double_List) return Element_Type
     with Pre => Size(List) > 0;

   -- Add an item to the front/back of a list.
   procedure Push_Front(List : in out Double_List; Item : in Element_Type)
     with Post => Size(List) = Size(List'Old) + 1 and Front(List) = Item;

   procedure Push_Back(List : in out Double_List; Item : in Element_Type)
     with Post => Size(List) = Size(List'Old) + 1 and Back(List) = Item;

   -- Remove (and return) an item from the front/back of a list.
   procedure Pop_Front(List : in out Double_List; Item : out Element_Type)
     with
       Pre  => Size(List) > 0,
       Post => Size(List) = Size(List'Old) - 1 and Item = Front(List'Old);

   procedure Pop_Back(List : in out Double_List; Item : out Element_Type)
     with
       Pre  => Size(List) > 0,
       Post => Size(List) = Size(List'Old) - 1 and Item = Back(List'Old);

private

   type List_Node;
   type Node_Access is access List_Node;

   type List_Node is
      record
         Item     : Element_Type;
         Next     : Node_Access;
         Previous : Node_Access;
      end record;

   type Double_List is new Ada.Finalization.Controlled with
      record
         Head  : Node_Access;
         Tail  : Node_Access;
         Count : Natural := 0;
      end record
     with Type_Invariant =>
       (Count  = 0) = (Head  = null and Tail  = null) and
       (Count /= 0) = (Head /= null and Tail /= null);


   -- Override the necessary procedures for the controlled type...

   -- The default initialization above is suffcient.
   --overriding procedure Initialize(List : in out Double_List);
   overriding procedure Adjust(List : in out Double_List);
   overriding procedure Finalize(List : in out Double_List);

end Spica.Double_Lists;
