with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded;
with Map;
with Fifo;

package solver is
  type Point is record
    X : Integer := 0;
    Y : Integer := 0;
  end record;

  type PointType is (Invalid, Wall, Dash, Finish);

  procedure Solve_Maze(maze : Map.M_Access);

  foundPellet : Boolean := false;

private
  function Add_Point(x:Positive; y:Positive) return Point;
  function Search_Area(maze:Map.M_Access; x:Positive; y:Positive) return PointType;

end solver;
