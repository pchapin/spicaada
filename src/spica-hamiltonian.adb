
package body Spica.Hamiltonian is

   -- Returns True iff To can be reached from From by crossing a single edge.
   function Is_Immediately_Reachable(G : Graph; From, To : Vertex_Number_Type) return Boolean is
      Successors : Vertex_List := Get_Successor_List(G, From);
   begin
      return (for some V of Successors => V = To);
   end Is_Immediately_Reachable;


   function Is_Hamiltonian_Path(G : Graph; P : Vertex_List) return Boolean is
   begin
      if P'Length /= Size(G) then
         return False;
      end if;

      return (for all I in P'Range => not (for some J in I + 1 .. P'Last => P(I) = P(J))) and then
                (for all I in P'First .. P'Last - 1 => Is_Immediately_Reachable(G, P(I), P(I + 1)));
   end Is_Hamiltonian_Path;


   function Is_Hamiltonian_Cycle(G : Graph; P : Vertex_List) return Boolean is
   begin
      return Is_Immediately_Reachable(G, From => P(P'Last), To => P(P'First)) and then
               Is_Hamiltonian_Path(G, P);
   end Is_Hamiltonian_Cycle;


   function Hamiltonian_Path(G : Graph) return Vertex_List is
      Path : Vertex_List(1 .. Size(G));
   begin
      -- Start with a path in vertex number order.
      for I in 1 .. Size(G) loop
         Path(I) := I;
      end loop;

      while not Is_Hamiltonian_Path(G, Path) loop
         -- Compute the next permutation. If no more permutations exist, raise Not_Found.
         -- See: https://en.wikipedia.org/wiki/Permutation, section: "Generation in lexicographic order."
         -- Note that there are n! permutations to consider (where n = Size(G)).
         null;
      end loop;
      return Path;
   end Hamiltonian_Path;

end Spica.Hamiltonian;
