
with Spica.Graphs;

generic
   type Vertex_Type is private;
   with package Graphs_Package is new Graphs(Vertex_Type);
package Spica.Graph_Algorithms is
   use Graphs_Package;

   subtype Extended_Vertex_Number_Type is
     Natural range 0 .. Vertex_Number_Type'Last;

   -- Information about each vertex required for Breadth_First_Search.
   type BFS_Vertex_Information is
      record
         Distance    : Natural := 0;
         Predecessor : Extended_Vertex_Number_Type := 0; -- Zero means "no predecessor."
      end record;

   -- Describes a tree of vertexes.
   type BFS_Vertex_Tree is array(Vertex_Number_Type range <>) of BFS_Vertex_Information;

   -- Information about each vertex required for Depth_First_Search.
   subtype DFS_Time_Type is Natural;
   type DFS_Vertex_Information is
      record
         Discovery_Time : DFS_Time_Type := 0;
         Finishing_Time : DFS_Time_Type := 0;
         Predecessor    : Extended_Vertex_Number_Type := 0; -- Zero means "no predecessor."
      end record;

   -- Describes depth first trees of vertexes.
   type DFS_Vertex_Trees is array(Vertex_Number_Type range <>) of DFS_Vertex_Information;

   -- Describes a sequence of vertexes returned by Topological_Sort.
   type Vertex_Sequence is array(Natural range <>) of Vertex_Number_Type;

   -- Does a BreadthFirstSearch of the given Graph, starting at the given Vertex, and returns
   -- a description of the breadth first tree, with distances and predecessors filled in.
   function Breadth_First_Search
     (G : Graph; Start_Vertex : Vertex_Number_Type) return BFS_Vertex_Tree;

   -- Does a DepthFirstSearch of the given Graph, and returns a description of all the depth
   -- first trees, with discovery times, finishing times, and predecessors filled in.
   procedure Depth_First_Search
     (G : in Graph; Trees : out DFS_Vertex_Trees; Has_Cycle : out Boolean);

   -- Does a topological sort of the given graph, and returns True in Is_DAG if such a sort
   -- is possible. If so, the returned sequence of vertex numbers is a valid sort.
   procedure Topological_Sort
     (G : in Graph; Sequence : out Vertex_Sequence; Is_DAG : out Boolean);

end Spica.Graph_Algorithms;
