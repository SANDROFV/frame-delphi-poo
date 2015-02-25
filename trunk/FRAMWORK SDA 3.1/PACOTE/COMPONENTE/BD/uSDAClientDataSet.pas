unit uSDAClientDataSet;

interface

uses
  SysUtils, Classes, DB, DBClient, SDAInterfaces,dbTables;

 type

  PBcd = ^TBcd;
  TBcd  = packed record
    Precision: Byte;                        { 1..64 }
    SignSpecialPlaces: Byte;                { Sign:1, Special:1, Places:6 }
    Fraction: packed array [0..31] of Byte; { BCD Nibbles, 00..99 per Byte, high Nibble 1st }
  end;
type
  TSDAClientDataSet = class(TClientDataSet,ISQLObject)
  private
    { Private declarations }
    FParams: TParams;
  protected
    { Protected declarations }
   // function  GetFieldClass(FieldType: TFieldType): TFieldClass; override;
 //   procedure DataConvert(Field: TField; Source, Dest: Pointer; ToNative: Boolean); override;
    //ISQLObject
   property  Params: TParams read fParams write fParams ;
   function  ParamCount:integer;
   function  ParamName(ParamIndex:integer):string;
   function  FieldsCount:integer;
   function  FieldExist(const FieldName:string; var FieldIndex:integer):boolean;
   function  ParamExist(const ParamName:string; var ParamIndex:integer):boolean;
   function  FieldValue(const FieldName:string; Old:boolean):variant;   overload;
   function  FieldValue(const FieldIndex:integer;Old:boolean):variant; overload;
   function  ParamValue(const ParamName:string):variant;   overload;
   function  ParamValue(const ParamIndex:integer):variant; overload;
   procedure SetParamValue(const ParamIndex:integer; aValue:Variant);
   function  FieldName(FieldIndex:integer):string;
   function  IEof:boolean;
   procedure INext;
//
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure   OpenWP(ParamValues: array of Variant);
    destructor Destroy; override;
  published
    property Active;
  end;

//procedure Register;

implementation
  {
procedure Register;
begin
  RegisterComponents('SDADB', [TSDAClientDataSet]);
end;
    }
{ TSDAClientDataSet }



constructor TSDAClientDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TSDAClientDataSet.Destroy;
begin
  inherited Destroy;
end;

function TSDAClientDataSet.FieldExist(const FieldName: string;
  var FieldIndex: integer): boolean;
var
  tf:TField;
begin
 tf:=FindField(FieldName);
 Result:= Assigned(tf);
 if Result then
  FieldIndex:=tf.Index;

end;

function TSDAClientDataSet.FieldName(FieldIndex: integer): string;
begin
     Result:=Fields[FieldIndex].FieldName;
end;

function TSDAClientDataSet.FieldsCount: integer;
begin
     Result:=FieldCount
end;

function TSDAClientDataSet.FieldValue(const FieldName: string;
  Old: boolean): variant;
var
  tf:TField;
begin
 tf:=FieldByName(FieldName);
 if Old then
  Result:= tf.OldValue
 else
  Result:= tf.Value

end;

function TSDAClientDataSet.FieldValue(const FieldIndex: integer;
  Old: boolean): variant;
 var
  tf:TField;
begin
 tf:=Fields[FieldIndex];
 if Old and (State<>dsInsert) then
  Result:= tf.OldValue
 else
  Result:= tf.Value
end;
 {
function TSDAClientDataSet.GetFieldClass(FieldType: TFieldType): TFieldClass;
begin
 case FieldType of
  ftBCD :  Result:=TpSDAClientBCDField;
 else
  Result:=inherited GetFieldClass( FieldType)
 end

end; }

function TSDAClientDataSet.IEof: boolean;
begin
   Result:=Eof;
end;

procedure TSDAClientDataSet.INext;
begin
   Next;
end;

procedure TSDAClientDataSet.OpenWP(ParamValues: array of Variant);
var i :integer;
    pc:integer;
begin
// Exec Query with ParamValues
 if High(ParamValues)<Pred(Params.Count) then
  pc:=High(ParamValues)
 else
  pc:=Pred(Params.Count);
 for i:=Low(ParamValues)  to pc do
  Params[i].Value:=ParamValues[i];
 Open   ;

end;

function TSDAClientDataSet.ParamCount: integer;
begin
   Result:=Params.Count
end;

function TSDAClientDataSet.ParamExist(const ParamName: string;
  var ParamIndex: integer): boolean;
var
   par:TParam;
begin
 par:=Params.FindParam(ParamName);
 Result :=par<>nil;
 if Result then
  ParamIndex:=par.Index;

end;

function TSDAClientDataSet.ParamName(ParamIndex: integer): string;
begin
   Result:=Params[ParamIndex].Name;
end;



function TSDAClientDataSet.ParamValue(const ParamIndex: integer): variant;
begin
  Result:=Params[ParamIndex].Value;
end;
function TSDAClientDataSet.ParamValue(const ParamName: string): variant;
begin
  // Result:=Params[ParamName].Value  ;

end;

procedure TSDAClientDataSet.SetParamValue(const ParamIndex: integer;
  aValue: Variant);
begin
    Params[ParamIndex].Value:=aValue;
end;

end.
