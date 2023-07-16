with Ada.Containers;
with Ada.Containers.Doubly_Linked_Lists;
with Ada.Containers.Vectors;

-- For more information on Ada library containers used here see:
--
-- http://www.ada-auth.org/standards/rm12_w_tc1/html/RM-A-18-2.html
-- http://www.ada-auth.org/standards/rm12_w_tc1/html/RM-A-18-3.html

package Spica.Edmonds_Karp is
   use type Ada.Containers.Count_Type;

   subtype Extended_Vertex_Number_Type is
     Ada.Containers.Count_Type range 0 .. Ada.Containers.Count_Type'Last;
   subtype Vertex_Number_Type is
     Extended_Vertex_Number_Type range 1 .. Extended_Vertex_Number_Type'Last;
   No_Vertex : constant Extended_Vertex_Number_Type := 0;

   type Flow_Type is digits 12 range -1.0E12 .. 1.0E12;

   type Edge_Information is
      record
         From : Vertex_Number_Type;
         To   : Vertex_Number_Type;
         Capacity : Flow_Type := 0.0;
         Flow     : Flow_Type := 0.0;
      end record;

   package Edge_Lists is new
     Ada.Containers.Doubly_Linked_Lists
       (Element_Type => Edge_Information);

   package Vertex_Vectors is new
     Ada.Containers.Vectors
       (Index_Type   => Vertex_Number_Type,
        Element_Type => Edge_Lists.List,
        "="          => Edge_Lists."=");

   type Graph is
      record
         Vertexes : Vertex_Vectors.Vector;
      end record;

   -- Adds a directed edge to the graph that runs between vertexes Edge.From and Edge.To. If the
   -- edge already exists its capacity and flow are replaced. If either the Edge.From or Edge.To
   -- vertexes do not exist, they are created.
   procedure Add_Edge(G : in out Graph; Edge : in Edge_Information);

   -- Returns the value of the maximum flow for a given graph with the give source and sink.
   function Maximum_Flow
     (G : in out Graph; Source, Sink : in Vertex_Number_Type) return Flow_Type
     with Pre => (Source <= G.Vertexes.Length and Sink <= G.Vertexes.Length);

end Spica.Edmonds_Karp;
