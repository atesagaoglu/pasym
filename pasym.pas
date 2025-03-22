program pasym;
uses
    SysUtils,
    BaseUnix;
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

    while not eof(manifestFile) and (line <> ' ') do
    begin
        Readln(manifestFile, line);
        Write(line);
        delimit := Pos('->', line);

        // start and end are inclusive
        source := Copy(line, 1, delimit-1); // from start to arrow
        target := Copy(line, delimit+2, Length(line)); // from after arrow to end

        source := Trim(source);
        target := Trim(target);

        Writeln('source: ', source);
        Writeln('target: ', target)
        Writeln();

        // if not flagDry then
        //     fpSymlink(source, target);
    end;
    Close(manifestFile);
end.
