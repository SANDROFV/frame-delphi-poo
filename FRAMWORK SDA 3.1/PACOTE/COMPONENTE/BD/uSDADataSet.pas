unit uSDADataSet;

interface

uses
  SysUtils, Classes, Datasnap.DBClient,Data.DB, dbTables, uSDAParametro,FireDAC.Comp.Client;

type
  TSDADataSet = class(TCustomClientDataSet)
  private
    fFDQuery    :TFDQuery;

    function GetSQL: TStrings;
    procedure SetSQL(const Value: TStrings);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property SQL: TStrings read GetSQL write SetSQL;
    procedure ExecSQL; overload;
    //TFDQuery


  end;

implementation

constructor TSDADataSet.Create(AOwner: TComponent);
begin
  inherited;
  Filtered      := true;
  FilterOptions := [foCaseInsensitive];
  fFDQuery      := TFDQuery.Create(self);
end;

destructor TSDADataSet.Destroy;
begin
  fFDQuery.Free;
  inherited;
end;

procedure TSDADataSet.ExecSQL;
begin
  fFDQuery.ExecSQL;
end;

function TSDADataSet.GetSQL: TStrings;
begin
 result :=   SQL;
end;

procedure TSDADataSet.SetSQL(const Value: TStrings);
begin
  SQL := Value;
end;

end.

