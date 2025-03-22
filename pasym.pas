program pasym;
uses
    SysUtils;
var
    fileName: string;
    manifestFile: textFile;
    Line: string;
begin
    
    if ParamCount = 1 then
    begin
        fileName := ParamStr(1);
    end
    else
    begin
        fileName := 'manifest.pasym';
    end;

    Assign(manifestFile, fileName);
    Reset(manifestFile);

    Line := '';

    while not eof(manifestFile) and (Line <> ' ') and FileExists(fileName) do
        begin
        Readln(manifestFile, Line);
        Writeln(Line);
        end;
    Close(manifestFile);
end.
