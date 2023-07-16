

-- This function returns the length of the longest common subsequence of two strings. Note that
-- it currently makes no attempt to return the actual subsequence.
--
function Spica.Longest_Common_Subsequence(X, Y : String) return Natural is
   C : array(0 .. X'Length, 0 .. Y'Length) of Natural;
begin
   for I in C'Range(1) loop
      C(I, 0) := 0;
   end loop;
   for J in C'Range(2) loop
      C(0, J) := 0;
   end loop;

   for I in 1 .. C'Last(1) loop
      for J in 1 .. C'Last(2) loop
         if X(X'First + (I - 1)) = Y(Y'First + (J - 1)) then
            C(I, J) := C(I - 1, J - 1) + 1;
         elsif C(I - 1, J) >= C(I, J - 1) then
            C(I, J) := C(I - 1, J);
         else
            C(I, J) := C(I, J - 1);
         end if;
      end loop;
   end loop;
   return C(X'Length, Y'Length);
end Spica.Longest_Common_Subsequence;
