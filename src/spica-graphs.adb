
package body Spica.Graphs is

   procedure Create_Vertex
     (The_Graph     : in out Graph;
      Vertex_Data   : in     Vertex_Type;
      Vertex_Number :    out Vertex_Number_Type)
   is
      Empty_EdgesF : Edge_Vectors.Vector;
      Empty_EdgesB : Edge_Vectors.Vector;
   begin
      The_Graph.Data.Append(Vertex_Data);
      The_Graph.Forward.Append(Empty_EdgesF);
      The_Graph.Backward.Append(Empty_EdgesB);
      The_Graph.Size := The_Graph.Size + 1;
      Vertex_Number  := The_Graph.Data.Last_Index;
   end Create_Vertex;


   procedure Create_Edge
     (The_Graph : in out Graph;
      From      : in     Vertex_Number_Type;
      To        : in     Vertex_Number_Type)
   is
      -- Helper function returns True if the edge already exists; False otherwise.
      function Edge_Exists return Boolean is
      begin
         return The_Graph.Forward(From).Contains(To);
      end Edge_Exists;

      -- Helper procedure used in call to Update_Element.
      procedure Append_To(Edge_Vector : in out Edge_Vectors.Vector) is
      begin
         Edge_Vector.Append(To);
      end Append_To;

      -- Helper procedure used in call to Update_Element.
      procedure Append_From(Edge_Vector : in out Edge_Vectors.Vector) is
      begin
         Edge_Vector.Append(From);
      end Append_From;

   begin
      if From > The_Graph.Size then raise Bad_Vertex; end if;
      if To   > The_Graph.Size then raise Bad_Vertex; end if;
      if Edge_Exists then return; end if;

      The_Graph.Forward.Update_Element(From, Append_To'Access);
      The_Graph.Backward.Update_Element(To, Append_From'Access);
   end Create_Edge;


   function Get_Vertex
     (The_Graph     : Graph;
      Vertex_Number : Vertex_Number_Type) return Vertex_Type is
   begin
      if Vertex_Number > The_Graph.Size then raise Bad_Vertex; end if;
      return The_Graph.Data(Vertex_Number);
   end Get_Vertex;


   procedure Put_Vertex
     (The_Graph     : in out Graph;
      Vertex_Number : in     Vertex_Number_Type;
      Vertex_Data   : in     Vertex_Type) is
   begin
      if Vertex_Number > The_Graph.Size then raise Bad_Vertex; end if;
      The_Graph.Data.Replace_Element(Vertex_Number, Vertex_Data);
   end Put_Vertex;


   function Get_Successor_List
     (The_Graph : Graph; Vertex_Number : Vertex_Number_Type) return Vertex_List is
   begin
      if Vertex_Number > The_Graph.Size then raise Bad_Vertex; end if;
      declare
         Count  : Natural := Natural(The_Graph.Forward(Vertex_Number).Length);
         Result : Vertex_List(1 .. Count);
      begin
         for I in Result'Range loop
            Result(I) := The_Graph.Forward(Vertex_Number)(I - 1);
         end loop;
         return Result;
      end;
   end Get_Successor_List;


   function Get_Predecessor_List
     (The_Graph : Graph; Vertex_Number : Vertex_Number_Type)
       return Vertex_List is
   begin
      if Vertex_Number > The_Graph.Size then raise Bad_Vertex; end if;
      declare
         Count  : Natural := Natural(The_Graph.Backward(Vertex_Number).Length);
         Result : Vertex_List(1 .. Count);
      begin
         for I in Result'Range loop
            Result(I) := The_Graph.Backward(Vertex_Number)(I - 1);
         end loop;
         return Result;
      end;
   end Get_Predecessor_List;


   function Size(The_Graph : Graph) return Natural is
   begin
      return The_Graph.Size;
   end Size;

end Spica.Graphs;
