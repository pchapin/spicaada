
generic
package Spica.KV_Stores.Check is

   type Key_Value_Pair is
      record
         Key   : Key_Type;
         Value : Value_Type;
      end record;

   type Key_Array_Type is array(Natural range <>) of Key_Type;
   type Pair_Array_Type is array(Natural range <>) of Key_Value_Pair;

   procedure Check_Insert
     (Container : in out KV_Store'Class; Pair_Array : in Pair_Array_Type);

   procedure Check_Delete
     (Container : in out KV_Store'Class; Pair_Array : in Pair_Array_Type; Delete_Array : in Key_Array_Type);

end Spica.KV_Stores.Check;
