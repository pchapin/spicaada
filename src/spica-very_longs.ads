
private with Ada.Containers.Vectors;
private with Interfaces;

package Spica.Very_Longs is

   type    Very_Long is private;
   subtype Bit       is Natural range 0..1;
   type    Bit_Index is new Natural;

   -- Used when converting a string of digits into a Very_Long.
   Invalid_Number : exception;

   -- Constructors.
   function Make(Number : in Integer) return Very_Long;
   function Make(Number : in String) return Very_Long;

   -- Basic arithmetic.
   function   "+"(L, R : Very_Long) return Very_Long;
   function   "-"(L, R : Very_Long) return Very_Long;
   function   "-"(N    : Very_Long) return Very_Long;  -- Unary minus.
   function   "*"(L, R : Very_Long) return Very_Long;
   function   "/"(L, R : Very_Long) return Very_Long;
   function "mod"(L, R : Very_Long) return Very_Long;

   -- Relational operators.
   function  "<"(L, R : Very_Long) return Boolean;
   function "<="(L, R : Very_Long) return Boolean;
   function  ">"(L, R : Very_Long) return Boolean;
   function ">="(L, R : Very_Long) return Boolean;

   -- Bit access.
   function  Number_Of_Bits(Number : in Very_Long) return Bit_Index;
   function  Get_Bit(Number     : in Very_Long;
                     Bit_Number : in Bit_Index) return Bit;
   procedure Put_Bit(Number     : in out Very_Long;
                     Bit_Number : in Bit_Index;
                     Bit_Value  : in Bit);

private
   use Interfaces;

   type Sign_Type  is (Plus, Minus);         -- Used for the sign flag.
   type Long_Digit is new Unsigned_64;

   package Digits_Vector is new Ada.Containers.Vectors(
      Index_Type => Ada.Containers.Count_Type, Element_Type => Long_Digit);
   use Digits_Vector;

   -- The structure of a Very_Long integer.
   type Very_Long is
      record
         Sign_Flag   : Sign_Type;
         Long_Digits : Vector;
      end record;

end Spica.Very_Longs;
