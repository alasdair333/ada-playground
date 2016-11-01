-- Map package.
package body Map is

  -- Function: Reader
  -- Description: Reads in a map file, creates the map in memory.
  function Reader (fileName : String) return M_Access
  is
    file : File_Type;
    currentLine : Integer := 0;
    m:  M_Access;
    mapSize : Point;
    pacman : Point;
    food : Point;
    mapLine : Integer := 1;
    MapTooBig : Exception;
  begin
    Open(File => file,
          Mode => In_File,
          Name => fileName);
    loop
      exit when End_Of_File(file);

      case currentLine is
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

            -- Check the line isn't larger than what we said it was.
            if ((SU.Length(m.layout(mapLine)) - 1) >= mapSize.X) then
              Put("Map Line too big on Line: ");
              Put(Integer'Image(mapLine));

              raise MapTooBig with "Map Size too big";
            end if;

          end if;
          mapLine := mapLine + 1;
      end case;

      currentLine := currentLine + 1;
    end loop;

    Close(file);
    return m;
  end Reader;

  -- Function: Find_XY
  -- Description: Finds the X & Y coords in the map file.
 function Find_XY( line : String) return Point is
    spaceIndex : Natural := line'First;
    spaceCount : Natural := 0;
    XY : Point;

    MapPropertyMissing : Exception;
    TooManySpaces : Exception;
 begin
   XY.X := 0;
   XY.Y := 0;
   --Lets do some basic error checking
   spaceCount := SF.Count(line, " ");
   if ( spaceCount = 0 ) then
     raise MapPropertyMissing;
   elsif ( spaceCount > 1 ) then
     raise TooManySpaces;
   end if;

   spaceIndex := SF.Index(line, " ");
   XY.Y := Integer'Value(line(line'first..spaceIndex));
   XY.X := Integer'Value(line(spaceIndex+1..line'Last));

  return XY;

  Exception
    when MapPropertyMissing =>
      Put_Line("Missing Property from Map File");
      return XY;
    when TooManySpaces =>
      Put_Line("Too many spaces in property");
      return XY;
    when Constraint_Error =>
      Put_Line("Error in Map File.");
      return XY;
    when others =>
      Put_Line("Unhandled Error");
      return XY;
 end Find_XY;
end Map;
