
generic
   type Key_Type is private;
   type Value_Type is private;
package Spica.KV_Stores is

   type KV_Store is limited interface;

   -- Exception that is raised if an element is not found when doing a lookup.
   Not_Found : exception;

   -- Inserts a (Key, Value) pair into the store.
   -- If the key is already present, the corresponding value is replaced.
   procedure Insert
     (Container : in out KV_Store; Key : in Key_Type; Value : in Value_Type) is abstract;

   -- Returns the value associated with the given key. Raises Not_Found if the key is absent.
   -- The mode on Container is 'in out' to allow for implementations that modify the Container
   -- each time a lookup operation is done (e. g., splay trees).
   function Search
     (Container : in out KV_Store; Key : in Key_Type) return Value_Type is abstract;

   -- Deletes a (Key, Value) pair from the Container. If the key is absent, there is no effect.
   -- TODO: What should happen if Delete cannot be implemented for a particular concrete store?
   --       Possibilities include: 1) raising an exception or 2) having no effect.
   procedure Delete(Container : in out KV_Store; Key : in Key_Type) is abstract;

   -- Returns the number of elements in the KV_Store.
   function Size(Container : KV_Store) return Natural is abstract;

   --------------------
   -- Debugging/Testing
   --------------------

   -- Exception raised by Check_Santity (below).
   Inconsistent_Store : exception;

   -- For debugging. Raises Inconsistent_Store with given message if a problem is found. Test
   -- programs can use this procedure to check the sanity of the store after an operation is
   -- done. The message is intended to reflect which operation was attempted, and is thus only
   -- known to the caller.
   procedure Check_Sanity(Container : in KV_Store; Message : in String) is abstract;

end Spica.KV_Stores;
