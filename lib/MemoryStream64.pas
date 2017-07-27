unit MemoryStream64;
{
  create by passbyyou
  2011-10
}

interface

uses
  ZLib,
{$IFDEF FPC}
  zstream,
{$ENDIF}
  CoreClasses, SysUtils, UnicodeMixedLib;

type
  TMemoryStream64 = class(TCoreClassMemoryStream)
  private
    function GetAsBytes: TBytes;
    procedure SetAsBytes(const Value: TBytes);
  public
    property AsBytes: TBytes read GetAsBytes write SetAsBytes;
  end;

{$IFDEF FPC}

  TDecompressionStream = class(zstream.TDecompressionStream)
  public
  end;

  { TCompressionStream }

  TCompressionStream = class(zstream.TCompressionStream)
  public
    constructor Create(stream: TCoreClassStream); overload;
    constructor Create(level: Tcompressionlevel; stream: TCoreClassStream); overload;
  end;
{$ELSE}

  TDecompressionStream = TZDecompressionStream;
  TCompressionStream = TZCompressionStream;
{$ENDIF}

function MaxCompressStream(Sour: TCoreClassStream; ComTo: TCoreClassStream): Boolean;
function FastCompressStream(Sour: TCoreClassStream; ComTo: TCoreClassStream): Boolean;
function CompressStream(Sour: TCoreClassStream; ComTo: TCoreClassStream): Boolean;
function DecompressStream(Sour: TCoreClassStream; DeTo: TCoreClassStream): Boolean;
function DecompressStreamToPtr(Sour: TCoreClassStream; var DeTo: Pointer): Boolean;

implementation

function TMemoryStream64.GetAsBytes: TBytes;
var
  bk: Int64;
begin
  bk := Position;
  Position := 0;

  SetLength(Result, size);
  read(Result, size);

  Position := bk;
end;

procedure TMemoryStream64.SetAsBytes(const Value: TBytes);
begin
  Clear;
  write(Value, Length(Value));
end;

{$IFDEF FPC}


constructor TCompressionStream.Create(stream: TCoreClassStream);
begin
  inherited Create(clfastest, stream);
end;

constructor TCompressionStream.Create(level: Tcompressionlevel; stream: TCoreClassStream);
begin
  inherited Create(level, stream);
end;
{$ENDIF}


function MaxCompressStream(Sour: TCoreClassStream; ComTo: TCoreClassStream): Boolean;
var
  cp: TCompressionStream;
  sizevalue: Int64;
begin
  Result := False;
  try
    sizevalue := Sour.size;
    ComTo.WriteBuffer(sizevalue, umlInt64Length);
    if Sour.size > 0 then
      begin
        Sour.Position := 0;
        cp := TCompressionStream.Create(clMax, ComTo);
        Result := cp.CopyFrom(Sour, sizevalue) = sizevalue;
        DisposeObject(cp);
      end;
  except
  end;
end;

function FastCompressStream(Sour: TCoreClassStream; ComTo: TCoreClassStream): Boolean;
var
  cp: TCompressionStream;
  sizevalue: Int64;
begin
  Result := False;
  try
    sizevalue := Sour.size;
    ComTo.WriteBuffer(sizevalue, umlInt64Length);
    if Sour.size > 0 then
      begin
        Sour.Position := 0;
        cp := TCompressionStream.Create(clfastest, ComTo);
        Result := cp.CopyFrom(Sour, sizevalue) = sizevalue;
        DisposeObject(cp);
      end;
  except
  end;
end;

function CompressStream(Sour: TCoreClassStream; ComTo: TCoreClassStream): Boolean;
var
  cp: TCompressionStream;
  sizevalue: Int64;
begin
  Result := False;
  try
    sizevalue := Sour.size;
    ComTo.WriteBuffer(sizevalue, umlInt64Length);
    if Sour.size > 0 then
      begin
        Sour.Position := 0;
        cp := TCompressionStream.Create(clDefault, ComTo);
        Result := cp.CopyFrom(Sour, sizevalue) = sizevalue;
        DisposeObject(cp);
      end;
  except
  end;
end;

function DecompressStream(Sour: TCoreClassStream; DeTo: TCoreClassStream): Boolean;
var
  DC: TDecompressionStream;
  DeSize: Int64;
begin
  Result := False;
  Sour.ReadBuffer(DeSize, umlInt64Length);
  if DeSize > 0 then
    begin
      try
        DC := TDecompressionStream.Create(Sour);
        Result := DeTo.CopyFrom(DC, DeSize) = DeSize;
        DisposeObject(DC);
      except
      end;
    end;
end;

function DecompressStreamToPtr(Sour: TCoreClassStream; var DeTo: Pointer): Boolean;
var
  DC: TDecompressionStream;
  DeSize: Int64;
begin
  Result := False;
  try
    Sour.ReadBuffer(DeSize, umlInt64Length);
    if DeSize > 0 then
      begin
        DC := TDecompressionStream.Create(Sour);
        GetMem(DeTo, DeSize);
        Result := DC.Read(DeTo^, DeSize) = DeSize;
        DisposeObject(DC);
      end;
  except
  end;
end;

initialization

finalization

end.
