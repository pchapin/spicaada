with Ada.Unchecked_Deallocation;

package body Spica.Fibonacci_Heaps is

   procedure Deallocate_Node is new
     Ada.Unchecked_Deallocation(Node, Node_Access);


   procedure Initialize(H : in out Heap) is
   begin
      H.Top  := null;
      H.Size := 0;
   end Initialize;


   procedure Finalize(H : in out Heap) is

      procedure Finalize_Children(Node : in not null Node_Access) is
         Current : Node_Access := Node;
         Temp    : Node_Access;
      begin
         loop
            if Current.Child /= null then
               Finalize_Children(Current.Child);
            end if;
            Temp := Current.Right_Sibling;
            Deallocate_Node(Current);
            Current := Temp;
            exit when Current = Node;  -- Is this well defined? Node has been deallocated.
         end loop;
      end Finalize_Children;

   begin
      if H.Top /= null then
         Finalize_Children(H.Top);
      end if;
   end Finalize;


   procedure Insert(H : in out Heap; Item : in Key_Type) is
      New_Node : Node_Access := new Node;
   begin
      New_Node.Key := Item;
      if H.Top = null then
         New_Node.Left_Sibling  := New_Node;
         New_Node.Right_Sibling := New_Node;
         H.Top := New_Node;
      else
         New_Node.Left_Sibling  := H.Top.Left_Sibling;
         New_Node.Right_Sibling := H.Top;
         H.Top.Left_Sibling.Right_Sibling := New_Node;
         H.Top.Left_Sibling     := New_Node;
         if New_Node.Key < H.Top.Key then
            H.Top := New_Node;
         end if;
      end if;
      H.Size := H.Size + 1;
   end Insert;


   function Top_Priority(H : Heap) return Key_Type is
   begin
      return H.Top.Key;
   end Top_Priority;


   procedure Delete_Top_Priority(H : in out Heap) is
   begin
      raise Program_Error with "Not Implemented";
   end Delete_Top_Priority;


   procedure Union(Destination : in out Heap; Source : in out Heap) is
      Source_Immediate_Left       : Node_Access;
      Destination_Immediate_Right : Node_Access;
   begin
      -- If the source is empty, there is nothing to do.
      if Source.Top = null then
         return;
      end if;

      -- If the destination is empty, just move the source to the destination.
      if Destination.Top = null then
         Destination.Top  := Source.Top;
         Destination.Size := Source.Size;
         Source.Top  := null;
         Source.Size := 0;
         return;
      end if;

      -- Both the source and destination are non-empty heaps...
      Source_Immediate_Left       := Source.Top.Left_Sibling;
      Destination_Immediate_Right := Destination.Top.Right_Sibling;

      -- Now the tricky stuff.
      Destination.Top.Right_Sibling := Source.Top;
      Source.Top.Left_Sibling       := Destination.Top;
      Source_Immediate_Left.Right_Sibling      := Destination_Immediate_Right;
      Destination_Immediate_Right.Left_Sibling := Source_Immediate_Left;
      if Source.Top.Key < Destination.Top.Key then
         Destination.Top := Source.Top;
      end if;
      Source.Top  := null;
      Source.Size := 0;
   end Union;


   function Size(H : Heap) return Natural is
   begin
      return H.Size;
   end Size;


   procedure Check_Sanity(H : in Heap; Message : in String) is

      Total_Count : Natural := 0;

      procedure Process_Children(First_Child : in not null Node_Access; Parent : in Node_Access) is
         Current : not null Node_Access := First_Child;
         Child_Count : Natural := 0;
      begin
         loop
            Total_Count := Total_Count + 1;
            Child_Count := Child_Count + 1;

            -- All children of a node have the correct parent pointer...
            if Current.Parent /= Parent then
               raise Heaps_Package.Inconsistent_Heap with Message;
            end if;

            -- The key in the children is greater than or equal to the key in the parent...
            if Parent /= null then
               if Current.Key < Parent.Key then
                  raise Heaps_Package.Inconsistent_Heap with Message;
               end if;
            end if;

            -- Check consistency of the left and right sibling pointers.
            if Current.Right_Sibling.Left_Sibling /= Current then
               raise Heaps_Package.Inconsistent_Heap with Message;
            end if;
            if Current.Left_Sibling.Right_Sibling /= Current then
               raise Heaps_Package.Inconsistent_Heap with Message;
            end if;

            -- Recursively handle the children of this child.
            if Current.Child /= null then
               Process_Children(Current.Child, Current);
            end if;

            exit when Current.Right_Sibling = First_Child;

            -- Advance to the next child on the right.
            Current := Current.Right_Sibling;
         end loop;

         -- The degree of the parent equals the number of children.
         if Parent /= null then
            if First_Child.Parent.Degree /= Child_Count then
               raise Heaps_Package.Inconsistent_Heap with Message;
            end if;
         end if;
      end Process_Children;

   begin
      -- Deal with the empty heap first.
      if H.Top = null then
         if H.Size /= 0 then
            raise Heaps_Package.Inconsistent_Heap with Message;
         end if;
         return;
      end if;

      Process_Children(H.Top, null);

      -- Check the total node count.
      if H.Size /= Total_Count then
         raise Heaps_Package.Inconsistent_Heap with Message;
      end if;
   end Check_Sanity;


   procedure Insert(H : in out Heap; Item : in Key_Type; Result_Node : out Node_Handle) is
   begin
      raise Program_Error with "Not Implemented";
   end Insert;


   procedure Raise_Key_Priority
     (H : in out Heap; Existing_Node : in Node_Handle; New_Item : in Key_Type) is
   begin
      raise Program_Error with "Not Implemented";
   end Raise_Key_Priority;


   procedure Delete(H : in out Heap; Existing_Node : in out Node_Handle) is
   begin
      raise Program_Error with "Not Implemented";
   end Delete;


   function Get_Key(Existing_Node : Node_Handle) return Key_Type is
   begin
      return Existing_Node.Key;
   end Get_Key;

end Spica.Fibonacci_Heaps;
