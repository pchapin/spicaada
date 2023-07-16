
package body Spica.Maybes is

   function Filter
     (Optional  : Maybe;
      Predicate : access function(Element : Element_Type) return Boolean) return Maybe is
   begin
      -- Filtering a None returns None.
      if Optional.State = None then
         return Optional;
      end if;

      -- If the predicate fails, return None.
      if not Predicate(Optional.Element) then
         return (State => None);
      end if;

      -- The predicate succeeded.
      return Optional;
   end Filter;

end Spica.Maybes;
