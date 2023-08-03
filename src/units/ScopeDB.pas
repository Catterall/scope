unit ScopeDB;

interface

uses
  ADODB;

type
  TScopeDB = class
  private
    FConnection: TADOConnection;
  public
    constructor Create(const aConnectionString: string);
    destructor Destroy; override;

    procedure Connect(const aConnectionString: string);
    procedure ExecuteQuery(Query: TADOQuery; const aSQL: string; IsSelectQuery: boolean = false);

    property Connection: TADOConnection read FConnection;
  end;

implementation

uses
  SysUtils;

{ TScopeDB }

constructor TScopeDB.Create(const aConnectionString: string);
begin
  Connect(aConnectionString);
end;

destructor TScopeDB.Destroy;
begin
  if Assigned(FConnection) then
  begin
    FConnection.Close;
    FreeAndNil(FConnection);
  end;
  inherited;
end;

procedure TScopeDB.Connect(const aConnectionString: string);
begin
  if (Trim(aConnectionString) = '') then
    raise Exception.Create('Connection string cannot be empty');

  FConnection := TADOConnection.Create(nil);
  try
    FConnection.ConnectionString := aConnectionString;
    FConnection.Connected := True;
  except
    on E: Exception do
    begin
      FreeAndNil(FConnection);
      raise Exception.Create('Failed to connect to the database: ' + E.Message);
    end;
  end;
end;

procedure TScopeDB.ExecuteQuery(Query: TADOQuery; const aSQL: string; IsSelectQuery: boolean);
begin
  if not Assigned(FConnection) then
    raise Exception.Create('Database connection is not established');

  Query.Connection := FConnection;
  Query.SQL.Text := aSQL;
  if IsSelectQuery then
    Query.Open
  else
    Query.ExecSQL;
end;

end.

