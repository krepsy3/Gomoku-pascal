unit Default_AI;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, global, math;

  function GetAIName: String;
  procedure Move(gamefield: GameFieldArray; Me, Enemy, Difficulty: Byte;
    out pickedx, pickedy: Integer);

implementation
  {Retrieves display name of the AI}
  function GetAIName: String;
  begin
    GetAIName := 'Počítač-výchozíUI';
  end;

  {Gets score of a tile. Higher the score, better to pick the tile.}
  function GetPointPlayerScore(gamefield: GameFieldArray;
    x,y: Integer; Player, Difficulty: Byte; isMe: Boolean): Integer;
  var
    i, j, k, d, tx, ty: Integer;
    res, count, barrier: Integer;

  begin
    res := 0;

    for k := 0 to 3 do  //0=left-right; 1=up-down; 2=topl-botr; 3=botl-topr;
    begin
      count := 0;
      barrier := 0;

      for j := -1 to 0 do
      begin
        d := (2 * j) + 1;  //d=direction: -1 for j = -1; 1 for j = 0

        for i := 1 to 5 do
        begin
          {%Region assign coords tx, ty}
          case k of
            0:
              begin
                tx := x + i*d;
                ty := y;
              end;
            1:
              begin
                tx := x;
                ty := y + i*d;
              end;
            2:
              begin
                tx := x + i*d;
                ty := y + i*d;
              end;
            3:
              begin
                tx := x + i*d;
                ty := y - i*d;
              end;
          end;
          {%EndRegion}

          if (tx < 0) or (tx > High(gamefield)) or
             (ty < 0) or (ty > High(gamefield[0])) then
          begin
            barrier := barrier + 1;
            Break;
          end

          else if gamefield[tx][ty] = Player then
            count := count + 1

          else
          begin
            if gamefield[tx][ty] <> 0 then
              barrier := barrier + 1;
            Break;
          end;
        end;
      end;

      if count >= 4 then
      begin
        if isMe then count := 20
        else count := 15;
      end;

      count := trunc(power(count, 2));

      case Difficulty of
        0: res := res + count;
        1: if barrier > 0 then res := res + (count div 2)
           else res := res + count;
        2: if (barrier > 1) and (count < 200) then res := res + 0
           else if barrier = 1 then res := res + (count div 2)
           else res := res + count;
      end;
    end;

    GetPointPlayerScore := res;
  end;

  {Performs the computer ai pick. Coordinates are retrieved as out params}
  procedure Move(gamefield: GameFieldArray; Me, Enemy, Difficulty: Byte;
    out pickedx, pickedy: Integer);

  type
    int2tuple = record
      x1, x2: Integer
    end;

  var
    i, j: Integer;
    score, max, ma2x: Integer;
    scorefield: Array of Array of Integer;
    possiblecoords: Array of int2tuple;

  begin
    SetLength(scorefield, 0, 0);
    SetLength(scorefield, length(gamefield), length(gamefield[0]));
    SetLength(possiblecoords, 0);
    max := -1;
    ma2x := -2;

    //get scores
    for i := 0 to High(scorefield) do for j := 0 to High(scorefield) do
    begin
      if gamefield[i][j] = 0 then
      begin
        score := GetPointPlayerScore(gamefield, i, j, Me, Difficulty, true);
        score := score +
          GetPointPlayerScore(gamefield, i, j, Enemy, Difficulty, false);

        if score > max then
        begin
          ma2x := max;
          max := score;
        end

        else if score > ma2x then
          ma2x := score;

        scorefield[i][j] := score;
      end

      else
        scorefield[i][j] := -1;
    end;

    //get possible outputs
    if (max > 0) or
       (gamefield[High(gamefield) div 2][High(gamefield[0]) div 2] <> 0) then
    begin
      for i := 0 to High(scorefield) do for j := 0 to High(scorefield[0]) do
      begin
        if (scorefield[i][j] = max) or
           ((scorefield[i][j] = ma2x) and (Difficulty = 0)) then
        begin
          SetLength(possiblecoords, Length(possiblecoords) + 1);
          with possiblecoords[High(possiblecoords)] do
          begin
            x1 := i;
            x2 := j;
          end;
        end;
      end;

    //set the out vars
    i := Random(Length(possiblecoords));
    pickedx := possiblecoords[i].x1;
    pickedy := possiblecoords[i].x2;
  end

  else
  begin
    pickedx := High(gamefield) div 2;
    pickedy := High(gamefield[0]) div 2;
  end;
end;

end.
