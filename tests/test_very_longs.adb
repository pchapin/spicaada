
-- To-Do:
--
--- Test cases need to be reviewed for coverage. Testing procedures can probably be improved
--  (common code factored out (use a generic?)... more table driven relational tests, etc).

with Ada.Assertions;
with Ada.Strings.Bounded;
with Ada.Text_IO;
with Spica.Very_Longs;

use Ada.Assertions;
use Ada.Text_IO;
use Spica.Very_Longs;

procedure Test_Very_Longs is

   package Bounded_128 is new Ada.Strings.Bounded.Generic_Bounded_Length(128);
   use Bounded_128;

   --
   -- Helper subprograms
   --

   procedure Check_Bits(N : in Very_Long; Expected : in String) is
      Expected_Bit : Bit;
   begin
      Assert(Number_Of_Bits(N) = Expected'Length, "Bad length");
      for I in 0 .. Number_Of_Bits(N) - 1 loop
         if Expected(Expected'Last - Integer(I)) = '0' then
            Expected_Bit := 0;
         else
            Expected_Bit := 1;
         end if;
         Assert(Get_Bit(N, I) = Expected_Bit, "Bad bit");
      end loop;
   end Check_Bits;

   --
   -- Test procedures
   --

   procedure Test_Integer_Constructor is
      type Test_Case is
         record
            N        : Integer;
            Expected : Bounded_String;
         end record;

      subtype Test_Index is Integer range 1 .. 5;
      Test_Cases : array(Test_Index) of Test_Case :=
        (( N =>            1, Expected => To_Bounded_String("1")),
         ( N =>     16#FFFF#, Expected => To_Bounded_String("1111111111111111")),
         ( N =>    16#10000#, Expected => To_Bounded_String("10000000000000000")),
         ( N => 16#5A5A5A5A#, Expected => To_Bounded_String("1011010010110100101101001011010")),
         ( N => 16#7FFFFFFF#, Expected => To_Bounded_String("1111111111111111111111111111111")));

      Number : Very_Long;
   begin
      Number := Make(0);
      Assert(Number_Of_Bits(Number) = 0, "Value zero has incorrect bit count");
      for I in Test_Index loop
         Number := Make(Test_Cases(I).N);
         Check_Bits(Number, To_String(Test_Cases(I).Expected));
      end loop;
   end Test_Integer_Constructor;


   procedure Test_String_Constructor is
      type Test_Case is
         record
            N : Bounded_String;
            Expected : Bounded_String;
         end record;

      subtype Test_Index is Integer range 1 .. 4;
      Test_Cases : array(Test_Index) of Test_Case :=
        (( N        => To_Bounded_String("5"),
           Expected => To_Bounded_String("101")),
         ( N        => To_Bounded_String("4294967296"),
           Expected => To_Bounded_String("100000000000000000000000000000000")),
         ( N        => To_Bounded_String("18446744073709551615"),
           Expected => To_Bounded_String("1111111111111111111111111111111111111111111111111111111111111111")),
         ( N        => To_Bounded_String("18446744073709551616"),
           Expected => To_Bounded_String("10000000000000000000000000000000000000000000000000000000000000000")));

      Number : Very_Long;
   begin
      for I in Test_Index loop
         Number := Make(To_String(Test_Cases(I).N));
         Check_Bits(Number, To_String(Test_Cases(I).Expected));
      end loop;
   end Test_String_Constructor;


   procedure Test_Relationals is
      Number1, Number2 : Very_Long;
   begin
      -- Check numbers consisting of a single long digit.
      Number1 := Make(0);
      Number2 := Make(2);
      Assert(     Number1 <  Number2 , "Bad relational");
      Assert(not (Number1 =  Number2), "Bad relational");
      Assert(     Number1 <= Number2 , "Bad relational");
      Assert(not (Number1 >  Number2), "Bad relational");
      Assert(not (Number1 >= Number2), "Bad relational");

      Number1 := Make(1);
      Assert(     Number1 <  Number2 , "Bad relational");
      Assert(not (Number1 =  Number2), "Bad relational");
      Assert(     Number1 <= Number2 , "Bad relational");
      Assert(not (Number1 >  Number2), "Bad relational");
      Assert(not (Number1 >= Number2), "Bad relational");

      Number1 := Make(2);
      Assert(not (Number1 <  Number2), "Bad relational");
      Assert(     Number1 =  Number2 , "Bad relational");
      Assert(     Number1 <= Number2 , "Bad relational");
      Assert(not (Number1 >  Number2), "Bad relational");
      Assert(     Number1 >= Number2 , "Bad relational");

      Number1 := Make( 0);
      Number2 := Make(-2);
      Assert(not (Number1 <  Number2), "Bad relational");
      Assert(not (Number1 =  Number2), "Bad relational");
      Assert(not (Number1 <= Number2), "Bad relational");
      Assert(     Number1 >  Number2 , "Bad relational");
      Assert(     Number1 >= Number2 , "Bad relational");

      Number1 := Make(-1);
      Assert(not (Number1 <  Number2), "Bad relational");
      Assert(not (Number1 =  Number2), "Bad relational");
      Assert(not (Number1 <= Number2), "Bad relational");
      Assert(     Number1 >  Number2 , "Bad relational");
      Assert(     Number1 >= Number2 , "Bad relational");

      Number1 := Make(-2);
      Assert(not (Number1 <  Number2), "Bad relational");
      Assert(     Number1 =  Number2 , "Bad relational");
      Assert(     Number1 <= Number2 , "Bad relational");
      Assert(not (Number1 >  Number2), "Bad relational");
      Assert(     Number1 >= Number2 , "Bad relational");

      Number1 := Make(-1);
      Number2 := Make( 1);
      Assert(     Number1 <  Number2 , "Bad relational");
      Assert(not (Number1 =  Number2), "Bad relational");
      Assert(     Number1 <= Number2 , "Bad relational");
      Assert(not (Number1 >  Number2), "Bad relational");
      Assert(not (Number1 >= Number2), "Bad relational");

      -- Check numbers containing multiple long digits.
      Number1 := Make("1234567890987654321");
      Number2 := Make("1234567890987654321");
      Assert(not (Number1 <  Number2), "Bad relational");
      Assert(     Number1 =  Number2 , "Bad relational");
      Assert(     Number1 <= Number2 , "Bad relational");
      Assert(not (Number1 >  Number2), "Bad relational");
      Assert(     Number1 >= Number2 , "Bad relational");

      Number1 := Make("1234567890987654321");
      Number2 := Make("1234567890987654320");
      Assert(not (Number1 <  Number2), "Bad relational");
      Assert(not (Number1 =  Number2), "Bad relational");
      Assert(not (Number1 <= Number2), "Bad relational");
      Assert(     Number1 >  Number2 , "Bad relational");
      Assert(     Number1 >= Number2 , "Bad relational");

      Number1 := Make("1234567890987654320");
      Number2 := Make("1234567890987654321");
      Assert(     Number1 <  Number2 , "Bad relational");
      Assert(not (Number1 =  Number2), "Bad relational");
      Assert(     Number1 <= Number2 , "Bad relational");
      Assert(not (Number1 >  Number2), "Bad relational");
      Assert(not (Number1 >= Number2), "Bad relational");
   end Test_Relationals;


   procedure Test_Addition is
      type Test_Case is
         record
            X : Bounded_String;
            Y : Bounded_String;
            Z : Bounded_String;  -- Z = X + Y
         end record;

      subtype Test_Index is Integer range 1 .. 16;
      Test_Cases : array(Test_Index) of Test_Case :=
        ((X => To_Bounded_String( "0"), Y => To_Bounded_String( "1"), Z => To_Bounded_String( "1")),
         (X => To_Bounded_String( "1"), Y => To_Bounded_String( "0"), Z => To_Bounded_String( "1")),
         (X => To_Bounded_String( "1"), Y => To_Bounded_String("-1"), Z => To_Bounded_String( "0")),
         (X => To_Bounded_String( "1"), Y => To_Bounded_String( "2"), Z => To_Bounded_String( "3")),
         (X => To_Bounded_String( "1"), Y => To_Bounded_String("-2"), Z => To_Bounded_String("-1")),
         (X => To_Bounded_String("-2"), Y => To_Bounded_String( "1"), Z => To_Bounded_String("-1")),

         (X => To_Bounded_String("1234567890987654321"),
          Y => To_Bounded_String("0"),
          Z => To_Bounded_String("1234567890987654321")),

         (X => To_Bounded_String("1234567890987654321"),
          Y => To_Bounded_String("1234567890987654321"),
          Z => To_Bounded_String("2469135781975308642")),

         (X => To_Bounded_String("9999999999999999999"),
          Y => To_Bounded_String("1"),
          Z => To_Bounded_String("10000000000000000000")),

         (X => To_Bounded_String("1234567890987654321"),
          Y => To_Bounded_String("-1234567890987654321"),
          Z => To_Bounded_String("0")),

         (X => To_Bounded_String("1234567890987654321"),
          Y => To_Bounded_String("-1"),
          Z => To_Bounded_String("1234567890987654320")),

         (X => To_Bounded_String("-1"),
          Y => To_Bounded_String("1234567890987654321"),
          Z => To_Bounded_String("1234567890987654320")),

         (X => To_Bounded_String("-1234567890987654321"),
          Y => To_Bounded_String("-1"),
          Z => To_Bounded_String("-1234567890987654322")),

         (X => To_Bounded_String("65535"),
          Y => To_Bounded_String("1"),
          Z => To_Bounded_String("65536")),

         (X => To_Bounded_String("4294967295"),
          Y => To_Bounded_String("1"),
          Z => To_Bounded_String("4294967296")),

        (X => To_Bounded_String("-4294967296"),
          Y => To_Bounded_String("1"),
          Z => To_Bounded_String("-4294967295")));

      X, Y, Sum : Very_Long;
      Expected  : Very_Long;
   begin
      for I in Test_Index loop
         X := Make(To_String(Test_Cases(I).X));
         Y := Make(To_String(Test_Cases(I).Y));
         Expected := Make(To_String(Test_Cases(I).Z));
         Sum := X + Y;
         Assert(Sum = Expected, "Bad addition");
      end loop;
  end Test_Addition;


   procedure Test_Subtraction is
      type Test_Case is
         record
            X : Bounded_String;
            Y : Bounded_String;
            Z : Bounded_String;  -- Z = X - Y
         end record;

      subtype Test_Index is Integer range 1 .. 20;
      Test_Cases : array(Test_Index) of Test_Case :=
        ((X => To_Bounded_String( "3"), Y => To_Bounded_String( "0"), Z => To_Bounded_String( "3")),
         (X => To_Bounded_String( "0"), Y => To_Bounded_String( "3"), Z => To_Bounded_String("-3")),
         (X => To_Bounded_String( "3"), Y => To_Bounded_String( "3"), Z => To_Bounded_String( "0")),
         (X => To_Bounded_String( "3"), Y => To_Bounded_String("-3"), Z => To_Bounded_String( "6")),
         (X => To_Bounded_String("-3"), Y => To_Bounded_String( "3"), Z => To_Bounded_String("-6")),
         (X => To_Bounded_String("-3"), Y => To_Bounded_String("-3"), Z => To_Bounded_String( "0")),
         (X => To_Bounded_String( "3"), Y => To_Bounded_String( "1"), Z => To_Bounded_String( "2")),
         (X => To_Bounded_String( "1"), Y => To_Bounded_String( "3"), Z => To_Bounded_String("-2")),
         (X => To_Bounded_String("-3"), Y => To_Bounded_String("-1"), Z => To_Bounded_String("-2")),
         (X => To_Bounded_String("-1"), Y => To_Bounded_String("-3"), Z => To_Bounded_String( "2")),

         (X => To_Bounded_String("1234567890987654321"),
          Y => To_Bounded_String("0"),
          Z => To_Bounded_String("1234567890987654321")),

         (X => To_Bounded_String("1234567890987654321"),
          Y => To_Bounded_String("1234567890987654321"),
          Z => To_Bounded_String("0")),

         (X => To_Bounded_String("5678909876543211234"),
          Y => To_Bounded_String("1234567890987654321"),
          Z => To_Bounded_String("4444341985555556913")),

         (X => To_Bounded_String("10000000000000000000"),
          Y => To_Bounded_String("1"),
          Z => To_Bounded_String("9999999999999999999")),

         (X => To_Bounded_String("1234567890987654321"),
          Y => To_Bounded_String("-1234567890987654321"),
          Z => To_Bounded_String("2469135781975308642")),

         (X => To_Bounded_String("1234567890987654321"),
          Y => To_Bounded_String("-1"),
          Z => To_Bounded_String("1234567890987654322")),

         (X => To_Bounded_String("-1"),
          Y => To_Bounded_String("1234567890987654321"),
          Z => To_Bounded_String("-1234567890987654322")),

         (X => To_Bounded_String("-1234567890987654321"),
          Y => To_Bounded_String("-1"),
          Z => To_Bounded_String("-1234567890987654320")),

         (X => To_Bounded_String("4294967296"),
          Y => To_Bounded_String("1"),
          Z => To_Bounded_String("4294967295")),

         (X => To_Bounded_String("-4294967296"),
          Y => To_Bounded_String("-1"),
          Z => To_Bounded_String("-4294967295")));

      X, Y, Difference : Very_Long;
      Expected         : Very_Long;
   begin
      for I in Test_Index loop
         X := Make(To_String(Test_Cases(I).X));
         Y := Make(To_String(Test_Cases(I).Y));
         Expected := Make(To_String(Test_Cases(I).Z));
         Difference := X - Y;
         Assert(Difference = Expected, "Bad subtraction");
      end loop;
   end Test_Subtraction;


   procedure Test_Multiplication is
      type Test_Case is
         record
            X : Bounded_String;
            Y : Bounded_String;
            Z : Bounded_String;  -- Z = X * Y
         end record;

      subtype Test_Index is Integer range 1 .. 8;
      Test_Cases : array(Test_Index) of Test_Case :=
        ((X => To_Bounded_String(" 0"), Y => To_Bounded_String(" 0"), Z => To_Bounded_String(" 0")),
         (X => To_Bounded_String(" 1"), Y => To_Bounded_String(" 1"), Z => To_Bounded_String(" 1")),
         (X => To_Bounded_String(" 1"), Y => To_Bounded_String(" 2"), Z => To_Bounded_String(" 2")),
         (X => To_Bounded_String(" 2"), Y => To_Bounded_String(" 1"), Z => To_Bounded_String(" 2")),
         (X => To_Bounded_String(" 1"), Y => To_Bounded_String("-1"), Z => To_Bounded_String("-1")),
         (X => To_Bounded_String("-1"), Y => To_Bounded_String(" 1"), Z => To_Bounded_String("-1")),
         (X => To_Bounded_String("-1"), Y => To_Bounded_String("-1"), Z => To_Bounded_String(" 1")),

         (X => To_Bounded_String("1234567890987654321"),
          Y => To_Bounded_String("5678909876543211234"),
          Z => To_Bounded_String("7010999789392912665121155378475842114")));

      X, Y, Product : Very_Long;
      Expected      : Very_Long;
   begin
      for I in Test_Index loop
         X := Make(To_String(Test_Cases(I).X));
         Y := Make(To_String(Test_Cases(I).Y));
         Expected := Make(To_String(Test_Cases(I).Z));
         Product := X * Y;
         Assert(Product = Expected, "Bad multiplication");
      end loop;
   end Test_Multiplication;


   procedure Test_Bits is
      Number : Very_Long;
   begin
      Number := Make(0);
      Assert(Number_Of_Bits(Number) = 0, "Value zero has incorrect bit count");

      -- Try setting the least significant bit.
      Put_Bit(Number, 0, 1);
      Assert(Number_Of_Bits(Number) = 1, "Single bit Very_Long has wrong bit count");
      Assert(Get_Bit(Number, 0) = 1, "Unexpected bit 0 in Very_Long");

      -- Create a number with two long digits.
      Put_Bit(Number, 32, 1);
      Assert(Number_Of_Bits(Number) = 33, "Extended Very_Long has wrong bit count");
      Assert(Get_Bit(Number, 32) = 1, "Unexpected bit 32 in Very_Long");

      -- Create a 65 bit number (three long digits; one bit more than Long_Digit can hold.
      Put_Bit(Number, 64, 1);
      Assert(Number_Of_Bits(Number) = 65, "Extended Very_Long has wrong bit count");
      Assert(Get_Bit(Number, 64) = 1, "Unexpected bit 64 in Very_Long");

      -- Verify that I can get bits that are off the end of the number.
      Assert(Get_Bit(Number, 65) = 0, "Uninitialized bit is 1");

      -- Erase bits one at a time and verify.
      Put_Bit(Number, 64, 0);
      Assert(Number_Of_Bits(Number) = 33, "No contraction after bit erasure");
      Put_Bit(Number, 32, 0);
      Assert(Number_Of_Bits(Number) =  1, "No contraction after bit erasure");
      Put_Bit(Number, 0, 0);
      Assert(Number_Of_Bits(Number) =  0, "No contraction after bit erasure");
   end Test_Bits;

begin
   Put("Very_Longs: Integer constructor... ");
   Test_Integer_Constructor;
   Put_Line("ok");

   Put("Very_Longs: String constructor... ");
   Test_String_Constructor;
   Put_Line("ok");

   Put("Very_Longs: Relational operators... ");
   Test_Relationals;
   Put_Line("ok");

   Put("Very_Longs: Addition... ");
   Test_Addition;
   Put_Line("ok");

   Put("Very_Longs: Subtraction... ");
   Test_Subtraction;
   Put_Line("ok");

   Put("Very_Longs: Multiplication... ");
   Test_Multiplication;
   Put_Line("ok");

   Put("Very_Longs: Bit access... ");
   Test_Bits;
   Put_Line("ok");
end Test_Very_Longs;
