
package body Spica.Sorters is


   -- This follows the pseudo-code on page 18 of CLRS.
   procedure Insertion_Sort(A : in out Array_Type) is
      I   : Natural;
      Key : Element_Type;
   begin
      for J in 2 .. A'Length loop
         pragma Loop_Invariant
           (for all K in 1 .. J - 2 => (A(K) < A(K + 1) or A(K) = A(K + 1)));

         Key := A(J);
         I := J - 1;
         while I > 0 and then Key < A(I) loop
            A(I + 1) := A(I);
            I := I - 1;
         end loop;
         A(I + 1) := Key;
      end loop;
   end Insertion_Sort;


   -- This follows the pseudo-code on page 31 of CLRS.
   procedure Merge_Sort(A : in out Array_Type; P, R : Positive) is

      procedure Merge(A : in out Array_Type; P, Q, R : Positive)
        with Pre => A'First = 1 and P <= Q and Q < R
      is
         N1 : constant Positive := Q - P + 1;
         N2 : constant Positive := R - Q;
         Left   : Array_Type(1 .. N1 + 1);
         Right  : Array_Type(1 .. N2 + 1);
         I, J : Positive;
      begin
         Left(1 .. N1) := A(P .. Q);
         Right(1 .. N2) := A(Q + 1 .. R);
         Left(N1 + 1) := Infinity;
         Right(N2 + 1) := Infinity;

         I := 1;
         J := 1;
         for K in P .. R loop
            if Left(I) < Right(J) then  -- What is the effect of using < here instead of <= ?
               A(K) := Left(I);
               I := I + 1;
            else
               A(K) := Right(J);
               J := J + 1;
            end if;
         end loop;
      end Merge;

      Q : Positive;
   begin
      if P < R then
         Q := (P + R)/2;
         Merge_Sort(A, P, Q);
         Merge_Sort(A, Q + 1, R);
         Merge(A, P, Q, R);
      end if;
   end Merge_Sort;

end Spica.Sorters;
