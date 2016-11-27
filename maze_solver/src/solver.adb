package body solver is

    procedure Solve_Maze(maze : Map.M_Access) is
      package SU renames Ada.Strings.Unbounded;
      package Point_Fifo is new Fifo(Point);
      use Point_Fifo;

      type Line(Size:Positive) is tagged record
        Text: String(1..Size);
      end record;
      type L_Access is access Line;
      mazeLine : L_Access;

      My_Fifo : Fifo_Type;
      Val: Point;
    begin

      -- Find Pacman in the maze.
      If (SU.Element(maze.layout(maze.pacMan.Y+1), maze.pacMan.X+1) = 'P') then
        Put_Line("Found Pacman");
        Push(My_Fifo, Add_Point(maze.pacMan.X+1,maze.pacMan.Y+1));

        Put_Line("Searching");
        while not Is_Empty(My_Fifo) loop
          Pop(My_Fifo, Val);

          --Up
          if (Search_Area(maze, Val.X, Val.Y-1) = Dash) then
            Push(My_Fifo, Add_Point(Val.X, Val.Y-1));

            mazeLine := new Line(SU.Length(maze.layout(Val.Y-1)));
            mazeLine.Text := SU.To_String(maze.layout(Val.Y-1));
            mazeLine.Text(Val.X) := '_';
            maze.layout(Val.Y-1) := SU.To_Unbounded_String(mazeLine.Text);

          end if;

          --Left
          if (Search_Area(maze, Val.X-1, Val.Y) = Dash) then
            Push(My_Fifo, Add_Point(Val.X -1, Val.Y));

            mazeLine := new Line(SU.Length(maze.layout(Val.Y)));
            mazeLine.Text := SU.To_String(maze.layout(Val.Y));
            mazeLine.Text(Val.X - 1) := '_';
            maze.layout(Val.Y) := SU.To_Unbounded_String(mazeLine.Text);

          end if;

          --Right
          if (Search_Area(maze, Val.X+1, Val.Y) = Dash) then
            Push(My_Fifo, Add_Point(Val.X +1, Val.Y));

            mazeLine := new Line(SU.Length(maze.layout(Val.Y)));
            mazeLine.Text := SU.To_String(maze.layout(Val.Y));
            mazeLine.Text(Val.X + 1) := '_';
            maze.layout(Val.Y) := SU.To_Unbounded_String(mazeLine.Text);

          end if;

          --Down
          if (Search_Area(maze, Val.X, Val.Y+1) = Dash) then
            Push(My_Fifo, Add_Point(Val.X, Val.Y+1));

            mazeLine := new Line(SU.Length(maze.layout(Val.Y+1)));
            mazeLine.Text := SU.To_String(maze.layout(Val.Y+1));
            mazeLine.Text(Val.X) := '_';
            maze.layout(Val.Y+1) := SU.To_Unbounded_String(mazeLine.Text);

          end if;

          if (foundPellet) then
            Put_Line("Found Pellet");
            Clear_Queue(My_Fifo);
          end if;

        end loop;

      else
        Put("Didn't Find Pacman");
      end if;
    end Solve_Maze;

    function Search_Area(maze:Map.M_Access; x:Positive; y:Positive) return PointType is
      package SU renames Ada.Strings.Unbounded;
      charType : PointType := Invalid;
    begin

      case SU.Element(maze.layout(y), x) is
        when '-' => charType := Dash;
        when '%' => charType := Wall;
        when '.' =>
          charType := Finish;
          foundPellet := True;
        when others => charType := Invalid;
      end case;

      return charType;
    end Search_Area;

    function Add_Point(x:Positive; y:Positive) return Point is
      XY: Point;
    begin
      XY.x := x;
      XY.y := y;

      return XY;
    end Add_Point;

end solver;
