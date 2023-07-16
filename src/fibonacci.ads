
package Fibonacci is

   -- I'm defining a specific data type here in anticipation of one day using an extended
   -- precision integer type (the new Ada standard will include one).
   type Nat is range 0 .. 2**63 - 1;

   -- The straightfoward implementation using recursion. This follows the mathematical
   -- definition but is very slow to execute because of the way it repeatedly solves the
   -- same subproblems.
   function Fib_Recursive(N : Nat) return Nat;

   -- A memoized version of the function above that stores subproblem solutions in a table.
   -- This is, essentially, an example of "top down" dynamic programming.
   function Fib_Memoized_Recursive(N : Nat) return Nat;

   -- This version illustrates "bottom up" dynamic programming. Notice this version is not
   -- recursive since interatively building the final solution from the bottom is natural.
   function Fib_Bottom_Up(N : Nat) return Nat;

end Fibonacci;
