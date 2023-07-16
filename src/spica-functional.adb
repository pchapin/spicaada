
package body Spica.Functional is
   use type A.State_Type;

   function Map
     (Optional    : A.Maybe;
      Transformer : access function
                      (Element : A_Type) return B_Type) return B.Maybe is
   begin
      -- Mapping a None returns None.
      if Optional.State = A.None then
         return (State => B.None);
      end if;

      return (State => B.Just, Element => Transformer(Optional.Element));
   end Map;


   function Flat_Map
     (Optional    : A.Maybe;
      Transformer : access function
                      (Element : A_Type) return B.Maybe) return B.Maybe is
   begin
      -- Mapping a None returns None.
      if Optional.State = A.None then
         return (State => B.None);
      end if;

      return Transformer(Optional.Element);
   end Flat_Map;

end Spica.Functional;
