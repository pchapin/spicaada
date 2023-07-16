Spica TODO List
===============

+ Switch the build system over to Alire and define the library as a crate.

+ Think about breaking down the general frameworks used. That is probably the wrong design. See
  the comments in the README for more information.

+ Does it make sense to include some additional primitive operations for trees such as Minimum
  and Maximum (be careful of the names... the ordering relation is a generic parameter).

+ Documentation? I'd like to use AdaDoc for this, but AdaDoc isn't ready for the Ada 2012 (or
  later) material.

+ Add some more heap and tree types to make the collection a bit more interesting.

+ Fix the graph type to use Ada 2012 library components rather than GNAT specific components.
