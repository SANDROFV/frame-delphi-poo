unit SDACtrlGridButtons;

interface

uses
  Windows, SysUtils, Classes, Controls, DB, Messages, Graphics, ExtCtrls,
  DBClient, Dialogs, Forms, stdCtrls, uSDADataSet, uSDAClientDataSet, Variants,
   Buttons;

type
  TSdaCtrlGrid = class;

  TStateSdaCtrlGrid = (ssBrowse, ssInsert, ssEdit, ssInactive);

  TSdaPanelButtons = class(TCustomPanel)
  private
    FSdaCtrlGrid : TSdaCtrlGrid;
    FStateSdaCtrlGrid : TStateSdaCtrlGrid;
    function GetTop: Integer;
    function GetLeft: Integer;
    function GetWidth: Integer;
    function GetHeight: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetWidth(const Value: Integer);
  private
    FbtnInsert    : TSpeedButton;
    FbtnEdit      : TSpeedButton;
    FbtnDelete    : TSpeedButton;
    FbtnPost      : TSpeedButton;
    FbtnCancel    : TSpeedButton;
    FbtnGeral     : TSpeedButton;
  protected
    procedure CreateWnd; override;

    procedure ClickBtnInsert(Sender: TObject);
    procedure ClickBtnEdit(Sender: TObject);
    procedure ClickBtnDelete(Sender: TObject);
//    procedure ClickBtnPost(Sender: TObject);
    procedure ClickBtnCancel(Sender: TObject);
    procedure ClickBtnGeral(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetStateSdaCtrlGrid(const Value: TStateSdaCtrlGrid);

    property StateSdaCtrlGrid : TStateSdaCtrlGrid read FStateSdaCtrlGrid write FStateSdaCtrlGrid;

    property btnPost   : TSpeedButton read FbtnPost write FbtnPost;
    property btnInsert : TSpeedButton read FbtnInsert write FbtnInsert;
    property btnEdit   : TSpeedButton read FbtnEdit write FbtnEdit;
    property btnDelete : TSpeedButton read FbtnDelete write FbtnDelete;
    property btnCancel : TSpeedButton read FbtnCancel write FbtnCancel;
    property btnGeral  : TSpeedButton read FbtnGeral write FbtnGeral;
  end;

  TDBField = class(TCollectionItem)
  private
    FField     : string;
    FFieldType : TFieldType;
    FSize      : Integer;
    FControl   : String;
    FValue     : Variant;
    FTitle     : String;
    FRequired  : Boolean;

    procedure SetSize(const Value: Integer);
    procedure SetField(const Value: string);
    procedure SetControl(const Value: String);
    procedure SetValue(const Value: Variant);
    procedure SetFieldType(const Value: TFieldType);
    procedure SetRequired(const Value: Boolean);
    procedure SetTitle(const Value: String);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Value: Variant read FValue write SetValue;
  published
    property Field: string read FField write SetField;
    property FieldType: TFieldType read FFieldType write SetFieldType;
    property Size: Integer read FSize write SetSize;
    property Control: String read FControl write SetControl;
    property Title: String read FTitle write SetTitle;
    property Required: Boolean read FRequired write SetRequired;
  end;

  TDBFields = class(TCollection)
  private
    FSdaCtrlGrid: TSdaCtrlGrid;
    FOwner: TSdaCtrlGrid;
    function GetItem(Index: Integer): TDBField;
    procedure SetItem(Index: Integer; Value: TDBField);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(SdaCtrlGrid: TSdaCtrlGrid);
    function Add: TDBField;
    property Items[Index: Integer]: TDBField read GetItem write SetItem; default;
    property Owner : TSdaCtrlGrid read FOwner write FOwner;
  end;
  {Final da Coleção TDBField}


  TSdaCtrlGridLink = class(TDataLink)
  private
    FDBCtrlGrid: TSdaCtrlGrid;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
  public
    constructor Create(DBCtrlGrid: TSdaCtrlGrid);
  end;

  TSdaCtrlGridOrientation = (goVertical, goHorizontal);
  TSdaCtrlGridBorder = (gbNone, gbRaised);
  TSdaCtrlGridKey = (gkNull, gkEditMode, gkPriorTab, gkNextTab, gkLeft,
    gkRight, gkUp, gkDown, gkScrollUp, gkScrollDown, gkPageUp, gkPageDown,
    gkHome, gkEnd, gkInsert, gkAppend, gkDelete, gkCancel);

  TPaintPanelEvent = procedure(DBCtrlGrid: TSdaCtrlGrid;
    Index: Integer) of object;

  TGridState = (gsInsert, gsEdit, gsBrowse, gsInactive);

  TDBCtrlPanel = class(TWinControl)
  private
    FDBCtrlGrid: TSdaCtrlGrid;
    procedure WMEraseBkgnd(var Message: Messages.TMessage); message WM_ERASEBKGND;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure PaintWindow(DC: HDC); override;
  public
    constructor CreateLinked(DBCtrlGrid: TSdaCtrlGrid);
  end;

  TOnFillSdaDataSet = procedure(DataSet : TDataSet) of object;
  TOnClickGeralButton = procedure(Sender : TObject; var InsertRegister : Boolean) of object;
  TOnBeforeAddSdaDataSet  = procedure (SdaDataSet : TDataSet; var FieldName : String; var NewValue : Variant) of object;

  TSdaCtrlGrid = class(TWinControl)
  private
    FAutoClear : Boolean;
    FTitle : String;
    FGridState : TGridState;
    FDBFields : TDBFields;
    FDataLink: TSdaCtrlGridLink;
    FPanel: TDBCtrlPanel;
    FCanvas: TCanvas;
    FColCount: Integer;
    FRowCount: Integer;
    FPanelWidth: Integer;
    FPanelHeight: Integer;
    FPanelIndex: Integer;
    FPanelCount: Integer;
    FBitmapCount: Integer;
    FPanelBitmap: HBitmap;
    FSaveBitmap: HBitmap;
    FPanelDC: HDC;
    FOrientation: TSdaCtrlGridOrientation;
    FPanelBorder: TSdaCtrlGridBorder;
    FAllowInsert: Boolean;
    FAllowDelete: Boolean;
    FAllowInsertClient: Boolean;
    FAllowDeleteClient: Boolean;
    FShowFocus: Boolean;
    FFocused: Boolean;
    FClicking: Boolean;
    FSelColorChanged: Boolean;
    FScrollBarKind: Integer;
    FSelectedColor: TColor;
    FOnPaintPanel: TPaintPanelEvent;

		FSdaDataSet : TDataSet;
		FSdaClientDataSet : TSdaClientDataSet;
    FDataSource : TDataSource;
    FState: TGridState;
    //FFieldToBeDeleted: integer;
    FLastSequence : Integer;
    FCanDataSetChange : Boolean;

    FSdaPanelButtons : TSdaPanelButtons;
    FOnAfterPost, FOnBeforeInsert, FOnAfterInsert, FOnBeforeDelete, FOnAfterDelete, FOnBeforeCancel, FOnAfterCancel, FOnBeforeEdit, FOnAfterEdit: TNotifyEvent;
    FOnBeforeScroll, FOnAfterScroll: TDataSetNotifyEvent;
    FOnFillSdaDataSet : TOnFillSdaDataSet;
    FRequired: Boolean;
    FRequiredColor: TColor;
    FMessageCodeError: Integer;
    FPanelButtons: Boolean;
    FShowGeralButton: Boolean;
    FResourceGeralButton: String;
    FOnClickGeralButton: TOnClickGeralButton;
    FCaptionButtonGeral: String;
    FSdsDelete: TSdaClientDataSet;
    FOnBeforeAddSdaDataSet: TOnBeforeAddSdaDataSet;

    function AcquireFocus: Boolean;
    procedure AdjustSize;
    procedure CreatePanelBitmap;
    procedure DataSetChanged(Reset: Boolean);
    procedure DestroyPanelBitmap;
    procedure DrawPanel(DC: HDC; Index: Integer);
    procedure DrawPanelBackground(DC: HDC; const R: TRect; Erase, Selected: Boolean);
    function FindNext(StartControl: TWinControl; GoForward: Boolean; var WrapFlag: Integer): TWinControl;
    function GetDataSource: TDataSource;
    function GetEditMode: Boolean;
    function GetPanelBounds(Index: Integer): TRect;
    function PointInPanel(const P: TSmallPoint): Boolean;
    procedure Reset;
    procedure Scroll(Inc: Integer; ScrollLock: Boolean);
    procedure ScrollMessage(var Message: TWMScroll);
    procedure SelectNext(GoForward: Boolean);
    procedure SetColCount(Value: Integer);
    procedure SetDataSource(Value: TDataSource);
    procedure SetEditMode(Value: Boolean);
    procedure SetOrientation(Value: TSdaCtrlGridOrientation);
    procedure SetPanelBorder(Value: TSdaCtrlGridBorder);
    procedure SetPanelHeight(Value: Integer);
    procedure SetPanelIndex(Value: Integer);
    procedure SetPanelWidth(Value: Integer);
    procedure SetRowCount(Value: Integer);
    procedure SetSelectedColor(Value: TColor);
    procedure UpdateScrollBar;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMEraseBkgnd(var Message: Messages.TMessage); message WM_ERASEBKGND;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMSize(var Message: TMessage); message WM_SIZE;
    procedure CMChildKey(var Message: TCMChildKey); message CM_CHILDKEY;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure SetDBFields(const Value: TDBFields);
    procedure SetSdaDataSet(const Value: TDataSet);
    procedure UpdateControls;
    procedure AssignChangeControls;
    procedure OnDataChangeControls(Sender: TObject);
    procedure SetupInternalSdaPanelButtons;
    procedure SetPositionPanelButtons;
    function IsFieldClientDataSet(Field: String): Boolean;
    function Exists(DsSource, DsClone: TDataSet): Boolean;
    function ExistsField(DsSource: TDataSet; FieldName: String): Boolean;
  protected
    function GetChildParent: TComponent; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure CriaTabClientDS(AClientDS: TSdaClientDataSet);
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure PaintPanel(Index: Integer); virtual;
    procedure PaintWindow(DC: HDC); override;
    procedure ReadState(Reader: TReader); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure TurnOffDataSet; virtual;
    procedure DoExit; override;
    procedure DoAfterScroll(DataSet: TDataSet);
    procedure DoBeforeScroll(DataSet: TDataSet);

    procedure Loaded; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure SetParent(AParent: TWinControl); override;

    procedure CMVisiblechanged(var Message: TMessage);
      message CM_VISIBLECHANGED;
    procedure CMEnabledchanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMBidimodechanged(var Message: TMessage);
      message CM_BIDIMODECHANGED;

    property DataSource: TDataSource read GetDataSource;
    property Canvas: TCanvas read FCanvas;
    property EditMode: Boolean read GetEditMode write SetEditMode;
    property PanelCount: Integer read FPanelCount;
    property PanelIndex: Integer read FPanelIndex write SetPanelIndex;
    property State: TGridState read FState;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function HasControlFocused: boolean;
    procedure DoKey(Key: TSdaCtrlGridKey);
    procedure GetTabOrderList(List: TList); override;
    procedure Delete;
    procedure Cancel;
    procedure Insert;
    procedure Edit;
    procedure Clear;
    procedure ClearControls;
    function IsEmpty : Boolean;
    procedure FilterRegisterSdaFind(SdaFind, FieldName : String; DataSet : TDataSet; Value: String); overload;
    procedure FilterRegisterSdaFind(SdaFind, FieldName: String; DataSet : TDataSet; Value: Integer); overload;
    procedure FilterRegisterComboBox(ComboBox : String; DataSet : TDataSet; KeyFields: string; KeyValues: Variant);
    procedure FillLabel(LabelName, Value: string);
    procedure HoldDelete;
    procedure DisableAllButtons;
    Procedure EnableButtons;
    function IsEdition : Boolean;
    procedure AddSdaDataSet(Value: TDataSet; CurrentRec : Boolean = false; FieldsKey : String = '');

    property Panel: TDBCtrlPanel read FPanel;
    property SdaDataSet : TDataSet write SetSdaDataSet default nil;
    property SdaClientDataSet : TSdaClientDataSet read FSdaClientDataSet write FSdaClientDataSet;
    property SdsDelete : TSdaClientDataSet read FSdsDelete write FSdsDelete;
    property SdaPanelButtons : TSdaPanelButtons read FSdaPanelButtons write FSdaPanelButtons;
    property MessageCodeError : Integer read FMessageCodeError write FMessageCodeError default 0;
  published
    property Align;
    property AllowDelete: Boolean read FAllowDelete write FAllowDelete;
    property AllowInsert: Boolean read FAllowInsert write FAllowInsert;
    property ColCount: Integer read FColCount write SetColCount;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Orientation: TSdaCtrlGridOrientation read FOrientation write SetOrientation default goVertical;
    property PanelBorder: TSdaCtrlGridBorder read FPanelBorder write SetPanelBorder default gbRaised;
    property PanelHeight: Integer read FPanelHeight write SetPanelHeight;
    property PanelWidth: Integer read FPanelWidth write SetPanelWidth;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property TabOrder;
    property TabStop default True;
    property RowCount: Integer read FRowCount write SetRowCount;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor stored FSelColorChanged default clActiveCaption;
    property ShowFocus: Boolean read FShowFocus write FShowFocus default True;
    property ShowHint;
    property Visible;

    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnPaintPanel        : TPaintPanelEvent read FOnPaintPanel write FOnPaintPanel;
    property OnBeforeScroll      : TDataSetNotifyEvent read FOnBeforeScroll write FOnBeforeScroll;
    property OnBeforeInsert      : TNotifyEvent read FOnBeforeInsert write FOnBeforeInsert;
    property OnBeforeEdit        : TNotifyEvent read FOnBeforeEdit write FOnBeforeEdit;
    property OnBeforeCancel      : TNotifyEvent read FOnBeforeCancel write FOnBeforeCancel;
    property OnBeforeDelete      : TNotifyEvent read FOnBeforeDelete write FOnBeforeDelete;
    property OnAfterPost         : TNotifyEvent read FOnAfterPost write FOnAfterPost;
    property OnAfterInsert       : TNotifyEvent read FOnAfterInsert write FOnAfterInsert;
    property OnAfterEdit         : TNotifyEvent read FOnAfterEdit write FOnAfterEdit;
    property OnAfterCancel       : TNotifyEvent read FOnAfterCancel write FOnAfterCancel;
    property OnAfterDelete       : TNotifyEvent read FOnAfterDelete write FOnAfterDelete;
    property OnAfterScroll       : TDataSetNotifyEvent read FOnAfterScroll write FOnAfterScroll;
    property OnClickGeralButton  : TOnClickGeralButton read FOnClickGeralButton write FOnClickGeralButton;
    Property OnBeforeAddSdaDataSet: TOnBeforeAddSdaDataSet read FOnBeforeAddSdaDataSet Write FOnBeforeAddSdaDataSet;


    property OnFillSdaDataSet    : TOnFillSdaDataSet read FOnFillSdaDataSet write FOnFillSdaDataSet;
    property DBFields            : TDBFields read FDBFields write SetDBFields;
    property AutoClear           : Boolean read FAutoClear write FAutoClear;
    property Title               : String read FTitle write FTitle;
    property Required            : Boolean read FRequired write FRequired;
    property RequiredColor       : TColor read FRequiredColor write FRequiredColor;
    property PanelButtons        : Boolean read FPanelButtons write FPanelButtons;
    property ShowGeralButton     : Boolean read FShowGeralButton write FShowGeralButton;
    property ResourceGeralButton : String read FResourceGeralButton write FResourceGeralButton;
    property CaptionButtonGeral  : String read FCaptionButtonGeral write FCaptionButtonGeral;

  end;


implementation


//{$R SdaCtrlGridButtons.res}

uses // DBLocal,
uSDADataType, SdaBusca, SDAClasseBaseEDT;

{ TSdaCtrlGridLink }

constructor TSdaCtrlGridLink.Create(DBCtrlGrid: TSdaCtrlGrid);
begin
  inherited Create;
  FDBCtrlGrid := DBCtrlGrid;
  RPR;
end;

procedure TSdaCtrlGridLink.ActiveChanged;
begin
  FDBCtrlGrid.DataSetChanged(False);
  if Self.DataSource.DataSet.State in [dsBrowse] then
    FDBCtrlGrid.FState := gsBrowse
  else if Self.DataSource.DataSet.State in [dsInactive] then
    FDBCtrlGrid.FState := gsInactive;
end;

procedure TSdaCtrlGridLink.DataSetChanged;
begin
  if FDBCtrlGrid.FCanDataSetChange then
    FDBCtrlGrid.DataSetChanged(False);
end;

{ TDBCtrlPanel }

constructor TDBCtrlPanel.CreateLinked(DBCtrlGrid: TSdaCtrlGrid);
begin
  inherited Create(DBCtrlGrid);
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csDoubleClicks, csOpaque, csReplicatable];
  FDBCtrlGrid := DBCtrlGrid;
  Parent := DBCtrlGrid;
end;

procedure TDBCtrlPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params.WindowClass do
    style := style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TDBCtrlPanel.PaintWindow(DC: HDC);
var
  R: TRect;
  Selected: Boolean;
begin
  with FDBCtrlGrid do
  begin
    if FDataLink.Active then
    begin
      Selected := (FDataLink.ActiveRecord = FPanelIndex);
      DrawPanelBackground(DC, Self.ClientRect, True, Selected);
      FCanvas.Handle := DC;
      try
        FCanvas.Font := Font;
        FCanvas.Brush.Style := bsSolid;
        FCanvas.Brush.Color := Color;

        PaintPanel(FDataLink.ActiveRecord);

        if FShowFocus and FFocused and Selected then
        begin
          R := Self.ClientRect;
          if FPanelBorder = gbRaised then InflateRect(R, -2, -2);
          FCanvas.Brush.Color := Color;
          FCanvas.DrawFocusRect(R);
        end
        else
          UpdateControls;

      finally
        FCanvas.Handle := 0;
      end;
    end else
      DrawPanelBackground(DC, Self.ClientRect, True, csDesigning in ComponentState);
  end;

end;

procedure TDBCtrlPanel.WMPaint(var Message: TWMPaint);
var
  DC: HDC;
  PS: TPaintStruct;
begin
  if Message.DC = 0 then
  begin
    FDBCtrlGrid.CreatePanelBitmap;
    try
      Message.DC := FDBCtrlGrid.FPanelDC;
      PaintHandler(Message);
      Message.DC := 0;
      DC := BeginPaint(Handle, PS);
      BitBlt(DC, 0, 0, Width, Height, FDBCtrlGrid.FPanelDC, 0, 0, SRCCOPY);
      EndPaint(Handle, PS);
    finally
      FDBCtrlGrid.DestroyPanelBitmap;
    end;
  end else
    PaintHandler(Message);

end;

procedure TDBCtrlPanel.WMNCHitTest(var Message: TWMNCHitTest);
begin
  if csDesigning in ComponentState then
    Message.Result := HTCLIENT else
    Message.Result := HTTRANSPARENT;
end;

procedure TDBCtrlPanel.WMEraseBkgnd(var Message: Messages.TMessage);
begin
  Message.Result := 1;
end;

{ TSdaCtrlGrid }

procedure TSdaCtrlGrid.Loaded;
begin
  inherited Loaded;

  CriaTabClientDS(TSdaClientDataSet(DataSource.DataSet));
end;

procedure TSdaCtrlGrid.CriaTabClientDS(AClientDS: TSdaClientDataSet);
var
 i : integer;
begin
    if not (csLoading in ComponentState) then
      with AClientDS do
        begin
          close;
          fieldDefs.Clear;

          for i := 0 to FDBFields.Count - 1 do
          begin
            if (FDBFields.Items[i].FField = '') then
            begin
              showmessage('Campo não foi definido');
              exit;
            end;

            if (FDBFields.Items[i].FFieldType = ftUnknown) then
            begin
              showmessage('Tipo de Campo não foi definido');
              exit;
            end;

            if (FDBFields.Items[i].FFieldType = ftString) and (FDBFields.Items[i].FSize = 0) then
            begin
              showmessage('Tamanho não foi definido');
              exit;
            end;

            AClientDS.FieldDefs.Add( FDBFields.Items[i].FField,
                                     FDBFields.Items[i].FFieldType,
                                     FDBFields.Items[i].FSize,
                                     False)
          end;

          if FDBFields.Count > 0 then
          begin
            AClientDS.FieldDefs.Add( 'CtrlSequencial',ftInteger,0,False);

            CreateDataSet;
            Open;
            FSdsDelete.FieldDefs := FSdaClientDataSet.FieldDefs;
            FSdsDelete.CreateDataSet;
            FSdsDelete.Open;
          end;

          if FPanelButtons then
            FSdaPanelButtons.SetStateSdaCtrlGrid(ssBrowse)
          else
            FSdaPanelButtons.SetStateSdaCtrlGrid(ssInsert);
        end;
end;

constructor TSdaCtrlGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csOpaque, csDoubleClicks];
  ControlStyle := ControlStyle + [csReplicatable];
  TabStop := True;
  FDataLink := TSdaCtrlGridLink.Create(Self);
  FCanvas := TCanvas.Create;
  FPanel := TDBCtrlPanel.CreateLinked(Self);
  FColCount := 1;
  FRowCount := 3;
  FPanelWidth := 200;
  FPanelHeight := 72;
  FPanelBorder := gbRaised;
  FAllowInsert := false;
  FAllowDelete := false;
  FAllowInsertClient := false;
  FAllowDeleteClient := false;
  FShowFocus := True;
  FSelectedColor := clActiveCaption;
  FGridState := gsInactive;
  FTitle := 'Grid';
  FPanelButtons := true;
  FLastSequence := 1;
  FCanDataSetChange := true;

  FSdaClientDataSet := TSdaClientDataSet.Create(Self);
  (FSdaClientDataSet as TDataSet).BeforeScroll := DoBeforeScroll;
  (FSdaClientDataSet as TDataSet).AfterScroll  := DoAfterScroll;

  FSdsDelete := TSdaClientDataSet.Create(Self);

  FDataSource := TDataSource.Create(Self);
  FDataSource.DataSet := FSdaClientDataSet;
  SetDataSource(FDataSource);

  FDBFields := TDBFields.Create(self);

  AdjustSize;

  SetupInternalSdaPanelButtons;

end;

destructor TSdaCtrlGrid.Destroy;
begin
  FCanvas.Free;
  FDataLink.Free;
  FDataLink := nil;
  FDBFields.Free;
  FDBFields := nil;
  FSdaClientDataSet.Free;
  FSdaClientDataSet := nil;
  FSdaDataSet.Free;
  FSdaDataSet := nil;
  FDataSource.Free;
  FDataSource := nil;
  FSdaPanelButtons := nil;
  inherited Destroy;
end;

function TSdaCtrlGrid.HasControlFocused: boolean;
var
  i, j: integer;
begin
  Result := False;
  if Focused then
    Result := True
  else
    begin
      j := -1;
      for i := 0 to ControlCount - 1 do
        if Controls[i] is TDBCtrlPanel then
          if TDBCtrlPanel(Controls[i]).Focused then
            begin
              Result := True;
              Break;
            end
          else
            begin
              j := i;
              Break;
            end;
      if j <> - 1 then
        for j := 0 to TDBCtrlPanel(Controls[i]).ControlCount - 1 do
          if TWinControl(TDBCtrlPanel(Controls[i]).Controls[j]).Focused then
            begin
              Result := True;
              Break;
            end;
    end;
end;

function TSdaCtrlGrid.AcquireFocus: Boolean;
begin
  Result := True;
  if not (Focused or EditMode) then
  begin
    SetFocus;
    Result := Focused;
  end;
end;

procedure TSdaCtrlGrid.AdjustSize;
var
  W, H: Integer;
begin
  W := FPanelWidth * FColCount;
  H := FPanelHeight * FRowCount;
  if FOrientation = goVertical then
    Inc(W, GetSystemMetrics(SM_CXVSCROLL)) else
    Inc(H, GetSystemMetrics(SM_CYHSCROLL));
  SetBounds(Left, Top, W, H);
  Reset;
end;

procedure TSdaCtrlGrid.CreatePanelBitmap;
var
  DC: HDC;
begin
  if FBitmapCount = 0 then
  begin
    DC := GetDC(0);
    FPanelBitmap := CreateCompatibleBitmap(DC, FPanel.Width, FPanel.Height);
    ReleaseDC(0, DC);
    FPanelDC := CreateCompatibleDC(0);
    FSaveBitmap := SelectObject(FPanelDC, FPanelBitmap);

  end;
  Inc(FBitmapCount);

end;

procedure TSdaCtrlGrid.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_CLIPCHILDREN;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TSdaCtrlGrid.CreateWnd;
begin
  inherited CreateWnd;

  if FOrientation = goVertical then
    FScrollBarKind := SB_VERT else
    FScrollBarKind := SB_HORZ;

  if not FDataLink.Active then
    SetScrollRange(Handle, FScrollBarKind, 0, 4, False);

  UpdateScrollBar;

  if not FPanelButtons then
  begin
    FSdaPanelButtons.Visible := false;
    Top := Top - 30;
  end;

end;

procedure TSdaCtrlGrid.DataSetChanged(Reset: Boolean);
var
  NewPanelIndex, NewPanelCount: Integer;
  FocusedControl: TWinControl;
  R: TRect;
begin
  if FGridState = gsEdit then
    exit;

  if csDesigning in ComponentState then
  begin
    NewPanelIndex := 0;
    NewPanelCount := 1;
  end
  else
    if (FDataLink.Active) then
    begin
      NewPanelIndex := FDataLink.ActiveRecord;
      NewPanelCount := FDataLink.RecordCount;
      if NewPanelCount = 0 then
        NewPanelCount := 1;

    end
    else
    begin
      NewPanelIndex := 0;
      NewPanelCount := 1;
    end;

    FocusedControl := nil;
    R := GetPanelBounds(NewPanelIndex);
    if Reset or not HandleAllocated then
      FPanel.BoundsRect := R
    else
    begin
      FocusedControl := FindControl(GetFocus);

      if (FocusedControl <> FPanel) and FPanel.ContainsControl(FocusedControl) then
        FPanel.SetFocus
      else
        FocusedControl := nil;

      if NewPanelIndex <> FPanelIndex then
      begin
        SetWindowPos(FPanel.Handle, 0, R.Left, R.Top, R.Right - R.Left,
          R.Bottom - R.Top, SWP_NOZORDER or SWP_NOREDRAW);
        if NewPanelIndex >= FPanelCount then
          { Force a full redraw of all children controls when inserting a
            record and the panel is in a previously unused position }
          RedrawWindow(FPanel.Handle, nil, 0, RDW_INVALIDATE or RDW_ALLCHILDREN);
      end;
    end;

  FPanelIndex := NewPanelIndex;
  FPanelCount := NewPanelCount;
  FPanel.Visible := FPanelCount > 0;
  FPanel.Invalidate;

  if not Reset then
  begin
    Invalidate;
    Update;
  end;

  UpdateScrollBar;

  if (FocusedControl <> nil) and not FClicking and FocusedControl.CanFocus then
    FocusedControl.SetFocus;

  if FDataLink.Active then
    if FDataLink.RecordCount > 0 then
      UpdateControls;
end;

procedure TSdaCtrlGrid.DestroyPanelBitmap;
begin
  Dec(FBitmapCount);
  if FBitmapCount = 0 then
  begin
    SelectObject(FPanelDC, FSaveBitmap);
    DeleteDC(FPanelDC);
    DeleteObject(FPanelBitmap);
  end;
end;

procedure TSdaCtrlGrid.DoKey(Key: TSdaCtrlGridKey);
var
  HInc, VInc: Integer;
begin
  if FDataLink.Active then
  begin
    if FOrientation = goVertical then
    begin
      HInc := 1;
      VInc := FColCount;
    end else
    begin
      HInc := FRowCount;
      VInc := 1;
    end;
    with FDataLink.DataSet do
      case Key of
        gkEditMode: EditMode := not EditMode;
        gkPriorTab: SelectNext(False);
        gkNextTab: SelectNext(True);
        gkLeft: Scroll(-HInc, False);
        gkRight: Scroll(HInc, False);
        gkUp: Scroll(-VInc, False);
        gkDown: Scroll(VInc, False);
        gkScrollUp: Scroll(-VInc, True);
        gkScrollDown: Scroll(VInc, True);
        gkPageUp: Scroll(-FDataLink.BufferCount, True);
        gkPageDown: Scroll(FDataLink.BufferCount, True);
        gkHome: First;
        gkEnd: Last;
        gkInsert:
          if FAllowInsertClient and CanModify then
          begin
            Insert;
            EditMode := True;
          end;
        gkAppend:
          if FAllowInsertClient and CanModify then
          begin
            Append;
            EditMode := True;
          end;
        gkDelete:
          if FAllowDeleteClient and CanModify then
          begin
            Delete;
            EditMode := False;
          end;
        gkCancel:
          begin
            Cancel;
            EditMode := False;
          end;
      end;
  end;
end;

procedure TSdaCtrlGrid.DrawPanel(DC: HDC; Index: Integer);
var
  SaveActive: Integer;
  R: TRect;
begin
  R := GetPanelBounds(Index);
  if Index < FPanelCount then
  begin
    SaveActive := FDataLink.ActiveRecord;
    FDataLink.ActiveRecord := Index;

    FPanel.PaintTo(FPanelDC, 0, 0);
    FDataLink.ActiveRecord := SaveActive;

  end
   else
    DrawPanelBackground(FPanelDC, FPanel.ClientRect, True, False);

  BitBlt(DC, R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top, FPanelDC, 0, 0, SRCCOPY);

  UpdateControls;


end;

procedure TSdaCtrlGrid.DrawPanelBackground(DC: HDC; const R: TRect;
  Erase, Selected: Boolean);
var
  Brush: HBrush;
begin
  if Erase then
  begin
    if Selected then FPanel.Color := FSelectedColor
    else FPanel.Color := Color;
    Brush := CreateSolidBrush(ColorToRGB(FPanel.Color));
    FillRect(DC, R, Brush);
    DeleteObject(Brush);
  end;
  if FPanelBorder = gbRaised then
    DrawEdge(DC, PRect(@R)^, BDR_RAISEDINNER, BF_RECT);

end;

function TSdaCtrlGrid.GetChildParent: TComponent;
begin
  Result := FPanel;
end;


procedure TSdaCtrlGrid.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
  FPanel.GetChildren(Proc, Root);
end;

function TSdaCtrlGrid.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TSdaCtrlGrid.GetEditMode: Boolean;
begin
  Result := not Focused and ContainsControl(FindControl(GetFocus));
end;

function TSdaCtrlGrid.GetPanelBounds(Index: Integer): TRect;
var
  Col, Row: Integer;
begin
  if FOrientation = goVertical then
  begin
    Col := Index mod FColCount;
    Row := Index div FColCount;
  end else
  begin
    Col := Index div FRowCount;
    Row := Index mod FRowCount;
  end;
  Result.Left := FPanelWidth * Col;
  Result.Top := FPanelHeight * Row;
  Result.Right := Result.Left + FPanelWidth;
  Result.Bottom := Result.Top + FPanelHeight;
end;

procedure TSdaCtrlGrid.GetTabOrderList(List: TList);
begin
end;

procedure TSdaCtrlGrid.KeyDown(var Key: Word; Shift: TShiftState);
var
  GridKey: TSdaCtrlGridKey;
begin
  inherited KeyDown(Key, Shift);
  GridKey := gkNull;
  case Key of
    VK_LEFT: GridKey := gkLeft;
    VK_RIGHT: GridKey := gkRight;
    VK_UP: GridKey := gkUp;
    VK_DOWN: GridKey := gkDown;
    VK_PRIOR: GridKey := gkPageUp;
    VK_NEXT: GridKey := gkPageDown;
    VK_HOME: GridKey := gkHome;
    VK_END: GridKey := gkEnd;
    VK_RETURN, VK_F2: GridKey := gkEditMode;
    VK_INSERT:
      if GetKeyState(VK_CONTROL) >= 0 then
        GridKey := gkInsert else
        GridKey := gkAppend;
    VK_DELETE: if GetKeyState(VK_CONTROL) < 0 then GridKey := gkDelete;
    VK_ESCAPE: GridKey := gkCancel;
  end;
  DoKey(GridKey);
end;

procedure TSdaCtrlGrid.PaintWindow(DC: HDC);
var
  I: Integer;
  Brush: HBrush;
begin
  if csDesigning in ComponentState then
  begin
    FPanel.Update;
    Brush := CreateHatchBrush(HS_BDIAGONAL, ColorToRGB(clBtnShadow));
    SetBkColor(DC, ColorToRGB(Color));
    FillRect(DC, ClientRect, Brush);
    DeleteObject(Brush);
    for I := 1 to FColCount * FRowCount - 1 do
      DrawPanelBackground(DC, GetPanelBounds(I), False, False);
  end else
  begin
    CreatePanelBitmap;
    try
      for I := 0 to FColCount * FRowCount - 1 do
      begin
        if (FPanelCount <> 0) and (I = FPanelIndex) then
          FPanel.Update
        else
          DrawPanel(DC, I);

      end;
    finally
      DestroyPanelBitmap;
    end;
  end;
  { When width or height are not evenly divisible by panel size, fill the gaps }
  if HandleAllocated then
  begin
    if (Height <> FPanel.Height * FRowCount) then
    begin
      Brush := CreateSolidBrush(ColorToRGB(Color));
      FillRect(DC, Rect(0, FPanel.Height * FRowCount, Width, Height), Brush);
      DeleteObject(Brush);
    end;
    if (Width <> FPanel.Width * FColCount) then
    begin
      Brush := CreateSolidBrush(ColorToRGB(Color));
      FillRect(DC, Rect(FPanelWidth * FColCount, 0, Width, Height), Brush);
      DeleteObject(Brush);
    end;
  end;
end;

procedure TSdaCtrlGrid.PaintPanel(Index: Integer);
begin
  if Assigned(FOnPaintPanel) then FOnPaintPanel(Self, Index);
end;

function TSdaCtrlGrid.PointInPanel(const P: TSmallPoint): Boolean;
begin
  Result := (FPanelCount > 0) and PtInRect(GetPanelBounds(FPanelIndex),
    SmallPointToPoint(P));
end;

procedure TSdaCtrlGrid.ReadState(Reader: TReader);
begin
  inherited ReadState(Reader);
  FPanel.FixupTabList;
end;

procedure TSdaCtrlGrid.Reset;
begin
  if csDesigning in ComponentState then
    FDataLink.BufferCount := 1 else
    FDataLink.BufferCount := FColCount * FRowCount;
  DataSetChanged(True);
end;

procedure TSdaCtrlGrid.Scroll(Inc: Integer; ScrollLock: Boolean);
var
  NewIndex, ScrollInc, Adjust: Integer;
begin
  if FDataLink.Active and (Inc <> 0) then
    with FDataLink.DataSet do
      if State = dsInsert then
      begin
        UpdateRecord;
        if Modified then Post else
          if (Inc < 0) or not EOF then Cancel;
      end else
      begin
        CheckBrowseMode;
        DisableControls;
        try
          if ScrollLock then
            if Inc > 0 then
              MoveBy(Inc - MoveBy(Inc + FDataLink.BufferCount - FPanelIndex - 1))
            else
              MoveBy(Inc - MoveBy(Inc - FPanelIndex))
          else
          begin
            NewIndex := FPanelIndex + Inc;
            if (NewIndex >= 0) and (NewIndex < FDataLink.BufferCount) then
              MoveBy(Inc)
            else
              if MoveBy(Inc) = Inc then
              begin
                if FOrientation = goVertical then
                  ScrollInc := FColCount else
                  ScrollInc := FRowCount;
                if Inc > 0 then
                  Adjust := ScrollInc - 1 - NewIndex mod ScrollInc
                else
                  Adjust := 1 - ScrollInc - (NewIndex + 1) mod ScrollInc;
                MoveBy(-MoveBy(Adjust));
              end;
          end;
          if (Inc = 1) and EOF and FAllowInsertClient and CanModify then Append;
        finally
          EnableControls;
        end;
      end;
end;

procedure TSdaCtrlGrid.ScrollMessage(var Message: TWMScroll);
var
  Key: TSdaCtrlGridKey;
  SI: TScrollInfo;
begin
  if AcquireFocus then
  begin
    Key := gkNull;
    case Message.ScrollCode of
      SB_LINEUP: Key := gkScrollUp;
      SB_LINEDOWN: Key := gkScrollDown;
      SB_PAGEUP: Key := gkPageUp;
      SB_PAGEDOWN: Key := gkPageDown;
      SB_TOP: Key := gkHome;
      SB_BOTTOM: Key := gkEnd;
      SB_THUMBPOSITION:
        if FDataLink.Active and FDataLink.DataSet.IsSequenced then
        begin
          SI.cbSize := sizeof(SI);
          SI.fMask := SIF_ALL;
          GetScrollInfo(Self.Handle, FScrollBarKind, SI);
          if SI.nTrackPos <= 1 then Key := gkHome
          else if SI.nTrackPos >= FDataLink.DataSet.RecordCount then Key := gkEnd
          else
          begin
            FDataLink.DataSet.RecNo := SI.nTrackPos;
            Exit;
          end;
        end else
        begin
          case Message.Pos of
            0: Key := gkHome;
            1: Key := gkPageUp;
            3: Key := gkPageDown;
            4: Key := gkEnd;
          end;
        end;
    end;
    DoKey(Key);
  end;
end;

function TSdaCtrlGrid.FindNext(StartControl: TWinControl; GoForward: Boolean;
  var WrapFlag: Integer): TWinControl;
var
  I, StartIndex: Integer;
  List: TList;
begin
  List := TList.Create;
  try
    StartIndex := 0;
    I := 0;
    Result := StartControl;
    FPanel.GetTabOrderList(List);
    if List.Count > 0 then
    begin
      StartIndex := List.IndexOf(StartControl);
      if StartIndex = -1 then
        if GoForward then
          StartIndex := List.Count - 1 else
          StartIndex := 0;
      I := StartIndex;
      repeat
        if GoForward then
        begin
          Inc(I);
          if I = List.Count then I := 0;
        end else
        begin
          if I = 0 then I := List.Count;
          Dec(I);
        end;
        Result := List[I];
      until (Result.CanFocus and Result.TabStop) or (I = StartIndex);
    end;
    WrapFlag := 0;
    if GoForward then
    begin
      if I <= StartIndex then WrapFlag := 1;
    end else
    begin
      if I >= StartIndex then WrapFlag := -1;
    end;
  finally
    List.Free;
  end;
end;

procedure TSdaCtrlGrid.SelectNext(GoForward: Boolean);
var
  WrapFlag: Integer;
  ParentForm: TCustomForm;
  ActiveControl, Control: TWinControl;
begin
  ParentForm := GetParentForm(Self);
  if ParentForm <> nil then
  begin
    ActiveControl := ParentForm.ActiveControl;
    if ContainsControl(ActiveControl) then
    begin
      Control := FindNext(ActiveControl, GoForward, WrapFlag);
      if not (FDataLink.DataSet.State in dsEditModes) then
      begin
        FPanel.SetFocus;
        try
          if WrapFlag <> 0 then Scroll(WrapFlag, False);
        except
          ActiveControl.SetFocus;
          raise;
        end
      end;
      if not Control.CanFocus then
        Control := FindNext(Control, GoForward, WrapFlag);
      if Control.CanFocus then
	      Control.SetFocus;
    end;
  end;
end;

procedure TSdaCtrlGrid.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  ScrollWidth, ScrollHeight, NewPanelWidth, NewPanelHeight: Integer;
begin
  ScrollWidth := 0;
  ScrollHeight := 0;
  if FOrientation = goVertical then
    ScrollWidth := GetSystemMetrics(SM_CXVSCROLL) else
    ScrollHeight := GetSystemMetrics(SM_CYHSCROLL);
  NewPanelWidth := (AWidth - ScrollWidth) div FColCount;
  NewPanelHeight := (AHeight - ScrollHeight) div FRowCount;
  if NewPanelWidth < 1 then NewPanelWidth := 1;
  if NewPanelHeight < 1 then NewPanelHeight := 1;
  if (FPanelWidth <> NewPanelWidth) or (FPanelHeight <> NewPanelHeight) then
  begin
    FPanelWidth := NewPanelWidth;
    FPanelHeight := NewPanelHeight;
    Reset;
  end;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  SetPositionPanelButtons;
end;

procedure TSdaCtrlGrid.SetColCount(Value: Integer);
begin
  if Value < 1 then Value := 1;
  if Value > 100 then Value := 100;
  if FColCount <> Value then
  begin
    FColCount := Value;
    AdjustSize;
  end;
end;

procedure TSdaCtrlGrid.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
end;

procedure TSdaCtrlGrid.SetEditMode(Value: Boolean);
var
  Control: TWinControl;
begin
  if GetEditMode <> Value then
    if Value then
    begin
      Control := FPanel.FindNextControl(nil, True, True, False);
      if Control <> nil then Control.SetFocus;
    end else
      SetFocus;
end;

procedure TSdaCtrlGrid.SetOrientation(Value: TSdaCtrlGridOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    RecreateWnd;
    AdjustSize;
  end;
end;

procedure TSdaCtrlGrid.SetPanelBorder(Value: TSdaCtrlGridBorder);
begin
  if FPanelBorder <> Value then
  begin
    FPanelBorder := Value;
    Invalidate;
    FPanel.Invalidate;
  end;
end;

procedure TSdaCtrlGrid.SetPanelHeight(Value: Integer);
begin
  if Value < 1 then Value := 1;
  if Value > 65535 then Value := 65535;
  if FPanelHeight <> Value then
  begin
    FPanelHeight := Value;
    AdjustSize;
  end;
end;

procedure TSdaCtrlGrid.SetPanelIndex(Value: Integer);
begin
  if FDataLink.Active and (Value < PanelCount) then
    FDataLink.DataSet.MoveBy(Value - FPanelIndex);
end;

procedure TSdaCtrlGrid.SetPanelWidth(Value: Integer);
begin
  if Value < 1 then Value := 1;
  if Value > 65535 then Value := 65535;
  if FPanelWidth <> Value then
  begin
    FPanelWidth := Value;
    AdjustSize;
  end;
end;

procedure TSdaCtrlGrid.SetRowCount(Value: Integer);
begin
  if Value < 1 then Value := 1;
  if Value > 100 then Value := 100;
  if FRowCount <> Value then
  begin
    FRowCount := Value;
    AdjustSize;
  end;
end;

procedure TSdaCtrlGrid.SetSelectedColor(Value: TColor);
begin
  if Value <> FSelectedColor then
  begin
    FSelectedColor := Value;
    FSelColorChanged := Value <> Color;
    Invalidate;
    FPanel.Invalidate;
  end;
end;

procedure TSdaCtrlGrid.UpdateScrollBar;
var
  SIOld, SINew: TScrollInfo;
begin
  if FDatalink.Active and HandleAllocated then
    with FDatalink.DataSet do
    begin
      SIOld.cbSize := sizeof(SIOld);
      SIOld.fMask := SIF_ALL;
      GetScrollInfo(Self.Handle, FScrollBarKind, SIOld);
      SINew := SIOld;
      if IsSequenced then
      begin
        SINew.nMin := 1;
        SINew.nPage := Self.RowCount * Self.ColCount;
        SINew.nMax := RecordCount + SINew.nPage -1;
        if State in [dsInactive, dsBrowse, dsEdit] then
          SINew.nPos := RecNo;
      end
      else
      begin
        SINew.nMin := 0;
        SINew.nPage := 0;
        SINew.nMax := 4;
        if BOF then SINew.nPos := 0
        else if EOF then SINew.nPos := 4
        else SINew.nPos := 2;
      end;
      if (SINew.nMin <> SIOld.nMin) or (SINew.nMax <> SIOld.nMax) or
        (SINew.nPage <> SIOld.nPage) or (SINew.nPos <> SIOld.nPos) then
        SetScrollInfo(Self.Handle, FScrollBarKind, SINew, True);
    end;
end;

procedure TSdaCtrlGrid.WMLButtonDown(var Message: TWMLButtonDown);
var
  I: Integer;
  P: TPoint;
  Window: HWnd;
begin
  if FDataLink.Active then
  begin
    P := SmallPointToPoint(Message.Pos);
    for I := 0 to FPanelCount - 1 do
      if (I <> FPanelIndex) and PtInRect(GetPanelBounds(I), P) then
      begin
        FClicking := True;
        try
          SetPanelIndex(I);
        finally
          FClicking := False;
        end;
        P := ClientToScreen(P);
        Window := WindowFromPoint(P);
        if IsChild(FPanel.Handle, Window) then
        begin
          Windows.ScreenToClient(Window, P);
          Message.Pos := PointToSmallPoint(P);
          with Messages.TMessage(Message) do SendMessage(Window, Msg, WParam, LParam);
          Exit;
        end;
        Break;
      end;
  end;
  if AcquireFocus then
  begin
    if PointInPanel(Message.Pos) then
    begin
      EditMode := False;
      Click;
    end;
    inherited;
  end;
end;

procedure TSdaCtrlGrid.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  if PointInPanel(Message.Pos) then DblClick;
  inherited;
end;

procedure TSdaCtrlGrid.WMHScroll(var Message: TWMHScroll);
begin
  ScrollMessage(Message);
end;

procedure TSdaCtrlGrid.WMVScroll(var Message: TWMVScroll);
begin
  ScrollMessage(Message);
end;

procedure TSdaCtrlGrid.WMEraseBkgnd(var Message: Messages.TMessage);
begin
  Message.Result := 1;
end;

procedure TSdaCtrlGrid.WMPaint(var Message: TWMPaint);
begin
  PaintHandler(Message);
end;

procedure TSdaCtrlGrid.WMSetFocus(var Message: TWMSetFocus);
begin
  FFocused := True;
  FPanel.Repaint;
end;

procedure TSdaCtrlGrid.WMKillFocus(var Message: TWMKillFocus);
begin
  FFocused := False;
  FPanel.Repaint;
end;

procedure TSdaCtrlGrid.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS or DLGC_WANTCHARS;
end;

procedure TSdaCtrlGrid.WMSize(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

function GetShiftState: TShiftState;
begin
  Result := [];
  if GetKeyState(VK_SHIFT) < 0 then Include(Result, ssShift);
  if GetKeyState(VK_CONTROL) < 0 then Include(Result, ssCtrl);
  if GetKeyState(VK_MENU) < 0 then Include(Result, ssAlt);
end;

procedure TSdaCtrlGrid.CMChildKey(var Message: TCMChildKey);
var
  ShiftState: TShiftState;
  GridKey: TSdaCtrlGridKey;
begin
  with Message do
    if Sender <> Self then
    begin
      ShiftState := GetShiftState;
      if Assigned(OnKeyDown) then OnKeyDown(Sender, CharCode, ShiftState);
      GridKey := gkNull;
      case CharCode of
        VK_TAB:
          if not (ssCtrl in ShiftState) and
            (Sender.Perform(WM_GETDLGCODE, 0, 0) and DLGC_WANTTAB = 0) then
            if ssShift in ShiftState then
              GridKey := gkPriorTab else
              GridKey := gkNextTab;
        VK_RETURN:
          if (Sender.Perform(WM_GETDLGCODE, 0, 0) and DLGC_WANTALLKEYS = 0) then
            GridKey := gkEditMode;
        VK_F2: GridKey := gkEditMode;
        VK_ESCAPE: GridKey := gkCancel;
      end;
      if GridKey <> gkNull then
      begin
        DoKey(GridKey);
        Result := 1;
        Exit;
      end;
    end;
  inherited;
end;

procedure TSdaCtrlGrid.CMColorChanged(var Message: TMessage);
begin
  inherited;
  if not FSelColorChanged then
    FSelectedColor := Color;
end;

procedure TSdaCtrlGrid.SetDBFields(const Value: TDBFields);
begin
    FDBFields.Assign(Value);
		CriaTabClientDS(TSdaClientDataSet(FSdaClientDataSet));
end;

procedure TSdaCtrlGrid.TurnOffDataSet;
begin
  FDataSource.Enabled := False;
end;

procedure TSdaCtrlGrid.DoExit;
begin
  inherited DoExit;
end;

procedure TSdaCtrlGrid.Clear;
begin
  if FSdaClientDataSet.State in [dsInsert, dsEdit] then
    FSdaClientDataSet.Cancel;

  if Assigned(TSdaClientDataSet(FSdaClientDataSet)) then
    if TSdaClientDataSet(FSdaClientDataSet).State <> dsInactive then
    begin
      TSdaClientDataSet(FSdaClientDataSet).EmptyDataSet;
      FSdsDelete.EmptyDataSet;
    end;

  ClearControls;

  if FPanelButtons then
    FSdaPanelButtons.SetStateSdaCtrlGrid(ssBrowse);
end;

function TSdaCtrlGrid.IsFieldClientDataSet(Field : String) : Boolean;
var
  k : Integer;
begin
  Result := false;
  for k := 0 to FDataLink.DataSet.Fields.Count - 1 do
    if UpperCase(FDataLink.DataSet.Fields[k].FieldName) = UpperCase(Field) then
      Result := true;
end;


procedure TSdaCtrlGrid.UpdateControls;
var
  i, j : integer;


  function IsNumber(value : Variant) : Boolean;
  var
    i : Integer;
    Str : String;
  begin
    Str := VarToStr(value);
    Result := true;
    for i := 1 to length(Str) do
      if not (Str[i] in ['0'..'9']) then
        result := false;
  end;

begin
  if FDataLink.DataSet.State = dsInactive then
    exit;

  if FDataLink.DataSet.RecordCount = 0 then
    exit;

  for i := 0 to FDBFields.Count - 1 do
    for j := 0 to FPanel.ControlCount - 1 do
    begin
      if Uppercase(TWinControl(FPanel.Controls[j]).Name) = UpperCase(FDBFields.Items[i].FControl) then
        if IsFieldClientDataSet(FDBFields.Items[i].FField) then
        begin
         // if FPanel.Controls[j] is TSdaEditString then
       //     TSdaEditString(FPanel.Controls[j]).Value := FDataLink.DataSet.FieldByname(FDBFields.Items[i].FField).AsSTring
        //  else  if FPanel.Controls[j] is TSdaEditInteger then
       //     TSdaEditInteger(FPanel.Controls[j]).Value := FDataLink.DataSet.FieldByname(FDBFields.Items[i].FField).AsInteger
       //   else if FPanel.Controls[j] is TSdaEditFloat then
      //      TSdaEditFloat(FPanel.Controls[j]).Value := FDataLink.DataSet.FieldByname(FDBFields.Items[i].FField).AsFloat
     //     else if FPanel.Controls[j] is TSdaEditDate then
     //       TSdaEditDate(FPanel.Controls[j]).Value := FDataLink.DataSet.FieldByname(FDBFields.Items[i].FField).AsDateTime
     //     else if FPanel.Controls[j] is TSdaEditMultipleMask then
     //       TSdaEditMultipleMask(FPanel.Controls[j]).Value := FDataLink.DataSet.FieldByname(FDBFields.Items[i].FField).AsString
        //  else
         //  if FPanel.Controls[j] is TSdaMemo then
       //     TSdaMemo(FPanel.Controls[j]).text := FDataLink.DataSet.FieldByname(FDBFields.Items[i].FField).AsString
     //     else if FPanel.Controls[j] is TSdaDBComboBox then
     //     begin
      //      TSdaDBComboBox(FPanel.Controls[j]).Locate(TSdaDBComboBox(FPanel.Controls[j]).FieldView, FDataLink.DataSet.FieldByname(FDBFields.Items[i].FField).AsString)
    //      end
    //      else if FPanel.Controls[j] is TSdaRadioGroup then
    //      begin
    //        if IsNumber(FDataLink.DataSet.FieldByname(FDBFields.Items[i].FField).Value) then
      //        TSdaRadioGroup(FPanel.Controls[j]).ValueInteger := FDataLink.DataSet.FieldByname(FDBFields.Items[i].FField).AsInteger
    //        else
     //         TSdaRadioGroup(FPanel.Controls[j]).ValueString := FDataLink.DataSet.FieldByname(FDBFields.Items[i].FField).AsString;
  //        end
  //        else if FPanel.Controls[j] is TSdaCheckBox then
  //        begin
    //        if IsNumber(FDataLink.DataSet.FieldByname(FDBFields.Items[i].FField).Value) then
   //           TSdaCheckBox(FPanel.Controls[j]).ValueInteger := FDataLink.DataSet.FieldByname(FDBFields.Items[i].FField).AsInteger
   //         else
    //          TSdaCheckBox(FPanel.Controls[j]).ValueString := FDataLink.DataSet.FieldByname(FDBFields.Items[i].FField).AsString;
     //     end;
        end;
    end;

    if Assigned(FOnFillSdaDataSet) then
      FOnFillSdaDataSet(FSdaClientDataSet);

end;

procedure TSdaCtrlGrid.ClearControls;
var
  i, j : integer;
begin
  for i := 0 to FDBFields.Count - 1 do
    for j := 0 to FPanel.ControlCount - 1 do
    begin
      if Uppercase(TWinControl(FPanel.Controls[j]).Name) = UpperCase(FDBFields.Items[i].FControl) then
        if IsFieldClientDataSet(FDBFields.Items[i].FField) then
        begin
          if FPanel.Controls[j] is TSdaEdit then
            TSdaEdit(FPanel.Controls[j]).Clear
          {else if FPanel.Controls[j] is TSdaEditInt then
            TSdaEditInteger(FPanel.Controls[j]).Clear
          else if FPanel.Controls[j] is TSdaEditFloat then
            TSdaEditFloat(FPanel.Controls[j]).Clear
          else if FPanel.Controls[j] is TSdaEditDate then
            TSdaEditDate(FPanel.Controls[j]).Clear
          else if FPanel.Controls[j] is TSdaEditMultipleMask then
            TSdaEditMultipleMask(FPanel.Controls[j]).Clear
          else if FPanel.Controls[j] is TSdaMemo then
            TSdaMemo(FPanel.Controls[j]).Clear
          else if FPanel.Controls[j] is TSdaRadioGroup then
            TSdaRadioGroup(FPanel.Controls[j]).ValueString := TSdaRadioGroup(FPanel.Controls[j]).defaultValue
          else if FPanel.Controls[j] is TSdaCheckBox then
            TSdaCheckBox(FPanel.Controls[j]).cheCked := false
          else if FPanel.Controls[j] is TSdaDBComboBox then
            TSdaDBComboBox(FPanel.Controls[j]).ItemIndex := -1;   }
        end;
    end;
end;

procedure TSdaCtrlGrid.SetSdaDataSet(const Value: TDataSet);
var
  i : Integer;
begin
  if Value <> nil then
  begin
{    if Assigned(FSdaDataSet) then
      FSdaDataSet.Free;

    FSdaDataSet := Value;
}
    if not FSdaClientDataSet.Active then
    begin
      CriaTabClientDS(TSdaClientDataSet(FSdaClientDataSet));
      FSdaClientDataSet.Open;
      FSdsDelete.Open;
    end
    else
      Clear;

    if FSdaClientDataSet.State in [dsInsert, dsEdit] then
      FSdaClientDataSet.Cancel;

    FSdaClientDataSet.DisableControls;

    try

//        if Value.RecordCount > 0 then
        Value.First;

        FLastSequence := 1;

        while not Value.Eof do
        begin
          FGridState := gsInsert;

          FSdaClientDataSet.Append;
          for i := 0 to FSdaClientDataSet.Fields.Count - 2 do
            FSdaClientDataSet.FieldByName(FSdaClientDataSet.Fields[i].FieldName).Value := Value.FieldByName(FSdaClientDataSet.Fields[i].FieldName).Value;

          FSdaClientDataSet.FieldByName('CtrlSequencial').Value := FLastSequence;
          FSdaClientDataSet.Post;

          try
            UpdateControls;
          Except
          end;

          Repaint;

          Inc(FLastSequence);

          Value.NExt;
        end;

        if Value.RecordCount > 0 then
        begin
          FSdaClientDataSet.First;
          AssignChangeControls;
        end;

        FGridState := gsBrowse;

        if FPanelButtons then
          FSdaPanelButtons.SetStateSdaCtrlGrid(ssBrowse)
        else
          FSdaPanelButtons.SetStateSdaCtrlGrid(ssInsert);

    finally
      FSdaClientDataSet.EnableControls;
    end;
  end;
end;

procedure TSdaCtrlGrid.AssignChangeControls;
var
  i : Integer;
begin
  if FDataLink.DataSet.State <> dsBrowse then
    exit;

  for i := 0 to FPanel.ControlCount - 1 do
  begin
    if (FPanel.ControlS[I] is TSdaEdit) then
       TSdaEdit(FPanel.ControlS[I]).OnChange :=  OnDataChangeControls
   { else if (FPanel.ControlS[I] is TSdaEditInteger) then
       TSdaEditInteger(FPanel.ControlS[I]).OnChange := OnDataChangeControls
    else if (FPanel.ControlS[I] is TSdaEditFloat) then
       TSdaEditFloat(FPanel.ControlS[I]).OnChange := OnDataChangeControls
    else if (FPanel.ControlS[I] is TSdaEditDate) then
       TSdaEditDate(FPanel.ControlS[I]).OnChange := OnDataChangeControls
    else if (FPanel.ControlS[I] is TSdaEditMultipleMask) then
       TSdaEditMultipleMask(FPanel.ControlS[I]).OnChange := OnDataChangeControls
    else if (FPanel.ControlS[I] is TSdaMemo) then
       TSdaMemo(FPanel.ControlS[I]).OnChange := OnDataChangeControls
    else if (FPanel.ControlS[I] is TSdaRadioGroup) then
       TSdaRadioGroup(FPanel.ControlS[I]).OnClick :=  OnDataChangeControls
    else if (FPanel.ControlS[I] is TSdaCheckBox) then
       TSdaCheckBox(FPanel.ControlS[I]).OnClick :=  OnDataChangeControls
    else if (FPanel.ControlS[I] is TSdaDBComboBox) then
       TSdaDBComboBox(FPanel.ControlS[I]).OnChange :=  OnDataChangeControls;  }
  end;
end;

procedure TSdaCtrlGrid.OnDataChangeControls(Sender: TObject);
var
  i : Integer;
begin
	if FSdaClientDataSet.Active then
    if FSdaClientDataSet.RecordCount > 0 then
    begin
      FSdaClientDataSet.Edit;
      for i := 0 to FDBFields.Count - 1 do
        if Sender is TSdaEdit then
        begin
          if UpperCase(FDBFields.Items[i].FControl) = UpperCase(TSdaEdit(Sender).Name) then
            FSdaClientDataSet.FieldByName(FDBFields.Items[i].FField).AsString := TSdaEdit(Sender).text;
        end
      {  else if Sender is TSdaEditInteger then
        begin
          if UpperCase(FDBFields.Items[i].FControl) = UpperCase(TSdaEditInteger(Sender).Name) then
            FSdaClientDataSet.FieldByName(FDBFields.Items[i].FField).AsInteger := TSdaEditInteger(Sender).Value;
        end
        else if Sender is TSdaEditFloat then
        begin
          if UpperCase(FDBFields.Items[i].FControl) = UpperCase(TSdaEditFloat(Sender).Name) then
            FSdaClientDataSet.FieldByName(FDBFields.Items[i].FField).AsFloat := TSdaEditFloat(Sender).Value;
        end
        else if Sender is TSdaEditDate then
        begin
          if UpperCase(FDBFields.Items[i].FControl) = UpperCase(TSdaEditDate(Sender).Name) then
            if TSdaEditDate(Sender).IsComplete then
              if TSdaEditDate(Sender).ValidDate then
                FSdaClientDataSet.FieldByName(FDBFields.Items[i].FField).AsDateTime := TSdaEditDate(Sender).Value;
        end
        else if Sender is TSdaEditMultipleMask then
        begin
          if UpperCase(FDBFields.Items[i].FControl) = UpperCase(TSdaEditMultipleMask(Sender).Name) then
            FSdaClientDataSet.FieldByName(FDBFields.Items[i].FField).AsString := TSdaEditMultipleMask(Sender).Value;
        end
        else if Sender is TSdaMemo then
        begin
          if UpperCase(FDBFields.Items[i].FControl) = UpperCase(TSdaMemo(Sender).Name) then
            FSdaClientDataSet.FieldByName(FDBFields.Items[i].FField).AsString := TSdaMemo(Sender).Value;
        end
        else if Sender is TSdaRadioGroup then
        begin
          if UpperCase(FDBFields.Items[i].FControl) = UpperCase(TSdaRadioGroup(Sender).Name) then
            FSdaClientDataSet.FieldByName(FDBFields.Items[i].FField).AsString := TSdaRadioGroup(Sender).ValueString;
        end
        else if Sender is TSdaCheckBox then
        begin
          if UpperCase(FDBFields.Items[i].FControl) = UpperCase(TSdaCheckBox(Sender).Name) then
            FSdaClientDataSet.FieldByName(FDBFields.Items[i].FField).AsString := TSdaCheckBox(Sender).ValueString;
        end
        else if Sender is TSdaDBComboBox then
        begin
          if UpperCase(FDBFields.Items[i].FControl) = UpperCase(TSdaDBComboBox(Sender).Name) then
          begin
            if TSdaDBComboBox(Sender).SdaDataSet.RecNo <> TSdaDBComboBox(Sender).ItemIndex + 1 then
              TSdaDBComboBox(Sender).SdaDataSet.RecNo := TSdaDBComboBox(Sender).ItemIndex + 1 ;

            FSdaClientDataSet.FieldByName(FDBFields.Items[i].FField).AsString := TSdaDBComboBox(Sender).ValueString;
          end;   }
        end;

  //  end;
end;

function TSdaCtrlGrid.IsEmpty: Boolean;
begin
  Result := FSdaClientDataSet.RecordCount = 0;
end;

procedure TSdaCtrlGrid.Delete;
begin
  if FSdaClientDataSet.RecordCount > 0 then
    FSdaClientDataSet.Delete;
end;

procedure TSdaCtrlGrid.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  FSdaPanelButtons.BiDiMode := BiDiMode;
end;

procedure TSdaCtrlGrid.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  FSdaPanelButtons.Enabled := Enabled;
end;

procedure TSdaCtrlGrid.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  FSdaPanelButtons.Visible := Visible;
end;

procedure TSdaCtrlGrid.SetupInternalSdaPanelButtons;
begin
  if Assigned(FSdaPanelButtons) then exit;
  FSdaPanelButtons := TSdaPanelButtons.Create(Self);
  FSdaPanelButtons.FreeNotification(Self);
  SetPositionPanelButtons;
end;


procedure TSdaCtrlGrid.SetPositionPanelButtons;
var
  P: TPoint;
begin
  if FSdaPanelButtons = nil then exit;

  P := Point(Left, Top - 30);

  FSdaPanelButtons.SetBounds(P.x, P.y, Width, 30);
end;

procedure TSdaCtrlGrid.SetParent(AParent: TWinControl);
begin
  inherited;
  inherited SetParent(AParent);
  if FSdaPanelButtons = nil then exit;
  FSdaPanelButtons.Parent := AParent;
  FSdaPanelButtons.Visible := True;

end;

procedure TSdaCtrlGrid.Cancel;
begin
  FSdaClientDataSet.Cancel;
end;

procedure TSdaCtrlGrid.Edit;
begin
  FSdaClientDataSet.Edit;
end;

procedure TSdaCtrlGrid.Insert;
begin
  FSdaClientDataSet.Insert;
end;

procedure TSdaCtrlGrid.FilterRegisterComboBox(ComboBox : String; DataSet : TDataSet; KeyFields: string; KeyValues: Variant);
var
  i : Integer;
begin
  if DataSet.State <> dsBrowse then
    exit;

  {for i := 0 to FPanel.ControlCount - 1 do
    if FPanel.Controls[i] is TSdaDBComboBox then
      if LowerCase(FPanel.Controls[i].Name) = LowerCase(ComboBox) then
      begin
          TSdaDBComboBox(FPanel.Controls[i]).Locate(KeyFields,KeyValues);
      end; }
end;

procedure TSdaCtrlGrid.FillLabel(LabelName, Value: string);
var
  i : Integer;
begin
  for i := 0 to FPanel.ControlCount - 1 do
    if FPanel.Controls[i] is TLabel then
      if LowerCase(FPanel.Controls[i].Name) = LowerCase(LabelName) then
        if Value <> 'NULL' then
          TLabel(FPanel.Controls[i]).Caption := Value
        else
          TLabel(FPanel.Controls[i]).Caption := '';
end;

procedure TSdaCtrlGrid.FilterRegisterSdaFind(SdaFind, FieldName : String; DataSet : TDataSet; Value: String);
var
  i : Integer;
begin
  if DataSet.State <> dsBrowse then
    exit;

  for i := 0 to FPanel.ControlCount - 1 do
    if FPanel.Controls[i] is TSDABusca then
    begin
      if LowerCase(FPanel.Controls[i].Name) = LowerCase(SdaFind) then
      begin
        TSDABusca(FPanel.Controls[i]).UpdatedControl := false;
        TSDABusca(FPanel.Controls[i]).Filter := FieldName + ' = ''' + Value + '''';
        TSDABusca(FPanel.Controls[i]).UpdatedControl := true;
      end;
    end;

end;

procedure TSdaCtrlGrid.FilterRegisterSdaFind(SdaFind, FieldName: String; DataSet : TDataSet; Value: Integer);
var
  i : Integer;
begin
  if DataSet.State <> dsBrowse then
    exit;

  for i := 0 to FPanel.ControlCount - 1 do
    if FPanel.Controls[i] is TSDABusca then
      if LowerCase(FPanel.Controls[i].Name) = LowerCase(SdaFind) then
      begin
        TSDABusca(FPanel.Controls[i]).UpdatedControl := false;
        TSDABusca(FPanel.Controls[i]).Filter := FieldName + ' = ' + IntToStr(Value);
        TSDABusca(FPanel.Controls[i]).UpdatedControl := true;
      end;

end;

procedure TSdaCtrlGrid.HoldDelete;
var
  i : Integer;
begin
  FSdsDelete.Insert;

  for i := 0 to FSdaClientDataSet.Fields.Count - 1 do
    FSdsDelete.Fields[i].Value := FSdaClientDataSet.Fields[i].Value;

  FSdsDelete.Post;
end;

procedure TSdaCtrlGrid.DisableAllButtons;
begin
  FSdaPanelButtons.SetStateSdaCtrlGrid(ssInactive);
end;

procedure TSdaCtrlGrid.EnableButtons;
begin
  FSdaPanelButtons.SetStateSdaCtrlGrid(ssBrowse);
end;

function TSdaCtrlGrid.IsEdition: Boolean;
begin
  Result := FSdaPanelButtons.btnPost.Enabled;
end;

procedure TSdaCtrlGrid.DoAfterScroll;
begin
  if Assigned(FOnAfterScroll) then FOnAfterScroll((Self.FSdaClientDataSet as TDataSet));
end;

procedure TSdaCtrlGrid.DoBeforeScroll;
begin
    if Assigned(FOnBeforeScroll) then FOnBeforeScroll((Self.FSdaClientDataSet as TDataSet));
end;

procedure TSdaCtrlGrid.AddSdaDataSet(Value: TDataSet; CurrentRec : Boolean = false; FieldsKey : String = '');
var
  i, cont         : Integer;
  FieldName : String;
  NewValue  : Variant;
  Client    : TSdaClientDataSet;
  bExists   : Boolean;
  aRequired : Array of Boolean;

  Function FieldPart(Ind : integer) : String;
  var
    i, Position, PosIni : Integer;
    sFieldsKey : String;
  begin
    Result := '';

    Position   := 1;
    PosIni     := 1;
    sFieldsKey := FieldsKey + ';';


    for i := 0 to Length(sFieldsKey) do
      if (sFieldsKey[i] = ';') and (Position = Ind) then
      begin
        Result := Copy(sFieldsKey,PosIni,i-PosIni);
        Position := Position+1;
        PosIni := i+1;
        break;
      end
      else if (sFieldsKey[i] = ';') then
      begin
        Position := Position+1;
        PosIni := i+1;
      end;
  end;

  Function FieldCount : Integer;
  var
    i          : Integer;
    sFieldsKey : String;
  begin
    Result := 0;

    sFieldsKey := FieldsKey + ';';

    for i := 0 to Length(sFieldsKey) do
      if sFieldsKey[i] = ';' then
        Result := Result + 1;
  end;


  procedure InsertClient;
  var
    i: integer;
  begin
    Client.Insert;

    for i := 0 to Value.FieldCount - 1 do
    begin
      FieldName := Value.Fields[i].FieldName;
      NewValue  := '';

      if Assigned(FOnBeforeAddSdaDataSet) then
        FOnBeforeAddSdaDataSet(Value, FieldName, NewValue);

      if (NewValue <> '') and (LowerCase(FieldName) = LowerCase(Value.Fields[i].FieldName)) then
        Client.FieldByName(Value.Fields[i].FieldName).Value := NewValue
      else
        Client.FieldByName(Value.Fields[i].FieldName).Value := Value.FieldByName(Value.Fields[i].FieldName).Value
    end;

    Client.Post;
  end;

  function ExistsValueDs(DsSource, DsClone : TDataSet; KeyFields : String) : Boolean;
  var
    i : Integer;
    V : Variant;
  begin
    V := VarArrayCreate([0,FieldCount-1], varVariant);

    for i := 0 to FieldCount - 1 do
      V[i] := DsClone.FieldByName(FieldPart(i+1)).Value;

    Result := DsSource.Locate(KeyFields, v, [loCaseInsensitive])

  end;

  function LocateRegister(Ds : TDataSet; KeyFields : String) : Boolean;
  var
    i : Integer;
    V : Variant;
  begin
    V := VarArrayCreate([0,FieldCount-1], varVariant);

    for i := 0 to FieldCount - 1 do
      V[i] := Ds.FieldByName(FieldPart(i+1)).Value;

    Result := FSdaClientDataSet.Locate(KeyFields, v, [loCaseInsensitive])

  end;


begin
  if value.RecordCount = 0 then
    exit;

  Screen.Cursor := crHourGlass;

  Client := TSdaClientDataSet.Create(self);

  Client.FieldDefs := Value.FieldDefs;

  Client.DisableControls;

  if Assigned(FSdaClientDataSet) then
    FSdaClientDataSet.DisableControls;

  Value.DisableControls;

  if not CurrentRec then
  begin
    if Assigned(FOnBeforeAddSdaDataSet) then
    begin
      Client.CreateDataSet;

      Value.First;

      while not Value.Eof do
      begin
        InsertClient;

        Value.Next;
      end;
    end
    else
      Client.CloneCursor(TClientDataSet(Value),false, true);
  end
  else
  begin
    Client.CreateDataSet;
    InsertClient;
  end;


  if not Assigned(FSdaClientDataSet) then
    SetSdaDataSet(Client)
  else
  begin
    Client.First;
    cont := 0;

    // Retira a obrigatoriedade dos campos
    for i := 0 to FDBFields.Count - 1 do
    begin
      SetLength(aRequired, Length(aRequired) + 1);
      aRequired[high(aRequired)] := FDBFields.Items[i].FRequired;
      FDBFields.Items[i].FRequired := false;
    end;

    while not Client.Eof do
    begin
      Inc(cont);

      if FieldsKey <> '' then
        bExists := ExistsValueDs(FSdaClientDataSet, Client, FieldsKey)
      else
        bExists := Exists(FSdaClientDataSet,Client);

      if not bExists then
      begin
        if not (FSdaClientDataSet.State in [dsInsert, dsEdit]) then
          FSdaClientDataSet.Append;

        for i := 0 to FSdaClientDataSet.FieldCount - 2 do
          if ExistsField(Client, FSdaClientDataSet.Fields[i].FieldName) then
            FSdaClientDataSet.FieldByName(FSdaClientDataSet.Fields[i].FieldName).Value := Client.FieldByName(FSdaClientDataSet.Fields[i].FieldName).Value;

        FSdaClientDataSet.FieldByName('CtrlSequencial').Value := FLastSequence;

        Inc(FLastSequence);

        FSdaClientDataSet.Post;

      end;
      Client.Next;
    end;
  end;

  // Recoloca a obrigatoriedade dos campos
  for i := 0 to FDBFields.Count - 1 do
    FDBFields.Items[i].FRequired := aRequired[i];

  Client.EnableControls;
  if Assigned(FSdaClientDataSet) then
    FSdaClientDataSet.EnableControls;
  Value.EnableControls;

  if (FieldsKey <> '') and (Client.RecordCount = 1) then
     LocateRegister(Client, FieldsKey);

  Screen.Cursor := crDefault;

end;

function TSdaCtrlGrid.ExistsField(DsSource : TDataSet; FieldName : String) : Boolean;
var
  i : Integer;
begin
  Result := false;

  for i := 0 to DsSource.FieldCount - 1 do
    if LowerCase(DsSource.Fields[i].FieldName) = LowerCase(FieldName) then
    begin
      Result := true;
      exit;
    end;

end;


function TSdaCtrlGrid.Exists(DsSource, DsClone : TDataSet) : Boolean;
var
  j : Integer;
  EveryEqual : Boolean;

  function ValueField(Ds : TDataSet; FieldName : String) : Variant;
  var
    i : Integer;
  begin
    for i := 0 to Ds.Fields.Count - 1 do
      if LowerCase(Ds.Fields[i].FieldName) = LowerCase(FieldName) then
      begin
        Result := Ds.Fields[i].Value;
        exit;
      end;
  end;

begin
  Result := false;

  DsSource.First;

  while not DsSource.Eof do
  begin
    EveryEqual := true;

    for j := 0 to FDBFields.Count - 1 do
      if ExistsField(DsSource, FDBFields.Items[j].FField) then
        if ValueField(DsSource,FDBFields.Items[j].FField) <> ValueField(DsClone,FDBFields.Items[j].FField) then
        begin
          EveryEqual := false;
          break;
        end;

    if EveryEqual then
    begin
      Result := true;
      exit;
    end;

    DsSource.Next;
  end;

end;



{ TDBField}


constructor TDBField.Create(Collection: TCollection);
begin
  inherited Create(Collection);
end;


procedure TDBField.Assign(Source: TPersistent);
begin
  if Source is TDBField then
  begin
    Control  := TDBField(Source).Control;
    Value    := TDBField(Source).Value;
    Title    := TDBField(Source).Title;
    Required := TDBField(Source).Required;
  end
  else inherited Assign(Source);
end;


procedure TDBField.SetField(const Value: string);
begin
  if FField <> Value then
    FField := UpperCase(Value);
end;

procedure TDBField.SetSize(const Value: Integer);
begin
  FSize := Value;
end;

procedure TDBField.SetFieldType(const Value: TFieldType);
begin
  FFieldType := value;
end;

procedure TDBField.SetControl(const Value: String);

begin
  FControl := Value;
end;


procedure TDBField.SetValue(const Value: Variant);
begin
  if FValue <> Value then
    FValue := Value;
end;


function TDBField.GetDisplayName: string;
begin
  Result := Field;
  if Result = '' then Result := inherited GetDisplayName;
end;


destructor TDBField.Destroy;
begin
  inherited;
end;

procedure TDBField.SetRequired(const Value: Boolean);
begin
  FRequired := Value;
end;

procedure TDBField.SetTitle(const Value: String);
begin
  FTitle := Value;
end;

{ TDBFields }


constructor TDBFields.Create(SdaCtrlGrid: TSdaCtrlGrid);
begin
  inherited Create(TDBField);
  FSdaCtrlGrid := SdaCtrlGrid;
  FOwner := SdaCtrlGrid;
end;



function TDBFields.Add: TDBField;
begin
  Result := TDBField(inherited Add);
end;


function TDBFields.GetItem(Index: Integer): TDBField;
begin
  Result := TDBField(inherited GetItem(Index));
end;



function TDBFields.GetOwner: TPersistent;
begin
 Result := FSdaCtrlGrid;
end;


procedure TDBFields.SetItem(Index: Integer; Value: TDBField);
begin
  inherited SetItem(Index, Value);
end;


{ TSdaPanelButtons }

procedure TSdaPanelButtons.ClickBtnCancel(Sender: TObject);
begin
  if Assigned(FSdaCtrlGrid.OnBeforeCancel) then
     FSdaCtrlGrid.OnBeforeCancel(Self);

  FSdaCtrlGrid.Cancel;
  SetStateSdaCtrlGrid(ssBrowse);

  if Assigned(FSdaCtrlGrid.OnAfterCancel) then
     FSdaCtrlGrid.OnAfterCancel(Self);


  if FSdaCtrlGrid.SdaClientDataSet.RecordCount = 0 then
    FSdaCtrlGrid.ClearControls;

  FSdaCtrlGrid.FSdaClientDataSet.Filtered := false;

end;

procedure TSdaPanelButtons.ClickBtnDelete(Sender: TObject);
begin
  if Assigned(FSdaCtrlGrid.OnBeforeDelete) then
     FSdaCtrlGrid.OnBeforeDelete(Self);

  FSdaCtrlGrid.Delete;

  SetStateSdaCtrlGrid(ssBrowse);

  if Assigned(FSdaCtrlGrid.OnAfterDelete) then
     FSdaCtrlGrid.OnAfterDelete(Self);

  if FSdaCtrlGrid.SdaClientDataSet.RecordCount = 0 then
    FSdaCtrlGrid.ClearControls;

end;

procedure TSdaPanelButtons.ClickBtnEdit(Sender: TObject);
var
  iSeq : Integer;
begin
  if Assigned(FSdaCtrlGrid.OnBeforeEdit) then
     FSdaCtrlGrid.OnBeforeEdit(Self);

  SetStateSdaCtrlGrid(ssEdit);

  FSdaCtrlGrid.FCanDataSetChange := false;

  iSeq := FSdaCtrlGrid.SdaClientDataSet.fieldByName('CtrlSequencial').AsInteger;

  FSdaCtrlGrid.SdaClientDataSet.Filtered := true;
  FSdaCtrlGrid.SdaClientDataSet.Filter := 'CtrlSequencial = ' + IntToStr(iSeq);

  FSdaCtrlGrid.Cancel;

  FSdaCtrlGrid.ClearControls;

  FSdaCtrlGrid.Cancel;

  FSdaCtrlGrid.FCanDataSetChange := true;

  FSdaCtrlGrid.FSdaClientDataSet.First;

  FSdaCtrlGrid.Edit;

  if Assigned(FSdaCtrlGrid.OnAfterEdit) then
     FSdaCtrlGrid.OnAfterEdit(Self);

end;

procedure TSdaPanelButtons.ClickBtnInsert(Sender: TObject);
begin
  if Assigned(FSdaCtrlGrid.OnBeforeInsert) then
     FSdaCtrlGrid.OnBeforeInsert(Self);

  SetStateSdaCtrlGrid(ssInsert);

  FSdaCtrlGrid.FCanDataSetChange := false;

  FSdaCtrlGrid.SdaClientDataSet.Filtered := true;
  FSdaCtrlGrid.SdaClientDataSet.Filter := 'CtrlSequencial = ' + IntToStr(FSdaCtrlGrid.FLastSequence);

  FSdaCtrlGrid.ClearControls;

  FSdaCtrlGrid.FCanDataSetChange := true;

  FSdaCtrlGrid.Insert;

  if Assigned(FSdaCtrlGrid.OnAfterInsert) then
     FSdaCtrlGrid.OnAfterInsert(Self);

end;

procedure TSdaPanelButtons.ClickBtnGeral(Sender: TObject);
var
  Inserted : Boolean;
begin
  Inserted := false;

  if Assigned(FSdaCtrlGrid.OnClickGeralButton) then
     FSdaCtrlGrid.OnClickGeralButton(Self,Inserted);

  if Inserted then
    SetStateSdaCtrlGrid(ssBrowse);
end;



constructor TSdaPanelButtons.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FbtnInsert := TSpeedButton.Create(Self);
  FbtnEdit   := TSpeedButton.Create(Self);
  FbtnDelete := TSpeedButton.Create(Self);
  FbtnPost   := TSpeedButton.Create(Self);
  FbtnCancel := TSpeedButton.Create(Self);
  FbtnGeral  := TSpeedButton.Create(Self);

  FSdaCtrlGrid := TSdaCtrlGrid(AOWner);

  Name := 'SubPanel';  { do not localize }
  SetSubComponent(True);

end;

procedure TSdaPanelButtons.CreateWnd;
begin
  inherited;
  Caption := '';

  With FbtnInsert do
  begin
    Glyph.LoadFromResourceName(HInstance, 'CGINCLUIR');
    Parent := Self;
    OnClick := ClickBtnInsert;
    Height := 30;
    Width := 30;
    Left := 0;
    Top := 0;
  end;

  With FbtnEdit do
  begin
    Glyph.LoadFromResourceName(HInstance, 'CGEDIT');
    Parent := Self;
    OnClick := ClickBtnEdit;
    Height := 30;
    Width := 30;
    Left := 30;
    Top := 0;
  end;

  With FbtnDelete do
  begin
    Glyph.LoadFromResourceName(HInstance, 'CGDELETE');
    Parent := Self;
    OnClick := ClickBtnDelete;
    Height := 30;
    Width := 30;
    Left := 60;
    Top := 0;
  end;

  With btnPost do
  begin
    Glyph.LoadFromResourceName(HInstance, 'CGPOST');
    Parent := Self;
//    OnClick := ClickBtnPost;
    Height := 30;
    Width := 30;
    Left := 100;
    Top := 0;
  end;

  With FbtnCancel do
  begin
    Glyph.LoadFromResourceName(HInstance, 'CGCANCEL');
    Parent := Self;
    OnClick := ClickBtnCancel;
    Height := 30;
    Width := 30;
    Left := 130;
    Top := 0;
  end;

  With FbtnGeral do
  begin
    Width := 30;
    Parent := Self;
    OnClick := ClickBtnGeral;
    Height := 30;
    Left := 170;
    Top := 0;

    if FSdaCtrlGrid.ShowGeralButton and (FSdaCtrlGrid.ResourceGeralButton <> '') then
      Glyph.LoadFromResourceName(HInstance, FSdaCtrlGrid.ResourceGeralButton)
    else if FSdaCtrlGrid.ShowGeralButton and (FSdaCtrlGrid.CaptionButtonGeral <> '') then
    begin
      Caption := FSdaCtrlGrid.CaptionButtonGeral;
      Width := Canvas.TextWidth(Caption) + 10;
    end;

  end;


end;

procedure TSdaPanelButtons.SetStateSdaCtrlGrid(const Value: TStateSdaCtrlGrid);
begin
  FStateSdaCtrlGrid := Value;

  FbtnGeral.Visible := FSdaCtrlGrid.ShowGeralButton;

  FSdaCtrlGrid.Panel.Enabled :=  Value <> ssBrowse;

  if FSdaCtrlGrid.SdaClientDataSet.State = dsInactive then
  begin
    FbtnInsert.Enabled := false;
    FbtnEdit.Enabled   := false;
    FbtnDelete.Enabled := false;
    FbtnPost.Enabled   := false;
    FbtnCancel.Enabled := false;
    FbtnGeral.Enabled  := false;
  end
  else
  begin
    FbtnInsert.Enabled := (Value <> ssInactive) and (Value = ssBrowse) and (FSdaCtrlGrid.AllowInsert);
    FbtnEdit.Enabled   := (Value <> ssInactive) and (Value = ssBrowse) and ( (FSdaCtrlGrid.SdaClientDataSet.RecordCount > 0) or ( FSdaCtrlGrid.SdaClientDataSet.Filtered ) )  ;
    FbtnDelete.Enabled := (Value <> ssInactive) and (Value = ssBrowse) and ( (FSdaCtrlGrid.SdaClientDataSet.RecordCount > 0) or ( FSdaCtrlGrid.SdaClientDataSet.Filtered ) ) and (FSdaCtrlGrid.AllowDelete);
    FbtnPost.Enabled   := (Value <> ssInactive) and (Value = ssInsert) or (Value = ssEdit);
    FbtnCancel.Enabled := (Value <> ssInactive) and (Value = ssInsert) or (Value = ssEdit);
    FbtnGeral.Enabled  := (Value <> ssInactive) and (Value = ssBrowse);
  end;


end;

function TSdaPanelButtons.GetHeight: Integer;
begin
  Result := inherited Height;
end;

function TSdaPanelButtons.GetLeft: Integer;
begin
  Result := inherited Left;
end;

function TSdaPanelButtons.GetTop: Integer;
begin
  Result := inherited Top;
end;

function TSdaPanelButtons.GetWidth: Integer;
begin
  Result := inherited Width;
end;

procedure TSdaPanelButtons.SetHeight(const Value: Integer);
begin
  SetBounds(Left, Top, Width, Value);
end;

procedure TSdaPanelButtons.SetWidth(const Value: Integer);
begin
  SetBounds(Left, Top, Value, Height);
end;

end.
