
package body Spica.Double_Lists is

   function Size(List : Double_List) return Natural is
   begin
      return List.Count;
   end Size;


   function Front(List : Double_List) return Element_Type is
      Result : Element_Type;
   begin
      raise Program_Error with "Not implemented: Spica.Double_Lists.Front";
      return Result;
   end Front;


   function Back(List : Double_List) return Element_Type is
      Result : Element_Type;
   begin
      raise Program_Error with "Not implemented: Spica.Double_Lists.Back";
      return Result;
   end Back;


   procedure Push_Front(List : in out Double_List; Item : in Element_Type) is
   begin
      raise Program_Error with "Not implemented: Spica.Double_Lists.Push_Front";
   end Push_Front;


   procedure Push_Back(List : in out Double_List; Item : in Element_Type) is
   begin
      raise Program_Error with "Not implemented: Spica.Double_Lists.Push_Back";
   end Push_Back;


   procedure Pop_Front(List : in out Double_List; Item : out Element_Type) is
   begin
      raise Program_Error with "Not implemented: Spica.Double_Lists.Pop_Front";
   end Pop_Front;


   procedure Pop_Back(List : in out Double_List; Item : out Element_Type) is
   begin
      raise Program_Error with "Not implemented: Spica.Double_Lists.Pop_Back";
   end Pop_Back;


   procedure Adjust(List : in out Double_List) is
   begin
      raise Program_Error with "Not implemented: Spica.Double_Lists.Adjust";
   end Adjust;


   procedure Finalize(List : in out Double_List) is
   begin
      raise Program_Error with "Not implemented: Spica.Double_Lists.Finalize";
   end Finalize;

end Spica.Double_Lists;
