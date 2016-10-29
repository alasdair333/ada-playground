-- Map Specification file.
-- Read in a map from a text file.
-- Based on the programming challenge https://www.hackerrank.com/challenges/pacman-dfs

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;
with Ada.Strings.Unbounded;

package Map is
  package SU renames Ada.Strings.Unbounded;
  package SF renames Ada.Strings.Fixed;
  type Grid is array(Positive range <>) of SU.Unbounded_String;

  type Point is record
    X : Integer := 0;
    Y : Integer := 0;
  end record;

  type Maze (width:Positive; height:Positive) is tagged record
    pacman : Point;
    food : Point;
    layout : Grid(1..height) := (others => SU.To_Unbounded_String(""));
  end record;

  type M_Access is access Maze;

  function Reader( fileName : String) return M_Access;

private
  function Find_XY( line : String) return Point;

end Map;
