
with Spica.Heaps;
private with Ada.Finalization;

generic
   type Key_Type is private;
   with package Heaps_Package is new Heaps(Key_Type);
   with function "<"(L, R : Key_Type) return Boolean is <>;
package Spica.Fibonacci_Heaps is

   type Heap is limited new Heaps_Package.Heap with private;
   type Node_Handle is private;

   -- Inserts Item into heap H. Duplicate items are allowed. Amortized O(1)
   overriding
   procedure Insert(H : in out Heap; Item : in Key_Type);

   -- Returns the highest priority key in the heap. Amortized O(1)
   overriding
   function Top_Priority(H : Heap) return Key_Type;

   -- Removes the highest priority key from the heap. Amortized O(log(N))
   overriding
   procedure Delete_Top_Priority(H : in out Heap);

   -- Merges heap Source into Destination. The source heap is emptied. Amortized O(1)
   overriding
   procedure Union(Destination : in out Heap; Source : in out Heap);

   -- Returns the number of elements in the heap. O(1)
   overriding
   function Size(H : Heap) return Natural;

   -- Raises Heaps_Package.Inconsistent_Heap if the heap is in an invalid state.
   overriding
   procedure Check_Sanity(H : in Heap; Message : in String);

   -- Fibonacci Heap Operations
   ----------------------------

   -- Like the Insert above except it returns a access value to the node containing the key.
   not overriding
   procedure Insert(H : in out Heap; Item : in Key_Type; Result_Node : out Node_Handle);

   -- Raises a key's priority. Amortized O(1).
   not overriding
   procedure Raise_Key_Priority
     (H : in out Heap; Existing_Node : in Node_Handle; New_Item : in Key_Type)
     with Pre => New_Item < Get_Key(Existing_Node);

   -- Removes the existing node (and its key) from the heap. Amortized O(log(N))
   not overriding
   procedure Delete(H : in out Heap; Existing_Node : in out Node_Handle);

   -- Returns the key inside the existing node. O(1)
   function Get_Key(Existing_Node : Node_Handle) return Key_Type;

private

   type Node;
   type Node_Handle is access Node;
   subtype Node_Access is Node_Handle;

   type Heap is limited new Ada.Finalization.Limited_Controlled and Heaps_Package.Heap with
      record
         Top  : Node_Access;
         Size : Natural;
      end record;

   overriding procedure Initialize(H : in out Heap);
   overriding procedure Finalize(H : in out Heap);

   type Node is
      record
         Key           : Key_Type;
         Degree        : Natural := 0;
         Mark          : Boolean := False;
         Parent        : Node_Access;
         Left_Sibling  : Node_Access;
         Right_Sibling : Node_Access;
         Child         : Node_Access;
      end record;

end Spica.Fibonacci_Heaps;
