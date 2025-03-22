program pasym;
uses
    SysUtils,
    BaseUnix,
    Errors;
var
    fileName: string;
    manifestFile: textFile;
    line: string;
    source: string;
    target: string;
    delimit: smallint;
    i: integer;

    flagDry: boolean;
begin

    flagDry := false;
    
    // TODO: Implement a better parsing algorithm and add support for chaining
    if ParamCount > 0 then
    begin
        for i := 1 to ParamCount do
        begin
            // Check if the first argument is the file name or not
            if (i = 1) 
                and (Length(ParamStr(i)) > 0)
                and (ParamStr(i)[1] <> '-') then filename := ParamStr(1);
            if (ParamStr(i) = '--dry') or (ParamStr(i) = '-d') then flagDry := true;
        end;
    end;

    // Default file name
    if fileName = '' then
    begin
        fileName := 'manifest.pasym';
    end;

    // Writeln('filename -> ', fileName);
    if flagDry then Writeln('Running in dry mode');

    if not FileExists(fileName) then
    begin
        Writeln('Manifest file "', fileName, '" does not exist.');
        Exit();
    end;

    Assign(manifestFile, fileName);
    Reset(manifestFile);

    line := '';

    // TODO: Reformat this to reduce indentation
    // TODO: Allow partial linking
    while not eof(manifestFile) and (line <> ' ') do
    begin
        Readln(manifestFile, line);
        Writeln(line);
        delimit := Pos('->', line);

        // start and end are inclusive
        source := Copy(line, 1, delimit-1); // from start to arrow
        target := Copy(line, delimit+2, Length(line)); // from after arrow to end

        // don't forget to expand to absolute paths
        source := ExpandFileName(Trim(source));
        target := ExpandFileName(Trim(target));

        Writeln('source: ', source);
        Writeln('target: ', target);
        Writeln();

        if not flagDry then
            // for some reason, do this conversion
            if (fpSymlink(PChar(AnsiString(source)), PChar(AnsiString(target)))) < 0 then
            begin
                Writeln('Error occured during linking ', source, ' to ', target);
                case FpGeterrno of
                    ESysENOENT:
                    begin
                        if not FileExists(source) then
                        begin
                            Writeln('Source file ', source, ' does not exist.');
                        end
                        else
                            Writeln('Target path ', target, ' is not valid.');
                        end;
                    end;

                    ESysEACCESS: Writeln('Write access denied at target path ', target);
                    // TODO: Handle other errors properly
                    ESysENOTDIR: Writeln('ENOTDIR')
            end;
    end;
    Close(manifestFile);
end.
