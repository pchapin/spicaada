with Spica.Maybes;

generic
   type A_Type is private;
   type B_Type is private;
package Spica.Functional is

   package A is new Spica.Maybes(Element_Type => A_Type);
   package B is new Spica.Maybes(Element_Type => B_Type);

   function Map
     (Optional    : A.Maybe;
      Transformer : access function
                      (Element : A_Type) return B_Type) return B.Maybe;

   function Flat_Map
     (Optional    : A.Maybe;
      Transformer : access function
                      (Element : A_Type) return B.Maybe) return B.Maybe;

end Spica.Functional;
