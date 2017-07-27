unit TextDataEngine;

interface

uses SysUtils, Variants,
  // Hash
  ListEngine, CoreClasses;

type
  TSectionTextData = class;

  THashTextEngine = TSectionTextData;

  TSectionTextData = class(TCoreClassObject)
  private
    FComment                             : TCoreClassStrings;
    FSectionTextList, FSectionVariantList: THashObjectList;
    FAutoUpdateDefaultValue              : Boolean;
    FMaxHashBlock                        : Integer;

    function GetNames(aName: string): TCoreClassStrings;
    procedure SetNames(aName: string; const Value: TCoreClassStrings);
    function GetHit(aSectionName, _VariantName: string): Variant;
    procedure SetHit(aSectionName, _VariantName: string; const Value: Variant);
    function GetVariantList(aName: string): THashVariantList;
    procedure SetVariantList(aName: string; const Value: THashVariantList);
    // return override state
    function AddDataSection(aSection: string; TextList: TCoreClassStrings): Boolean;
  public
    constructor Create; overload;
    constructor Create(AHashBlock: Integer); overload;
    destructor Destroy; override;

    procedure ReBuildList;
    procedure Clear;
    procedure Delete(aName: string);

    function Exists(aName: string): Boolean;

    function GetDefaultValue(const SectionName, KeyName: string; const DefaultValue: Variant): Variant;
    procedure SetDefaultValue(const SectionName, KeyName: string; const Value: Variant);

    // import section
    function DataImport(TextList: TCoreClassStrings): Boolean;

    // export section
    procedure DataExport(TextList: TCoreClassStrings);

    procedure Merge(sour: TSectionTextData);
    procedure Assign(sour: TSectionTextData);
    function Same(sour: TSectionTextData): Boolean;

    procedure LoadFromStream(Stream: TCoreClassStream);
    procedure SaveToStream(Stream: TCoreClassStream);

    procedure LoadFromFile(FileName: string);
    procedure SaveToFile(FileName: string);

    function GetAsText: string;
    procedure SetAsText(const Value: string);
    property AsText: string read GetAsText write SetAsText;

    procedure GetSectionList(Dest: TCoreClassStrings);
    function GetSectionObjectName(_Obj: THashVariantList): string;

    property AutoUpdateDefaultValue: Boolean read FAutoUpdateDefaultValue write FAutoUpdateDefaultValue;
    property Comment: TCoreClassStrings read FComment write FComment;
    property Hit[aSectionName, _VariantName: string]: Variant read GetHit write SetHit; default;
    property Names[aName: string]: TCoreClassStrings read GetNames write SetNames;
    property Texts[aName: string]: TCoreClassStrings read GetNames write SetNames;
    property Strings[aName: string]: TCoreClassStrings read GetNames write SetNames;
    property VariantList[aName: string]: THashVariantList read GetVariantList write SetVariantList;
  end;

  THashVariantTextStream = class(TCoreClassObject)
  private
    FVariantList: THashVariantList;

    function GetNames(aName: string): Variant;
    procedure SetNames(aName: string; const Value: Variant);
  public
    constructor Create(_VList: THashVariantList);
    destructor Destroy; override;
    procedure Clear;

    function VToStr(v: Variant; _EncodeString: Boolean): string; inline;
    function StrToV(_TextString: string): Variant; inline;

    procedure DataImport(TextList: TCoreClassStrings);
    procedure DataExport(TextList: TCoreClassStrings);
    procedure LoadFromStream(Stream: TCoreClassStream);
    procedure SaveToStream(Stream: TCoreClassStream);
    procedure LoadFromFile(FileName: string);
    procedure SaveToFile(FileName: string);
    procedure LoadFromText(aText: string);

    procedure SaveToText(var aText: string); overload;
    function Text: string;

    function GetValue(aName: string; v: Variant): Variant;

    property Names[aName: string]: Variant read GetNames write SetNames; default;
    property VariantList: THashVariantList read FVariantList write FVariantList;
  end;

implementation

uses UnicodeMixedLib, PascalStrings;

function TSectionTextData.GetNames(aName: string): TCoreClassStrings;
var
  h: THashVariantTextStream;
begin
  if not FSectionTextList.Exists(aName) then
      FSectionTextList[aName] := TCoreClassStringList.Create;

  if FSectionVariantList.Exists(aName) then
    begin
      Result := TCoreClassStringList.Create;
      h := THashVariantTextStream.Create(THashVariantList(FSectionVariantList[aName]));
      h.DataExport(Result);
      DisposeObject(h);

      FSectionTextList[aName] := Result;
    end;

  Result := TCoreClassStrings(FSectionTextList[aName]);
end;

procedure TSectionTextData.SetNames(aName: string; const Value: TCoreClassStrings);
var
  ns: TCoreClassStrings;
begin
  ns := TCoreClassStringList.Create;
  ns.Assign(Value);
  FSectionTextList[aName] := ns;
  FSectionVariantList.Delete(aName);
end;

function TSectionTextData.GetHit(aSectionName, _VariantName: string): Variant;
var
  nsl: TCoreClassStrings;
  vl : THashVariantList;
  vt : THashVariantTextStream;
begin
  Result := NULL;
  vl := THashVariantList(FSectionVariantList[aSectionName]);
  if vl = nil then
    begin
      nsl := Names[aSectionName];
      if nsl = nil then
          Exit;
      if nsl.Count = 0 then
          Exit;
      vl := THashVariantList.Create(FMaxHashBlock);
      vl.AutoUpdateDefaultValue := AutoUpdateDefaultValue;

      vt := THashVariantTextStream.Create(vl);
      vt.DataImport(nsl);
      DisposeObject(vt);

      FSectionVariantList[aSectionName] := vl;
    end;
  Result := vl[_VariantName];
end;

procedure TSectionTextData.SetHit(aSectionName, _VariantName: string; const Value: Variant);
var
  nsl: TCoreClassStrings;
  vl : THashVariantList;
  vt : THashVariantTextStream;
begin
  vl := THashVariantList(FSectionVariantList[aSectionName]);
  if vl = nil then
    begin
      vl := THashVariantList.Create(FMaxHashBlock);
      vl.AutoUpdateDefaultValue := AutoUpdateDefaultValue;

      nsl := Names[aSectionName];
      if nsl <> nil then
        begin
          vt := THashVariantTextStream.Create(vl);
          vt.DataImport(nsl);
          DisposeObject(vt);
        end;
      FSectionVariantList[aSectionName] := vl;
    end;
  vl[_VariantName] := Value;
end;

function TSectionTextData.GetVariantList(aName: string): THashVariantList;
var
  nsl: TCoreClassStrings;
  vt : THashVariantTextStream;
begin
  Result := THashVariantList(FSectionVariantList[aName]);
  if Result = nil then
    begin
      Result := THashVariantList.Create(FMaxHashBlock);
      Result.AutoUpdateDefaultValue := FAutoUpdateDefaultValue;
      nsl := Names[aName];
      if nsl <> nil then
        begin
          vt := THashVariantTextStream.Create(Result);
          vt.DataImport(nsl);
          DisposeObject(vt);
        end;

      FSectionVariantList[aName] := Result;
    end;
end;

procedure TSectionTextData.SetVariantList(aName: string; const Value: THashVariantList);
var
  h: THashVariantTextStream;
begin
  FSectionVariantList[aName] := Value;
  if not FSectionTextList.Exists(aName) then
      FSectionTextList[aName] := TCoreClassStringList.Create;
  h := THashVariantTextStream.Create(Value);
  TCoreClassStrings(FSectionTextList[aName]).Clear;
  h.DataExport(TCoreClassStrings(FSectionTextList[aName]));
  DisposeObject(h);
end;

function TSectionTextData.AddDataSection(aSection: string; TextList: TCoreClassStrings): Boolean;
var
  _Obj: TCoreClassObject;
begin
  while (TextList.Count > 0) and (TextList[0] = '') do
      TextList.Delete(0);
  while (TextList.Count > 0) and (TextList[TextList.Count - 1] = '') do
      TextList.Delete(TextList.Count - 1);

  FSectionTextList.Add(aSection, TextList);
end;

constructor TSectionTextData.Create;
begin
  inherited Create;
  FMaxHashBlock := 10;
  FComment := TCoreClassStringList.Create;
  FSectionTextList := THashObjectList.Create(True, FMaxHashBlock);
  FSectionVariantList := THashObjectList.Create(True, FMaxHashBlock);
  FAutoUpdateDefaultValue := False;
end;

constructor TSectionTextData.Create(AHashBlock: Integer);
begin
  inherited Create;
  FMaxHashBlock := AHashBlock;
  FComment := TCoreClassStringList.Create;
  FSectionTextList := THashObjectList.Create(True, FMaxHashBlock);
  FSectionVariantList := THashObjectList.Create(True, FMaxHashBlock);
  FAutoUpdateDefaultValue := False;
end;

destructor TSectionTextData.Destroy;
begin
  Clear;
  DisposeObject(FSectionTextList);
  DisposeObject(FSectionVariantList);
  DisposeObject(FComment);
  inherited Destroy;
end;

procedure TSectionTextData.ReBuildList;
var
  i        : Integer;
  tmpSecLst: TCoreClassStrings;
  nsl      : TCoreClassStrings;
  h        : THashVariantTextStream;
begin
  tmpSecLst := TCoreClassStringList.Create;

  FSectionVariantList.GetListData(tmpSecLst);
  if tmpSecLst.Count > 0 then
    for i := 0 to tmpSecLst.Count - 1 do
      begin
        nsl := TCoreClassStringList.Create;
        h := THashVariantTextStream.Create(THashVariantList(tmpSecLst.Objects[i]));
        h.DataExport(nsl);
        DisposeObject(h);
        FSectionTextList[tmpSecLst[i]] := nsl;
      end;

  FSectionVariantList.Clear;
  DisposeObject(tmpSecLst);
end;

procedure TSectionTextData.Clear;
begin
  FSectionTextList.Clear;
  FSectionVariantList.Clear;
  FComment.Clear;
end;

procedure TSectionTextData.Delete(aName: string);
begin
  FSectionTextList.Delete(aName);
  FSectionVariantList.Delete(aName);
end;

function TSectionTextData.Exists(aName: string): Boolean;
begin
  Result := FSectionTextList.Exists(aName) or FSectionVariantList.Exists(aName);
end;

function TSectionTextData.GetDefaultValue(const SectionName, KeyName: string; const DefaultValue: Variant): Variant;
begin
  Result := VariantList[SectionName].GetDefaultValue(KeyName, DefaultValue);
end;

procedure TSectionTextData.SetDefaultValue(const SectionName, KeyName: string; const Value: Variant);
begin
  Hit[SectionName, KeyName] := Value;
end;

function TSectionTextData.DataImport(TextList: TCoreClassStrings): Boolean;
var
  i    : Integer;
  nsect: string;
  ntLst: TCoreClassStrings;

  tmpSecLst: TCoreClassStrings;
  nsl      : TCoreClassStrings;
  vt       : THashVariantTextStream;
begin
  // merge section
  tmpSecLst := TCoreClassStringList.Create;
  FSectionVariantList.GetListData(tmpSecLst);
  if tmpSecLst.Count > 0 then
    for i := 0 to tmpSecLst.Count - 1 do
      begin
        vt := THashVariantTextStream.Create(THashVariantList(tmpSecLst.Objects[i]));
        nsl := TCoreClassStringList.Create;
        FSectionTextList[tmpSecLst[i]] := nsl;
        vt.DataExport(nsl);
        DisposeObject(vt);
      end;
  DisposeObject(tmpSecLst);
  FSectionVariantList.Clear;
  // import new section
  ntLst := nil;
  nsect := '';
  Result := False;
  if Assigned(TextList) then
    begin
      if TextList.Count > 0 then
        begin
          i := 0;
          while i < TextList.Count do
            begin
              if umlMultipleMatch(False, '[*]', umlTrimChar(TextList[i], ' ')) then
                begin
                  if Result then
                      AddDataSection(nsect, ntLst);
                  ntLst := TCoreClassStringList.Create;
                  nsect := umlGetFirstStr(TextList[i], '[]').Text;
                  Result := True;
                end
              else if Result then
                begin
                  ntLst.Append(TextList[i]);
                end
              else
                begin
                  if TextList[i] <> '' then
                      FComment.Append(TextList[i]);
                end;
              Inc(i);
            end;
          if Result then
              AddDataSection(nsect, ntLst);
        end;

      while (FComment.Count > 0) and (FComment[0] = '') do
          FComment.Delete(0);
      while (FComment.Count > 0) and (FComment[FComment.Count - 1] = '') do
          FComment.Delete(FComment.Count - 1);
    end;
end;

procedure TSectionTextData.DataExport(TextList: TCoreClassStrings);
var
  i        : Integer;
  tmpSecLst: TCoreClassStrings;
  nsl      : TCoreClassStrings;
  vt       : THashVariantTextStream;
begin
  TextList.AddStrings(FComment);
  if FComment.Count > 0 then
      TextList.Append('');
  tmpSecLst := TCoreClassStringList.Create;

  FSectionVariantList.GetListData(tmpSecLst);
  if tmpSecLst.Count > 0 then
    for i := 0 to tmpSecLst.Count - 1 do
      begin
        vt := THashVariantTextStream.Create(THashVariantList(tmpSecLst.Objects[i]));
        nsl := TCoreClassStringList.Create;
        FSectionTextList[tmpSecLst[i]] := nsl;
        vt.DataExport(nsl);
        DisposeObject(vt);
      end;

  FSectionTextList.GetListData(tmpSecLst);
  if tmpSecLst.Count > 0 then
    for i := 0 to tmpSecLst.Count - 1 do
      if (tmpSecLst.Objects[i] is TCoreClassStrings) then
        begin
          nsl := TCoreClassStrings(tmpSecLst.Objects[i]);
          if nsl <> nil then
            begin
              TextList.Append('[' + tmpSecLst[i] + ']');
              TextList.AddStrings(nsl);
              TextList.Append('');
            end;
        end;

  DisposeObject(tmpSecLst);
end;

procedure TSectionTextData.Merge(sour: TSectionTextData);
var
  ns: TCoreClassStringList;
begin
  try
    ReBuildList;
    ns := TCoreClassStringList.Create;
    sour.ReBuildList;
    sour.DataExport(ns);
    DataImport(ns);
    DisposeObject(ns);
    ReBuildList;
  except
  end;
end;

procedure TSectionTextData.Assign(sour: TSectionTextData);
var
  ns: TCoreClassStringList;
begin
  try
    ns := TCoreClassStringList.Create;
    sour.ReBuildList;
    sour.DataExport(ns);
    Clear;
    DataImport(ns);
    DisposeObject(ns);
  except
  end;
end;

function TSectionTextData.Same(sour: TSectionTextData): Boolean;
var
  i : Integer;
  ns: TCoreClassStringList;
  n : string;
begin
  Result := False;
  ReBuildList;
  sour.ReBuildList;

  // if Comment.Text <> sour.Comment.Text then
  // Exit;

  if FSectionTextList.Count <> sour.FSectionTextList.Count then
      Exit;

  ns := TCoreClassStringList.Create;

  for i := 0 to ns.Count - 1 do
    begin
      n := ns[i];
      if not sour.Exists(n) then
        begin
          DisposeObject(ns);
          Exit;
        end;
    end;

  for i := 0 to ns.Count - 1 do
    begin
      n := ns[i];
      if not SameText(Strings[n].Text, sour.Strings[n].Text) then
        begin
          DisposeObject(ns);
          Exit;
        end;
    end;

  DisposeObject(ns);
  Result := True;
end;

procedure TSectionTextData.LoadFromStream(Stream: TCoreClassStream);
var
  n: TCoreClassStrings;
begin
  Clear;
  n := TCoreClassStringList.Create;
  {$IFDEF FPC}
  n.LoadFromStream(Stream);
  {$ELSE}
  n.LoadFromStream(Stream, TEncoding.UTF8);
  {$ENDIF}
  DataImport(n);
  DisposeObject(n);
end;

procedure TSectionTextData.SaveToStream(Stream: TCoreClassStream);
var
  n: TCoreClassStrings;
begin
  n := TCoreClassStringList.Create;
  DataExport(n);
  {$IFDEF FPC}
  n.SaveToStream(Stream);
  {$ELSE}
  n.SaveToStream(Stream, TEncoding.UTF8);
  {$ENDIF}
  DisposeObject(n);
end;

procedure TSectionTextData.LoadFromFile(FileName: string);
var
  ns: TCoreClassStream;
begin
  ns := TCoreClassFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
      LoadFromStream(ns);
  finally
      DisposeObject(ns);
  end;
end;

procedure TSectionTextData.SaveToFile(FileName: string);
var
  ns: TCoreClassStream;
begin
  ns := TCoreClassFileStream.Create(FileName, fmCreate);
  try
      SaveToStream(ns);
  finally
      DisposeObject(ns);
  end;
end;

function TSectionTextData.GetAsText: string;
var
  ns: TCoreClassStringList;
begin
  ns := TCoreClassStringList.Create;
  DataExport(ns);
  Result := ns.Text;
  DisposeObject(ns);
end;

procedure TSectionTextData.SetAsText(const Value: string);
var
  ns: TCoreClassStringList;
begin
  Clear;

  ns := TCoreClassStringList.Create;
  ns.Text := Value;
  DataImport(ns);
  DisposeObject(ns);
end;

procedure TSectionTextData.GetSectionList(Dest: TCoreClassStrings);
var
  i        : Integer;
  tmpSecLst: TCoreClassStrings;
  nsl      : TCoreClassStrings;
  vt       : THashVariantTextStream;
begin
  tmpSecLst := TCoreClassStringList.Create;
  FSectionVariantList.GetListData(tmpSecLst);
  if tmpSecLst.Count > 0 then
    for i := 0 to tmpSecLst.Count - 1 do
      begin
        vt := THashVariantTextStream.Create(THashVariantList(tmpSecLst.Objects[i]));
        nsl := TCoreClassStringList.Create;
        FSectionTextList[tmpSecLst[i]] := nsl;
        vt.DataExport(nsl);
        DisposeObject(vt);
      end;
  DisposeObject(tmpSecLst);

  FSectionTextList.GetListData(Dest);
end;

function TSectionTextData.GetSectionObjectName(_Obj: THashVariantList): string;
begin
  Result := FSectionVariantList.GetObjAsName(_Obj);
end;

function THashVariantTextStream.GetNames(aName: string): Variant;
begin
  if FVariantList <> nil then
      Result := FVariantList[aName]
  else
      Result := NULL;
end;

procedure THashVariantTextStream.SetNames(aName: string; const Value: Variant);
begin
  if FVariantList <> nil then
      FVariantList[aName] := Value;
end;

constructor THashVariantTextStream.Create(_VList: THashVariantList);
begin
  inherited Create;
  FVariantList := _VList;
end;

destructor THashVariantTextStream.Destroy;
begin
  inherited Destroy;
end;

procedure THashVariantTextStream.Clear;
begin
  if FVariantList <> nil then
      FVariantList.Clear;
end;

function THashVariantTextStream.VToStr(v: Variant; _EncodeString: Boolean): string;
var
  n: umlString;
begin
  try
    case VarType(v) of
      varSmallint, varInteger, varShortInt, varByte, varWord, varLongWord:
        begin
          Result := IntToStr(v);
        end;
      varInt64:
        begin
          Result := IntToStr(int64(v));
        end;
      varUInt64:
        begin
          Result := UIntToStr(UInt64(v));
        end;
      varSingle, varDouble, varCurrency, varDate:
        begin
          Result := FloatToStr(v);
        end;
      varOleStr, varString, varUString:
        begin
          if _EncodeString then
            begin
              n.Text := VarToStr(v);

              if umlExistsLimitChar(n, #10#13#9#8#0) then
                  Result := '___base64:' + umlEncodeLineBASE64(n).Text
              else
                  Result := n.Text;
            end
          else
              Result := VarToStr(v);
        end;
      varBoolean:
        begin
          Result := BoolToStr(v, True);
        end;
      else
        Result := VarToStr(v);
    end;
  except
      Result := '';
  end;
end;

function THashVariantTextStream.StrToV(_TextString: string): Variant;
begin
  try
    if umlMultipleMatch(True, '___base64:*', umlTrimSpace(_TextString)) then
      begin
        _TextString := umlDeleteFirstStr(umlTrimSpace(_TextString), ':').Text;
        Result := umlDecodeLineBASE64(_TextString).Text;
      end
    else
      begin
        case umlGetNumTextType(_TextString) of
          ntBool: Result := StrToBool(_TextString);
          ntInt: Result := StrToInt(_TextString);
          ntInt64: Result := StrToInt64(_TextString);
          {$IFDEF FPC}
          ntUInt64: Result := StrToQWord(_TextString);
          {$ELSE}
          ntUInt64: Result := StrToUInt64(_TextString);
          {$ENDIF}
          ntWord: Result := StrToInt(_TextString);
          ntByte: Result := StrToInt(_TextString);
          ntSmallInt: Result := StrToInt(_TextString);
          ntShortInt: Result := StrToInt(_TextString);
          ntUInt: Result := StrToInt(_TextString);
          ntSingle: Result := StrToFloat(_TextString);
          ntDouble: Result := StrToFloat(_TextString);
          ntCurrency: Result := StrToFloat(_TextString);
          else Result := _TextString;
        end;
      end;
  except
      Result := _TextString;
  end;
end;

procedure THashVariantTextStream.DataImport(TextList: TCoreClassStrings);
var
  i                 : Integer;
  _TextString, aName: string;
begin
  if FVariantList = nil then
      Exit;
  if TextList.Count > 0 then
    for i := 0 to TextList.Count - 1 do
      begin
        _TextString := TextList[i];
        if (umlMultipleMatch(False, '*:*', _TextString)) or (umlMultipleMatch(False, '*=*', _TextString)) then
          begin
            aName := umlGetFirstStr_M(_TextString, ':=').Text;
            if aName <> '' then
              begin
                _TextString := umlDeleteFirstStr_M(_TextString, ':=').Text;
                FVariantList[aName] := StrToV(_TextString);
              end;
          end
        else
            FVariantList[_TextString] := StrToV('');
      end;
end;

procedure THashVariantTextStream.DataExport(TextList: TCoreClassStrings);
var
  i  : Integer;
  vl : TCoreClassList;
  v  : Variant;
  _VS: string;
begin
  if FVariantList = nil then
      Exit;
  vl := TCoreClassList.Create;
  FVariantList.HashList.GetListData(vl);
  if vl.Count > 0 then
    for i := 0 to vl.Count - 1 do
      begin
        v := PHashVariantListData(PHashListData(vl[i])^.Data)^.v;
        _VS := VToStr(v, True);

        if _VS <> '' then
            TextList.Append((PHashListData(vl[i])^.OriginName + ':' + _VS))
        else
            TextList.Append(PHashListData(vl[i])^.OriginName);
      end;
  DisposeObject(vl);
end;

procedure THashVariantTextStream.LoadFromStream(Stream: TCoreClassStream);
var
  n: TCoreClassStrings;
begin
  if FVariantList = nil then
      Exit;
  n := TCoreClassStringList.Create;
  {$IFDEF FPC}
  n.LoadFromStream(Stream);
  {$ELSE}
  n.LoadFromStream(Stream, TEncoding.UTF8);
  {$ENDIF}
  DataImport(n);
  DisposeObject(n);
end;

procedure THashVariantTextStream.SaveToStream(Stream: TCoreClassStream);
var
  n: TCoreClassStrings;
begin
  if FVariantList = nil then
      Exit;
  n := TCoreClassStringList.Create;
  DataExport(n);
  {$IFDEF FPC}
  n.SaveToStream(Stream);
  {$ELSE}
  n.SaveToStream(Stream, TEncoding.UTF8);
  {$ENDIF}
  DisposeObject(n);
end;

procedure THashVariantTextStream.LoadFromFile(FileName: string);
var
  ns: TCoreClassStream;
begin
  ns := TCoreClassFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
      LoadFromStream(ns);
  finally
      DisposeObject(ns);
  end;
end;

procedure THashVariantTextStream.SaveToFile(FileName: string);
var
  ns: TCoreClassStream;
begin
  ns := TCoreClassFileStream.Create(FileName, fmCreate);
  try
      SaveToStream(ns);
  finally
      DisposeObject(ns);
  end;
end;

procedure THashVariantTextStream.LoadFromText(aText: string);
var
  n: TCoreClassStrings;
begin
  if FVariantList = nil then
      Exit;
  n := TCoreClassStringList.Create;
  n.Text := aText;
  DataImport(n);
  DisposeObject(n);
end;

procedure THashVariantTextStream.SaveToText(var aText: string);
var
  n: TCoreClassStrings;
begin
  if FVariantList = nil then
      Exit;
  n := TCoreClassStringList.Create;
  DataExport(n);
  aText := n.Text;
  DisposeObject(n);
end;

function THashVariantTextStream.Text: string;
begin
  SaveToText(Result);
end;

function THashVariantTextStream.GetValue(aName: string; v: Variant): Variant;
begin
  Result := Names[aName];
  if VarIsNull(Result) then
    begin
      Names[aName] := v;
      Result := v;
    end;
end;

end.
