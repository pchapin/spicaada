
package body Fibonacci is

   function Fib_Recursive(N : Nat) return Nat is
      Result : Nat;
   begin
      case N is
         when 0 | 1 =>
            Result := N;
         when others =>
            Result := Fib_Recursive(N - 1) + Fib_Recursive(N - 2);
      end case;
      return Result;
   end Fib_Recursive;


   function Fib_Memoized_Recursive(N : Nat) return Nat is
      Table : array(2 .. N) of Nat := (others => 0);

      function Fib_Memoized_Helper(I : Nat) return Nat is
         Result : Nat;
      begin
         -- If the answer has been previously computed, just return it.
         if Table(I) > 0 then
            Result := Table(I);
         else
            case I is
               when 0 | 1 =>
                  Result := I;
               when others =>
                  Result := Fib_Memoized_Helper(I - 1) + Fib_Memoized_Helper(I - 2);
                  Table(I) := Result;  -- Save this result for later use.
            end case;
         end if;
         return Result;
      end Fib_Memoized_Helper;

   begin
      return Fib_Memoized_Helper(N);
   end Fib_Memoized_Recursive;


   function Fib_Bottom_Up(N : Nat) return Nat is
      Table  : array(0 .. N) of Nat := (0 => 0, 1 => 1, others => 0);
   begin
      case N is
         when 0 | 1 =>
            null;
         when others =>
            for I in 2 .. N loop

               -- Compute and record subproblem solutions from the smallest size toward the
               -- desired size. This computation makes use of previously computed results
               -- that are stored in the table.
               Table(I) := Table(I - 1) + Table(I - 2);
            end loop;
      end case;
      return Table(N);
   end Fib_Bottom_Up;


end Fibonacci;
