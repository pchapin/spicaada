
with Ada.Containers.Doubly_Linked_Lists;

package body Spica.Graph_Algorithms is
   use type Ada.Containers.Count_Type;

   function Breadth_First_Search
     (G : Graph; Start_Vertex : Vertex_Number_Type) return BFS_Vertex_Tree
   is
      -- We need a queue of vertex numbers...
      package Vertex_Number_Lists is
        new Ada.Containers.Doubly_Linked_Lists(Element_Type => Vertex_Number_Type);

      Q : Vertex_Number_Lists.List;  -- Initialized to empty.
      U : Vertex_Number_Type;

      -- Vertexes get colored. We need to track that.
      type Color_Type is (White, Gray, Black);
      Vertex_Colors : array(1 .. Size(G)) of Color_Type;

      -- The result we want to return: distance and predecessors of every vertex.
      Result : BFS_Vertex_Tree(1 .. Size(G));
   begin
      -- Initialize...
      Vertex_Colors := (others => White);
      for V of Result loop
         V := (Distance => Natural'Last, Predecessor => 0);
      end loop;
      Vertex_Colors(Start_Vertex) := Gray;
      Result(Start_Vertex) := (Distance => 0, Predecessor => 0);

      Q.Append(Start_Vertex);
      while Q.Length /= 0 loop
         U := Q.First_Element;
         Q.Delete_First;

         for V of Get_Successor_List(G, U) loop
            if Vertex_Colors(V) = White then
               Vertex_Colors(V) := Gray;
               Result(V).Distance := Result(U).Distance + 1;
               Result(V).Predecessor := U;
               Q.Append(V);
            end if;
         end loop;
         Vertex_Colors(U) := Black;
      end loop;

      return Result;
   end Breadth_First_Search;


   procedure Depth_First_Search
     (G : in Graph; Trees : out DFS_Vertex_Trees; Has_Cycle : out Boolean) is
   begin
      -- TODO: Finish me!
      null;
   end Depth_First_Search;


   procedure Topological_Sort
     (G : in Graph; Sequence : out Vertex_Sequence; Is_DAG : out Boolean) is
   begin
      -- TODO: Finish me!
      null;
   end Topological_Sort;

end Spica.Graph_Algorithms;
