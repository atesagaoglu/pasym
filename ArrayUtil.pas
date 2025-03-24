Unit ArrayUtil;
{$mode objfpc}

interface

procedure PrintArray(arr: array of AnsiString);
function ArrayIncludes(arr: array of AnsiString; e: AnsiString): integer;

implementation

procedure PrintArray(arr: array of AnsiString);
var
    i: word;
begin
    Write('[ ');
    for i := Low(arr) to High(arr) do
    begin
        Write(arr[i]);
        if i <> (Length(arr) - 1) then write(', ');
    end;
    Writeln(' ]');
end;

function ArrayIncludes(arr: array of AnsiString; e: AnsiString): integer;
var
    i: word;
begin
    Result := -1; // not found
    for i:= Low(arr) to High(arr) do
    begin
        if arr[i] = e then
        begin
            Result := i;
            break;
        end;
    end;
end;

end.
