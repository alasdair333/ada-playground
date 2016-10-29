-- Map package.
package body Map is

  function Reader (fileName : String) return M_Access
  is
    file : File_Type;
    x : Integer;
    y : Integer;
    current_line : Integer := 0;
    m:  M_Access;
    mapSize : Point;
    pacman : Point;
    food : Point;
    mapLine : Integer := 1;

  begin
    Open(File => file,
          Mode => In_File,
          Name => fileName);
    loop
      exit when End_Of_File(file);

      case current_line is
        when 0 =>
          -- Pacman position
          pacman := Find_XY(Get_Line (File));

        when 1 =>
          -- Food position
          food := Find_XY(Get_Line (File));

        when 2 =>
          -- Map size
          mapSize := Find_XY(Get_Line (File));

          m := new Maze(mapSize.X, mapSize.Y);
          m.pacman := pacman;
          m.food := food;
        when others =>
          -- Map
          if (mapLine < mapSize.Y + 1) then
            m.layout(mapLine) := SU.To_Unbounded_String(Get_Line(File));
          end if;
          mapLine := mapLine + 1;
      end case;

      current_line := current_line + 1;
    end loop;

    Close(file);
    return m;
  end Reader;

 function Find_XY( line : String) return Point is
    Index_List : array(line'Range) of Natural;
    Space_Index : Natural := Index_List'First;
    Next_Index : Natural := Index_List'First;
    XY : Point;
 begin
   Space_Index := SF.Index(line, " ");

   XY.Y := Integer'Value(line(line'first..Space_Index));
   XY.X := Integer'Value(line(Space_Index+1..line'Last));

  return XY;
 end Find_XY;

end Map;
