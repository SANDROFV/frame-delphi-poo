unit SDABusca;

interface

uses
  SysUtils,Classes, Controls, Buttons, uSDADataSet, uSDAClientDataSet, db, dialogs,
  ExtCtrls, DBGrids, DBClient, Provider, Variants, SDACtrlGridButtons, Graphics, Grids, Forms, Windows;

type
  TSDABusca = class;

  TFieldResult = class(TCollectionItem)
  private
    FField   : string;
  //  FControl : String;
    FValue   : TField;
    FControle: TControl;
    procedure SetField(const Value: string);
//    procedure SetControl(const Value: String);
    procedure SetControle(const Value: TControl );
    procedure SetValue(const Value: TField);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Value: TField read FValue write SetValue;
  published
    property Field: string read FField write SetField;
   // property Control: String read FControl write SetControl;
    property Controle  : TControl read FControle write SetControle default nil;
  end;

  TFieldResults = class(TCollection)
  private
    FSdaCustomFind: TSDABusca;
    FOwner: TSDABusca;
    function GetItem(Index: Integer): TFieldResult;
    procedure SetItem(Index: Integer; Value: TFieldResult);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(SdaCustomFind: TSDABusca);
    function Add: TFieldResult;
    function FindControlFieldsResults(Control: String):TFieldResult;
    property Items[Index: Integer]: TFieldResult read GetItem write SetItem; default;
  end;
  {Final da Coleção TFieldResult}


  {Inicio da coleção da ColumnGrid}
  TColumnGrid = class(TCollectionItem)
  private
    FTitle  : String;
    FField   : string;
    FMask : string;
    FWidth : Integer;

    procedure SetField(const Value: string);
    procedure SetTitle(const Value: string);
    procedure SetWidth(const Value: Integer);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Field: string read FField write SetField;
    property Title: string read FTitle write SetTitle;
    property Mask: string read FMask write FMask;
    property Width: Integer read FWidth write SetWidth;
  end;

  {TColumnGrids}
  TColumnGrids = class(TCollection)
  private
    FSdaCustomFind: TSDABusca;
    FOwner: TComponent;
    function GetItem(Index: Integer): TColumnGrid;
    procedure SetItem(Index: Integer; Value: TColumnGrid);

  protected
    function GetOwner: TPersistent; override;

  public
    constructor Create(SdaCustomFind: TSDABusca);
    function Add: TColumnGrid;

    property Items[Index: Integer]: TColumnGrid
       read GetItem write SetItem; default;
  end;
  {Final da coleção do ColumnGrid}

  TOnChangeFilter = procedure (FieldName, Filter : String; var DataSet : TDataSet) of object;
  TOnPaintLineGrid = procedure (Grid : TDBGrid; DataSet : TDataSet) of object;
  TOnModalResult = procedure (ModalResult: Boolean) of object;

  TFindGridOption = (dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgMultiSelect);
  TFindGridOptions = set of TFindGridOption;

  TSDABusca = class(TSpeedButton)
  private
    { Private declarations }
    FFormCaption  : String;
    FModalResult  : Boolean;
    FFormHeight   : Integer;
    FFormWidth    : Integer;
    FFilter       : String;
    FMasterFind   : TSDABusca;
    FTitleFind    : String;
    FEmptyMessage : String;
    FDoneFind     : Boolean;
    FColumnsGrid  : TColumnGrids;
    FFieldsResult    : TFieldResults;
    FSdaDataSet      : TDataSet;
    FSelectedRows    :  TSDAClientDataSet;
    FDBGrid          : TDBGrid;
    FStartAutomatic  : Boolean;
    FContainWord     : Boolean;
    FBeforeExecute   : TNotifyEvent;
    FAfterFind       : TNotifyEvent;
    FOnChangeFilter  : TOnChangeFilter;
    FOnPaintLineGrid : TOnPaintLineGrid;
    FUpdatedControl  : Boolean;
    FMessageEmpty    : TNotifyEvent;
    FTagString       : String;
    FIsSelected      : Boolean;
    FOldRow          : Integer;
    FOnModalResult   : TOnModalResult;
    fGridOptions     : TFindGridOptions;
    FNewSelectedRow  : Boolean;
    FSQL             : TStrings;
    procedure SetColumnsGrid(const Value: TColumnGrids);
    procedure SetFieldsResul(const Value: TFieldResults);
    procedure SetSdaDataSet(const Value: TDataSet);
    procedure SetFilter(const Value: String);
    function DescendantClass(Classe: TClass; ClassePai: String): Boolean;
    function GetSdaDataSet: TSDAClientDataSet;
    procedure PositionRegister(Var Client : TClientDataSet);
    function ParentForm(WinControl : TWinControl): TForm;
    function GetNewSelectedRow: Boolean;
    function ControlsIsFilled:Boolean;
    procedure SetOptions(Value: TFindGridOptions);
    function  getFieldsResult(Field: String):TFieldResult;
 //   function GetSQL: TStrings;
    procedure SetSQL(const Value: TStrings);
  protected
    { Protected declarations }
    property DBGrid : TDBGrid read FDBGrid write FDBGrid;
    procedure Click; override;
    procedure Loaded;override;
  public
    { Public declarations }

    procedure ClearValues;
    procedure FillClientDatasetGrid(Sds: TDataSet; Var Client : TClientDataSet);
    property ModalResult: Boolean read FModalResult write FModalResult;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Execute(pFilter : String);
    procedure Clear;
    function ValueString(Field : String) : String;
    function ValueInteger(Field : String) : Integer;
    function ValueDate(Field : String) : TDateTime;
    function ValueFloat(Field : String) : Double;
    procedure UpdateControls;
    property SelectedRows  : TSDAClientDataSet read GetSdaDataSet write FSelectedRows default nil;
    property SdaDataSet    : TDataSet read FSdaDataSet write SetSdaDataSet default nil;
    property Filter        : String read FFilter write SetFilter;
    property UpdatedControl: Boolean read FUpdatedControl write FUpdatedControl;
    property IsSelected    : Boolean read FIsSelected write FIsSelected;
    property NewSelectedRow : Boolean read FNewSelectedRow;
  published
    { Published declarations }
    property SQL            : TStrings read fSQL write SetSQL;
    property FormHeight     : Integer read FFormHeight write FFormHeight;
    property FormWidth      : Integer read FFormWidth write FFormWidth;
    property FormCaption    : String read FFormCaption write FFormCaption;
    property ColumnsGrid    : TColumnGrids read FColumnsGrid write SetColumnsGrid;
    property FieldsResult   : TFieldResults read FFieldsResult write SetFieldsResul;
    property MasterFind     : TSDABusca read FMasterFind write FMasterFind;
    property TitleFind      : String read FTitleFind write FTitleFind;
    property EmptyMessage   : String read FEmptyMessage write FEmptyMessage;
    property StartAutomatic : Boolean read FStartAutomatic write FStartAutomatic;
    property ContainWord    : Boolean read FContainWord write FContainWord;
    property DoneFind       : Boolean read FDoneFind write FDoneFind;
    property BeforeExecute  : TNotifyEvent read FBeforeExecute Write FBeforeExecute;
    property AfterFind      : TNotifyEvent read FAfterFind Write FAfterFind;
    property MessageEmpty   : TNotifyEvent read FMessageEmpty Write FMessageEmpty;
    property OnChangeFilter : TOnChangeFilter read FOnChangeFilter Write FOnChangeFilter;
    property OnModalResult  : TOnModalResult read FOnModalResult Write FOnModalResult;
    property OnPaintLineGrid: TOnPaintLineGrid read FOnPaintLineGrid Write FOnPaintLineGrid;
    property GridOptions    : TFindGridOptions read fGridOptions write SetOptions
    default [dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection];
    property TagString      : String read FTagString write FTagString;
  end;


implementation


Uses uSDADataType,  SDAClasseBaseEDT, frm_Pesquisa,
      Messages, StdCtrls, Spin;

{ TFieldResult}


constructor TFieldResult.Create(Collection: TCollection);
begin
  inherited Create(Collection);
end;


procedure TFieldResult.Assign(Source: TPersistent);
begin
  if Source is TFieldResult then
  begin
    Controle  := TFieldResult(Source).Controle;
    Value    := TFieldResult(Source).Value;
  end
  else inherited Assign(Source);
end;


procedure TFieldResult.SetField(const Value: string);
begin
  if FField <> Value then
    FField := UpperCase(Value);
end;

        {
procedure TFieldResult.SetControl(const Value: String);

begin
  FControle := Value;
end;   }


procedure TFieldResult.SetControle(const Value: TControl);
begin
     FControle := Value;
end;

procedure TFieldResult.SetValue(const Value: TField);
begin
  if FValue <> Value then
    FValue := Value;
end;


function TFieldResult.GetDisplayName: string;
begin
  Result := Field;
  if Result = '' then Result := inherited GetDisplayName;
end;


destructor TFieldResult.Destroy;
begin
  inherited;
end;

{ TFieldResults }


constructor TFieldResults.Create(SdaCustomFind: TSDABusca);
begin
  inherited Create(TFieldResult);
  FSdaCustomFind := SdaCustomFind;
  FOwner := SdaCustomFind;
end;



function TFieldResults.Add: TFieldResult;
begin
  Result := TFieldResult(inherited Add);
end;


function TFieldResults.GetItem(Index: Integer): TFieldResult;
begin
  Result := TFieldResult(inherited GetItem(Index));
end;



function TFieldResults.GetOwner: TPersistent;
begin
 Result := FSdaCustomFind;
end;


procedure TFieldResults.SetItem(Index: Integer; Value: TFieldResult);
begin
  inherited SetItem(Index, Value);
end;


{ Inicio da Class TColumnGrid }

constructor TColumnGrid.Create(Collection: TCollection);
begin
  inherited Create(Collection);
end;


procedure TColumnGrid.Assign(Source: TPersistent);
begin
  if Source is TColumnGrid then
    begin
      Field  := TColumnGrid(Source).Field;
      Title  := TColumnGrid(Source).Title;
      Width  := TColumnGrid(Source).Width;
    end
  else inherited Assign(Source);
end;


function TColumnGrid.GetDisplayName: string;
begin
  Result := Title;
  if Result = '' then Result := inherited GetDisplayName;
end;


procedure TColumnGrid.SetField(const Value: string);
begin
  if FField <> Value then
    FField := Value;
end;


procedure TColumnGrid.SetTitle(const Value: string);
begin
  if FTitle <> Value then
    FTitle := Value;
end;

procedure TColumnGrid.SetWidth(const Value: Integer);
begin
  if FWidth <> Value then
    FWidth := Value;
end;


{ TFindViwes }



constructor TColumnGrids.Create(SdaCustomFind: TSDABusca);
begin
  inherited Create(TColumnGrid);
  FSdaCustomFind := SdaCustomFind;
  FOwner := SdaCustomFind;
end;


function TColumnGrids.Add: TColumnGrid;
begin
  Result := TColumnGrid(inherited Add);
end;


function TColumnGrids.GetItem(Index: Integer): TColumnGrid;
begin
  Result := TColumnGrid(inherited GetItem(Index));
end;



function TColumnGrids.GetOwner: TPersistent;
begin
 Result := FSdaCustomFind;
end;


procedure TColumnGrids.SetItem(Index: Integer; Value: TColumnGrid);
begin
  inherited SetItem(Index, Value);
end;

{Final da Class TColumnGrid}


function TFieldResults.FindControlFieldsResults(
  Control: String): TFieldResult;
var
  i: integer;
begin
   Result := nil;
   for i:=0 to Self.Count - 1 do
      if lowercase(Self.Items[i].FControle.Name) = lowercase(Control) then
      begin
         Result := Self.Items[i];
         break;
      end;
end;

{ TSDABusca }

procedure TSDABusca.SetColumnsGrid(const Value: TColumnGrids);
begin
  FColumnsGrid.Assign(Value);
end;

procedure TSDABusca.SetFieldsResul(const Value: TFieldResults);
begin
  FFieldsResult.Assign(Value);
end;

constructor TSDABusca.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);

  FFieldsResult   := TFieldResults.Create(Self);
  FColumnsGrid    := TColumnGrids.Create(Self);
  FUpdatedControl := true;
  FIsSelected     := false;

  FFormHeight := 450;
  FFormWidth := 560;
  FFormCaption := 'Pesquisa';
  Height := 21;
  Width := 21;
  Caption := '...';
  FEmptyMessage := 'Nenhum Registro foi retornado.';
  fGridOptions := [dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection];
  FStartAutomatic := true;
  FSQL            := TStringList.Create;
end;

Destructor TSDABusca.Destroy;
begin
  FColumnsGrid.Free;
  FFieldsResult.Free;
  FreeAndNil(FSQL);

  Inherited Destroy;
end;

function TSDABusca.ParentForm(WinControl : TWinControl) : TForm;
begin
  if WinControl.parent is TForm then
  begin
    Result := WinControl.parent as TForm;
    exit;
  end
  else
    Result := ParentForm(WinControl.parent);
end;

procedure TSDABusca.Click;
var
  Form          : TForm;
  SdaCustomEdit : TSDAEdit;

  function NextComponent(ComponentName : String) : TWinControl;
  var
    i, TabOrder : Integer;
  begin
    TabOrder := Form.ActiveControl.TabOrder;

    for i := 0 to Form.ComponentCount - 1 do
      if Form.Components[i] is TWinControl then
        if TWinControl(Form.Components[i]).TabOrder >= (TabOrder + 1) then
          if (TWinControl(Form.Components[i]).CanFocus) and TWinControl(Form.Components[i]).TabStop then
          begin
            TWinControl(Form.Components[i]).SetFocus;
            exit;
          end;
  end;

  function IsFrame(WinControl : TWinControl) : Boolean;
  begin
    if Assigned(WinControl.Parent) then
    begin
      if WinControl.Parent is TFrame then
      begin
        Result := true;
        exit;
      end
      else
        Result := IsFrame(WinControl.Parent);
    end
    else
      Result := false;
  end;

begin

  inherited Click;
  Execute('');

  Form := ParentForm(TWinControl(self)) as TForm;

  if Form.ActiveControl is TSDAEdit then
  begin
    SdaCustomEdit := TSDAEdit(Form.ActiveControl);

    if Assigned(SdaCustomEdit.SDABusca) then
      if SdaCustomEdit.SDABusca = self then
      begin
        if IsFrame(Form.ActiveControl) then
          NextComponent(Form.ActiveControl.Parent.name)
        else
          NextComponent(Form.ActiveControl.name);
      end;
  end;
end;

procedure TSDABusca.SetSdaDataSet(const Value: TDataSet);
begin
{  if Assigned(FSdaDataSet) then
    FSdaDataSet.Free;
}
	FSdaDataSet               := Value;
  FSdaDataSet.Filtered      := True;
  FSdaDataSet.FilterOptions := [foCaseInsensitive];
  FIsSelected               := false;
end;

procedure TSDABusca.SetSQL(const Value: TStrings);
begin
 FSQL :=       Value;
end;

procedure TSDABusca.Execute(pFilter : String);
var
  frmSdaMostraPesquisa : TfrmPesquisa;
  i                    : Integer;

  function MasterOpen : boolean;
  begin
    Result := true;
    if Assigned(FMasterFind) then
       Result := TSDABusca(FMasterFind).DoneFind;
  end;

begin
  FModalResult := False;

  if not MasterOpen then
  begin
    if TSDABusca(FMasterFind).TitleFind <> '' then
      ShowMessage(TSDABusca(FMasterFind).TitleFind + ' não foi escolhido.')
    else
      ShowMessage('Informação anterior não foi preenchida.');
    exit;
  end;

  // executa o evento BeforeExecute
  if Assigned(FBeforeExecute) then
     FBeforeExecute(Self);

  if Not Assigned(FSdaDataSet) then
  begin
     ShowMessage('DataSet não foi carregado !!');
     exit;
  end;

  { Alterado para evitar que o ponteiro do registro fosse modificado na atribuição do filtro
    Othon Henrique R. Aranha - 19/10/2007 }
  //if Trim(pFilter) <> '' then
    Filter := pFilter;

  if FSdaDataSet.RecordCount = 0 then
  begin
    FModalResult := false;
    if Assigned(FMessageEmpty) then
       FMessageEmpty(Self)
    else
    begin
      ShowMessage(FEmptyMessage);
      exit;
    end;
  end;

  frmSdaMostraPesquisa := TfrmPesquisa.Create(self);

  Try

    with frmSdaMostraPesquisa do
    begin
      SdaCustomFind  := Self;


      // Alimenta Client DataSet do Grid de Pesquisa

      FillClientDatasetGrid(FSdaDataSet, cdsPesquisa);

      if FFormHeight > 0 then
         Height := FFormHeight;
      if FFormWidth > 0 then
         Width  := FFormWidth;

      // Mostra Titula do Form
      Caption := FFormCaption;

      // Limpa DBGrid para receber novos Valores
      GridPesquisa.Columns.Clear;

      if FColumnsGrid.Count > 0 then
      begin
        For i := 0 To FColumnsGrid.Count-1 do
        Begin
          GridPesquisa.Columns.Add;
          GridPesquisa.Columns[i].FieldName     := FColumnsGrid.Items[i].Field;
          if FColumnsGrid.Items[i].Title <> '' then
            GridPesquisa.Columns[i].Title.Caption := FColumnsGrid.Items[i].Title
          else
            GridPesquisa.Columns[i].Title.Caption := FColumnsGrid.Items[i].Field;
          if FColumnsGrid.Items[i].Width > 0 then
             GridPesquisa.Columns[i].Width      := FColumnsGrid.Items[i].Width;

          //GridPesquisa.Columns[i].Title.Font.Name := 'Courier New';
        end;
      end;

      GridOptions := Self.GridOptions;

      ShowModal;

    end;

  Finally

    With frmSdaMostraPesquisa do
    Begin
        If MdResult = 'OK'  Then
        begin
          if FSdaDataSet.RecordCount = 0 then
            FSdaDataSet.Filter := '';

          if GridPesquisa.DataSource.DataSet.RecordCount > 0 then
          begin
            PositionRegister(cdsPesquisa);

            FModalResult := True;
            FDoneFind    := True;
            FIsSelected  := True;
          end
          else
          begin
            FModalResult      := False;
            FDoneFind         := ControlsIsFilled;
            FIsSelected       := ControlsIsFilled;
          end;
        end
        else
        begin
          if FOldRow >= 1 then
            FSdaDataSet.RecNo := FOldRow;
          FModalResult      := False;
          FDoneFind         := ControlsIsFilled;
          FIsSelected       := ControlsIsFilled;
        end;

        FDBGrid := GridPesquisa;

        if Assigned(fOnModalResult) then
           fOnModalResult(FModalResult);

        if FModalResult then
          UpdateControls;
    end;

    if Assigned(FAfterFind) then
      FAfterFind(Self);

    Screen.Cursor := crDefault;
  end;
end;

procedure TSDABusca.FillClientDatasetGrid(Sds : TDataSet; Var Client : TClientDataSet);
var
  i, Seq : Integer;
begin
  Try
    Screen.Cursor := crSQLWait;

    Client.Close;

    Client.FieldDefs.Clear;

    for i := 0 to Sds.FieldDefs.Count - 1 do
      if (Sds.Fields[i].DataType = ftInteger) or
         (Sds.Fields[i].DataType = ftFloat) or
         (Sds.Fields[i].DataType = ftSmallint	) or
         (Sds.Fields[i].DataType = ftWord	) or
         (Sds.Fields[i].DataType = ftCurrency	) then
        Client.FieldDefs.Add(Sds.Fields[i].FieldName,Sds.Fields[i].DataType,0,false)
      else if (Sds.Fields[i].DataType = ftDate) or (Sds.Fields[i].DataType = ftDateTime) then
        Client.FieldDefs.Add(Sds.Fields[i].FieldName,Sds.Fields[i].DataType,0,false)
      else
        Client.FieldDefs.Add(Sds.Fields[i].FieldName,Sds.Fields[i].DataType,Sds.Fields[i].DataSize,false);

    Client.FieldDefs.Add('SDABuscaSequencial',ftInteger,0,false);

    Client.CreateDataSet;
    Client.Open;

    Seq := 1;

    Sds.First;
    while not Sds.Eof do
    begin
      Client.Insert;
      for i := 0 to Sds.FieldCount - 1 do
        Client.Fields[i].Value := Sds.Fields[i].Value;

      Client.Fields[Client.FieldCount-1].Value := Seq;
      Client.Post;

      Inc(Seq);

      Sds.Next;
    end;
  Finally
    Screen.Cursor := crDefault;
  End;
end;

procedure TSDABusca.PositionRegister(Var Client : TClientDataSet);
{var
  V : Variant;
  Fields : String;
  i, Count : Integer;
}
begin
  {FSdaDataSet.First;
  FSdaDataSet.Locate(Client.Fields[0].FieldName,Client.Fields[0].Value,[]);}
  FSdaDataSet.RecNo := Client.FieldByName('SDABuscaSequencial').AsInteger;
  FNewSelectedRow   := GetNewSelectedRow;
  FOldRow           := FSdaDataSet.RecNo;

{  Count := 0;
  for i := 0 to Client.FieldCount - 1 do
    if (Client.Fields[i].DataType <> ftOraClob) and (Client.Fields[i].DataType <> ftOraBlob) then
      Inc(Count);

  V := VarArrayCreate([0,Count-1], varVariant);

  Fields := '';
  Count := 0;
  for i := 0 to Client.FieldCount - 1 do
  begin
    if (Client.Fields[i].DataType <> ftOraClob) and (Client.Fields[i].DataType <> ftOraBlob) then
    begin
      Fields := Fields + Client.Fields[i].FieldName + ';';
      V[Count] := Client.Fields[i].Value;
      Inc(Count);
    end;
  end;

  Fields := Copy(Fields,1,Length(Fields)-1);

  FSdaDataSet.Locate(Fields, V, []);
}
end;

procedure TSDABusca.SetFilter(const Value: String);
var
  Atualize : Boolean;
  Client: TClientDataSet;
begin
  Try
    if Pos('Not Atualize', Value) > 0 then
    begin
      FFilter := Trim(Copy(Value,13,Length(Value)));
      Atualize := false;
    end
    else
    begin
      FFilter      := Value;
      Atualize     := true;
      FDoneFind    := true;
    end;

    if FSdaDataSet.Active then
    begin
      Client     := TClientDataSet.Create(Self);
      {FOldRow := -1;
      if FSdaDataSet.Recno > -1 then
        FOldRow := FSdaDataSet.Recno;}

      if Trim(Filter) <> '' then
      begin
        FillClientDatasetGrid(FSdaDataSet, Client);
        Client.Filter   := FFilter;
        Client.Filtered := True;
        if Not Client.FieldByName('SDABuscaSequencial').IsNull then
          FOldRow   := Client.FieldByName('SDABuscaSequencial').Value;
        Client.Filtered := False;
      end;
      FSdaDataSet.Filter := FFilter;
    end;

    if ((Atualize or ((not Atualize) and (FSdaDataSet.RecordCount = 1))) and (Value <> '')) and FUpdatedControl then
    begin
      UpdateControls;
      FIsSelected  := true;
      FDoneFind    := true;
    end;
  Finally
    Client.Free;
  End;
end;

Function TSDABusca.DescendantClass(Classe : TClass; ClassePai: String):Boolean;
var
ClassRef: TClass;

begin
  Result := False;
  ClassRef := Classe;
  while ClassRef <> nil do
  begin
    if UpperCase(ClassRef.ClassName) = UpperCase(ClassePai) then
       begin
         result := True;
         Exit;
       end;
    ClassRef := ClassRef.ClassParent;
  end;
end;

procedure TSDABusca.UpdateControls;
var
  i, j : Integer;

  function IsSdaCtrlGridParent : Boolean;
  begin
    Result := false;
    if Assigned(Parent.Parent) then
      if Parent.Parent is TSDACtrlGrid then
        result := true;
  end;

  function CtrlGridParent : TSDACtrlGrid;
  begin
    Result := nil;
    if Assigned(Parent.Parent) then
      if Parent.Parent is TSDACtrlGrid then
        result := TSDACtrlGrid(Parent.Parent);
  end;

  function IsSdaCtrlGridField(FieldName : String) : Boolean;
  var
    i : integer;
  begin
    Result := false;
    For i := 0 To TSdaCtrlGrid(Parent.Parent).DBFields.Count - 1 do
      if UpperCase(TSdaCtrlGrid(Parent.Parent).DBFields[i].Field) = UpperCase(FieldName) then
        Result := true;

  end;
begin

  If not SdaDataSet.IsEmpty Then
     For i := 0 To FFieldsResult.Count - 1 do
     begin
        FFieldsResult.Items[i].FValue := FSdaDataSet.FieldByName(FFieldsResult.Items[i].FField);

        //if (FFieldsResult.Items[i].FControle <> '') and (not IsSdaCtrlGridParent) then
        if (assigned(FFieldsResult.Items[i].FControle)) and (not IsSdaCtrlGridParent) then
        begin
          if not Assigned(Self.Owner.FindComponent(FFieldsResult.Items[i].Controle.Name)) then
            raise Exception.Create(FFieldsResult.Items[i].Controle.name + ' not exists');


          {
          if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaEditString') then
            TSdaEditString(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Value := FFieldsResult.Items[i].FValue.AsString
          else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaEditInteger') then
          begin
            if not FFieldsResult.Items[i].FValue.IsNull then
              TSdaEditInteger(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Value := FFieldsResult.Items[i].FValue.AsInteger
          end
          else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaEditFloat') then
          begin
            if not FFieldsResult.Items[i].FValue.IsNull then
              TSdaEditFloat(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Value := FFieldsResult.Items[i].FValue.AsFloat
          end
          else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaEditDate') then
          begin
            if not FFieldsResult.Items[i].FValue.IsNull then
              TSdaEditDate(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Value := FFieldsResult.Items[i].FValue.AsDateTime
          end
          else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaEditMultipleMask') then
            TSdaEditMultipleMask(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Value := FFieldsResult.Items[i].FValue.AsString
          else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaCheckBox') then
            TSdaCheckBox(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).ValueString := FFieldsResult.Items[i].FValue.AsString
          else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaRadioGroup') then
            TSdaRadioGroup(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).ValueString := FFieldsResult.Items[i].FValue.AsString
          else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaMemo') then
            TSdaMemo(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Value := FFieldsResult.Items[i].FValue.AsString  }
          {$IFNDEF NOT_COMPILE_ADDICT_INFOPOWER and $IFNDEF NOT_COMPILE_ADDICT}
         // else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaAddictRichEdit') then
         //   TSdaAddictRichEdit(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Value := FFieldsResult.Items[i].FValue.AsString
          {$ENDIF}
          {$IFNDEF NOT_COMPILE_ADDICT_INFOPOWER and $IFNDEF NOT_COMPILE_ADDICT and $IFNDEF NOT_COMPILE_INFOPOWER}
      //    else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaEditor') then
     //       TSdaEditor(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Value := FFieldsResult.Items[i].FValue.AsString
          {$ENDIF}
        end
        else if IsSdaCtrlGridParent then
        begin
          for j := 0 to CtrlGridParent.Panel.ControlCount - 1 do
          begin
            if Uppercase(TWinControl(CtrlGridParent.Panel.Controls[j]).Name) = UpperCase(FFieldsResult.Items[i].Controle.name) then
            begin
            if CtrlGridParent.Panel.Controls[j] is TSDAEdit then
                TSDAEdit(CtrlGridParent.Panel.Controls[j]).Text := FFieldsResult.Items[i].FValue.AsString;
             { if CtrlGridParent.Panel.Controls[j] is TSdaEditString then
                TSdaEditString(CtrlGridParent.Panel.Controls[j]).Value := FFieldsResult.Items[i].FValue.AsString
              else if CtrlGridParent.Panel.Controls[j] is TSdaEditMultipleMask then
                TSdaEditMultipleMask(CtrlGridParent.Panel.Controls[j]).Value := FFieldsResult.Items[i].FValue.AsString
              else if CtrlGridParent.Panel.Controls[j] is TSdaCheckBox then
                TSdaCheckBox(CtrlGridParent.Panel.Controls[j]).ValueString := FFieldsResult.Items[i].FValue.AsString
              else if CtrlGridParent.Panel.Controls[j] is TSdaRadioGroup then
                TSdaMemo(CtrlGridParent.Panel.Controls[j]).Value := FFieldsResult.Items[i].FValue.AsString
              else if CtrlGridParent.Panel.Controls[j] is TSdaMemo then
                TSdaMemo(CtrlGridParent.Panel.Controls[j]).Value := FFieldsResult.Items[i].FValue.AsString
              else if CtrlGridParent.Panel.Controls[j] is TSdaEditFloat then
                TSdaEditFloat(CtrlGridParent.Panel.Controls[j]).Value := FFieldsResult.Items[i].FValue.AsFloat
              else if CtrlGridParent.Panel.Controls[j] is TSdaEditInteger then
                TSdaEditInteger(CtrlGridParent.Panel.Controls[j]).Value := FFieldsResult.Items[i].FValue.AsInteger
              else if CtrlGridParent.Panel.Controls[j] is TSdaEditDate then
                TSdaEditDate(CtrlGridParent.Panel.Controls[j]).Value := FFieldsResult.Items[i].FValue.AsDateTime }
              {$IFNDEF NOT_COMPILE_ADDICT_INFOPOWER and $IFNDEF NOT_COMPILE_ADDICT}
           //   else if CtrlGridParent.Panel.Controls[j] is TSdaAddictRichEdit then
             //   TSdaAddictRichEdit(CtrlGridParent.Panel.Controls[j]).Value := FFieldsResult.Items[i].FValue.AsString
              {$ENDIF}
              {$IFNDEF NOT_COMPILE_ADDICT_INFOPOWER and $IFNDEF NOT_COMPILE_ADDICT and $IFNDEF NOT_COMPILE_INFOPOWER}
            //  else if CtrlGridParent.Panel.Controls[j] is TSdaEditor then
            //    TSdaEditor(CtrlGridParent.Panel.Controls[j]).Value := FFieldsResult.Items[i].FValue.AsString
              {$ENDIF}
            end;
          end;
        end;

     end;
end;

procedure TSDABusca.Clear;
var
  i : Integer;
begin
   if Assigned(FSdaDataSet) then
     if FSdaDataSet.RecordCount > 0 then
       if not FSdaDataSet.Bof and not FSdaDataSet.Eof then
         FSdaDataSet.RecNo := -1;

   For i := 0 To FFieldsResult.Count - 1 do
   begin
      if Assigned(FFieldsResult.Items[i].Controle)then continue;
     { if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaEditString') then
        TSdaEditString(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Clear
      else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaEditInteger') then
        TSdaEditInteger(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Clear
      else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaEditFloat') then
        TSdaEditFloat(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Clear
      else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaEditDate') then
        TSdaEditDate(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Clear
      else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaEditMultipleMask') then
        TSdaEditMultipleMask(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Clear
      else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaCheckBox') then
        TSdaCheckBox(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Checked := false
      else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaRadioGroup') then
        TSdaRadioGroup(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).ItemIndex := -1
      else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaMemo') then
        TSdaMemo(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Clear     }
      {$IFNDEF NOT_COMPILE_ADDICT_INFOPOWER and $IFNDEF NOT_COMPILE_ADDICT}
     // else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaAddictRichEdit') then
     //   TSdaAddictRichEdit(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Clear
      {$ENDIF}
      {$IFNDEF NOT_COMPILE_ADDICT_INFOPOWER and $IFNDEF NOT_COMPILE_ADDICT and $IFNDEF NOT_COMPILE_INFOPOWER}
     // else if DescendantClass(Self.Owner.FindComponent(FFieldsResult.Items[i].Control).ClassType, 'TSdaEditor') then
     //   TSdaEditor(Self.Owner.FindComponent(FFieldsResult.Items[i].Control)).Clear;
      {$ENDIF}
   end;

  FIsSelected := false;

end;

function TSDABusca.ValueDate(Field: String): TDateTime;
begin
  if not Assigned(FSdaDataSet) then
    Result := TDateTimeNull
  else
  begin
      if  FSdaDataSet.FieldByName(Field).IsNull then
        Result := TDateTimeNull
      else
        Result := FSdaDataSet.FieldByName(Field).AsDateTime;
  end;
end;

function TSDABusca.ValueFloat(Field: String): Double;
begin
  if not Assigned(FSdaDataSet) then
    Result := ExtendedNull
  else
  begin
      if  FSdaDataSet.FieldByName(Field).IsNull then
        Result := ExtendedNull
      else
        Result := FSdaDataSet.FieldByName(Field).AsFloat;
  end;
end;

function TSDABusca.ValueInteger(Field: String): Integer;
begin
  if not Assigned(FSdaDataSet) then
    Result := IntegerNull
  else
  begin
      if  FSdaDataSet.FieldByName(Field).IsNull then
        Result := IntegerNull
      else
        Result := FSdaDataSet.FieldByName(Field).AsInteger;
  end;
end;

function TSDABusca.ValueString(Field: String): String;
begin
  if not Assigned(FSdaDataSet) then
    Result := StringNull
  else
  begin
      if  FSdaDataSet.FieldByName(Field).IsNull then
        Result := StringNull
      else
        Result := FSdaDataSet.FieldByName(Field).AsString;
  end;
end;

function TSDABusca.GetSdaDataSet: TSdaClientDataSet;
var
  i, j: Integer;
  Sds : TSDAClientDataSet;
begin
  Sds := TSDAClientDataSet.Create(self);
  Sds.FieldDefs := FSdaDataSet.FieldDefs;
  Sds.CreateDataSet;
  Sds.Open;

  if FDBGrid.SelectedRows.Count>0 then
  begin
    for i:=0 to FDBGrid.SelectedRows.Count-1 do
    begin
      FDBGrid.DataSource.DataSet.GotoBookmark(pointer(FDBGrid.SelectedRows.Items[i]));
      Sds.Insert;
      for j := 0 to FSdaDataSet.FieldCount-1 do
        Sds.Fields[j].Value := FDBGrid.DataSource.DataSet.Fields[j].Value;
      Sds.Post;
    end;
  end
  else
  begin
    Sds.Insert;
    for j := 0 to FSdaDataSet.FieldCount-1 do
      Sds.Fields[j].Value := FDBGrid.DataSource.DataSet.Fields[j].Value;
    Sds.Post;
  end;
  FSelectedRows := Sds;
  Result := FSelectedRows;
end;



procedure TSDABusca.ClearValues;
var
  i: integer;
begin
     For i := 0 To FFieldsResult.Count - 1 do
        FFieldsResult.Items[i].FValue.Clear;
end;

function TSDABusca.GetNewSelectedRow: Boolean;
begin
  Result := FOldRow <> FSdaDataSet.RecNo;
end;

function TSDABusca.ControlsIsFilled: Boolean;
var
  Form: TCustomForm;
  Component: TComponent;
  i: integer;
begin
  Result := False;
  Form := GetParentForm(Self);
  for i:=0 to FieldsResult.Count - 1 do
  begin
    Component := Form.FindComponent(FieldsResult[i].Controle.Name);
    if Assigned(Component) then
    begin
    {   if Component is TCustomSDAEdit then
          Result := Not ( Component as TCustomSDAEdit).IsNull
       else if Component is TSdaCheckBox then
          Result := Not ( ( Component as TSdaCheckBox).ValueString = '' )
       else if Component is TSdaComboBox then
          Result := Not ( ( Component as TSdaComboBox).ValueString = '' )
       else if Component is TSdaLabeledComboBox then
          Result := Not ( ( Component as TSdaLabeledComboBox).Items[( Component as TSdaLabeledComboBox).ItemIndex] = '' )
       else if Component is TSdaListBox then
          Result := Not ( ( Component as TSdaListBox).ValueString = '' )
       else if Component is TSdaSpinEdit then
          Result := Not ( ( Component as TSdaSpinEdit).Value = IntegerNull )
       else if Component is TSdaEditMultipleMask then
          Result := Not ( ( Component as TSdaEditMultipleMask).IsNull )
       else if Component is TSdaRadioGroup then
          Result := Not ( Component as TSdaRadioGroup).IsNull
       else if Component is TSdaMemo then
          Result := Not ( Component as TSdaMemo).IsNull   }
       {$IFNDEF NOT_COMPILE_ADDICT_INFOPOWER and $IFNDEF NOT_COMPILE_ADDICT}
      // else if Component is TSdaAddictRichEdit then
      //    Result := Not ( Component as TSdaAddictRichEdit).IsNull
       {$ENDIF}
       {$IFNDEF NOT_COMPILE_ADDICT_INFOPOWER and $IFNDEF NOT_COMPILE_ADDICT and $IFNDEF NOT_COMPILE_INFOPOWER}
     //  else if Component is TSdaEditor then
     //     Result := Not ( ( Component as TSdaEditor).Value = '' )
       {$ENDIF}
    end;
    if Result then break;
  end;
end;



procedure TSDABusca.SetOptions(Value: TFindGridOptions);
begin
  FGridOptions := Value;
end;

procedure TSDABusca.Loaded;
begin
  inherited;
end;


function TSDABusca.getFieldsResult(Field: String): TFieldResult;
var
  i: integer;
begin
   Result := nil;
   for i:=0 to FieldsResult.Count - 1 do
     if FieldsResult[i].FField = Field then
     begin
        Result := FieldsResult[i];
        break;
     end;
end;

end.




