
The Spica Library
=================

This is the Ada part of the [Spica meta-library](https://github.com/pchapin/spica).

This is an Ada library of unusual or specialized algorithms and data structures. It was created
largely as an exercise, but some effort has been made to implement the algorithms and data
structures here with enough quality to be useful.

The samples and other programs can be built using the `spica.gpr` GNAT project file. There are
two build scenarios defined: Release and Debug. The default scenario is Debug. In this scenario
debug information is included in the executable. It also sets the Assertion Policy to "Check"
which means Ada assertions, pre- and postconditions, loop invariants, and other similar things
will be included in the runtime checking done by the program (typically an exception is raised
if the checks fail). In the Release scenario optimization is turned on and the Assertion Policy
is set to "Ignore" which removes the runtime checking associated with the assertions.

To build programs at the command line use something like:

    $ gprbuild spica.gpr tests.adb
  
This builds the main program in `tests.adb` and all required packages needed to support that
program. The resulting executable is put under the `build` folder. You must specify the GPR file
first so `gprbuild` knows where to get project settings.

To build a program in release mode do:

    $ gprbuild spica.gpr -XBUILD=Release tests.adb
    
You can also compile a single file without creating an overall executable. This does syntatic
and semantic checking on the file and can be useful while you are working on that file. Use a
command such as:

    $ gprbuild spica.gpr -c spica-sorters.adb
    
Note that you compile package body files, specification files are compiled on demand depending
on the `with` statements in the body file you are compiling. It is not necessary to specify the
path to a source file if it is in one of the source folders. The `gprbuild` tool will search for
the file automatically.

Enjoy!

Peter Chapin  
spicacality@kelseymountain.org  
