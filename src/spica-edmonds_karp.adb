
package body Spica.Edmonds_Karp is
   use Edge_Lists;
   use Vertex_Vectors;

   procedure Add_Edge(G : in out Graph; Edge : in Edge_Information) is
      Found    : Boolean := False;

      procedure Add_Vertex(G : in out Graph; N : in Vertex_Number_Type) is
      begin
         -- If this vertex is new...
         if Vertex_Number_Type(G.Vertexes.Length) < N then
            G.Vertexes.Append(New_Item => Empty_List, Count => N - G.Vertexes.Length);
         end if;
      end Add_Vertex;

   begin
      Add_Vertex(G, Edge.From);
      Add_Vertex(G, Edge.To);
      for Current_Edge of G.Vertexes(Edge.From) loop
         if Current_Edge.To = Edge.To then
            Current_Edge.Capacity := Edge.Capacity;
            Current_Edge.Flow := Edge.Flow;
            Found := True;
         end if;
      end loop;

      if not Found then
         G.Vertexes(Edge.From).Append(New_Item => Edge);
      end if;
   end Add_Edge;


   -- Looks up the specified edge and returns it. If the edge does not exist the returned flow
   -- and capacity are both zero. There shouldn't be any edges in G with zero capacity.
   function Get_Edge(G : Graph; From, To : Vertex_Number_Type) return Edge_Information is
      Result : Edge_Information := (From => From, To => To, Capacity => 0.0, Flow => 0.0);
   begin
      -- FINISH ME!
      return Result;
   end Get_Edge;


   -- Make the residual graph of G.
   procedure Make_Residual(G : in Graph; Residual : out Graph) is
   begin
      Residual.Vertexes.Clear;

      -- Consider every edge in the graph G.
      for Adjacency_List of G.Vertexes loop
         for Current_Edge of Adjacency_List loop

            -- If there is residual forward capacity, add an edge in the residual graph.
            if Current_Edge.Capacity > Current_Edge.Flow then
               Add_Edge(Residual, (From     => Current_Edge.From,
                                   To       => Current_Edge.To,
                                   Capacity => Current_Edge.Capacity - Current_Edge.Flow,
                                   Flow     => 0.0));
            end if;

            -- If there is forward flow, add a reverse edge in the residual graph.
            if Current_Edge.Flow > 0.0 then
               Add_Edge(Residual, (From     => Current_Edge.To,
                                   To       => Current_Edge.From,
                                   Capacity => Current_Edge.Flow,
                                   Flow     => 0.0));
            end if;
         end loop;
      end loop;
   end Make_Residual;


   -----------------------
   -- Breadth First Search
   -----------------------

   type Predecessor_Array_Type is
     array(Vertex_Number_Type range <>) of Extended_Vertex_Number_Type;

   function BFS(Residual : Graph) return Predecessor_Array_Type is
      Predecessors : Predecessor_Array_Type(1 .. Residual.Vertexes.Length) :=
        (others => No_Vertex);
   begin
      -- FINISH ME!
      -- Hint: Use an appropriate instantiation of Doubly_Linked_List for the required Queue.
      return Predecessors;
   end BFS;


   ---------------
   -- Edmonds Karp
   ---------------

   function Maximum_Flow
     (G : in out Graph; Source, Sink : in Vertex_Number_Type) return Flow_Type
   is
      Flow     : Flow_Type := 0.0;
      Residual : Graph;
   begin
      loop
         Make_Residual(G, Residual);
         declare
            Predecessors : Predecessor_Array_Type := BFS(Residual);
         begin
            exit when Predecessors(Sink) = No_Vertex;

            -- FINISH ME!
            null;
         end;
      end loop;
      return Flow;
   end Maximum_Flow;

end Spica.Edmonds_Karp;
