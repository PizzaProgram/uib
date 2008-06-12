unit mypool;
{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface
uses PDGUtils, SuperObject, jvUIB;

type
  TMyPool = class(TConnexionPool)
  private
    FDatabaseName: string;
    FUserName: string;
    FPassWord: string;
    FSQLDialect: Integer;
  protected
    procedure ConfigureConnexion(Database: TJvUIBDataBase); override;
  public
    constructor Create(MaxSize: Integer = 0); override;
  end;

  function QueryToJson(qr: TJvUIBQuery): ISuperObject;

var
  pool: TMyPool;

implementation
uses SysUtils, jvuiblib, PDGSocketStub;

{ TMyPool }

procedure TMyPool.ConfigureConnexion(Database: TJvUIBDataBase);
begin
  Database.DatabaseName := FDatabaseName;
  Database.UserName := FUserName;
  Database.PassWord := FPassWord;
  Database.SQLDialect := FSQLDialect;
  // one thread should try to connect to database at the same time
  // this eliminate dead lock when there is too many thread trying to connect
  Database.Connected := true;
end;

constructor TMyPool.Create(MaxSize: Integer = 0);
begin
  inherited Create(MaxSize);
  with TSuperObject.Parse(
    PChar(
      FileToString(
        ExtractFilePath(ParamStr(0)) + 'appserver.json'))) do
  begin
    FDatabaseName := s['database.databasename'];
    FUserName := s['database.username'];
    FPassWord := s['database.password'];
    FSQLDialect := i['database.sqldialect'];
  end;
end;

function QueryToJson(qr: TJvUIBQuery): ISuperObject;
var

















      uftBlob, uftBlobId:
      begin
        if qr.Fields.Data^.sqlvar[i].SqlSubType = 1 then
          rec.S['type'] := 'string' else
          rec.S['type'] := 'binary';
      end;
      uftTimestamp, uftDate, uftTime: rec.S['type'] := 'timestamp';
      {$IFDEF IB7_UP}



















        uftBlob, uftBlobId:
          begin
            qr.ReadBlob(i, str);
            if qr.Fields.Data^.sqlvar[i].SqlSubType = 1 then
              rec.AsArray.Add(TSuperObject.Create(PChar(str))) else
              rec.AsArray.Add(TSuperObject.Create(PChar(StrTobase64(str))));
          end;
        uftTimestamp, uftDate, uftTime: rec.AsArray.Add(TSuperObject.Create(PChar(qr.Fields.AsString[i])));
        {$IFDEF IB7_UP}









initialization
  pool := TMyPool.Create(0);

finalization
  while TPDGThread.ThreadCount > 0 do sleep(100);
  pool.Free;

end.