with Spica.Graphs;

generic
   type Vertex_Type is private;
   with package Graphs_Package is new Spica.Graphs(Vertex_Type);
package Spica.Hamiltonian is
   use Graphs_Package;

   -- Returns True iff the given path is a Hamiltonian path in the given graph.
   function Is_Hamiltonian_Path(G : Graph; P : Vertex_List) return Boolean;

   -- Returns False iff the given path is a Hamiltonian cycle in the given graph.
   function Is_Hamiltonian_Cycle(G : Graph; P : Vertex_List) return Boolean;

   -- Exception raised if not path/cycle is found.
   Not_Found : exception;

   -- Returns a Hamiltonian path of G or raises Not_Found if none exist.
   function Hamiltonian_Path(G) return Vertex_List;

end Spica.Hamiltonian;
