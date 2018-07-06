{ * opCode                                                                     * }
{ ****************************************************************************** }
{ * https://github.com/PassByYou888/CoreCipher                                 * }
{ * https://github.com/PassByYou888/ZServer4D                                  * }
{ * https://github.com/PassByYou888/zExpression                                * }
{ * https://github.com/PassByYou888/zTranslate                                 * }
{ * https://github.com/PassByYou888/zSound                                     * }
{ * https://github.com/PassByYou888/zAnalysis                                  * }
{ * https://github.com/PassByYou888/zGameWare                                  * }
{ * https://github.com/PassByYou888/zRasterization                             * }
{ ****************************************************************************** }
unit OpCode;

{$INCLUDE zDefine.inc}

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

  TOnOpCall   = function(var Param: TOpParam): Variant;
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
    FParam: TCoreClassList;
    FAutoFreeLink: Boolean;
    function DoExecute(opRT: TOpCustomRunTime): Variant; virtual;
    function GetParam(index: Integer): POpData;
    procedure EvaluateParam(opRT: TOpCustomRunTime); overload;
    procedure EvaluateParam(printLog: Boolean; opRT: TOpCustomRunTime); overload;
  public
    Owner: TOpCode;
    ParsedInfo: SystemString;
    ParsedLineNo: Integer;

    constructor Create; overload;
    constructor Create(AFreeLink: Boolean); overload;
    destructor Destroy; override;

    procedure SaveToStream(stream: TCoreClassStream);
    class function LoadFromStream(stream: TCoreClassStream; out LoadedOp: TOpCode): Boolean;

    function AddValue(v: Variant): Integer; overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddValueT(v: Variant; VT: TOpValueType): Integer; overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddLink(Obj: TOpCode): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF}
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
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Proc = class sealed(TOpCode)
  private
    // proc(a,b,c...)
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Add = class sealed(TOpCode)
  private
    // a + b + n...
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Sub = class sealed(TOpCode)
  private
    // a - b - n...
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Mul = class sealed(TOpCode)
  private
    // a * b * n...
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Div = class sealed(TOpCode)
  private
    // a / b / n...
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_IntDiv = class sealed(TOpCode)
  private
    // a div b div n...
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Pow = class sealed(TOpCode)
  private
    // a pow b
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Mod = class sealed(TOpCode)
  private
    // a mod b mod n...
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Or = class sealed(TOpCode)
  private
    // a or b or n...
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_And = class sealed(TOpCode)
  private
    // a and b and n...
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Xor = class sealed(TOpCode)
  private
    // a xor b xor n...
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Shl = class sealed(TOpCode)
  private
    // a shl b shl n...
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Shr = class sealed(TOpCode)
  private
    // a shr b shr n...
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Equal = class sealed(TOpCode)
  private
    // a = b
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_LessThan = class sealed(TOpCode)
  private
    // a < b
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_EqualOrLessThan = class sealed(TOpCode)
  private
    // a <= b
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_GreaterThan = class sealed(TOpCode)
  private
    // a > b
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_EqualOrGreaterThan = class sealed(TOpCode)
  private
    // a >= b
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_NotEqual = class sealed(TOpCode)
  private
    // a <> b
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Symbol_Sub = class sealed(TOpCode)
  private
    // -a
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

  op_Symbol_Add = class sealed(TOpCode)
  private
    // +a
    function DoExecute(opRT: TOpCustomRunTime): Variant; override;
  end;

function LoadOpFromStream(stream: TCoreClassStream; out LoadedOp: TOpCode): Boolean;

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
    hash: Cardinal;
  end;

  POpRegData = ^opRegData;

var
  OpList: TCoreClassList;

procedure TopRTproc.Init;
begin
  SetLength(Param, 0);
  Name := '';
  OnOpCall := nil;
  OnOpMethod := nil;
{$IFNDEF FPC} OnOpProc := nil; {$ENDIF FPC}
end;

function GetRegistedOp(Name: TPascalString): POpRegData;
var
  i: Integer;
  p: POpRegData;
  hash: Cardinal;
begin
  Result := nil;
  hash := FastHashPascalString(@Name);
  for i := 0 to OpList.Count - 1 do
    begin
      p := OpList[i];
      if (p^.hash = hash) and (SameText(Name, p^.OpName)) then
          Exit(p);
    end;
end;

procedure RegisterOp(C: opClass);
var
  p: POpRegData;
begin
  if GetRegistedOp(C.ClassName) <> nil then
      raise Exception.Create('same op ' + C.ClassName);
  new(p);
  p^.opClass := C;
  p^.OpName := p^.opClass.ClassName;
  p^.hash := FastHashPascalString(@p^.OpName);
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

function LoadOpFromStream(stream: TCoreClassStream; out LoadedOp: TOpCode): Boolean;

  function LoadFromDataFrame_1(CurDataEng: TDataFrameEngine): TOpCode;
  var
    AName: SystemString;
    RegPtr: POpRegData;
    i, cnt: Integer;
    NeedNewOp: Boolean;
    newDataEng: TDataFrameEngine;
    v: Variant;
    VT: TOpValueType;
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
                VT := TOpValueType(CurDataEng.Reader.ReadInteger);
                Result.AddValueT(v, VT);
              end;
          end;
      end
    else
        raise Exception.Create('opCode failed');
  end;

var
  DataEng: TDataFrameEngine;
  DataEdition: Integer;
begin
  Result := False;
  DataEng := TDataFrameEngine.Create;
  try
    DataEng.DecodeFrom(stream, True);
    DataEdition := DataEng.Reader.ReadInteger;
    if DataEdition = 1 then
      begin
        LoadedOp := LoadFromDataFrame_1(DataEng);
        Result := True;
      end
    else
        LoadedOp := nil;
  except
  end;
  DisposeObject(DataEng);
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
  Result := ln(v);
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
    else if VarIsFloat(v) then
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
  v: Integer;
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
  if length(Param) = 2 then
      Result := umlGetFirstStr(VarToStr(Param[0]), VarToStr(Param[1])).Text
  else
      Result := '';
end;

function TOpCustomRunTime.DoDeleteFirst(var Param: TOpParam): Variant;
begin
  if length(Param) = 2 then
      Result := umlDeleteFirstStr(VarToStr(Param[0]), VarToStr(Param[1])).Text
  else
      Result := '';
end;

function TOpCustomRunTime.DoGetLast(var Param: TOpParam): Variant;
begin
  if length(Param) = 2 then
      Result := umlGetLastStr(VarToStr(Param[0]), VarToStr(Param[1])).Text
  else
      Result := '';
end;

function TOpCustomRunTime.DoDeleteLast(var Param: TOpParam): Variant;
begin
  if length(Param) = 2 then
      Result := umlDeleteLastStr(VarToStr(Param[0]), VarToStr(Param[1])).Text
  else
      Result := '';
end;

procedure TOpCustomRunTime.InternalReg;
begin
  ProcList.OnFreePtr := {$IFDEF FPC}@{$ENDIF FPC}FreeNotifyProc;
  RegOp('Int', {$IFDEF FPC}@{$ENDIF FPC}DoInt);
  RegOp('Frac', {$IFDEF FPC}@{$ENDIF FPC}DoFrac);
  RegOp('Exp', {$IFDEF FPC}@{$ENDIF FPC}DoExp);
  RegOp('Cos', {$IFDEF FPC}@{$ENDIF FPC}DoCos);
  RegOp('Sin', {$IFDEF FPC}@{$ENDIF FPC}DoSin);
  RegOp('Ln', {$IFDEF FPC}@{$ENDIF FPC}DoLn);
  RegOp('ArcTan', {$IFDEF FPC}@{$ENDIF FPC}DoArcTan);
  RegOp('Sqrt', {$IFDEF FPC}@{$ENDIF FPC}DoSqrt);
  RegOp('Tan', {$IFDEF FPC}@{$ENDIF FPC}DoTan);
  RegOp('Round', {$IFDEF FPC}@{$ENDIF FPC}DoRound);
  RegOp('Trunc', {$IFDEF FPC}@{$ENDIF FPC}DoTrunc);

  RegOp('Str', {$IFDEF FPC}@{$ENDIF FPC}DoStr);

  RegOp('Bool', {$IFDEF FPC}@{$ENDIF FPC}DoBool);
  RegOp('True', {$IFDEF FPC}@{$ENDIF FPC}DoTrue);
  RegOp('False', {$IFDEF FPC}@{$ENDIF FPC}DoFalse);
  RegOp('Random', {$IFDEF FPC}@{$ENDIF FPC}DoRandom);

  RegOp('GetFirst', {$IFDEF FPC}@{$ENDIF FPC}DoGetFirst);
  RegOp('DeleteFirst', {$IFDEF FPC}@{$ENDIF FPC}DoDeleteFirst);
  RegOp('GetLast', {$IFDEF FPC}@{$ENDIF FPC}DoGetLast);
  RegOp('DeleteLast', {$IFDEF FPC}@{$ENDIF FPC}DoDeleteLast);
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
  new(p);
  p^.Init;
  p^.Name := ProcName;
  p^.OnOpCall := OnProc;
  ProcList.Add(ProcName, p, True);
end;

procedure TOpCustomRunTime.RegOp(ProcName: SystemString; OnProc: TOnOpMethod);
var
  p: PopRTproc;
begin
  new(p);
  p^.Init;
  p^.Name := ProcName;
  p^.OnOpMethod := OnProc;
  ProcList.Add(ProcName, p, True);
end;

{$IFNDEF FPC}


procedure TOpCustomRunTime.RegOp(ProcName: SystemString; OnProc: TOnOpProc);
var
  p: PopRTproc;
begin
  new(p);
  p^.Init;
  p^.Name := ProcName;
  p^.OnOpProc := OnProc;
  ProcList.Add(ProcName, p, True);
end;
{$ENDIF FPC}


function TOpCode.DoExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := Null;
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
            p^.Value := p^.Op.DoExecute(opRT);

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

procedure TOpCode.SaveToStream(stream: TCoreClassStream);
  procedure SaveToDataFrame(Op: TOpCode; CurDataEng: TDataFrameEngine);
  var
    i: Integer;
    p: POpData;
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
  DataEng: TDataFrameEngine;
begin
  DataEng := TDataFrameEngine.Create;
  DataEng.WriteInteger(1);
  SaveToDataFrame(Self, DataEng);
  DataEng.EncodeTo(stream, True);
  DisposeObject(DataEng);
end;

class function TOpCode.LoadFromStream(stream: TCoreClassStream; out LoadedOp: TOpCode): Boolean;
begin
  Result := LoadOpFromStream(stream, LoadedOp);
end;

function TOpCode.AddValue(v: Variant): Integer;
var
  p: POpData;
begin
  new(p);
  p^.Op := nil;

  p^.Value := v;

  case VarType(v) of
    varSmallInt: p^.ValueType := ovtSmallInt;
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

function TOpCode.AddValueT(v: Variant; VT: TOpValueType): Integer;
var
  p: POpData;
begin
  new(p);
  p^.Op := nil;
  p^.Value := v;
  p^.ValueType := VT;
  Result := FParam.Add(p);
end;

function TOpCode.AddLink(Obj: TOpCode): Integer;
var
  p: POpData;
begin
  new(p);

  if Obj.Owner <> nil then
      p^.Op := Obj.CloneNewSelf
  else
      p^.Op := Obj;

  p^.Op.Owner := Self;

  p^.Value := Null;
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
      Exit(Null);
  end;

  try
      Result := DoExecute(opRT);
  except
      Result := Null;
  end;
end;

{ op_Value }

function op_Value.DoExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := Param[0]^.Value;
end;

{ op_Proc }
function op_Proc.DoExecute(opRT: TOpCustomRunTime): Variant;
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

  if length(p^.Param) <> Count - 1 then
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

function op_Add.DoExecute(opRT: TOpCustomRunTime): Variant;

  function Fast_VarIsStr(var v: Variant): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF}
  var
    p: pVarData;
  begin
    // optimized
    p := @TVarData(v);
    while p^.VType = varByRef or varVariant do
        p := pVarData(p^.VPointer);
    Result := (p^.VType = varOleStr) or (p^.VType = varString) or (p^.VType = varUString);
  end;

var
  i: Integer;
  N1, N2: TPascalString;
begin
  if Count = 0 then
      Exit(Null);
  Result := Param[0]^.Value;

  if Fast_VarIsStr(Result) then
    begin
      // optimized
      N1 := VarToStr(Result);
      for i := 1 to Count - 1 do
        begin
          try
              N1.Append(VarToStr(Param[i]^.Value));
          except
          end;
        end;
      Result := N1.Text;
    end
  else
    begin
      for i := 1 to Count - 1 do
        begin
          try
            if Fast_VarIsStr(Result) then
              begin
                // SystemString combine
                N1 := VarToStr(Result);
                if not umlIsNumber(N1) then
                  begin
                    Result := N1 + VarToStr(Param[i]^.Value);
                    Continue;
                  end
              end;

            if Fast_VarIsStr(Param[i]^.Value) then
              begin
                // SystemString combine
                N2 := VarToStr(Param[i]^.Value);
                if not umlIsNumber(N2) then
                  begin
                    Result := VarToStr(Result) + N2;
                    Continue;
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

function op_Sub.DoExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(Null);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result - Param[i]^.Value;
end;

{ op_Mul }

function op_Mul.DoExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(Null);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result * Param[i]^.Value;
end;

{ op_Div }

function op_Div.DoExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(Null);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result / Param[i]^.Value;
end;

{ op_IntDiv }

function op_IntDiv.DoExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(Null);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result div Param[i]^.Value;
end;

{ op_Pow }
function op_Pow.DoExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(Null);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Power(Result, Param[i]^.Value);
end;

{ op_Mod }

function op_Mod.DoExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(Null);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result mod Param[i]^.Value;
end;

{ op_Or }

function op_Or.DoExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(Null);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result or Param[i]^.Value;
end;

{ op_And }

function op_And.DoExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(Null);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result and Param[i]^.Value;
end;

{ op_Xor }

function op_Xor.DoExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(Null);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := Result xor Param[i]^.Value;
end;

{ op_shl }

function op_Shl.DoExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(Null);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := UInt64(Result) shl UInt64(Param[i]^.Value);
end;

{ op_shr }

function op_Shr.DoExecute(opRT: TOpCustomRunTime): Variant;
var
  i: Integer;
begin
  if Count = 0 then
      Exit(Null);
  Result := Param[0]^.Value;
  for i := 1 to Count - 1 do
      Result := UInt64(Result) shr UInt64(Param[i]^.Value);
end;

{ op_Equal }

function op_Equal.DoExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := Param[0]^.Value = Param[1]^.Value;
end;

{ op_LessThan }

function op_LessThan.DoExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := Param[0]^.Value < Param[1]^.Value;
end;

{ op_EqualOrLessThan }

function op_EqualOrLessThan.DoExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := Param[0]^.Value <= Param[1]^.Value;
end;

{ op_GreaterThan }

function op_GreaterThan.DoExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := Param[0]^.Value > Param[1]^.Value;
end;

{ op_EqualOrGreaterThan }

function op_EqualOrGreaterThan.DoExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := Param[0]^.Value >= Param[1]^.Value;
end;

{ op_NotEqual }

function op_NotEqual.DoExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := Param[0]^.Value <> Param[1]^.Value;
end;

{ op_Symbol_Sub }

function op_Symbol_Sub.DoExecute(opRT: TOpCustomRunTime): Variant;
begin
  Result := -Param[0]^.Value;
end;

{ op_Symbol_Add }

function op_Symbol_Add.DoExecute(opRT: TOpCustomRunTime): Variant;
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
 
