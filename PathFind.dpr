program PathFind;

{$APPTYPE CONSOLE}

  uses
    SysUtils, Windows;

  const
    TotalFilesFound: Integer = 0;


  function UpCaseStr (s: string): string;
    var
      i: Integer;
  begin
    for i := 1 to Length (s) do
      s[i] := UpCase (s[i]);
    Result := s;
  end;


  function GetEnv (const Name: string): string;
    var
      BufSize: Integer;
  begin
    BufSize := GetEnvironmentVariable (PChar (Name), nil, 0);
    if BufSize > 0 then
    begin
      SetLength (Result, BufSize - 1);
      GetEnvironmentVariable (PChar (Name), PChar (Result), BufSize);
    end
    else
      Result := '';
  end;


  function GetNthVar (const Path: string; N: Integer): string;
    { returns the Nth string in a ';'-separated string (zero based) }
    var
      i: Integer;
      c: Char;
  begin
    Result := '';
    i := 1;
    while (i <= Length (Path)) do
    begin
      c := Path[i];
      if (c = ';') then
        Dec (N)
      else
        if (N = 0) then
          Result := Result + c;
      Inc (i);
    end;
  end;


  procedure Check (CurPath: string; Name: string; Ext: string);
    var
      FullName: string;
      SR: TSearchRec;
  begin
    FullName := CurPath + '\' + Name + Ext;
    if (FileExists (FullName)) then
    begin
      if (SysUtils.FindFirst (FullName, faAnyFile, SR) = 0) then
      begin
        repeat
          WriteLn (CurPath + '\' + SR.Name);
          Inc (TotalFilesFound);
        until SysUtils.FindNext (SR) <> 0;
        SysUtils.FindClose (SR);
      end;
    end;
  end;


  var
    Query: string;
    HasExt: Boolean;
    PathExt,
    Path: string;
    i,
    j: Integer;
    CurPath,
    CurExt: string;
    ch: Char;

begin
  if (ParamCount () < 1) then
    WriteLn ('usage: PathFind [executable]')
  else
  begin
    Path := GetEnv ('PATH');
    Query := ParamStr (1);

    // option /L [search string]
    // list all paths in PATH (containing search string)

    if (Query = '/l') or (Query = '/L') then
    begin
      Query := '';
      if (ParamCount () >= 2) then
      begin
        Query := ParamStr (2);
        for i := 3 to ParamCount () do
          Query := Query + ' ' + ParamStr (i);

        ch := '"';
        if (Query[1] = ch) and (Query[Length (Query)] = ch) then
          Query := Copy (Query, 2, Length (Query) - 2);
      end;

      CurPath := '';
      for i := 1 to Length (Path) do
      begin
        ch := Path[i];
        if (ch = ';') then
        begin
          if (Query = '') or (Pos (UpCaseStr (Query), UpCaseStr (CurPath)) > 0) then
            WriteLn (CurPath);
          CurPath := '';
        end
        else
          CurPath := CurPath + ch;
      end;

    end
    else
    begin
      HasExt := Pos ('.', Query) > 0;

      PathExt := GetEnv ('PATHEXT');

      i := 0;
      CurPath := GetNthVar (Path, i);
      while (CurPath <> '') do
      begin

        if HasExt then
          Check (CurPath, Query, '')
        else
        begin

          j := 0;
          CurExt := GetNthVar (PathExt, j);
          while (CurExt <> '') do
          begin
            Check (CurPath, Query, CurExt);

            Inc (j);
            CurExt := GetNthVar (PathExt, j);
          end;

        end;

        Inc (i);
        CurPath := GetNthVar (Path, i);
      end;

      if (TotalFilesFound = 0) then
        WriteLn ('File not found');
    end;
  end;

end.
