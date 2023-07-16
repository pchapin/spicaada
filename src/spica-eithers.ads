-- This package provides an Either type in a manner similar to that of many functional languages.
-- Eithers are not mutable in the sense that their discriminant can't be changed. However, they
-- can be overwritten by another Maybe in the same state.

generic
   type Left_Type is private;
   type Right_Type is private;
package Spica.Eithers is

   type State_Type is (Left, Right);

   type Either(State : State_Type) is
      record
         case State is
            when Left =>
               Left_Element : Left_Type;
            when Right =>
               Right_Element : Right_Type;
         end case;
      end record;

end Spica.Eithers;
