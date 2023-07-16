
with Spica.KV_Stores;
with Spica.KV_Stores.Check;

package Test_Data is

   -- First instantiate the KV_Stores package.
   package Integer_Stores is
      new Spica.KV_Stores(Key_Type => Integer, Value_Type => Integer);

   -- Next instantiate the generic child "contained" by the parent instance.
   package Integer_Stores_Check is
      new Integer_Stores.Check;

   Insert_1 : constant Integer_Stores_Check.Pair_Array_Type(0 .. 9) :=
     (0 => (0, 100), 1 => (1, 101), 2 => (2, 102), 3 => (3, 103), 4 => (4, 104),
      5 => (5, 105), 6 => (6, 106), 7 => (7, 107), 8 => (8, 108), 9 => (9, 109));

   Insert_2 : constant Integer_Stores_Check.Pair_Array_Type(0 .. 9) :=
     (0 => (9, 109), 1 => (8, 108), 2 => (7, 107), 3 => (6, 106), 4 => (5, 105),
      5 => (4, 104), 6 => (3, 103), 7 => (2, 102), 8 => (1, 101), 9 => (0, 100));

   Insert_3 : constant Integer_Stores_Check.Pair_Array_Type(0 .. 9) :=
     (0 => (4, 104), 1 => (7, 107), 2 => (3, 103), 3 => (1, 101), 4 => (2, 102),
      5 => (9, 109), 6 => (6, 106), 7 => (8, 108), 8 => (5, 105), 9 => (1, 999));

   Delete_3 : constant Integer_Stores_Check.Key_Array_Type(0 .. 9) :=
     (0 => 1, 1 => 9, 2 => 4, 3 => 7, 4 => 3, 5 => 2, 6 => 6, 7 => 8, 8 => 5, 9 => 1);

end Test_Data;
