unit Parser;

{$mode objfpc}

interface

type
    TArgs = record
        dry: boolean;
        only: boolean;
        filename: string;
        name: string;
    end;

function ParseArgs: TArgs;

implementation

uses
    SysUtils;

function ParseArgs: TArgs;
var
    i, j: smallint;
    arg: string;
begin
    Result.dry := false;
    Result.only := false;
    Result.name := '';
    Result.filename := 'manifest.pasym';

    i := 1;

    while i <= ParamCount do
    begin
        arg := ParamStr(i);
        if Copy(arg, 1, 2) = '--' then // long form
        begin
            if arg = '--dry' then Result.dry := true
            else if arg = '--only' then
            begin
                // name must appear directly after --only
                Result.only := true;
                Inc(i);
                if i > ParamCount then
                begin
                    Writeln('Missing name after --only');
                    Halt(1);
                end;
                
                Result.name := ParamStr(i);
                Inc(i);
                if i <= ParamCount then Result.filename := ParamStr(i);
            end
            else
            begin
                Writeln('Unknown option: ', arg);
                Halt(1);
            end;
        end
        else if Copy(arg, 1, 1) = '-' then // short form
        begin
            for j := 2 to Length(arg) do
            begin
                Writeln('Looking: ', arg[j]);
                case arg[j] of
                    'd': Result.dry := true;
                    'o':
                        begin
                            if j <> Length(arg) then
                            // Unknown flags can't be caught otherwise
                            begin
                                Writeln('No flag can appear between -o and [name]');
                                Halt(1);
                            end;
                            Result.only := true;
                            Inc(i);
                            if i > ParamCount then
                            begin
                                Writeln('Missing name after -o');
                                Halt(1);
                            end;
                            Result.name := ParamStr(i);
                            Inc(i);
                            if i <= ParamCount then Result.filename := ParamStr(i);
                            break;
                        end;
                else
                    Writeln('Unknown flag: -', arg[j]);
                    Halt(1);
                end;
            end;
        end
        else
        begin
            Writeln('Unexpected argument: ', arg);
            Halt(1);
        end;

        Inc(i);
    end;

    if (not Result.only) and (Result.name <> '') then
    begin
      Writeln('Name given without -o/--only');
      Halt(1);
    end;
end;

end.
