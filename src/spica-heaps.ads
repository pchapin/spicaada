
generic
   type Key_Type is private;
package Spica.Heaps is

   type Heap is limited interface;

   -- Inserts Item into heap H. If the Key already exists in the heap, it may be replaced or
   -- duplicated inside the heap, depending on the concrete Heap type used.
   procedure Insert(H : in out Heap; Key : in Key_Type) is abstract;

   -- Returns the highest priority key in the heap. If duplicate keys exist, it is unspecified
   -- which is returned first.
   function Top_Priority(H : Heap) return Key_Type is abstract
     with Pre'Class => Size(H) > 0;

   -- Removes the highest priority key from the heap. If duplicate keys exist, it is unspecified
   -- which is removed first; it may not be the one first returned by Top_Priority.
   procedure Delete_Top_Priority(H : in out Heap) is abstract
     with Pre'Class => Size(H) > 0;

   -- Merges Source into Destination. Source is emptied. If the source heap contains keys that
   -- are already in the destination heap those keys might replace destination keys or exist
   -- alongside destination keys, depending on the concrete Heap type used.
   procedure Union(Destination : in out Heap; Source : in out Heap) is abstract;

   -- Returns the number of elements in the heap.
   function Size(H : Heap) return Natural is abstract;

   --------------------
   -- Debugging/Testing
   --------------------

   -- Exception raised by Check_Santity (below).
   Inconsistent_Heap : exception;

   -- For debugging. Raises Inconsistent_Heap with given message if a problem is found. Test
   -- programs can use this procedure to check the sanity of the store after an operation is
   -- done. The message is intended to reflect which operation was attempted, and is thus only
   -- known to the caller.
   procedure Check_Sanity(H : in Heap; Message : in String) is abstract;

end Spica.Heaps;
