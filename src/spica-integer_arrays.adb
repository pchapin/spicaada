
package body Spica.Integer_Arrays is

   function Find_Maximum_Subarray(A : Array_Type) return Subarray_Summary is

      function Find_Maximum_Crossing_Subarray
        (A : Array_Type; Low, Mid, High : Positive) return Subarray_Summary
      is
         Left_Sum  : Element_Type := Element_Type'First;
         Right_Sum : Element_Type := Element_Type'First;
         Sum : Element_Type;
         Maximum_Left  : Positive;
         Maximum_Right : Positive;
      begin
         Sum := 0;
         for I in reverse Low .. Mid loop
            Sum := Sum + A(I);
            if Sum > Left_Sum then
               Left_Sum := Sum;
               Maximum_Left := I;
            end if;
         end loop;

         Sum := 0;
         for J in Mid + 1 .. High loop
            Sum := Sum + A(J);
            if Sum > Right_Sum then
               Right_Sum := Sum;
               Maximum_Right := J;
            end if;
         end loop;

         return (Maximum_Left, Maximum_Right, Left_Sum + Right_Sum);
      end Find_Maximum_Crossing_Subarray;


      function Find_Maximum_Subarray
        (A : Array_Type; Low, High : Positive) return Subarray_Summary
        with Pre => Low <= High
      is
         Mid       : Positive;
         Subresult_Left  : Subarray_Summary;
         Subresult_Right : Subarray_Summary;
         Subresult_Cross : Subarray_Summary;
      begin
         if Low = High then
            return (Low, High, A(Low));
         else
            Mid := (Low + High)/2;
            Subresult_Left  := Find_Maximum_Subarray(A, Low, Mid);
            Subresult_Right := Find_Maximum_Subarray(A, Mid + 1, High);
            Subresult_Cross := Find_Maximum_Crossing_Subarray(A, Low, Mid, High);
            if Subresult_Left.Sum >= Subresult_Right.Sum and
               Subresult_Left.Sum >= Subresult_Cross.Sum
            then
               return Subresult_Left;
            elsif Subresult_Right.Sum >= Subresult_Left.Sum and
                  Subresult_Right.Sum >= Subresult_Cross.Sum
            then
               return Subresult_Right;
            else
               return Subresult_Cross;
            end if;
         end if;
      end Find_Maximum_Subarray;

   begin
      return Find_Maximum_Subarray(A, A'First, A'Last);
   end Find_Maximum_Subarray;

end Spica.Integer_Arrays;
