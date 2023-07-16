-- This package provides a Maybe type in a manner similar to that of many functional languages.
-- Maybes are not mutable in the sense that their discriminant can't be changed. However, they
-- can be overwritten by another Maybe in the same state.
--
-- Note that Haskell's naming (Maybe, None, Just) is used here instead of Scala's (Option, None,
-- Some) because "Some" is a reserved word in Ada.

generic
   type Element_Type is private;
package Spica.Maybes is

   type State_Type is (None, Just);

   type Maybe(State : State_Type) is
      record
         case State is
            when None =>
               null;
            when Just =>
               Element : Element_Type;
         end case;
      end record;

   function Filter
     (Optional  : Maybe;
      Predicate : access function(Element : Element_Type) return Boolean) return Maybe;

end Spica.Maybes;
