with Ada.Assertions;
with Ada.Text_IO;
with Spica.Longest_Common_Subsequence;

use Ada.Assertions;
use Ada.Text_IO;

procedure Test_Longest_Common_Subsequence is
   Longest_Length : Natural;
begin
   Put("Longest_Common_Subsequence: Book example... ");
   Longest_Length := Spica.Longest_Common_Subsequence("ABCBDAB", "BDCABA");
   Assert(Longest_Length = 4, "Longest_Common_Subsequence failed on book's example");
   Put_Line("ok");
end Test_Longest_Common_Subsequence;
