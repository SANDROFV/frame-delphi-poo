unit uSDAParametro;

interface

Uses Classes, SysUtils, uSDADataType ;

type

  TSdaParam = record
    ParamName     : string;
    ParamType : TSdaParamType;
    Value     : Variant;
  end;

  TArrayItems = array of TSdaParam;

  TSdaParams = class
  private
    FItems : TArrayItems;
    function GetItem(Index: Integer): TSdaParam;
    function GetCount : Integer;
  public
    constructor Create;
    Destructor  Destroy;override;
    procedure ClearParams;
    procedure AddParam(ParamName : String; ParamType : TSdaParamType; Value : Variant);

    property Items[Index: Integer]: TSdaParam read GetItem; default;
    property Count : Integer read GetCount;
  end;



implementation

procedure TSdaParams.AddParam(ParamName : String; ParamType : TSdaParamType; Value : Variant);
var
  i : Integer;
begin
  SetLength(FItems,Length(FItems)+1);
  i := high(FItems);
  FItems[i].ParamName := ParamName;
  FItems[i].ParamType := ParamType;
  FItems[i].Value := Value;
end;

procedure TSdaParams.ClearParams;
begin
    SetLength(FItems, 0);
end;

constructor TSdaParams.Create;
begin
  Inherited create;
end;


destructor TSdaParams.Destroy;
begin
  ClearParams;
  FreeAndNil(FItems);
  inherited;
end;

function TSdaParams.GetCount: Integer;
begin
  result := high(FItems)+1;
end;

function TSdaParams.GetItem(Index: Integer): TSdaParam;
begin
  Result := FItems[Index];
end;


end.

