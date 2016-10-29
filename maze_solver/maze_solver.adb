with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded;
with Map;

procedure maze_solver is
  package SU renames Ada.Strings.Unbounded;
  maze :  Map.M_Access;
begin
  maze := Map.Reader("moo.txt");

  Put("Pacman Position X: ");
  Put(Integer'Image(maze.pacMan.X));
  Put(" Y: ");
  Put_Line(Integer'Image(maze.pacMan.Y));

  Put("Food Position X: ");
  Put(Integer'Image(maze.food.X));
  Put(" Y: ");
  Put_Line(Integer'Image(maze.food.Y));

  for l in 1 .. maze.layout'length loop
    Put_Line(SU.To_String(maze.layout(l)));
  end loop;

end maze_solver;
