program pasym;
{$mode objfpc}
uses
    Parser,
    SysUtils,
    BaseUnix,
    Errors;
var
    manifestFile: textFile;
    line: string;
    source: string;
    target: string;
    name: string;
    delimit: smallint;
    delimitName: smallint;
    err: longint;

    args: TArgs;

begin

    args := ParseArgs;

    if args.dry then Writeln('pasym running in dry mode.');
    
    if not FileExists(args.fileName) then
    begin
        Writeln('Manifest file "', args.fileName, '" does not exist.');
        Exit();
    end;

    Assign(manifestFile, args.fileName);
    Reset(manifestFile);

    line := '';

    // TODO: Reformat this to reduce indentation
    // TODO: Allow partial linking
    while not eof(manifestFile) and (line <> ' ') do
    begin
        Readln(manifestFile, line);
        delimitName := Pos(':', line);
        delimit := Pos('->', line);

        // start and end are inclusive
        name := Copy(line, 1, delimitName - 1);
        source := Copy(line, delimitName + 1, (delimit - delimitName - 1));
        target := Copy(line, delimit+2, Length(line));

        // don't forget to expand to absolute paths
        name := Trim(name);
        source := ExpandFileName(Trim(source));
        target := ExpandFileName(Trim(target));

        {$IFDEF DEBUG}
        Writeln(line);
        Writeln('name: ', name);
        Writeln('source: ', source);
        Writeln('target: ', target);
        Writeln();
        {$ENDIF}


        if not args.dry then
        begin
            // for some reason, do this conversion
            if (fpSymlink(PChar(AnsiString(source)), PChar(AnsiString(target)))) < 0 then
            begin
                Writeln('Error occured during linking ', source, ' to ', target);
                err := FpGeterrno;
                
                if (err = ESysENOENT) then
                begin
                    if not FileExists(source) then
                    begin
                        Writeln('Source file ', source, ' does not exist.');
                    end
                    else
                        Writeln('Target path ', target, ' is not valid.');
                    end
                else if (err = ESysEACCES) then
                    Writeln('Write access denied at target path ', target)
                else if (err = ESysENOTDIR) then
                    Writeln('ENOTDIR');
            end;
        end;
    end;
    Close(manifestFile);
end.
