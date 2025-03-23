Program ParseTest;

{$mode objfpc}

uses
    SysUtils, Parser;

var
    args: TArgs;
begin
    args := ParseArgs;
    PrintArgs(args);
end.
