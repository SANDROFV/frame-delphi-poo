unit frm_Pesquisa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, Buttons, Grids, DBGrids, StdCtrls, ExtCtrls, Mask,
   uSDADataSet, SDABusca;

type
  TfrmPesquisa = class(TForm)
    pnlPesquisa: TPanel;
    pnlData: TPanel;
    lblPeriodoInicial: TLabel;
    lblPeriodoFinal: TLabel;
    lblDe: TLabel;
    mskInicial: TMaskEdit;
    mskFinal: TMaskEdit;
    pnlVariant: TPanel;
    lblProcurando: TLabel;
    mskProcurando: TMaskEdit;
    rgpCriterio: TRadioGroup;
    pnlDisplay: TPanel;
    Procurando: TStaticText;
    pnlGrid: TPanel;
    GridPesquisa: TDBGrid;
    pnlInfo: TPanel;
    pnlOperacao: TPanel;
    spbtConfirmar: TSpeedButton;
    SpeedButton4: TSpeedButton;
    dtsFind: TDataSource;
    cdsPesquisa: TClientDataSet;
    procedure spbtConfirmarClick(Sender: TObject);
    procedure GridPesquisaTitleClick(Column: TColumn);
    procedure mskProcurandoChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GridPesquisaDblClick(Sender: TObject);
    procedure GridPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure mskProcurandoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mskProcurandoKeyPress(Sender: TObject; var Key: Char);
    procedure rgpCriterioClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    { Private declarations }
    FSdaCustomFind: TComponent;
    FIndColumn : Integer;
    DrawBmpSort: Boolean;
    Tipo : TFieldType;
    fGridOptions: TFindGridOptions;
    procedure chkContemPalavraClick(Sender: TObject);
     procedure setGridOptions(Value: TFindGridOptions);
  public
    { Public declarations }
    Property SdaCustomFind: TComponent read FSdaCustomFind write FSdaCustomFind;
    Property GridOptions  : TFindGridOptions read fGridOptions write setGridOptions;
  end;

var
  frmPesquisa: TfrmPesquisa;
  MdResult : String;
implementation

{$R *.dfm}

procedure TfrmPesquisa.spbtConfirmarClick(Sender: TObject);
begin
if cdsPesquisa.RecordCount > 0 then
     MdResult := 'OK'
  else
     MdResult := 'Fechar';
  Close;
end;

procedure TfrmPesquisa.GridPesquisaTitleClick(Column: TColumn);
var
  IndexOption: TIndexOptions;
  TitleColuna: String;
begin
  Try

    Procurando.Caption := 'Pesquisando Coluna: << ' + Column.Title.Caption + ' >>';

   // Tipo := cdsFind.FieldByName(Column.Field.DisplayName).DataType;

    { Guardo definições do último índice utilizado
      e Deleto último índice utilizado}
    if cdsPesquisa.IndexDefs.Count > 0 then
    begin
      IndexOption := cdsPesquisa.IndexDefs[0].Options;
      cdsPesquisa.IndexDefs.Delete(0);
    end;

    { Crio um novo índice }
    cdsPesquisa.IndexDefs.AddIndexDef;
    cdsPesquisa.IndexDefs[0].Fields := Column.FieldName;

    { Se mudei de coluna }
    if ( Column.Index <> FIndColumn ) or ( FIndColumn = -1 )  then
    begin
      if FIndColumn <> -1 then
      begin
        TitleColuna := GridPesquisa.Columns[FIndColumn].Title.Caption;

        {if ( Pos(AscOrd,TitleColuna) > 0 ) or ( Pos(DescOrd,TitleColuna) > 0 )  then
          GridPesquisa.Columns[FIndColumn].Title.Caption := Copy(TitleColuna,1,Length(TitleColuna)-1);}
      end;

      cdsPesquisa.IndexDefs[0].Options := [];
      cdsPesquisa.IndexDefs[0].Name    := Column.FieldName + ' ASC';
      DrawBmpSort := True;
    end
    else { Alterno ordenação do índice (Ascendente,Descendente) }
      if IndexOption = [ixDescending] then
      begin
        cdsPesquisa.IndexDefs[0].Options := [];
        cdsPesquisa.IndexDefs[0].Name    := Column.FieldName + ' ASC';
        DrawBmpSort := True;
      end
      else
      begin
        cdsPesquisa.IndexDefs[0].Options := [ixDescending];
        cdsPesquisa.IndexDefs[0].Name    := Column.FieldName + ' DESC';
        DrawBmpSort := True;
      end;

    TitleColuna := GridPesquisa.Columns[Column.Index].Title.Caption;

    {if ( Pos(AscOrd,TitleColuna) > 0 ) or ( Pos(DescOrd,TitleColuna) > 0 )  then
       TitleColuna := Copy(TitleColuna,1,Length(TitleColuna)-1);}

    if cdsPesquisa.IndexDefs[0].Options = [ixDescending] then
       GridPesquisa.Columns[Column.Index].Title.Caption := TitleColuna// + DescOrd
    else
       GridPesquisa.Columns[Column.Index].Title.Caption := TitleColuna;// + AscOrd;

 //   cdsFind.IndexName := cdsFind.IndexDefs[0].Name;

    FIndColumn := Column.Index;

    case Tipo of
    ftDate,ftDateTime:
    Begin
      pnlVariant.Visible  := False;
      pnlData.Align       := alClient;
      pnlData.Visible     := True;
      mskInicial.Text     := FormatDateTime('dd/mm/yyyy', Date);
      mskInicial.SetFocus;
    end
    else
    Begin
      mskInicial.Text     := '';
      mskFinal.Text       := '';
      pnlData.Visible     := False;
      pnlVariant.Visible  := True;
      mskProcurando.SetFocus;
      mskProcurandoChange(mskProcurando);
    end;
    end;


//    cdsFind.EnableControls;
  Except
    ShowMessage('O Componente não foi configurado corretamente.');
  end;

end;


procedure TfrmPesquisa.mskProcurandoChange(Sender: TObject);

 var
  SearchFilter, TextFilter, FieldName : String;
  Sds : TClientDataSet;
begin
  TextFilter := mskProcurando.Text;
  FieldName := TSDABusca(SdaCustomFind).ColumnsGrid.Items[FIndColumn].Field;

  With cdsPesquisa do
  Begin
    DisableControls;

    if Assigned(TSDABusca(SdaCustomFind).OnChangeFilter) then
    begin
      //TSDABusca(SdaCustomFind).OnChangeFilter(FieldName, TextFilter, Sds.dataset);
      TSDABusca(SdaCustomFind).FillClientDatasetGrid(Sds, cdsPesquisa);
      cdsPesquisa.First;
    end
    else
    begin
      if  mskProcurando.Text <> '' then
      begin
        if TSDABusca(SdaCustomFind).SdaDataSet.FieldByName(TSDABusca(SdaCustomFind).ColumnsGrid.Items[FIndColumn].Field).DataType = ftString then
        begin
          case rgpCriterio.ItemIndex of
          0: SearchFilter := FieldName + ' = ''' + TextFilter + '*''';
          1: SearchFilter := FieldName + ' like ''%' + TextFilter + '%''';
          end;
        end
        else
          SearchFilter := TSDABusca(SdaCustomFind).ColumnsGrid.Items[FIndColumn].Field + ' = ''' + mskProcurando.text + '''';
        Filter := SearchFilter;
      end
      else
        Filter := '';
    end;

    EnableControls;
  end;
end;

procedure TfrmPesquisa.FormActivate(Sender: TObject);
var
I : Integer;

  function HasColumnsGrid(FieldName : String) : Boolean;
  var
    i : Integer;
  begin
    Result := false;
    for i := 0 to TSDABusca(SdaCustomFind).ColumnsGrid.Count - 1 do
    begin
      if trim(LowerCase(TSDABusca(SdaCustomFind).ColumnsGrid.Items[i].Field)) = trim(LowerCase(FieldName)) then
      begin
        Result := true;
        exit;
      end;
    end;

  end;

begin

  if not Assigned(TSDABusca(SdaCustomFind).SdaDataSet) then
    raise Exception.Create('SdaDataSet não foi passado.');

  dtsFind.DataSet := cdsPesquisa;

   for i := 0 to TSDABusca(SdaCustomFind).SdaDataSet.FieldDefs.Count - 1 do
     if HasColumnsGrid(TSDABusca(SdaCustomFind).SdaDataSet.FieldDefs.Items[i].Name) then
       cdsPesquisa.IndexDefs.Add(TSDABusca(SdaCustomFind).SdaDataSet.FieldDefs.Items[i].Name, TSDABusca(SdaCustomFind).SdaDataSet.FieldDefs.Items[i].Name, []);


  With cdsPesquisa do
  Begin
    DisableControls;

    Filtered := true;
    FilterOptions := [foCaseInsensitive];

    case cdsPesquisa.Fields[0].DataType of
    ftDateTime, ftDate:
    Begin
      pnlVariant.Visible := False;
      pnlData.Visible    := True;
      mskInicial.Text    := FormatDateTime('dd/mm/yyyy', Date);
      mskInicial.SetFocus;
    end;
    else
    Begin
      pnlData.Visible    := False;
      pnlVariant.Visible := True;
      mskProcurando.SetFocus;
    end;
    end;

    FIndColumn := -1;

    //FormataCamposdoGrid;

    if TSDABusca(SdaCustomFind).ColumnsGrid.Count = 0 Then
      raise Exception.Create('Property ColumnsGrid is empty');
{    begin
      For i := 0 To cdsFind.FieldCount-1  do
      Begin
            GridPesquisa.Columns.Add;
            GridPesquisa.Columns[i].FieldName     := cdsFind.Fields[i].DisplayName;
            GridPesquisa.Columns[i].Title.Caption := cdsFind.Fields[i].DisplayName;
      end;
    end
    else
}

    IndexName := IndexDefs.Items[0].Fields;

    EnableControls;
  End;

  GridPesquisa.OnTitleClick(GridPesquisa.Columns[0]);

  pnlInfo.Visible := false;

  cdsPesquisa.First;
end;

procedure TfrmPesquisa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action :=caFree;
end;

procedure TfrmPesquisa.GridPesquisaDblClick(Sender: TObject);
begin
  spbtConfirmar.Click;
end;

procedure TfrmPesquisa.GridPesquisaKeyPress(Sender: TObject;
  var Key: Char);
begin
 If Key = #13 Then
    spbtConfirmar.Click;
end;

procedure TfrmPesquisa.mskProcurandoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
If Key = VK_ESCAPE then
  Begin
    MdResult := 'Fechar';
    Close
  end;

  If Key = 13 then
  Begin
    MdResult := 'OK';
    Close
  end;
end;

procedure TfrmPesquisa.GridPesquisaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
If Key = VK_ESCAPE then
  Begin
    MdResult := 'Fechar';
    Close
  end;
  if (ssCtrl in shift) and (key = 13) then
        GridPesquisaTitleClick(TDBGrid(Sender).Columns.Items[TDBGrid(Sender).SelectedIndex]);
end;

procedure TfrmPesquisa.chkContemPalavraClick(Sender: TObject);
begin
  mskProcurando.SetFocus;
end;

procedure TfrmPesquisa.mskProcurandoKeyPress(Sender: TObject;
  var Key: Char);
begin
 case Tipo of
   ftInteger, ftLargeint, ftSmallint, ftWord :if Not ( Key in ['0'..'9',#8] ) then Key := #0;
   ftFloat, ftCurrency:if Not ( Key in ['0'..'9',',',#8] ) then Key := #0;
   end;
end;

procedure TfrmPesquisa.rgpCriterioClick(Sender: TObject);
begin
 mskProcurandoChange(Sender);
end;

procedure TfrmPesquisa.setGridOptions(Value: TFindGridOptions);
begin
 fGridOptions := Value;
  GridPesquisa.Options := [DBGrids.dgTitles];

  if dgIndicator in Value then
    GridPesquisa.Options := GridPesquisa.Options + [DBGrids.dgIndicator]
  else
    GridPesquisa.Options := GridPesquisa.Options - [DBGrids.dgIndicator];

  if dgColumnResize in Value  then
    GridPesquisa.Options := GridPesquisa.Options + [DBGrids.dgColumnResize]
  else
    GridPesquisa.Options := GridPesquisa.Options - [DBGrids.dgColumnResize];

  if dgColLines in Value then
    GridPesquisa.Options := GridPesquisa.Options + [DBGrids.dgColLines]
  else
    GridPesquisa.Options := GridPesquisa.Options - [DBGrids.dgColLines];

  if dgRowLines in Value then
    GridPesquisa.Options := GridPesquisa.Options + [DBGrids.dgRowLines]
  else
    GridPesquisa.Options := GridPesquisa.Options - [DBGrids.dgRowLines];

  if dgTabs in Value then
    GridPesquisa.Options := GridPesquisa.Options + [DBGrids.dgTabs]
  else
    GridPesquisa.Options := GridPesquisa.Options - [DBGrids.dgTabs];

  if dgRowSelect in Value then
    GridPesquisa.Options := GridPesquisa.Options + [DBGrids.dgRowSelect]
  else
    GridPesquisa.Options := GridPesquisa.Options - [DBGrids.dgRowSelect];

  if dgAlwaysShowSelection in Value  then
    GridPesquisa.Options := GridPesquisa.Options + [DBGrids.dgAlwaysShowSelection]
  else
    GridPesquisa.Options := GridPesquisa.Options - [DBGrids.dgAlwaysShowSelection];

  if dgMultiSelect in Value then
    GridPesquisa.Options := GridPesquisa.Options + [DBGrids.dgMultiSelect]
  else
    GridPesquisa.Options := GridPesquisa.Options - [DBGrids.dgMultiSelect];
end;

procedure TfrmPesquisa.SpeedButton4Click(Sender: TObject);
begin
 if GridPesquisa.SelectedIndex = 0 then
   MdResult := 'Nada'
 else
  MdResult := 'Fechar';
  Close;
end;

end.
