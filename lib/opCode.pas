{ * opCode                                                                     * }
{ ****************************************************************************** }
{ * https://github.com/PassByYou888/CoreCipher                                 * }
{ * https://github.com/PassByYou888/ZServer4D                                  * }
{ * https://github.com/PassByYou888/zExpression                                * }
{ * https://github.com/PassByYou888/zTranslate                                 * }
{ * https://github.com/PassByYou888/zSound                                     * }
{ * https://github.com/PassByYou888/zAnalysis                                  * }
{ ****************************************************************************** }
unit opCode;

{$I zDefine.inc}

interface

uses SysUtils, Variants, Math, CoreClasses, PascalStrings, DoStatusIO,
  ListEngine, UnicodeMixedLib, DataFrameEngine;

type
  TOpValueType = (
    ovtBool, ovtInt, ovtInt64, ovtUInt64, ovtWord, ovtByte, ovtSmallInt, ovtShortInt, ovtUInt,
    ovtSingle, ovtDouble, ovtCurrency,
    ovtString, ovtProc,
    ovtUnknow);

  TOpCode = class;

  TOpParam = packed array of Variant;

  POpData = ^opData;

  opData = packed record
    Op: TOpCode;
    Value: Variant;
    ValueType: TOpValueType;
  end;

  TOnOpCall   = function(var Param: TOpParam)  : Variant;
  TOnOpMethod = function(var Param: TOpParam): Variant of object;
  {$IFNDEF FPC}
  TOnOpProc = reference to function(var Param: TOpParam): Variant;
  {$ENDIF FPC}

  TOpCustomRunTime = class(TCoreClassObject)
  private
    procedure FreeNotifyProc(p: Pointer);

    function DoInt(var Param: TOpParam): Variant;
    function DoFrac(var Param: TOpParam): Variant;
    function DoExp(var Param: TOpParam): Variant;
    function DoCos(var Param: TOpParam): Variant;
    function DoSin(var Param: TOpParam): Variant;
    function DoLn(var Param: TOpParam): Variant;
    function DoArcTan(var Param: TOpParam): Variant;
    function DoSqrt(var Param: TOpParam): Variant;
    function DoTan(var Param: TOpParam): Variant;
    function DoRound(var Param: TOpParam): Variant;
    function DoTrunc(var Param: TOpParam): Variant;

    function DoStr(var Param: TOpParam): Variant;

    function DoBool(var Param: TOpParam): Variant;
    function DoTrue(var Param: TOpParam): Variant;
    function DoFalse(var Param: TOpParam): Variant;
    function DoRandom(var Param: TOpParam): Variant;

    function DoGetFirst(var Param: TOpParam): Variant;
    function DoDeleteFirst(var Param: TOpParam): Variant;
    function DoGetLast(var Param: TOpParam): Variant;
    function DoDeleteLast(var Param: TOpParam): Variant;

    procedure InternalReg;
  public
    ProcList: THashList;

    constructor Create; overload; virtual;
    constructor Create(maxHashLen: Integer); overload; virtual;
    destructor Destroy; override;

    procedure RegOp(ProcName: SystemString; OnProc: TOnOpCall); overload;
    procedure RegOp(ProcName: SystemString; OnProc: TOnOpMethod); overload;
    {$IFNDEF FPC} procedure RegOp(ProcName: SystemString; OnProc: TOnOpProc); overload; {$ENDIF FPC}
  end;

  opClass = class of TOpCode;

  TOpCode = class(TCoreClassObject)
  private
    FParam       : TCoreClassList;
    FAutoFreeLink: Boolean;
    function doExecute(opRT: TOpCustomRunTime): Variant; virtual;
    function GetParam(index: Integer): POpData;
    procedure EvaluateParam(opRT: TOpCustomRunTime); overload;
    procedure EvaluateParam(printLog: Boolean; opRT: TOpCustomRunTime); overload;
  public
    Owner       : TOpCode;
    ParsedInfo  : SystemString;
    ParsedLineNo: Integer;

    constructor Create; overload;
    constructor Create(AFreeLink: Boolean); overload;
    destructor Destroy; override;

    procedure SaveToStream(Stream: TCoreClassStream);
    class function LoadFromStream(Stream: TCoreClassStream; out LoadedOp: TOpCode): Boolean;

    function AddValue(v: Variant): Integer; overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddValueT(v: Variant; vt: TOpValueType): Integer; overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddLink(obj: TOpCode): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    { }
    function CloneNewSelf: TOpCode;

    property Param[index: Integer]: POpData read GetParam; default;
    function Count: Integer;

    function Execute: Variant; overload;
    function Execute(opRT: TOpCustomRunTime): Variant; overload;

    property AutoFreeLink: Boolean read FAutoFreeLink write FAutoFreeLink;
  end;

  op_Value = class sealed(TOpCode)
  private
    // a
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Proc = class sealed(TOpCode)
  private
    // proc(a,b,c...)
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Add = class sealed(TOpCode)
  private
    // a + b + n...
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Sub = class sealed(TOpCode)
  private
    // a - b - n...
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Mul = class sealed(TOpCode)
  private
    // a * b * n...
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Div = class sealed(TOpCode)
  private
    // a / b / n...
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_IntDiv = class sealed(TOpCode)
  private
    // a div b div n...
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Pow = class sealed(TOpCode)
  private
    // a pow b
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Mod = class sealed(TOpCode)
  private
    // a mod b mod n...
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Or = class sealed(TOpCode)
  private
    // a or b or n...
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_And = class sealed(TOpCode)
  private
    // a and b and n...
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Xor = class sealed(TOpCode)
  private
    // a xor b xor n...
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Shl = class sealed(TOpCode)
  private
    // a shl b shl n...
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Shr = class sealed(TOpCode)
  private
    // a shr b shr n...
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Equal = class sealed(TOpCode)
  private
    // a = b
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_LessThan = class sealed(TOpCode)
  private
    // a < b
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_EqualOrLessThan = class sealed(TOpCode)
  private
    // a <= b
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_GreaterThan = class sealed(TOpCode)
  private
    // a > b
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_EqualOrGreaterThan = class sealed(TOpCode)
  private
    // a >= b
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_NotEqual = class sealed(TOpCode)
  private
    // a <> b
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Symbol_Sub = class sealed(TOpCode)
  private
    // -a
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Symbol_Add = class sealed(TOpCode)
  private
    // +a
    function doExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

function LoadOpFromStream(Stream: TCoreClassStream; out LoadedOp: TOpCode): Boolean;

var
  DefaultOpRT: TOpCustomRunTime;

implementation

type
  PopRTproc = ^TopRTproc;

  TopRTproc = packed record
    Param: TOpParam;
    Name: SystemString;
    OnOpCall: TOnOpCall;
    OnOpMethod: TOnOpMethod;
    {$IFNDEF FPC} OnOpProc: TOnOpProc; {$ENDIF FPC}
    procedure Init;
  end;

  opRegData = packed record
    opClass: opClass;
    OpName: TPascalString;
    Hash: Cardinal;
  end;

  POpRegData = ^opRegData;

var
  OpList: TCoreClassList;

procedure TopRTproc.Init;
begin
  SetLength(Param, 0);
  name := '';
  OnOpCall := nil;
  OnOpMethod := nil;
  {$IFNDEF FPC} OnOpProc := nil; {$ENDIF FPC}
end;

function GetRegistedOp(Name: TPascalString): POpRegData;
var
  i   : Integer;
  p   : POpRegData;
  Hash: Cardinal;
begin
  Result := nil;
  Hash := FastHashPascalString(@name);
  for i := 0 to OpList.Count - 1 do
    begin
      p := OpList[i];
      if (p^.Hash = Hash) and (SameText(name, p^.OpName)) then
          Exit(p);
    end;
end;

procedure RegisterOp(c: opClass);
var
  p: POpRegData;
begin
  if GetRegistedOp(c.ClassName) <> nil then
      raise Exception.Create('same op ' + c.ClassName);
  New(p);
  p^.opClass := c;
  p^.OpName := p^.opClass.ClassName;
  p^.Hash := FastHashPascalString(@p^.OpName);
  OpList.Add(p);
end;

procedure _FreeOp;
var
  i: Integer;
  p: POpRegData;
begin
  for i := 0 to OpList.Count - 1 do
    begin
      p := OpList[i];
      Dispose(p);
    end;
  DisposeObject(OpList);
end;

function LoadOpFromStream(Stream: TCoreClassStream; out LoadedOp: TOpCode): Boolean;

  function LoadFromDataFrame_1(CurDataEng: TDataFrameEngine): TOpCode;
  var
    AName     : SystemString;
    RegPtr    : POpRegData;
    i, cnt    : Integer;
    NeedNewOp : Boolean;
    newDataEng: TDataFrameEngine;
    v         : Variant;
    vt        : TOpValueType;
  begin
    AName := CurDataEng.Reader.ReadString;
    RegPtr := GetRegistedOp(AName);
    if RegPtr <> nil then
      begin
        Result := RegPtr^.opClass.Create;
        Result.ParsedInfo := CurDataEng.Reader.ReadString;
        Result.ParsedLineNo := CurDataEng.Reader.ReadInteger;
        cnt := CurDataEng.Reader.ReadInteger;
        for i := 0 to cnt - 1 do
          begin
            NeedNewOp := CurDataEng.Reader.ReadBool;

            if NeedNewOp then
              begin
                // create new TOpCode
                newDataEng := TDataFrameEngine.Create;
                CurDataEng.Reader.ReadDataFrame(newDataEng);
                Result.AddLink(LoadFromDataFrame_1(newDataEng));
                DisposeObject(newDataEng);
              end
            else
              begin
                v := CurDataEng.Reader.ReadVariant;
                vt := TOpValueType(CurDataEng.Reader.ReadInteger);
                Result.AddValueT(v, vt);
              end;
          end;
      end
    else
        raise Exception.Create('opCode failed');
  end;

var
  dataEng    : TDataFrameEngine;
  DataEdition: Integer;
begin
  Result := False;
  dataEng := TDataFrameEngine.Create;
  try
    dataEng.DecodeFrom(Stream, True);
    DataEdition := dataEng.Reader.ReadInteger;
    if DataEdition = 1 then
      begin
        LoadedOp := LoadFromDataFrame_1(dataEng);
        Result := True;
      end
    else
        LoadedOp := nil;
  except
  end;
  DisposeObject(dataEng);
end;

procedure TOpCustomRunTime.FreeNotifyProc(p: Pointer);
begin
  SetLength(PopRTproc(p)^.Param, 0);
  Dispose(PopRTproc(p));
end;

function TOpCustomRunTime.DoInt(var Param: TOpParam): Variant;
var
  v: Variant;
  i: Integer;
begin
  v := 0;
  for i := low(Param) to high(Param) do
      v := v + Param[i];
  Result := Int(v);
end;

function TOpCustomRunTime.DoFrac(var Param: TOpParam): Variant;
var
  v: Variant;
  i: Integer;
begin
  v := 0;
  for i := low(Param) to high(Param) do
      v := v + Param[i];
  Result := Frac(v);
end;

function TOpCustomRunTime.DoExp(var Param: TOpParam): Variant;
var
  v: Variant;
  i: Integer;
begin
  v := 0;
  for i := low(Param) to high(Param) do
      v := v + Param[i];
  Result := Exp(v);
end;

function TOpCustomRunTime.DoCos(var Param: TOpParam): Variant;
var
  v: Variant;
  i: Integer;
begin
  v := 0;
  for i := low(Param) to high(Param) do
      v := v + Param[i];
  Result := Cos(v);
end;

function TOpCustomRunTime.DoSin(var Param: TOpParam): Variant;
var
  v: Variant;
  i: Integer;
begin
  v := 0;
  for i := low(Param) to high(Param) do
      v := v + Param[i];
  Result := Sin(v);
end;

function TOpCustomRunTime.DoLn(var Param: TOpParam): Variant;
var
  v: Variant;
  i: Integer;
begin
  v := 0;
  for i := low(Param) to high(Param) do
      v := v + Param[i];
  Result := Ln(v);
end;

function TOpCustomRunTime.DoArcTan(var Param: TOpParam): Variant;
var
  v: Variant;
  i: Integer;
begin
  v := 0;
  for i := low(Param) to high(Param) do
      v := v + Param[i];
  Result := ArcTan(v);
end;

function TOpCustomRunTime.DoSqrt(var Param: TOpParam): Variant;
var
  v: Variant;
  i: Integer;
begin
  v := 0;
  for i := low(Param) to high(Param) do
      v := v + Param[i];
  Result := Sqrt(v);
end;

function TOpCustomRunTime.DoTan(var Param: TOpParam): Variant;
var
  v: Variant;
  i: Integer;
begin
  v := 0;
  for i := low(Param) to high(Param) do
      v := v + Param[i];
  Result := Tan(v);
end;

function TOpCustomRunTime.DoRound(var Param: TOpParam): Variant;
var
  v: Variant;
  i: Integer;
begin
  v := 0;
  for i := low(Param) to high(Param) do
      v := v + Param[i];
  Result := Round(Double(v));
end;

function TOpCustomRunTime.DoTrunc(var Param: TOpParam): Variant;
var
  v: Variant;
  i: Integer;
begin
  v := 0;
  for i := low(Param) to high(Param) do
      v := v + Param[i];
  Result := Trunc(Double(v));
end;

function TOpCustomRunTime.DoStr(var Param: TOpParam): Variant;
var
  n: TPascalString;
  i: Integer;
begin
  n := '';
  for i := low(Param) to high(Param) do
      n.Append(VarToStr(Param[i]));
  Result := n;
end;

function TOpCustomRunTime.DoBool(var Param: TOpParam): Variant;
  function v2b(const v: Variant): Boolean;
  var
    n: TPascalString;
  begin
    if VarIsStr(v) then
      begin
        n.Text := VarToStr(v);
        n := n.DeleteChar(#32#9);
        if n.Same('True') or n.Same('Yes') or n.Same('1') then
            Result := True
        else
            Result := False;
      end
    else if VarIsOrdinal(v) then
        Result := v > 0
    else if VarisFloat(v) then
        Result := v > 0
    else
        Result := v;
  end;

var
  n: Boolean;
  i: Integer;
begin
  n := True;
  for i := low(Param) to high(Param) do
      n := n and v2b(Param[i]);
  Result := n;
end;

function TOpCustomRunTime.DoTrue(var Param: TOpParam): Variant;
begin
  Result := True;
end;

function TOpCustomRunTime.DoFalse(var Param: TOpParam): Variant;
begin
  Result := False;
end;

function TOpCustomRunTime.DoRandom(var Param: TOpParam): Variant;
var
  v: NativeInt;
  i: Integer;
begin
  v := 0;
  for i := low(Param) to high(Param) do
      v := v + Param[i];

  if v <> 0 then
      Result := Random(v)
  else
      Result := Random(MaxInt);
end;

function TOpCustomRunTime.DoGetFirst(var Param: TOpParam): Variant;
begin
  if Length(Param) = 2 then
      Result := umlGetFirstStr(VarToStr(Param[0]), VarToStr(Param[1])).Text
  else
      Result := '';
end;

function TOpCustomRunTime.DoDeleteFirst(var Param: TOpParam): Variant;
begin
  if Length(Param) = 2 then
      Result := umlDeleteFirstStr(VarToStr(Param[0]), VarToStr(Param[1])).Text
  else
      Result := '';
end;

function TOpCustomRunTime.DoGetLast(var Param: TOpParam): Variant;
begin
  if Length(Param) = 2 then
      Result := umlGetLastStr(VarToStr(Param[0]), VarToStr(Param[1])).Text
  else
      Result := '';
end;

function TOpCustomRunTime.DoDeleteLast(var Param: TOpParam): Variant;
begin
  if Length(Param) = 2 then
      Result := umlDeleteLastStr(VarToStr(Param[0]), VarToStr(Param[1])).Text
  else
      Result := '';
end;

procedure TOpCustomRunTime.InternalReg;
begin
  {$IFDEF FPC}
  ProcList.OnDataFreeProc := @FreeNotifyProc;
  RegOp('Int', @DoInt);
  RegOp('Frac', @DoFrac);
  RegOp('Exp', @DoExp);
  RegOp('Cos', @DoCos);
  RegOp('Sin', @DoSin);
  RegOp('Ln', @DoLn);
  RegOp('ArcTan', @DoArcTan);
  RegOp('Sqrt', @DoSqrt);
  RegOp('Tan', @DoTan);
  RegOp('Round', @DoRound);
  RegOp('Trunc', @DoTrunc);

  RegOp('Str', @DoStr);

  RegOp('Bool', @DoBool);
  RegOp('True', @DoTrue);
  RegOp('False', @DoFalse);
  RegOp('Random', @DoRandom);

  RegOp('GetFirst', @DoGetFirst);
  RegOp('DeleteFirst', @DoDeleteFirst);
  RegOp('GetLast', @DoGetLast);
  RegOp('DeleteLast', @DoDeleteLast);
  {$ELSE }
  ProcList.OnDataFreeProc := FreeNotifyProc;
  RegOp('Int', DoInt);
  RegOp('Frac', DoFrac);
  RegOp('Exp', DoExp);
  RegOp('Cos', DoCos);
  RegOp('Sin', DoSin);
  RegOp('Ln', DoLn);
  RegOp('ArcTan', DoArcTan);
  RegOp('Sqrt', DoSqrt);
  RegOp('Tan', DoTan);
  RegOp('Round', DoRound);
  RegOp('Trunc', DoTrunc);

  RegOp('Str', DoStr);

  RegOp('Bool', DoBool);
  RegOp('True', DoTrue);
  RegOp('False', DoFalse);
  RegOp('Random', DoRandom);

  RegOp('GetFirst', DoGetFirst);
  RegOp('DeleteFirst', DoDeleteFirst);
  RegOp('GetLast', DoGetLast);
  RegOp('DeleteLast', DoDeleteLast);
  {$ENDIF FPC}
end;

constructor TOpCustomRunTime.Create;
begin
  inherited Create;
  ProcList := THashList.Create(256);
  ProcList.AutoFreeData := True;
  InternalReg;
end;

constructor TOpCustomRunTime.Create(maxHashLen: Integer);
begin
  inherited Create;
  ProcList := THashList.Create(maxHashLen);
  ProcList.AutoFreeData := True;
  InternalReg;
end;

destructor TOpCustomRunTime.Destroy;
begin
  DisposeObject(ProcList);
  inherited Destroy;
end;

procedure TOpCustomRunTime.RegOp(ProcName: SystemString; OnProc: TOnOpCall);
var
  p: PopRTproc;
begin
  New(p);
  p^.Init;
  p^.Name := ProcName;
  p^.OnOpCall := OnProc;
  ProcList.Add(ProcName, p);
end;

procedure TOpCustomRunTime.RegOp(ProcName: SystemString; OnProc: TOnOpMethod);
var
  p: PopRTproc;
begin
  New(p);
  p^.Init;
  p^.Name := ProcName;
  p^.OnOpMethod := OnProc;
  ProcList.Add(ProcName, p);
end;

{$IFNDEF FPC}


procedure TOpCustomRunTime.RegOp(ProcName: SystemString; OnProc: TOnOpProc);
var
  p: PopRTproc;
begin
  New(p);
  p^.Init;
  p^.Name := ProcName;
  p^.OnOpProc := OnProc;
  ProcList.Add(ProcName, p);
end;
{$ENDIF FPC}


function TOpCode.doExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := NULL;
end;

function TOpCode.GetParam(index: Integer): POpData;
begin
  Result := FParam[index];
end;

procedure TOpCode.EvaluateParam(opRT: TOpCustomRunTime);
begin
  EvaluateParam(False, opRT);
end;

procedure TOpCode.EvaluateParam(printLog: Boolean; opRT: TOpCustomRunTime);
var
  i: Integer;
  p: POpData;
begin
  for i := 0 to FParam.Count - 1 do
    begin
      p := FParam[i];
      if p^.Op <> nil then
        begin
          try
              p^.Op.EvaluateParam(printLog, opRT);
          except
          end;

          try
            p^.Value := p^.Op.doExecute(opRT);

            if printLog then
                DoStatus('%s value:%s', [ClassName, VarToStr(p^.Value)]);
          except
          end;
        end;
    end;
end;

constructor TOpCode.Create;
begin
  inherited Create;
  Owner := nil;
  FParam := TCoreClassList.Create;
  FAutoFreeLink := True;
  ParsedInfo := '';
  ParsedLineNo := 0;
end;

constructor TOpCode.Create(AFreeLink: Boolean);
begin
  inherited Create;
  Owner := nil;
  FParam := TCoreClassList.Create;
  FAutoFreeLink := AFreeLink;
  ParsedInfo := '';
  ParsedLineNo := 0;
end;

destructor TOpCode.Destroy;
var
  i: Integer;
  p: POpData;
begin
  if FParam <> nil then
    begin
      for i := 0 to FParam.Count - 1 do
        begin
          p := FParam[i];
          if (FAutoFreeLink) and (p^.Op <> nil) then
              DisposeObject(p^.Op);
          Dispose(p);
        end;
      FParam.Clear;
      DisposeObject(FParam);
    end;
  inherited Destroy;
end;

procedure TOpCode.SaveToStream(Stream: TCoreClassStream);
  procedure SaveToDataFrame(Op: TOpCode; CurDataEng: TDataFrameEngine);
  var
    i         : Integer;
    p         : POpData;
    newDataEng: TDataFrameEngine;
  begin
    CurDataEng.WriteString(Op.ClassName);
    CurDataEng.WriteString(Op.ParsedInfo);
    CurDataEng.WriteInteger(Op.ParsedLineNo);
    CurDataEng.WriteInteger(Op.Count);
    for i := 0 to Op.Count - 1 do
      begin
        p := Op[i];
        if p^.Op <> nil then
          begin
            CurDataEng.WriteBool(True);
            newDataEng := TDataFrameEngine.Create;
            SaveToDataFrame(p^.Op, newDataEng);
            CurDataEng.WriteDataFrame(newDataEng);
            DisposeObject(newDataEng);
          end
        else
          begin
            CurDataEng.WriteBool(False);
            CurDataEng.WriteVariant(p^.Value);
            CurDataEng.WriteInteger(Integer(p^.ValueType));
          end;
      end;
  end;

var
  dataEng: TDataFrameEngine;
begin
  dataEng := TDataFrameEngine.Create;
  dataEng.WriteInteger(1);
  SaveToDataFrame(Self, dataEng);
  dataEng.EncodeTo(Stream, True);
  DisposeObject(dataEng);
end;

class function TOpCode.LoadFromStream(Stream: TCoreClassStream; out LoadedOp: TOpCode): Boolean;
begin
  Result := LoadOpFromStream(Stream, LoadedOp);
end;

function TOpCode.AddValue(v: Variant): Integer;
var
  p: POpData;
begin
  New(p);
  p^.Op := nil;

  p^.Value := v;

  case VarType(v) of
    varSmallint: p^.ValueType := ovtSmallInt;
    varInteger: p^.ValueType := ovtInt;
    varSingle: p^.ValueType := ovtSingle;
    varDouble: p^.ValueType := ovtDouble;
    varCurrency: p^.ValueType := ovtCurrency;
    varBoolean: p^.ValueType := ovtBool;
    varShortInt: p^.ValueType := ovtShortInt;
    varByte: p^.ValueType := ovtByte;
    varWord: p^.ValueType := ovtWord;
    varLongWord: p^.ValueType := ovtUInt;
    varInt64: p^.ValueType := ovtInt64;
    varUInt64: p^.ValueType := ovtUInt64;
    else
      begin
        if VarIsStr(v) then
            p^.ValueType := ovtString
        else
            p^.ValueType := ovtUnknow;
      end;
  end;

  Result := FParam.Add(p);
end;

function TOpCode.AddValueT(v: Variant; vt: TOpValueType): Integer;
var
  p: POpData;
begin
  New(p);
  p^.Op := nil;
  p^.Value := v;
  p^.ValueType := vt;
  Result := FParam.Add(p);
end;

function TOpCode.AddLink(obj: TOpCode): Integer;
var
  p: POpData;
begin
  New(p);

  if obj.Owner <> nil then
      p^.Op := obj.CloneNewSelf
  else
      p^.Op := obj;

  p^.Op.Owner := Self;

  p^.Value := NULL;
  p^.ValueType := ovtUnknow;
  Result := FParam.Add(p);
end;

function TOpCode.CloneNewSelf: TOpCode;
var
  i: Integer;
  p: POpData;
begin
  Result := opClass(Self.ClassType).Create;
  Result.ParsedInfo := Self.ParsedInfo;
  Result.ParsedLineNo := Self.ParsedLineNo;

  for i := 0 to FParam.Count - 1 do
    begin
      p := FParam[i];
      if p^.Op <> nil then
          Result.AddLink(p^.Op.CloneNewSelf)
      else
          Result.AddValueT(p^.Value, p^.ValueType);
    end;
end;

function TOpCode.Count: Integer;
begin
  Result := FParam.Count;
end;

function TOpCode.Execute: Variant;
begin
  Result := Execute(DefaultOpRT);
end;

function TOpCode.Execute(opRT: TOpCustomRunTime): Variant;
begin
  try
      EvaluateParam(opRT);
  except
      Exit(NULL);
  end;

  try
      Result := doExecute(opRT);
  except
      Result := NULL;
  end;
end;

{ op_Value }

function op_Value.doExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := Param[0]^.Value;
end;

{ op_Proc }
function op_Proc.doExecute(opRT: TOpCustomRunTime): Variant;
var
  p: PopRTproc;
  i: Integer;
begin
  Result := 0;
  if (opRT = nil) then
      opRT := DefaultOpRT;

  p := opRT.ProcList[VarToStr(Param[0]^.Value)];
  if p = nil then
    begin
      if opRT = DefaultOpRT then
          Exit;
      p := DefaultOpRT.ProcList[VarToStr(Param[0]^.Value)];
      if p = nil then
          Exit;
    end;

  if Length(p^.Param) <> Count - 1 then
      SetLength(p^.Param, Count - 1);

  for i := 1 to Count - 1 do
      p^.Param[i - 1] := Param[i]^.Value;

  if Assigned(p^.OnOpCall) then
      Result := p^.OnOpCall(p^.Param);
  if Assigned(p^.OnOpMethod) then
      Result := p^.OnOpMethod(p^.Param);
  {$IFNDEF FPC}
  if Assigned(p^.OnOpProc) then
      Result := p^.OnOpProc(p^.Param);
  {$ENDIF FPC}
end;

{ op_Add }

function op_Add.doExecute(opRT: TOpCustomRunTime): Variant;

  function Fast_VarIsStr(var v: Variant): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF}
  var
    p: PVarData;
  begin
    // optimized
    p := @TVarData(v);
    while p^.VType = varByRef or varVariant do
        p := PVarData(p^.VPointer);
    Result := (p^.VType = varOleStr) or (p^.VType = varString) or (p^.VType = varUString);
  end;

var
  i     : Integer;
  n1, n2: TPascalString;
begin
  if Count = 0 then
      Exit(NULL);
  Result := Param[0]^.Value;

  if Fast_VarIsStr(Result) then
    begin
      // optimized
      n1 := VarToStr(Result);
      for i := 1 to Count - 1 do
        begin
          try
              n1.Append(VarToStr(Param[i]^.Value));
          except
          end;
        end;
      Result := n1.Text;
    end
  else
    begin
      for i := 1 to Count - 1 do
        begin
          try
            if Fast_VarIsStr(Result) then
              begin
                // SystemString combine
                n1 := VarToStr(Result);
                if not umlIsNumber(n1) then
                  begin
                    Result := n1 + VarToStr(Param[i]^.Value);
                    continue;
                  end
              end;

            if Fast_VarIsStr(Param[i]^.Value) then
              begin
                // SystemString combine
                n2 := VarToStr(Param[i]^.Value);
                if not umlIsNumber(n2) then
                  begin
                    Result := VarToStr(Result) + n2;
                    continue;
                  end
              end;

            // logic compute
            Result := Result + Param[i]^.Value;
          except
          end;
        end;
    end;
end;

{ op_Sub }

function op_Sub.doExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(NULL);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result - Param[i]^.Value;
end;

{ op_Mul }

function op_Mul.doExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(NULL);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result * Param[i]^.Value;
end;

{ op_Div }

function op_Div.doExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(NULL);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result / Param[i]^.Value;
end;

{ op_IntDiv }

function op_IntDiv.doExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(NULL);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result div Param[i]^.Value;
end;

{ op_Pow }
function op_Pow.doExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(NULL);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Power(Result, Param[i]^.Value);
end;

{ op_Mod }

function op_Mod.doExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(NULL);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result mod Param[i]^.Value;
end;

{ op_Or }

function op_Or.doExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(NULL);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result or Param[i]^.Value;
end;

{ op_And }

function op_And.doExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(NULL);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result and Param[i]^.Value;
end;

{ op_Xor }

function op_Xor.doExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(NULL);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result xor Param[i]^.Value;
end;

{ op_shl }

function op_Shl.doExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(NULL);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := UInt64(Result) shl UInt64(Param[i]^.Value);
end;

{ op_shr }

function op_Shr.doExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(NULL);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := UInt64(Result) shr UInt64(Param[i]^.Value);
end;

{ op_Equal }

function op_Equal.doExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := Param[0]^.Value = Param[1]^.Value;
end;

{ op_LessThan }

function op_LessThan.doExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := Param[0]^.Value < Param[1]^.Value;
end;

{ op_EqualOrLessThan }

function op_EqualOrLessThan.doExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := Param[0]^.Value <= Param[1]^.Value;
end;

{ op_GreaterThan }

function op_GreaterThan.doExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := Param[0]^.Value > Param[1]^.Value;
end;

{ op_EqualOrGreaterThan }

function op_EqualOrGreaterThan.doExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := Param[0]^.Value >= Param[1]^.Value;
end;

{ op_NotEqual }

function op_NotEqual.doExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := Param[0]^.Value <> Param[1]^.Value;
end;

{ op_Symbol_Sub }

function op_Symbol_Sub.doExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := -Param[0]^.Value;
end;

{ op_Symbol_Add }

function op_Symbol_Add.doExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := (Param[0]^.Value);
end;

initialization

DefaultOpRT := TOpCustomRunTime.Create;
OleVariantInt64AsDouble := True;

OpList := TCoreClassList.Create;

RegisterOp(op_Value);
RegisterOp(op_Proc);
RegisterOp(op_Add);
RegisterOp(op_Sub);
RegisterOp(op_Mul);
RegisterOp(op_Div);
RegisterOp(op_IntDiv);
RegisterOp(op_Mod);
RegisterOp(op_Or);
RegisterOp(op_And);
RegisterOp(op_Xor);
RegisterOp(op_Shl);
RegisterOp(op_Shr);
RegisterOp(op_Equal);
RegisterOp(op_LessThan);
RegisterOp(op_EqualOrLessThan);
RegisterOp(op_GreaterThan);
RegisterOp(op_EqualOrGreaterThan);
RegisterOp(op_NotEqual);
RegisterOp(op_Symbol_Sub);
RegisterOp(op_Symbol_Add);

finalization

DisposeObject(DefaultOpRT);
_FreeOp;

end.
