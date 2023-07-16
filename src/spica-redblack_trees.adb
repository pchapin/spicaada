
with Ada.Unchecked_Deallocation;

package body Spica.RedBlack_Trees is

   procedure Deallocate_Node is new
     Ada.Unchecked_Deallocation(Object => Tree_Node, Name => Tree_Node_Access);

   procedure Left_Rotate(T : in out RedBlack_Tree; X : in Tree_Node_Access)
     with Pre => X.Right_Child /= T.Nil
   is
      Y : constant Tree_Node_Access := X.Right_Child;
   begin
      X.Right_Child := Y.Left_Child;
      if Y.Left_Child /= T.Nil then
         Y.Left_Child.Parent := X;
      end if;
      Y.Parent := X.Parent;
      if X.Parent = T.Nil then
         T.Root := Y;
      elsif X = X.Parent.Left_Child then
         X.Parent.Left_Child := Y;
      else
         X.Parent.Right_Child := Y;
      end if;
      Y.Left_Child := X;
      X.Parent := Y;
   end Left_Rotate;


   procedure Right_Rotate(T : in out RedBlack_Tree; Y : in Tree_Node_Access)
     with Pre => Y.Left_Child /= T.Nil
   is
      X : constant Tree_Node_Access := Y.Left_Child;
   begin
      Y.Left_Child := X.Right_Child;
      if X.Right_Child /= T.Nil then
         X.Right_Child.Parent := Y;
      end if;
      X.Parent := Y.Parent;
      if Y.Parent = T.Nil then
         T.Root := X;
      elsif Y = Y.Parent.Left_Child then
         Y.Parent.Left_Child := X;
      else
         Y.Parent.Right_Child := X;
      end if;
      X.Right_Child := Y;
      Y.Parent := X;
   end Right_Rotate;


   procedure RedBlack_Insert_Fixup(T : in out RedBlack_Tree; Z : in out Tree_Node_Access) is
      Y : Tree_Node_Access;
   begin
      while Z.Parent.Color = Red loop
         if Z.Parent = Z.Parent.Parent.Left_Child then
            Y := Z.Parent.Parent.Right_Child;
            if Y.Color = Red then
               -- Case #1
               Z.Parent.Color := Black;
               Y.Color := Black;
               Z.Parent.Parent.Color := Red;
               Z := Z.Parent.Parent;
            else
               if Z = Z.Parent.Right_Child then
                  -- Case #2
                  Z := Z.Parent;
                  Left_Rotate(T, Z);
               end if;
               -- Case #3
               Z.Parent.Color := Black;
               Z.Parent.Parent.Color := Red;
               Right_Rotate(T, Z.Parent.Parent);
            end if;
         else
            Y := Z.Parent.Parent.Left_Child;
            if Y.Color = Red then
               -- Case #1
               Z.Parent.Color := Black;
               Y.Color := Black;
               Z.Parent.Parent.Color := Red;
               Z := Z.Parent.Parent;
            else
               if Z = Z.Parent.Left_Child then
                  -- Case #2
                  Z := Z.Parent;
                  Right_Rotate(T, Z);
               end if;
               -- Case #3
               Z.Parent.Color := Black;
               Z.Parent.Parent.Color := Red;
               Left_Rotate(T, Z.Parent.Parent);
            end if;
         end if;
      end loop;
      T.Root.Color := Black;
   end RedBlack_Insert_Fixup;


   procedure Insert(T : in out RedBlack_Tree; Key : in Key_Type; Value : in Value_Type) is
      X : Tree_Node_Access;
      Y : Tree_Node_Access;
      Z : Tree_Node_Access;
   begin
      Y := T.Nil;
      X := T.Root;
      while X /= T.Nil loop

         -- If the key already exists, replace the value and we are done.
         if Key = X.Key then
            X.Value := Value;
            return;
         end if;

         -- Otherwise search down the tree.
         Y := X;
         if Key < X.Key then
            X := X.Left_Child;
         else
            X := X.Right_Child;
         end if;
      end loop;

      -- Y now points at the node to which we must attached the new node (or it is T.Nil).
      Z := new Tree_Node'(Key, Value, Red, others => <>);
      Z.Parent := Y;
      if Y = T.Nil then
         T.Root := Z;
      elsif Key < Y.Key then
         Y.Left_Child := Z;
      else
         Y.Right_Child := Z;
      end if;
      Z.Left_Child := T.Nil;
      Z.Right_Child := T.Nil;
      RedBlack_Insert_Fixup(T, Z);
      T.Count := T.Count + 1;
   end Insert;


   function Search(T : in out RedBlack_Tree; Key : Key_Type) return Value_Type is
      Result : Value_Type;

      procedure Search_Subtree(Pointer : in Tree_Node_Access) is
      begin
         if Pointer = T.Nil then
            raise KV_Package.Not_Found;
         else
            if Key = Pointer.Key then
               Result := Pointer.Value;
            elsif Key < Pointer.Key then
               Search_Subtree(Pointer.Left_Child);
            else
               Search_Subtree(Pointer.Right_Child);
            end if;
         end if;
      end Search_Subtree;

   begin
      Search_Subtree(T.Root);
      return Result;
   end Search;


   procedure RedBlack_Transplant(T : in out RedBlack_Tree; U, V : in out Tree_Node_Access) is
   begin
      if U.Parent = T.Nil then
         T.Root := V;
      elsif U = U.Parent.Left_Child then
         U.Parent.Left_Child := V;
      else
         U.Parent.Right_Child := V;
      end if;
      V.Parent := U.Parent;
   end RedBlack_Transplant;


   procedure RedBlack_Delete_Fixup(T : in out RedBlack_Tree; Incoming_X : in Tree_Node_Access) is
      X : Tree_Node_Access := Incoming_X;
      W : Tree_Node_Access;
   begin
      while X /= T.Root and X.Color = Black loop
         if X = X.Parent.Left_Child then
            W := X.Parent.Right_Child;
            if W.Color = Red then
               -- Case #1
               W.Color := Black;
               X.Parent.Color := Red;
               Left_Rotate(T, X.Parent);
               W := X.Parent.Right_Child;
            end if;
            if W.Left_Child.Color = Black and W.Right_Child.Color = Black then
               -- Case #2
               W.Color := Red;
               X := X.Parent;
            else
               if W.Right_Child.Color = Black then
                  -- Case #3
                  W.Left_Child.Color := Black;
                  W.Color := Red;
                  Right_Rotate(T, W);
                  W := X.Parent.Right_Child;
               end if;
               -- Case #4
               W.Color := X.Parent.Color;
               X.Parent.Color := Black;
               W.Right_Child.Color := Black;
               Left_Rotate(T, X.Parent);
               X := T.Root;
            end if;
         else
            W := X.Parent.Left_Child;
            if W.Color = Red then
               -- Case #1
               W.Color := Black;
               X.Parent.Color := Red;
               Right_Rotate(T, X.Parent);
               W := X.Parent.Left_Child;
            end if;
            if W.Right_Child.Color = Black and W.Left_Child.Color = Black then
               -- Case #2
               W.Color := Red;
               X := X.Parent;
            else
               if W.Left_Child.Color = Black then
                  -- Case #3
                  W.Right_Child.Color := Black;
                  W.Color := Red;
                  Left_Rotate(T, W);
                  W := X.Parent.Left_Child;
               end if;
               -- Case #4
               W.Color := X.Parent.Color;
               X.Parent.Color := Black;
               W.Left_Child.Color := Black;
               Right_Rotate(T, X.Parent);
               X := T.Root;
            end if;
         end if;
      end loop;
      X.Color := Black;
   end RedBlack_Delete_Fixup;


   -- TODO: Fix memory leak! Call Deallocate_Node at the appropriate place(s).
   procedure Delete(T : in out RedBlack_Tree; Key : in Key_Type) is

      function Search_For_Key(Key : in Key_Type) return Tree_Node_Access is
         Pointer : Tree_Node_Access := T.Root;
      begin
         -- Search down the tree starting at the root.
         while Pointer /= T.Nil loop
            -- If we found what we want, we are done.
            if Key = Pointer.Key then
               return Pointer;
            end if;

            -- Otherwise step in the correct direction.
            if Key < Pointer.Key then
               Pointer := Pointer.Left_Child;
            else
               Pointer := Pointer.Right_Child;
            end if;
         end loop;
         return T.Nil;
      end Search_For_Key;

      function Tree_Minimum(X : in Tree_Node_Access) return Tree_Node_Access
        with Pre => X /= T.Nil
      is
         Result : Tree_Node_Access := X;
      begin
         while Result.Left_Child /= T.Nil loop
            Result := Result.Left_Child;
         end loop;
         return Result;
      end Tree_Minimum;

      X : Tree_Node_Access;
      Y : Tree_Node_Access;
      Z : Tree_Node_Access;
      Y_Original_Color : Color_Type;
   begin
      Z := Search_For_Key(Key);

      -- If the Key is not present, we are done. Skip the body of this procedure.
      if Z /= T.Nil then
         Y := Z;
         Y_Original_Color := Y.Color;
         if Z.Left_Child = T.Nil then
            X := Z.Right_Child;
            RedBlack_Transplant(T, Z, Z.Right_Child);
         elsif Z.Right_Child = T.Nil then
            X := Z.Left_Child;
            RedBlack_Transplant(T, Z, Z.Left_Child);
         else
            Y := Tree_Minimum(Z.Right_Child);
            Y_Original_Color := Y.Color;
            X := Y.Right_Child;
            if Y.Parent = Z then
               X.Parent := Y;
            else
               RedBlack_Transplant(T, Y, Y.Right_Child);
               Y.Right_Child := Z.Right_Child;
               Y.Right_Child.Parent := Y;
            end if;
            RedBlack_Transplant(T, Z, Y);
            Y.Left_Child := Z.Left_Child;
            Y.Left_Child.Parent := Y;
            Y.Color := Z.Color;
         end if;
         if Y_Original_Color = Black then
            RedBlack_Delete_Fixup(T, X);
         end if;
         T.Count := T.Count - 1;
      end if;
   end Delete;


   function Size(T : RedBlack_Tree) return Natural is
   begin
      return T.Count;
   end Size;


   procedure Check_Sanity(T : in RedBlack_Tree; Message : in String) is
   begin
      -- Okay! *cracks knuckles* Let's get to it...

      -- First, let's verify the ordering property. As a side effect this will also check the
      -- structuring of the left and right child pointers. If the children aren't connected
      -- properly, we will likely get Contraint_Error when we dereference null pointers, or
      -- maybe an infinite loop or some other detectable problem.
      declare
         procedure Check_Ordering(Pointer : in not null Tree_Node_Access) is
         begin
            if Pointer.Left_Child /= T.Nil then
               if not (Pointer.Left_Child.Key < Pointer.Key) then
                  raise KV_Package.Inconsistent_Store with Message;
               end if;
               Check_Ordering(Pointer.Left_Child);
            end if;
            if Pointer.Right_Child /= T.Nil then
               if not (Pointer.Key < Pointer.Right_Child.Key) then
                  raise KV_Package.Inconsistent_Store with Message;
               end if;
               Check_Ordering(Pointer.Right_Child);
            end if;
         end Check_Ordering;
      begin
         if T.Root /= T.Nil then
            Check_Ordering(T.Root);
         end if;
      end;

      -- Still here? Great!

      -- Now let's check those parent pointers...
      declare
         procedure Check_Parents(Pointer : in not null Tree_Node_Access) is
         begin
            if Pointer.Left_Child /= T.Nil then
               if Pointer.Left_Child.Parent /= Pointer then
                  raise KV_Package.Inconsistent_Store with Message;
               end if;
               Check_Parents(Pointer.Left_Child);
            end if;
            if Pointer.Right_Child /= T.Nil then
               if Pointer.Right_Child.Parent /= Pointer then
                  raise KV_Package.Inconsistent_Store with Message;
               end if;
               Check_Parents(Pointer.Right_Child);
            end if;
         end Check_Parents;
      begin
         if T.Root /= T.Nil then
            Check_Parents(T.Root);
            if T.Root.Parent /= T.Nil then
               raise KV_Package.Inconsistent_Store with Message;
            end if;
         end if;
      end;

      -- The crowd cheers as we turn the corner!

      -- Next, let's verify the node count.
      declare
         function Node_Count(Pointer : in not null Tree_Node_Access) return Natural is
            Left_Count, Right_Count : Natural := 0;
         begin
            if Pointer.Left_Child /= T.Nil then
               Left_Count := Node_Count(Pointer.Left_Child);
            end if;
            if Pointer.Right_Child /= T.Nil then
               Right_Count := Node_Count(Pointer.Right_Child);
            end if;
            return 1 + Left_Count + Right_Count;
         end Node_Count;
      begin
         if T.Root /= T.Nil then
            if T.Count /= Node_Count(T.Root) then
               raise KV_Package.Inconsistent_Store with Message;
            end if;
         else
            if T.Count /= 0 then
               raise KV_Package.Inconsistent_Store with Message;
            end if;
         end if;
      end;

      -- The home stretch! The crowd goes wild!!

      -- Finally, we have to check the red/black properties.
      declare
         -- "Property 4" is as listed in CLRS Chapter 13, page 308:
         -- If a node is red, then both its children are black.
         procedure Check_Property_4(Pointer : in not null Tree_Node_Access) is
         begin
            if Pointer = T.Nil then return; end if;

            if Pointer.Color = Red then
               if Pointer.Left_Child.Color /= Black or Pointer.Right_Child.Color /= Black then
                  raise KV_Package.Inconsistent_Store with Message;
               end if;
            end if;
            Check_Property_4(Pointer.Left_Child);
            Check_Property_4(Pointer.Right_Child);
         end Check_Property_4;

         Overall_Black_Height : Natural;
         pragma Unreferenced(Overall_Black_Height);  -- See note below.

         function Black_Height(Pointer : in not null Tree_Node_Access) return Natural is
            Left_Height, Right_Height : Natural := 0;
         begin
            -- Nil always has a black height of 0.
            if Pointer = T.Nil then return 0; end if;

            Left_Height  := Black_Height(Pointer.Left_Child);
            Right_Height := Black_Height(Pointer.Right_Child);

            -- Compute my black height along both downward paths...
            -- A Nil child is always black, which is appropriate here.
            if Pointer.Left_Child.Color = Black then
               Left_Height := Left_Height + 1;
            end if;
            if Pointer.Right_Child.Color = Black then
               Right_Height := Right_Height + 1;
            end if;

            -- The black height of a node is consistent across both children.
            if Left_Height /= Right_Height then
               raise KV_Package.Inconsistent_Store with Message;
            end if;

            -- Return that consistent height
            return Left_Height;
         end Black_Height;
      begin
         -- Property 2: The root is black.
         if T.Root /= T.Nil then
            if T.Root.Color /= Black then
               raise KV_Package.Inconsistent_Store with Message;
            end if;
         end if;

         -- Property 3: Nil is black.
         if T.Nil.Color /= Black then
            raise KV_Package.Inconsistent_Store with Message;
         end if;

         Check_Property_4(T.Root);

         -- Property 5: For each node, all simple paths from the node to descendant leaves
         -- contain the same number of black nodes. If this call returns without exception,
         -- the property is satisfied. The returned value is ignored.
         Overall_Black_Height := Black_Height(T.Root);
      end;

      -- The finish line! *fist pumps* The crowd chants, "RED! BLACK! RED! BLACK!..."

   end Check_Sanity;


   procedure Initialize(T : in out RedBlack_Tree) is
   begin
      T.Nil   := new Tree_Node;
      T.Nil.Color := Black;
      T.Root  := T.Nil;
      T.Count := 0;
   end Initialize;


   procedure Finalize(T : in out RedBlack_Tree) is

      procedure Deallocate_Subtree(Pointer : in out Tree_Node_Access) is
      begin
         if Pointer /= T.Nil then
            Deallocate_Subtree(Pointer.Left_Child);
            Deallocate_Subtree(Pointer.Right_Child);
            Deallocate_Node(Pointer);
         end if;
      end Deallocate_Subtree;

   begin
      Deallocate_Subtree(T.Root);
      T.Count := 0;
      Deallocate_Node(T.Nil);
   end Finalize;


end Spica.RedBlack_Trees;
