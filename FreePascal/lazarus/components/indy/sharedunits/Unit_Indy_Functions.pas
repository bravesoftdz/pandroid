unit Unit_Indy_Functions;
{$mode delphi}

interface

uses IdBaseComponent, IdContext, IdComponent, IdTCPConnection, IdTCPClient,
 // StdCtrls,
  SysUtils, Variants, Classes, Graphics, Controls, Forms, Unit_Indy_Classes;

type

  TGenericRecord<TRecordType> = class
  private
    FValue: TRecordType;
    FIsNil: Boolean;
  public
    function ByteArrayToMyRecord(ABuffer: TBytes): TRecordType;
    function MyRecordToByteArray(aRecord: TRecordType): TBytes;
    property Value: TRecordType read FValue write FValue;
    property IsNil: Boolean read FIsNil write FIsNil;
  end;

function ReceiveBuffer(AClient: TIdTCPClient; var ABuffer: TBytes): Boolean; overload;
function SendBuffer(AClient: TIdTCPClient; ABuffer: TBytes): Boolean; overload;
function ReceiveBuffer(AContext: TIdContext; var ABuffer: TBytes): Boolean; overload;
function SendBuffer(AContext: TIdContext; ABuffer: TBytes): Boolean; overload;
function SendStream(AContext: TIdContext; AStream: TStream): Boolean; overload;
function ReceiveStream(AContext: TIdContext; var AStream: TStream): Boolean; overload;
function ReceiveStream(AClient: TIdTCPClient; var AStream: TStream): Boolean; overload;
function SendStream(AClient: TIdTCPClient; AStream: TStream): Boolean; overload;
function ByteArrayToMyRecord(ABuffer: TBytes): TMyRecord;
function MyRecordToByteArray(aRecord: TMyRecord): TBytes;
function ClientSendFile(AClient: TIdTCPClient; Filename: String): Boolean;
function ClientReceiveFile(AClient: TIdTCPClient; Filename: String): Boolean;
function ServerSendFile(AContext: TIdContext; Filename: String): Boolean;
function ServerReceiveFile(AContext: TIdContext; ServerFilename: String; var ClientFilename: String): Boolean;

implementation

///
/// -------------   HELPER FUNCTION FOR RECORD EXCHANGE   ---------------------
///

function ReceiveBuffer(AClient: TIdTCPClient; var ABuffer: TBytes)
  : Boolean; overload;
var
  LSize: LongInt;
begin
  Result := True;
  try
    LSize := AClient.IOHandler.ReadLongInt();
    AClient.IOHandler.ReadBytes(ABuffer, LSize, False);
  except
    Result := False;
  end;
end;

function SendBuffer(AClient: TIdTCPClient; ABuffer: TBytes): Boolean; overload;
begin
  try
    Result := True;
    try
      AClient.IOHandler.Write(LongInt(Length(ABuffer)));
      AClient.IOHandler.WriteBufferOpen;
      AClient.IOHandler.Write(ABuffer, Length(ABuffer));
      AClient.IOHandler.WriteBufferFlush;
    finally
      AClient.IOHandler.WriteBufferClose;
    end;
  except
    Result := False;
  end;

end;

function SendBuffer(AContext: TIdContext; ABuffer: TBytes): Boolean; overload;
begin
  try
    Result := True;
    try
      AContext.Connection.IOHandler.Write(LongInt(Length(ABuffer)));
      AContext.Connection.IOHandler.WriteBufferOpen;
      AContext.Connection.IOHandler.Write(ABuffer, Length(ABuffer));
      AContext.Connection.IOHandler.WriteBufferFlush;
    finally
      AContext.Connection.IOHandler.WriteBufferClose;
    end;
  except
    Result := False;
  end;
end;

function ReceiveBuffer(AContext: TIdContext; var ABuffer: TBytes)
  : Boolean; overload;
var
  LSize: LongInt;
begin
  Result := True;
  try
    LSize := AContext.Connection.IOHandler.ReadLongInt();
    AContext.Connection.IOHandler.ReadBytes(ABuffer, LSize, False);
  except
    Result := False;
  end;
end;

///
/// ---------------------   HELP FUNCTION FOR STREAM  EXCHANGE  --------------
///

function ReceiveStream(AContext: TIdContext; var AStream: TStream)
  : Boolean; overload;
var
  LSize: LongInt;
begin
  Result := True;
  try
    LSize := AContext.Connection.IOHandler.ReadLongInt();
    AContext.Connection.IOHandler.ReadStream(AStream, LSize, False);
  except
    Result := False;
  end;
end;

function ReceiveStream(AClient: TIdTCPClient; var AStream: TStream)
  : Boolean; overload;
var
  LSize: LongInt;
begin
  Result := True;
  try
    LSize := AClient.IOHandler.ReadLongInt();
    AClient.IOHandler.ReadStream(AStream, LSize, False);
  except
    Result := False;
  end;
end;

function SendStream(AContext: TIdContext; AStream: TStream): Boolean; overload;
var
  StreamSize: LongInt;
begin
  try
    Result := True;
    try
      StreamSize := (AStream.Size);

      // AStream.Seek(0, soFromBeginning);

      AContext.Connection.IOHandler.Write(LongInt(StreamSize));
      AContext.Connection.IOHandler.WriteBufferOpen;
      AContext.Connection.IOHandler.Write(AStream, 0, False);
      AContext.Connection.IOHandler.WriteBufferFlush;
    finally
      AContext.Connection.IOHandler.WriteBufferClose;
    end;
  except
    Result := False;
  end;

end;

function SendStream(AClient: TIdTCPClient; AStream: TStream): Boolean; overload;
var
  StreamSize: LongInt;
begin
  try
    Result := True;
    try
      StreamSize := (AStream.Size);

      // AStream.Seek(0, soFromBeginning);
      // AClient.IOHandler.LargeStream := True;
      // AClient.IOHandler.SendBufferSize := 32768;

      AClient.IOHandler.Write(LongInt(StreamSize));
      AClient.IOHandler.WriteBufferOpen;
      AClient.IOHandler.Write(AStream, 0, False);
      AClient.IOHandler.WriteBufferFlush;
    finally
      AClient.IOHandler.WriteBufferClose;
    end;
  except
    Result := False;
  end;
end;

///
/// ---------------      HELPER FUNCTIONS FOR FILES EXCHANGE  ----------------
///
function ClientSendFile(AClient: TIdTCPClient; Filename: String): Boolean;
begin

  AClient.IOHandler.LargeStream := True; // fully support large streams
  Result := True;
  try
    AClient.IOHandler.WriteFile(Filename); // send file stream data
  except
    Result := False;
  end;

end;

function ClientReceiveFile(AClient: TIdTCPClient; Filename: String): Boolean;
begin

  /// todo ......

end;

function ServerSendFile(AContext: TIdContext; Filename: String): Boolean;
begin

  /// todo ......

end;

function ServerReceiveFile(AContext: TIdContext; ServerFilename: String;
  var ClientFilename: String): Boolean;
var
  // LSize: String;
  AStream: TFileStream;
begin
  try
    Result := True;
    AStream := TFileStream.Create(ServerFilename, fmCreate + fmShareDenyNone);
    try
      AContext.Connection.IOHandler.ReadStream(AStream);
    finally
      FreeAndNil(AStream);
    end;
  except
    Result := False;
  end;
end;

///
/// ---------------   HELPER FUNCTION FOR RECORD EXCHANGE  ------------------
/// (not using generic syntax features of DELPHI 2009 and better )

function MyRecordToByteArray(aRecord: TMyRecord): TBytes;
var
  LSource: PAnsiChar;
begin
  LSource := PAnsiChar(@aRecord);
  SetLength(Result, SizeOf(TMyRecord));
  Move(LSource[0], Result[0], SizeOf(TMyRecord));
end;

function ByteArrayToMyRecord(ABuffer: TBytes): TMyRecord;
var
  LDest: PAnsiChar;
begin
  LDest := PAnsiChar(@Result);
  Move(ABuffer[0], LDest[0], SizeOf(TMyRecord));
end;

function TGenericRecord<TRecordType>.MyRecordToByteArray
  (aRecord: TRecordType): TBytes;
var
  LSource: PAnsiChar;
begin
  LSource := PAnsiChar(@aRecord);
  SetLength(Result, SizeOf(TRecordType));
  Move(LSource[0], Result[0], SizeOf(TRecordType));
end;

function TGenericRecord<TRecordType>.ByteArrayToMyRecord(ABuffer: TBytes)
  : TRecordType;
var
  LDest: PAnsiChar;
begin
  LDest := PAnsiChar(@Result);
  Move(ABuffer[0], LDest[0], SizeOf(TRecordType));
end;

end.