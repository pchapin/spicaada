private with Ada.Containers.Vectors;

generic
   -- Type used to represent each vertex. Different instantiations of Graph can use different
   -- vertex types depending on the intended application.
   type Vertex_Type is private;

package Spica.Graphs is

   type Graph is private;

   --  Vertex indicies range from 1 to some maximum value that grows dynamically. Vertex
   --  numbering is done by this package (and thus appears arbitrary to the application).
   subtype Vertex_Number_Type is Positive;

   -- Vertex lists are used to return information about successor and predecessor vertexes.
   type Vertex_List is array(Positive range <>) of Vertex_Number_Type;

   -- Exception that is raised when an out-of-bounds vertex is provided as an argument.
   Bad_Vertex : exception;

   -- Creates a new vertex in the graph. The given Vertex_Data is used to initialize the
   -- vertex. Once a vertex is created, it can not be removed. Returns the vertex index for the
   -- new vertex. The vertex index is determined by this package and is not under user control.
   procedure Create_Vertex
     (The_Graph     : in out Graph;
      Vertex_Data   : in     Vertex_Type;
      Vertex_Number :    out Vertex_Number_Type);

   -- Creates a new directed edge in the graph. Raises Bad_Vertex if either the source or
   -- destination verticies do not exist. Once an edge is created, it can not be removed. If
   -- the edge already exists, there is no effect.
   procedure Create_Edge
     (The_Graph : in out Graph;
      From      : in     Vertex_Number_Type;
      To        : in     Vertex_Number_Type);

   -- Returns the vertex data associated with a particular vertex. Raises Bad_Vertex if the
   -- specified vertex does not exist.
   function Get_Vertex
     (The_Graph     : Graph;
      Vertex_Number : Vertex_Number_Type) return Vertex_Type;

   -- Replaces the vertex data associated with a particular vertex with Vertex_Data. Raises
   -- Bad_Vertex if the specified vertex does not exist.
   procedure Put_Vertex
     (The_Graph     : in out Graph;
      Vertex_Number : in     Vertex_Number_Type;
      Vertex_Data   : in     Vertex_Type);

   -- Returns a list of vertex numbers of vertexes that are successors of the specified vertex.
   -- Raises Bad_Vertex if the specified vertex does not exist.
   function Get_Successor_List
     (The_Graph : Graph; Vertex_Number : Vertex_Number_Type) return Vertex_List;

   -- Returns a list of vertex numbers of vertexes that are predecessors of the specified vertex.
   -- Raises Bad_Vertex if the specified vertex does not exist.
   function Get_Predecessor_List
     (The_Graph : Graph; Vertex_Number : Vertex_Number_Type) return Vertex_List;

   -- Returns the number of vertexes in the graph.
   function Size(The_Graph : Graph) return Natural;

private
   -- Vectors of vertex data.
   package Vertex_Vectors is
     new Ada.Containers.Vectors(Index_Type => Vertex_Number_Type, Element_Type => Vertex_Type);

   -- Vectors of graph edges. Vector element represents a "remote" vertex number.
   package Edge_Vectors is
     new Ada.Containers.Vectors(Index_Type => Natural, Element_Type => Vertex_Number_Type);

   -- Vectors of adjacency information. Vector element is a table of all remove vertexes.
   package Adjacency_Vectors is
     new Ada.Containers.Vectors
       (Index_Type   => Vertex_Number_Type,
        Element_Type => Edge_Vectors.Vector,
        "="          => Edge_Vectors."=");


   type Graph is record
      Data     : Vertex_Vectors.Vector;     -- Holds all the vertex data.
      Forward  : Adjacency_Vectors.Vector;  -- For finding vertex successors.
      Backward : Adjacency_Vectors.Vector;  -- For finding vertex predecessors.
      Size     : Natural := 0;              -- Number of vertexes.
   end record;

end Spica.Graphs;
