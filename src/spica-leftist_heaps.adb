
-- The algorithms for manipulating leftist heaps follow the discussion in "Data Structures
-- and Algorithm Analysis in C++", third edition, by Mark Allen Weiss. Published by Addison
-- Wesley, ISBN=0-321-44146-X. Pages 229-235.
with Ada.Unchecked_Deallocation;

package body Spica.Leftist_Heaps is

   procedure Deallocate_Node is new
     Ada.Unchecked_Deallocation(Object => Heap_Node, Name => Heap_Node_Access);


   procedure Insert(H : in out Heap; Item : in Key_Type) is
      Temp_Heap : Heap;
   begin
      Temp_Heap.Root := new Heap_Node'(Data => Item, others => <>);
      Union(H, Temp_Heap);
   end Insert;


   procedure Union(Destination : in out Heap; Source : in out Heap) is
      Child_Heap : Heap;
      Larger     : access Heap;
      Smaller    : access Heap;
   begin
      if Source.Root = null then return; end if;
      if Destination.Root = null then
         Destination.Root := Source.Root;
         Source.Root := null;
         return;
      end if;

      -- Both heaps are non-empty.

      -- Identify the larger and smaller roots.
      if Destination.Root.Data < Source.Root.Data then
         Larger  := Source'Access;
         Smaller := Destination'Access;
      else
         Larger  := Destination'Access;
         Smaller := Source'Access;
      end if;

      -- Merge heap with larger root into right child of heap with smaller root.
      Child_Heap.Root := Smaller.Root.Right_Child;
      Union(Child_Heap, Larger.all);
      Smaller.Root.Right_Child := Child_Heap.Root;
      Child_Heap.Root := null;

      -- Swap the children of Smaller if necessary.
      if Smaller.Root.Left_Child = null or else
         Smaller.Root.Left_Child.Null_Path_Length < Smaller.Root.Right_Child.Null_Path_Length then
         declare
            Temp : Heap_Node_Access := Smaller.Root.Left_Child;
         begin
            Smaller.Root.Left_Child  := Smaller.Root.Right_Child;
            Smaller.Root.Right_Child := Temp;
         end;
      end if;

      -- Update the auxillary fields in the new Smaller root.
      if Smaller.Root.Right_Child = null then
         Smaller.Root.Count := Smaller.Root.Left_Child.Count + 1;
         Smaller.Root.Null_Path_Length := 0;
      else
         Smaller.Root.Count := Smaller.Root.Left_Child.Count + Smaller.Root.Right_Child.Count + 1;
         Smaller.Root.Null_Path_Length := Smaller.Root.Right_Child.Null_Path_Length + 1;
      end if;

      -- Update the parameters.
      Destination.Root := Smaller.Root;
      Source.Root := null;
   end Union;


   procedure Delete_Top_Priority(H : in out Heap) is
      Left_Child  : Heap_Node_Access;
      Right_Child : Heap_Node_Access;
      Temp_Heap   : Heap;
   begin
      if H.Root = null then return; end if;

      Left_Child  := H.Root.Left_Child;
      Right_Child := H.Root.Right_Child;
      Deallocate_Node(H.Root);

      H.Root := Left_Child;
      Temp_Heap.Root := Right_Child;
      Union(H, Temp_Heap);
   end Delete_Top_Priority;


   function Top_Priority(H : Heap) return Key_Type is
   begin
      if H.Root = null then
         raise Constraint_Error;
      end if;
      return H.Root.Data;
   end Top_Priority;


   function Size(H : Heap) return Natural is
   begin
      if H.Root = null then return 0; end if;
      return H.Root.Count;
   end Size;


   procedure Check_Sanity(H : in Heap; Message : in String) is

      procedure Check_Counts(Pointer : in Heap_Node_Access) is
      begin
         if Pointer = null then return; end if;
         Check_Counts(Pointer.Left_Child);
         Check_Counts(Pointer.Right_Child);
         if Pointer.Left_Child = null and Pointer.Right_Child = null then
            if Pointer.Count /= 1 then
               raise Heaps_Package.Inconsistent_Heap with Message;
            end if;
         elsif Pointer.Left_Child = null and Pointer.Right_Child /= null then
            if Pointer.Count /= Pointer.Right_Child.Count + 1 then
               raise Heaps_Package.Inconsistent_Heap with Message;
            end if;
         elsif Pointer.Left_Child /= null and Pointer.Right_Child = null then
            if Pointer.Count /= Pointer.Left_Child.Count + 1 then
               raise Heaps_Package.Inconsistent_Heap with Message;
            end if;
         else
            if Pointer.Count /= Pointer.Left_Child.Count + Pointer.Right_Child.Count + 1 then
               raise Heaps_Package.Inconsistent_Heap with Message;
            end if;
         end if;
      end Check_Counts;

      procedure Check_Path_Lengths(Pointer : in Heap_Node_Access) is
      begin
         if Pointer = null then return; end if;
         Check_Path_Lengths(Pointer.Left_Child);
         Check_Path_Lengths(Pointer.Right_Child);
         if Pointer.Left_Child = null or Pointer.Right_Child = null then
            if Pointer.Null_Path_Length /= 0 then
               raise Heaps_Package.Inconsistent_Heap with Message;
            end if;
         else
            if Pointer.Left_Child.Null_Path_Length < Pointer.Right_Child.Null_Path_Length then
               raise Heaps_Package.Inconsistent_Heap with Message;
            elsif Pointer.Null_Path_Length /= Pointer.Right_Child.Null_Path_Length + 1 then
               raise Heaps_Package.Inconsistent_Heap with Message;
            end if;
         end if;
      end Check_Path_Lengths;

      procedure Check_Heap_Property(Pointer : in Heap_Node_Access) is
      begin
         if Pointer = null then return; end if;
         Check_Heap_Property(Pointer.Left_Child);
         Check_Heap_Property(Pointer.Right_Child);
         if Pointer.Left_Child /= null and then Pointer.Left_Child.Data < Pointer.Data then
            raise Heaps_Package.Inconsistent_Heap with Message;
         end if;
         if Pointer.Right_Child /= null and then Pointer.Right_Child.Data < Pointer.Data then
            raise Heaps_Package.Inconsistent_Heap with Message;
         end if;
      end Check_Heap_Property;

   begin -- Check_Sanity
      Check_Counts(H.Root);
      Check_Path_Lengths(H.Root);
      Check_Heap_Property(H.Root);
   end Check_Sanity;


   procedure Finalize(H : in out Heap) is
      -- This might not be such a good way for leftist heaps because they are highly
      -- unbalanced to the left. This recursion might thus use a lot of stack space.
      --
      procedure Deallocate_Subtree(Pointer : in out Heap_Node_Access) is
      begin
         if Pointer = null then return; end if;
         Deallocate_Subtree(Pointer.Left_Child);
         Deallocate_Subtree(Pointer.Right_Child);
         Deallocate_Node(Pointer);
      end Deallocate_Subtree;

   begin -- Finalize
      Deallocate_Subtree(H.Root);
   end Finalize;

end Spica.Leftist_Heaps;
