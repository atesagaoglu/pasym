Program ParseTest;

{$mode objfpc}

uses
    SysUtils,
    Parser,
    ArrayUtil;

var
    args: TArgs;
begin
    args := ParseArgs;
    PrintArgs(args);

    PrintArray(args.names);
    Writeln(ArrayIncludes(args.names, 'kitty'));
end.
