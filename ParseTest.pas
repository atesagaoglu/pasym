Program ParseTest;

{$mode objfpc}

uses
    SysUtils, Parser;

var
    args: TArgs;
begin
    args := ParseArgs;

    Writeln('dry: ', BoolToStr(args.dry, True));
    Writeln('only: ', BoolToStr(args.only, True));
    Writeln('name: ', args.name);
    Writeln('filename: ', args.filename);
end.
