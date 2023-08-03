unit ScopeDBObjects;

interface

uses
  ADODB, SysUtils,

  ScopeDB;

type
  TScopeDBObject = class
  protected
    FID: Integer;
    FName: string;
    FBriefDescription: string;
    FLongDescription: string;
    FScopeDB: TScopeDB;

    function GetSelectSQL(const ID: Integer): string; virtual; abstract;
    function GetUpdateSQL: string; virtual; abstract;

    procedure PopulateFields(Query: TADOQuery); virtual;
    procedure ClearFields; virtual;
  public
    constructor Create(aScopeDB: TScopeDB; const ID: Integer);
    procedure Write;

    property ID: Integer read FID;
    property Name: string read FName write FName;
    property BriefDescription: string read FBriefDescription write FBriefDescription;
    property LongDescription: string read FLongDescription write FLongDescription;
  end;

implementation

{ TScopeDBObject }

constructor TScopeDBObject.Create(aScopeDB: TScopeDB; const ID: Integer);
var
  qry: TADOQuery;
begin
  if not Assigned(aScopeDB) then
    raise Exception.Create('TScopeDB instance cannot be nil');

  if not Assigned(aScopeDB.Connection) then
    raise Exception.Create('TScopeDB should have a valid connection');

  FScopeDB := aScopeDB;

  qry := TADOQuery.Create(nil);
  try
    FScopeDB.ExecuteQuery(qry, GetSelectSQL(ID), True);
    if not qry.Eof then
    begin
      FID := ID;
      PopulateFields(qry);
    end
    else
      ClearFields;
  finally
    qry.Free;
  end;
end;

procedure TScopeDBObject.Write;
var
  qry: TADOQuery;
begin
  qry := TADOQuery.Create(nil);
  try
    FScopeDB.ExecuteQuery(qry, GetUpdateSQL);
  finally
    qry.Free;
  end;
end;

procedure TScopeDBObject.PopulateFields(Query: TADOQuery);
begin
  FName := Query.FieldByName('Name').AsString;
  FBriefDescription := Query.FieldByName('BriefDescription').AsString;
  FLongDescription := Query.FieldByName('LongDescription').AsString;
end;

procedure TScopeDBObject.ClearFields;
begin
  FID := 0;
  FName := '';
  FBriefDescription := '';
  FLongDescription := '';
end;

end.

