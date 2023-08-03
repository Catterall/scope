unit Bug;

interface

uses
  ADODB,

  ScopeDBObjects, ScopeDB, ScopeConsts;

type
  TBugPriority = class (TScopeDBObject)
  protected
    FWeight: Integer;

    function GetSelectSQL(const aID: Integer): string; override;
    function GetUpdateSQL: string; override;
    procedure PopulateFields(aQuery: TADOQuery); override;
  public
    constructor Create(aScopeDB: TScopeDB; const aID: Integer);

    property Weight: Integer read FWeight write FWeight;
  end;

  TBugCategory = class (TScopeDBObject)
  protected
    function GetSelectSQL(const aID: Integer): string; override;
    function GetUpdateSQL: string; override;
    procedure PopulateFields(aQuery: TADOQuery); override;
  public
    constructor Create(aScopeDB: TScopeDB; const aID: Integer);
  end;

  TBug = class (TScopeDBObject)
  protected
    FCategory: TBugCategory;
    FPriority: TBugPriority;

    function GetSelectSQL(const aID: Integer): string; override;
    function GetUpdateSQL: string; override;
    procedure PopulateFields(aQuery: TADOQuery); override;
  public
    constructor Create(aScopeDB: TScopeDB; const aID: Integer);
    destructor Destroy; override;

    property Category: TBugCategory read FCategory;
    property Priority: TBugPriority read FPriority;
  end;

implementation

uses
  SysUtils;

{ TBugPriority }

constructor TBugPriority.Create(aScopeDB: TScopeDB; const aID: Integer);
begin
  inherited Create(aScopeDB, ID);
end;

function TBugPriority.GetSelectSQL(const aID: Integer): string;
begin
  Result :=
    'SELECT Name, Weight, BriefDescription, LongDescription ' +
    'FROM ' + TBL_BUG_PRIORITY + ' WHERE ' + FLD_BUG_PRIORITY_ID + ' = ' + IntToStr(aID);
end;

function TBugPriority.GetUpdateSQL: string;
begin
  Result :=
    'UPDATE ' + TBL_BUG_PRIORITY + ' SET ' +
      FLD_STD_NAME + ' = ' + QuotedStr(FName) + ', ' +
      FLD_BUG_PRIORITY_WEIGHT + ' = ' + IntToStr(FWeight) + ', ' +
      FLD_STD_BRIEF_DESCRIPTION + ' = ' + QuotedStr(FBriefDescription) + ', ' +
      FLD_STD_LONG_DESCRIPTION + ' = ' + QuotedStr(FLongDescription) +
    ' WHERE ' + FLD_BUG_PRIORITY_ID + ' = ' + IntToStr(FID);
end;

procedure TBugPriority.PopulateFields(aQuery: TADOQuery);
begin
  inherited;
  FWeight := aQuery.FieldByName(FLD_BUG_PRIORITY_WEIGHT).AsInteger;
end;

{ TBugCategory }

constructor TBugCategory.Create(aScopeDB: TScopeDB; const aID: Integer);
begin
  inherited Create(aScopeDB, ID);
end;

function TBugCategory.GetSelectSQL(const aID: Integer): string;
begin
  Result :=
    'SELECT Name, BriefDescription, LongDescription ' +
    'FROM ' + TBL_BUG_CATEGORY + ' WHERE ' + FLD_BUG_CATEGORY_ID + ' = ' + IntToStr(aID);
end;

function TBugCategory.GetUpdateSQL: string;
begin
  Result :=
    'UPDATE ' + TBL_BUG_CATEGORY + ' SET ' +
      FLD_STD_NAME + ' = ' + QuotedStr(FName) + ', ' +
      FLD_STD_BRIEF_DESCRIPTION + ' = ' + QuotedStr(FBriefDescription) + ', ' +
      FLD_STD_LONG_DESCRIPTION + ' = ' + QuotedStr(FLongDescription) +
    ' WHERE ' + FLD_BUG_CATEGORY_ID + ' = ' + IntToStr(FID);
end;

procedure TBugCategory.PopulateFields(aQuery: TADOQuery);
begin
  inherited;
end;

{ TBug }

constructor TBug.Create(aScopeDB: TScopeDB; const aID: Integer);
begin
  inherited Create(aScopeDB, ID);
  FCategory := TBugCategory.Create(aScopeDB, 0);
  FPriority := TBugPriority.Create(aScopeDB, 0);
end;

destructor TBug.Destroy;
begin
  FCategory.Free;
  FPriority.Free;
  inherited Destroy;
end;

function TBug.GetSelectSQL(const aID: Integer): string;
begin
  Result :=
    'SELECT Name, BriefDescription, LongDescription, CategoryID, PriorityID ' +
    'FROM ' + TBL_BUG + ' WHERE ' + FLD_BUG_ID + ' = ' + IntToStr(aID);
end;

function TBug.GetUpdateSQL: string;
begin
  Result :=
    'UPDATE ' + TBL_BUG + ' SET ' +
      FLD_STD_NAME + ' = ' + QuotedStr(FName) + ', ' +
      FLD_BUG_CATEGORY_ID + ' = ' + IntToStr(FCategory.ID) + ', ' +
      FLD_BUG_PRIORITY_ID + ' = ' + IntToStr(FPriority.ID) + ', ' +
      FLD_STD_BRIEF_DESCRIPTION + ' = ' + QuotedStr(FBriefDescription) + ', ' +
      FLD_STD_LONG_DESCRIPTION + ' = ' + QuotedStr(FLongDescription) +
    ' WHERE ' + FLD_BUG_ID + ' = ' + IntToStr(FID);
end;

procedure TBug.PopulateFields(aQuery: TADOQuery);
var
  CategoryID, PriorityID: Integer;
begin
  inherited;
  CategoryID := aQuery.FieldByName(FLD_BUG_CATEGORY_ID).AsInteger;
  PriorityID := aQuery.FieldByName(FLD_BUG_PRIORITY_ID).AsInteger;
  FCategory.Free;
  FPriority.Free;
  FCategory := TBugCategory.Create(FScopeDB, CategoryID);
  FPriority := TBugPriority.Create(FScopeDB, PriorityID);
end;

end.

