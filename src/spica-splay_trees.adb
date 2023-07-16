
-- Reference: "Data Structures and Algorithm Analysis in C++," third edition by Mark Allen
-- Weiss, Copyright 2006, Published by Addison Wesley, ISBN=0-321-44146-X, pages 149--158
-- (Section 4.5 "Splay Trees"). Some of the names choosen below reflect names used in Weiss's
-- diagrams.
with Ada.Unchecked_Deallocation;

package body Spica.Splay_Trees is

   ------------------------------------------------
   -- The following are internal helper subprograms
   ------------------------------------------------

   procedure Free_Node is new
     Ada.Unchecked_Deallocation(Node, Node_Access);


   procedure Finalize(T : in out Tree) is

      procedure Destroy_Subtree(N : in out Node_Access) is
      begin
         if N = null then return; end if;
         Destroy_Subtree(N.Left);
         Destroy_Subtree(N.Right);
         Free_Node(N);
      end Destroy_Subtree;

   begin
      Destroy_Subtree(T.Root);
      T.Count := 0;
   end Finalize;


   -- Search the subtree rooted at N for Key. Return a pointer to the item's node if it is
   -- found, and the null pointer otherwise. If given a null node, this function returns null.
   --
   function Basic_Lookup(N : Node_Access; Key : Key_Type) return Node_Access is
      X : Node_Access := N;
   begin
      while X /= null loop
         if Key < X.Key then
            X := X.Left;
         elsif X.Key < Key then
            X := X.Right;
         else
            exit;
         end if;
      end loop;
      return X;
   end Basic_Lookup;


   -- Insert item into tree T. Return pointer to new or existing node.
   procedure Basic_Insert
     (T : in out Tree; Key : Key_Type; Value : Value_Type; Result : out Node_Access)
   is
      X : Node_Access := T.Root;
   begin
      loop
         if Key < X.Key then
            if X.Left /= null then
               X := X.Left;
            else
               X.Left  := new Node'(Key => Key, Value => Value, Parent => X, others => <>);
               X       := X.Left;
               T.Count := T.Count + 1;
               exit;
            end if;
         elsif X.Key < Key then
            if X.Right /= null then
               X := X.Right;
            else
               X.Right := new Node'(Key => Key, Value => Value, Parent => X, others => <>);
               X       := X.Right;
               T.Count := T.Count + 1;
               exit;
            end if;
         else
            X.Value := Value;
            exit;
         end if;
      end loop;
      Result := X;
   end Basic_Insert;

   -- X points at a node in the tree T. This procedure moves that node to
   -- the root of T by performing the necessary zig-zag and zig-zig rota-
   -- tions. The names 'X', 'P', and 'G' were choosen to correspond to the
   -- diagrams on page 152 of the reference.
   --
   procedure Adjust_Root(T : in out Tree; X : in not null Node_Access) is

      -- Perform a zig-zag or zig-zig rotation. This is only called when X
      -- has a grandparent.
      --
      procedure ZigZagZig is
         P : Node_Access := X.Parent;
         G : Node_Access := X.Parent.Parent;

         -- After X is moved to the root of its subtree, the parent node of
         -- the subtree must be adjusted to point at X. This helper procedure
         -- handles this.
         --
         procedure Fixup_Subtree_Root is
         begin
            if G.Parent /= null then
               if G = G.Parent.Left then
                  G.Parent.Left := X;
               else
                  G.Parent.Right := X;
               end if;
            end if;
         end Fixup_Subtree_Root;

      begin -- ZigZagZig
         -- Two symmetrical zig-zag cases.
         if P.Right = X and G.Left = P then
            P.Right  := X.Left;
            if X.Left /= null then X.Left.Parent  := P; end if;
            G.Left   := X.Right;
            if X.Right /= null then X.Right.Parent := G; end if;
            X.Parent := G.Parent;
            Fixup_Subtree_Root;
            X.Left   := P;
            X.Right  := G;
            P.Parent := X;
            G.Parent := X;

         elsif P.Left = X and G.Right = P then
            P.Left   := X.Right;
            if X.Right /= null then X.Right.Parent := P; end if;
            G.Right  := X.Left;
            if X.Left /= null then X.Left.Parent  := G; end if;
            X.Parent := G.Parent;
            Fixup_Subtree_Root;
            X.Right  := P;
            X.Left   := G;
            P.Parent := X;
            G.Parent := X;

         -- Two symmetrical zig-zig cases.
         elsif P.Left = X and G.Left = P then
            P.Left   := X.Right;
            if X.Right /= null then X.Right.Parent := P; end if;
            G.Left   := P.Right;
            if P.Right /= null then P.Right.Parent := G; end if;
            P.Right  := G;
            X.Right  := P;
            X.Parent := G.Parent;
            Fixup_Subtree_Root;
            P.Parent := X;
            G.Parent := P;

         else
            P.Right  := X.Left;
            if X.Left /= null then X.Left.Parent := P; end if;
            G.Right  := P.Left;
            if P.Left /= null then P.Left.Parent := G; end if;
            P.Left   := G;
            X.Left   := P;
            X.Parent := G.Parent;
            Fixup_Subtree_Root;
            P.Parent := X;
            G.Parent := P;
         end if;
      end ZigZagZig;

   begin -- Adjust_Root
      while X.Parent /= null loop
         if X.Parent.Parent /= null then
            ZigZagZig;
         else
            -- Handle immediate child of the root as a simple rotation.
            if X.Parent.Left = X then
               X.Parent.Left  := X.Right;
               if X.Right /= null then X.Right.Parent := X.Parent; end if;
               X.Right        := X.Parent;
               X.Parent       := X.Parent.Parent;
               X.Right.Parent := X;
            else
               X.Parent.Right := X.Left;
               if X.Left /= null then X.Left.Parent := X.Parent; end if;
               X.Left         := X.Parent;
               X.Parent       := X.Parent.Parent;
               X.Left.Parent  := X;
            end if;
         end if;
      end loop;
      T.Root := X;
   end Adjust_Root;

   ---------------------------------------
   -- The following are public subprograms
   ---------------------------------------

   procedure Insert(T : in out Tree; Key : in Key_Type; Value : in Value_Type) is
      N : Node_Access;
   begin
      if T.Root = null then
         T.Root  := new Node'(Key => Key, Value => Value, others => <>);
         T.Count := 1;
      else
         Basic_Insert(T, Key, Value, N);
         Adjust_Root(T, N);
      end if;
   end Insert;


   function Search(T : in out Tree; Key : in Key_Type) return Value_Type is
      N : Node_Access;
   begin
      N := Basic_Lookup(T.Root, Key);
      if N = null then raise KV_Package.Not_Found; end if;
      Adjust_Root(T, N);
      return T.Root.Value;
   end Search;


   procedure Delete(T : in out Tree; Key : in Key_Type) is
   begin
      raise Program_Error with "Splay_Trees.Delete not implemented";
   end Delete;


   function Size(T : Tree) return Natural is
   begin
      return T.Count;
   end Size;


   procedure Check_Sanity(T : in Tree; Message : String) is
      Actual_Count : Natural := 0;

      procedure Traverse(N : in Node_Access) is
      begin
         if N = null then return; end if;

         Actual_Count := Actual_Count + 1;
         if N.Left /= null then
            if not (N.Left.Key < N.Key) then
               raise KV_Package.Inconsistent_Store with Message;
            end if;
            if N.Left.Parent /= N then
               raise KV_Package.Inconsistent_Store with Message;
            end if;
            Traverse(N.Left);
         end if;
         if N.Right /= null then
            if not (N.Key < N.Right.Key) then
               raise KV_Package.Inconsistent_Store with Message;
            end if;
            if N.Right.Parent /= N then
               raise KV_Package.Inconsistent_Store with Message;
            end if;
            Traverse(N.Right);
         end if;

      end Traverse;

   begin
      if T.Root  = null and T.Count  = 0 then return; end if;
      if T.Root  = null and T.Count /= 0 then
         raise KV_Package.Inconsistent_Store with Message;
      end if;
      if T.Root.Parent /= null then
         raise KV_Package.Inconsistent_Store with Message;
      end if;
      Traverse(T.Root);
      if Actual_Count /= T.Count then
         raise KV_Package.Inconsistent_Store with Message;
      end if;
   end Check_Sanity;


   -------------------------------
   -- The following is for testing
   -------------------------------

   function Dump(T : in Tree) return Dump_Type is
      Result : Dump_Type(0 .. T.Count - 1);
      Index  : Natural := 0;

      procedure Traverse(N : in Node_Access; Current_Level : Natural) is
      begin
         if N = null then return; end if;
         Traverse(N.Left, Current_Level + 1);
         Result(Index).Key   := N.Key;
         Result(Index).Value := N.Value;
         Result(Index).Level := Current_Level;
         Index := Index + 1;
         Traverse(N.Right, Current_Level + 1);
      end Traverse;

   begin
      Traverse(T.Root, 1);
      return Result;
   end Dump;

end Spica.Splay_Trees;
