with Ada.Numerics.Float_Random;
with Ada.Unchecked_Deallocation;

package body Spica.Skip_Lists is

   Gen : Ada.Numerics.Float_Random.Generator;

   procedure Deallocate_Node is new
     Ada.Unchecked_Deallocation(Node, Node_Access);


   procedure Insert(List : in out Skip_List; Key : in Key_Type; Value : in Value_Type) is
      Update    : Node_Access_Array;
      X         : Node_Access;
      New_Level : Positive;

      function Random_Level return Positive
        with Post => Random_Level'Result <= Max_Level
      is
         New_Level : Positive := 1;
      begin
         while Ada.Numerics.Float_Random.Random(Gen) < 0.5 loop
            New_Level := New_Level + 1;
         end loop;
         return Positive'Min(New_Level, Max_Level);
      end Random_Level;

   begin
      X := List.Header;
      for I in reverse 1 .. Max_Level loop
         while X.Forward(I) /= null and then X.Forward(I).Key < Key loop
            X := X.Forward(I);
         end loop;
         Update(I) := X;
      end loop;
      X := X.Forward(1);
      if X /= null and then X.Key = Key then
         X.Value := Value;
      else
         New_Level := Random_Level;
         X := new Node'(Key, Value, (others => null));
         for I in 1 .. New_Level loop
            X.Forward(I) := Update(I).Forward(I);
            Update(I).Forward(I) := X;
         end loop;
         List.Count := List.Count + 1;
      end if;
   end Insert;


   function Search(List : in out Skip_List; Key : in Key_Type) return Value_Type is
      Result : Value_Type;
      X : Node_Access;
   begin
      X := List.Header;
      for I in reverse 1 .. Max_Level loop
         while X.Forward(I) /= null and then X.Forward(I).Key < Key loop
            X := X.Forward(I);
         end loop;
      end loop;
      X := X.Forward(1);
      if X /= null and then X.Key = Key then
         Result := X.Value;
      else
         raise KV_Package.Not_Found;
      end if;
      return Result;
   end Search;


   procedure Delete(List : in out Skip_List; Key : in Key_Type) is
      Update : Node_Access_Array;
      X      : Node_Access;
   begin
      X := List.Header;
      for I in reverse 1 .. Max_Level loop
         while X.Forward(I) /= null and then X.Forward(I).Key < Key loop
            X := X.Forward(I);
         end loop;
         Update(I) := X;
      end loop;
      X := X.Forward(1);
      if X /= null and then X.Key = Key then
         for I in 1 .. Max_Level loop
            if Update(I) /= null and then Update(I).Forward(I) = X then
               Update(I).Forward(I) := X.Forward(I);
            end if;
         end loop;
         Deallocate_Node(X);
         List.Count := List.Count - 1;
      end if;
   end Delete;


   function Size(List : Skip_List) return Natural is
   begin
      return List.Count;
   end Size;


   procedure Check_Sanity(List : in Skip_List; Message : in String) is
      Actual_Count : Natural;      -- Used to count the number of list elements.
      Is_Sorted    : Boolean;      -- Flag to indicate if the list is properly sorted.
      Previous_Key : Key_Type;     -- Used during the ordering check.
      P            : Node_Access;  -- General purpose access value for list traversal.
   begin
      -- Count the number of elements actually in the list.
      Actual_Count := 0;
      P := List.Header.Forward(1);
      while P /= null loop
         Actual_Count := Actual_Count + 1;
         P := P.Forward(1);
      end loop;

      -- Check that the list is sorted as seen by all levels.
      Is_Sorted := True;
      for Level in 1 .. Max_Level loop
         P := List.Header.Forward(Level);
         while P /= null loop
            -- Check if the list is sorted. Skip this check on the first element.
            if P /= List.Header.Forward(Level) then
               if not (Previous_Key < P.Key) then
                  Is_Sorted := False;
               end if;
            end if;
            Previous_Key := P.Key;

            -- Move forward to the next item.
            P := P.Forward(Level);
         end loop;
      end loop;

      if not (Is_Sorted and (Actual_Count = List.Count)) then
         raise KV_Package.Inconsistent_Store with Message;
      end if;
   end Check_Sanity;


   procedure Initialize(List : in out Skip_List) is
   begin
      -- The header node is only used for it's Forward array. The (Key, Value) pair is ignored.
      List.Header := new Node;
      List.Header.Forward := (others => null);
      List.Count := 0;
   end Initialize;


   procedure Finalize(List : in out Skip_List) is
      P : Node_Access := List.Header.Forward(1);
      Temp : Node_Access;
   begin
      while P /= null loop
         Temp := P.Forward(1);
         Deallocate_Node(P);
         P := Temp;
      end loop;
      Deallocate_Node(List.Header);
   end Finalize;


end Spica.Skip_Lists;
