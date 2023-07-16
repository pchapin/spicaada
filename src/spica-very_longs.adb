with Ada.Containers; use Ada.Containers;

package body Spica.Very_Longs is

   Digit_Bits : constant := Long_Digit'Size / 2;
   Digit_Mask : constant := 2**Digit_Bits - 1;

   --
   -- Helper functions/procedures
   --

   procedure Trim_Zeros(Number : in out Very_Long) is
      Leading_Zeros : Count_Type;
      Digit_Count   : constant Count_Type := Length(Number.Long_Digits);
   begin
      -- If there are no digits, I am done. Be sure zero is positive.
      if Is_Empty(Number.Long_Digits) then
         Number.Sign_Flag := Plus;
         return;
      end if;

      -- Count the number of leading zeros.
      Leading_Zeros := 0;
      for I in reverse 0..(Digit_Count - 1) loop
         exit when Element(Number.Long_Digits, I) /= 0;
         Leading_Zeros := Leading_Zeros + 1;
      end loop;

      -- Resize the array of long digits.
      Set_Length(Number.Long_Digits, Digit_Count - Leading_Zeros);

      -- If this number is now zero, be sure that it is positive zero.
      if Is_Empty(Number.Long_Digits) then
         Number.Sign_Flag := Plus;
      end if;
   end Trim_Zeros;


   -- Compares absolute values.
   function "<"(L, R : Vector) return Boolean is
      Index    : Count_Type;
      L_Length : Count_Type := Length(L);
      R_Length : Count_Type := Length(R);
   begin
      -- Check the number of digits first.
      if R_Length > L_Length then return True; end if;
      if R_Length < L_Length then return False; end if;

      -- Both numbers have the same number of digits.
      if L_Length = 0 then return False; end if;

      Index := L_Length;
      for Loop_Counter in 0..(L_Length - 1) loop
         Index := Index - 1;
         if Element(R, Index) > Element(L, Index) then
            return True;
         end if;
         if Element(R, Index) < Element(L, Index) then
            return False;
         end if;
      end loop;

      -- They are equal.
      return False;
   end "<";


   --
   -- Constructors
   --

   function Make(Number : in Integer) return Very_Long is
      Result : Very_Long;
      Temp   : Integer := Number;
   begin
      -- Be sure current collection of long digits is empty.
      Clear(Result.Long_Digits);

      -- Set up sign flag and "normalize" incoming value to a non-negative.
      Result.Sign_Flag := Plus;
      if Temp < 0 then
         Result.Sign_Flag := Minus;
         Temp := -Temp;
      end if;

      -- This assumes that Integer is 32 bits (or less). This should be
      -- handled differently at some point. Ideally this code should deal
      -- gracefully with implementations that have a large Integer type by
      -- default.
      --
      if Temp > 0 then
         Append(Result.Long_Digits, Long_Digit(Temp));
      end if;
      return Result;
   end Make;


   function Make(Number : in String) return Very_Long is
      type State is (Optional_Space1, Optional_Space2, In_Number, Trailing_Underscore);
      Current_State : State := Optional_Space1;
      Ch            : Character;
      Digit_Value   : array(Character range '0' .. '9') of Integer :=
        (0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
      Desired_Sign  : Sign_Type := Plus;
      Result        : Very_Long;

      function Is_Digit(Ch : Character) return Boolean is
      begin
         case Ch is
            when '0' .. '9' => return True;
            when others     => return False;
         end case;
      end Is_Digit;

   begin
      Result := Make(0);
      for I in Number'Range loop
         Ch := Number(I);

         case Current_State is
            when Optional_Space1 =>
               if Ch = ' ' then
                  Current_State := Optional_Space1;
               elsif Ch = '+' then
                  Desired_Sign := Plus;
                  Current_State := Optional_Space2;
               elsif Ch = '-' then
                  Desired_Sign := Minus;
                  Current_State := Optional_Space2;
               elsif Is_Digit(Ch) then
                  Result := Make(10) * Result + Make(Digit_Value(Ch));
                  Current_State := In_Number;
               else
                  raise Invalid_Number;
               end if;

            when Optional_Space2 =>
               if Ch = ' ' then
                  Current_State := Optional_Space2;
               elsif Is_Digit(Ch) then
                  Result := Make(10) * Result + Make(Digit_Value(Ch));
                  Current_State := In_Number;
               else
                  raise Invalid_Number;
               end if;

            when In_Number =>
               if Ch = '_' then
                  Current_State := Trailing_Underscore;
               elsif Is_Digit(Ch) then
                  Result := Make(10) * Result + Make(Digit_Value(Ch));
                  Current_State := In_Number;
               else
                  raise Invalid_Number;
               end if;

            when Trailing_Underscore =>
               if Is_Digit(Ch) then
                  Result := Make(10) * Result + Make(Digit_Value(Ch));
                  Current_State := In_Number;
               else
                  raise Invalid_Number;
               end if;

         end case;
      end loop;

      -- Take care of some final details at the end.
      if Current_State /= In_Number then
         raise Invalid_Number;
      end if;
      Result.Sign_Flag := Desired_Sign;
      return Result;
   end Make;


   --
   -- Arithmetic Operators
   --

   -- Because of the possibility of negative arguments, "+" does the work of "-" as well.
   function "+"(L, R : Very_Long) return Very_Long is
      Value   : Vector;
      Result  : Very_Long;
      Carry   : Long_Digit := 0;
      L_Digit : Long_Digit;
      R_Digit : Long_Digit;
      Sum     : Long_Digit;

      procedure Subtract(Value : in out Vector; Large, Small : in Vector) is
         Borrow     : Long_Digit := 0;
         L_Digit    : Long_Digit;
         S_Digit    : Long_Digit;
         Difference : Long_Digit;
      begin
         -- Assume Value is empty.
         for I in 0 .. Length(Large) - 1 loop
            L_Digit := Element(Large, I);
            S_Digit := 0;
            if I < Length(Small) then
               S_Digit := Element(Small, I);
            end if;
            if L_Digit >= S_Digit + Borrow then
               Difference := L_Digit - S_Digit - Borrow;
               Borrow     := 0;
            else
               Difference := L_Digit + Shift_Left(1, Digit_Bits) - S_Digit - Borrow;
               Borrow     := 1;
            end if;
            Append(Value, Difference);
         end loop;
      end Subtract;

   begin -- "+"
      if (L.Sign_Flag = Plus  and R.Sign_Flag = Minus) or
         (L.Sign_Flag = Minus and R.Sign_Flag = Plus ) then

         -- L and R have different signs.
         if L.Long_Digits < R.Long_Digits then
            Result.Sign_Flag := R.Sign_Flag;
            Subtract(Value, R.Long_Digits, L.Long_Digits);
         else
            Result.Sign_Flag := L.Sign_Flag;
            Subtract(Value, L.Long_Digits, R.Long_Digits);
         end if;
         Move(Target => Result.Long_Digits, Source => Value);
         Trim_Zeros(Result);

      else
         -- L and R have the same sign.
         Result.Sign_Flag := L.Sign_Flag;
         for I in 0 .. Count_Type'Max(Length(L.Long_Digits), Length(R.Long_Digits)) - 1 loop
            L_Digit := 0;
            R_Digit := 0;
            if I < Length(L.Long_Digits) then
               L_Digit := Element(L.Long_Digits, I);
            end if;
            if I < Length(R.Long_Digits) then
               R_Digit := Element(R.Long_Digits, I);
            end if;
            Sum   := L_Digit + R_Digit + Carry;
            Carry := Shift_Right(Sum, Digit_Bits);
            Sum   := Sum and Digit_Mask;
            Append(Value, Sum);
         end loop;
         if Carry > 0 then
            Append(Value, Carry);
         end if;
         Move(Target => Result.Long_Digits, Source => Value);
      end if;

      return Result;
   end "+";


   -- Quite trivial because all the real work is in "+"
   function "-"(L, R : Very_Long) return Very_Long is
      Result : Very_Long;
   begin
      Result := L + (-R);
      return Result;
   end "-";


   function "-"(N : Very_Long) return Very_Long is
      Result : Very_Long;
   begin
      if N.Sign_Flag = Plus and Length(N.Long_Digits) /= 0 then
         Result.Sign_Flag := Minus;
      else
         Result.Sign_Flag := Plus;
      end if;
      Result.Long_Digits := N.Long_Digits;
      return Result;
   end "-";


   -- This code follows the "classical algorithm" for multiplication as described in Knuth's
   -- "The Art of Computer Programming, Volume 2: Seminumerical Algorithms" (third edition,
   -- published by Addison-Wesley, copyright 1998, page 268-270).
   --
   function "*"(L, R : Very_Long) return Very_Long is
      Result : Very_Long;
      Carry  : Long_Digit;
      Temp   : Long_Digit;
   begin
      -- Handle zero as a special case.
      if Is_Empty(L.Long_Digits) or Is_Empty(R.Long_Digits) then
         Clear(Result.Long_Digits);
         Result.Sign_Flag := Plus;
         return Result;
      end if;

      -- Compute the result's sign.
      if (L.Sign_Flag = Plus  and R.Sign_Flag = Plus ) or
         (L.Sign_Flag = Minus and R.Sign_Flag = Minus) then
         Result.Sign_Flag := Plus;
      else
         Result.Sign_Flag := Minus;
      end if;

      -- Prepare Result's digit array.
      Set_Length(Result.Long_Digits, Length(L.Long_Digits) + Length(R.Long_Digits));
      for I in First_Index(Result.Long_Digits) .. Last_Index(Result.Long_Digits) loop
         Replace_Element(Result.Long_Digits, I, 0);
      end loop;

      -- Do the multiplication.
      for J in First_Index(R.Long_Digits) .. Last_Index(R.Long_Digits) loop
         Carry := 0;
         for I in First_Index(L.Long_Digits) .. Last_Index(L.Long_Digits) loop
            Temp := ( Element(L.Long_Digits, I) * Element(R.Long_Digits, J) ) +
              Element(Result.Long_Digits, I + J) + Carry;
            Replace_Element(Result.Long_Digits, I + J, Temp and Digit_Mask);
            Carry := Shift_Right(Temp, Digit_Bits);
         end loop;
         Replace_Element(Result.Long_Digits, Length(L.Long_Digits) + J, Carry);
      end loop;

      Trim_Zeros(Result);
      return Result;
   end "*";


   function "/"(L, R : Very_Long) return Very_Long is
      Result: Very_Long;
   begin
      raise Program_Error with "Not Implemented: ""/""";
      return Result;
   end "/";


   function "mod"(L, R : Very_Long) return Very_Long is
      Result : Very_Long;
   begin
      raise Program_Error with "Not Implemented mod";
      return Result;
   end "mod";


   --
   -- Relational Operators
   --

   function "<"(L, R : Very_Long) return Boolean is
   begin
      -- Deal with sign flag issues first.
      if L.Sign_Flag = Minus and R.Sign_Flag = Plus  then return True;  end if;
      if L.Sign_Flag = Plus  and R.Sign_Flag = Minus then return False; end if;

      -- The sign flags are the same.
      if L.Sign_Flag = Minus then
         if R.Long_Digits < L.Long_Digits then return True; end if;
      else
         if L.Long_Digits < R.Long_Digits then return True; end if;
      end if;
      return False;
   end "<";


   function "<="(L, R : Very_Long) return Boolean is
   begin
      return (L < R) or (L = R);
   end "<=";


   function ">"(L, R : Very_Long) return Boolean is
   begin
      return not (L <= R);
   end ">";


   function ">="(L, R : Very_Long) return Boolean is
   begin
      return not (L < R);
   end ">=";

   --
   -- Bit Access
   --

   function Number_Of_Bits(Number : in Very_Long) return Bit_Index is
      Count       : Bit_Index;
      Last_Digit  : Long_Digit;
      Digit_Count : Count_Type := Length(Number.Long_Digits);
   begin
      -- Handle zero as a special case.
      if Is_Empty(Number.Long_Digits) then return 0; end if;

      -- Compute the number of bits in all long digits but the last.
      Count := Bit_Index(Digit_Bits * (Digit_Count - 1));

      -- Ignore leading zero bits in the last long digit.
      Last_Digit := Element(Number.Long_Digits, Digit_Count - 1);
      while Last_Digit /= 0 loop
         Last_Digit := Shift_Right(Last_Digit, 1);
         Count := Count + 1;
      end loop;

      return Count;
   end Number_Of_Bits;


   function Get_Bit(Number     : in Very_Long;
                    Bit_Number : in Bit_Index) return Bit is
      Digit_Number : Count_Type := Count_Type(Bit_Number / Digit_Bits);
      Bit_Position : Natural := Natural(Bit_Number mod Digit_Bits);
      Digit        : Long_Digit;
      Mask         : Long_Digit := Shift_Left(1, Bit_Position);
   begin
      if Digit_Number >= Length(Number.Long_Digits) then
         return 0;
      end if;

      Digit := Element(Number.Long_Digits, Digit_Number);
      if (Digit and Mask) /= 0 then
         return 1;
      end if;
      return 0;
   end Get_Bit;


   procedure Put_Bit(Number     : in out Very_Long;
                     Bit_Number : in Bit_Index;
                     Bit_Value  : in Bit) is
      Digit_Number : Count_Type := Count_Type(Bit_Number / Digit_Bits);
      Bit_Position : Natural := Natural(Bit_Number mod Digit_Bits);
      Digit        : Long_Digit;
   begin
      -- If the number isn't big enough, extend it.
      while Digit_Number >= Length(Number.Long_Digits) loop
         Append(Number.Long_Digits, 0);
      end loop;

      -- Now perform the necessary manipulations.
      Digit := Element(Number.Long_Digits, Digit_Number);
      if Bit_Value = 1 then
         Digit := Digit or Shift_Left(1, Bit_Position);
      else
         Digit := Digit and not Shift_Left(1, Bit_Position);
      end if;
      Replace_Element(Number.Long_Digits, Digit_Number, Digit);
      Trim_Zeros(Number);
   end Put_Bit;


end Spica.Very_Longs;
