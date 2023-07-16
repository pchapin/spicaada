with Ada.Assertions; use Ada.Assertions;

package body Spica.KV_Stores.Check is

   procedure Check_Insert
     (Container : in out KV_Store'Class; Pair_Array : in Pair_Array_Type)
   is
   begin
      for I in Pair_Array'Range loop
         Container.Insert(Pair_Array(I).Key, Pair_Array(I).Value);
         Check_Sanity(Container, "Insane container after Insert at index " & Natural'Image(I));

         Assert
           (Container.Search(Pair_Array(I).Key) = Pair_Array(I).Value,
            "Bad search result after Insert at index " & Natural'Image(I));
      end loop;
   end Check_Insert;


   procedure Check_Delete
     (Container : in out KV_Store'Class; Pair_Array : in Pair_Array_Type; Delete_Array : in Key_Array_Type)
   is
   begin
      for I in Pair_Array'Range loop
         Container.Insert(Pair_Array(I).Key, Pair_Array(I).Value);
      end loop;
      Check_Sanity(Container, "Insane container after multiple insertions");

      for I in Delete_Array'Range loop
         Container.Delete(Key => Delete_Array(I));
         Check_Sanity(Container, "Insane container after Delete at index " & Natural'Image(I));

         declare
            Dummy : Value_Type;
         begin
            Dummy := Container.Search(Key => Delete_Array(I));
            Assert(False, "Deleted item still in container at index " & Natural'Image(I));
         exception
            when Not_Found =>
               null;
         end;
      end loop;

   end Check_Delete;

end Spica.KV_Stores.Check;
