
generic
   type Key_Type is private;
package Spica.Heaps is

   type Heap is limited interface;

   -- Inserts Item into heap H. If the Key already exists in the heap, it is replaced.
   procedure Insert(H : in out Heap; Key : in Key_Type) is abstract;

   -- Returns the highest priority key in the heap.
   function Top_Priority(H : Heap) return Key_Type is abstract
     with Pre'Class => Size(H) > 0;

   -- Removes the highest priority key from the heap.
   procedure Delete_Top_Priority(H : in out Heap) is abstract
     with Pre'Class => Size(H) > 0;

   -- Merges Source into Destination. Source is emptied.
   procedure Union(Destination : in out Heap; Source : in out Heap) is abstract;

   -- Returns the number of elements in the heap.
   function Size(H : Heap) return Natural is abstract;

   --------------------
   -- Debugging/Testing
   --------------------

   -- Exception raised by Check_Santity (below).
   Inconsistent_Heap : exception;

   -- For debugging. Raises Inconsistent_Heap with given message if a problem is found.
   procedure Check_Sanity(H : in Heap; Message : in String) is abstract;

end Spica.Heaps;
