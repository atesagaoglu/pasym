unit Parser;

{$mode objfpc}

interface

type
    TArgs = record
        dry: boolean;
        only: boolean;
        filename: string;
        name: string;
        printOpts: boolean;
    end;

function ParseArgs: TArgs;
procedure PrintArgs(args: TArgs);
procedure PrintHelp;

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
            if arg = '--help' then PrintHelp()
            else if arg = '--dry' then Result.dry := true
            else if arg = '--print-opts' then Result.printOpts := true
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

procedure PrintArgs(args: TArgs);
begin
    Writeln('dry: ', BoolToStr(args.dry, True));
    Writeln('only: ', BoolToStr(args.only, True));
    Writeln('printOpts: ', BoolToStr(args.PrintOpts, True));
    Writeln('name: ', args.name);
    Writeln('filename: ', args.filename);
end;

function PadRight(s: String; width: Integer): String;
begin
    if Length(s) < width then
        PadRight := s + StringOfChar(' ', width - Length(s))
    else
        PadRight := s;
end;

procedure PrintHelp;
begin
    Writeln(PadRight('Usage:', 20), 'pasym [options...] [name] [manifest_file]');
    Writeln(PadRight('-d/--dry', 20), 'Run in dry mode');
    Writeln(PadRight('-o/--only', 20), 'Link only given entries. Must be followed with [name]');
    Writeln(PadRight('--print-opts', 20), 'Print given arguments.');
    Writeln(PadRight('--help', 20), 'Print help menu');
    Halt(1);
end;
end.
