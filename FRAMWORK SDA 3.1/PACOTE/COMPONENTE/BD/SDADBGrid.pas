unit SDADBGrid;

interface

uses DBGrids,Graphics,Classes,SysUtils, SDAGraphics,  db,Mask,
    Forms, Dialogs, Grids, Controls, types, StdCtrls;

type
   TTextStyle = ( tsNone, tsRaised, tsRecessed );
   TTitleStyle = (tsLazarus, tsStandard, tsNative);
   TAutoAdvance = (aaNone,aaDown,aaRight,aaLeft, aaRightDown, aaLeftDown);
   TGridZone = (gzNormal, gzFixedCols, gzFixedRows, gzFixedCells, gzInvalid);
   TGridZoneSet = set of TGridZone;

  TDbGridExtraOption = (
    dgeAutoColumns,       // if uncustomized columns, add them anyway?
    dgeCheckboxColumn     // enable the use of checkbox in columns
  );
  TDbGridExtraOptions = set of TDbGridExtraOption;


  TGetDbEditMaskEvent =
    procedure (Sender: TObject; const Field: TField;
               var Value: string) of object;

  TPrepareDbGridCanvasEvent =
    procedure(sender: TObject; DataCol: Integer;
              Column: TColumn; AState: TGridDrawState) of object;

  TDbGridSelEditorEvent =
    procedure(Sender: TObject; Column: TColumn;
              var Editor: TWinControl) of object;

   TUserCheckBoxBitmapEvent =
    procedure(Sender: TObject; const CheckedState: TCheckboxState;
              ABitmap: TBitmap) of object;

   TDataSetScrolledEvent =
    procedure(DataSet: TDataSet; Distance: Integer) of object;

   TDbGridStatusItem = (gsUpdatingData, gsAddingAutoColumns,
                       gsRemovingAutoColumns);
    TDbGridStatus = set of TDbGridStatusItem;







type
TComponentDataLink=class(TDatalink)
  private
    FDataSet: TDataSet;
    FDataSetName: string;
    FModified: Boolean;
    FOnDatasetChanged: TDatasetNotifyEvent;
    fOnDataSetClose: TDataSetNotifyEvent;
    fOnDataSetOpen: TDataSetNotifyEvent;
    FOnDataSetScrolled: TDataSetScrolledEvent;
    FOnEditingChanged: TDataSetNotifyEvent;
    fOnInvalidDataSet: TDataSetNotifyEvent;
    fOnInvalidDataSource: TDataSetNotifyEvent;
    FOnLayoutChanged: TDataSetNotifyEvent;
    fOnNewDataSet: TDataSetNotifyEvent;
    FOnRecordChanged: TFieldNotifyEvent;
    FOnUpdateData: TDataSetNotifyEvent;

    function GetDataSetName: string;
    function GetFields(Index: Integer): TField;
    procedure SetDataSetName(const AValue: string);
  protected
    procedure RecordChanged(Field: TField); override;
    procedure DataSetChanged; override;
    procedure ActiveChanged; override;
    procedure LayoutChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure FocusControl(Field: TFieldRef); override;
    // Testing Events
    procedure CheckBrowseMode; override;
    procedure EditingChanged; override;
    procedure UpdateData; override;
    function  MoveBy(Distance: Integer): Integer; override;
    property  Modified: Boolean read FModified write FModified;
  public
    property OnRecordChanged: TFieldNotifyEvent read FOnRecordChanged write FOnRecordChanged;
    property OnDataSetChanged: TDatasetNotifyEvent read FOnDatasetChanged write FOnDataSetChanged;
    property OnNewDataSet: TDataSetNotifyEvent read fOnNewDataSet write fOnNewDataSet;
    property OnDataSetOpen: TDataSetNotifyEvent read fOnDataSetOpen write fOnDataSetOpen;
    property OnInvalidDataSet: TDataSetNotifyEvent read fOnInvalidDataSet write fOnInvalidDataSet;
    property OnInvalidDataSource: TDataSetNotifyEvent read fOnInvalidDataSource write fOnInvalidDataSource;
    property OnLayoutChanged: TDataSetNotifyEvent read FOnLayoutChanged write FOnLayoutChanged;
    property OnDataSetClose: TDataSetNotifyEvent read fOnDataSetClose write fOnDataSetClose;
    property OnDataSetScrolled: TDataSetScrolledEvent read FOnDataSetScrolled write FOnDataSetScrolled;
    property OnEditingChanged: TDataSetNotifyEvent read FOnEditingChanged write FOnEditingChanged;
    property OnUpdateData: TDataSetNotifyEvent read FOnUpdateData write FOnUpdateData;
    property DataSetName:string read GetDataSetName write SetDataSetName;
    property Fields[Index: Integer]: TField read GetFields;
    property VisualControl;
  end;




type
TStringCellEditor=class(TCustomMaskEdit)
  private
    FGrid: TCustomGrid;
    FCol,FRow:Integer;
  protected
//    procedure WndProc(var TheMessage : TLMessage); override;
//    procedure Change; override;
//    procedure KeyDown(var Key : Word; Shift : TShiftState); override;
  //  procedure msg_SetMask(var Msg: TGridMessage); message GM_SETMASK;
  //  procedure msg_SetValue(var Msg: TGridMessage); message GM_SETVALUE;
  //  procedure msg_GetValue(var Msg: TGridMessage); message GM_GETVALUE;
 //   procedure msg_SetGrid(var Msg: TGridMessage); message GM_SETGRID;
//    procedure msg_SelectAll(var Msg: TGridMessage); message GM_SELECTALL;
 //   procedure msg_SetPos(var Msg: TGridMessage); message GM_SETPOS;
  public
//    procedure EditingDone; override;
  end;
  TPickListCellEditor = class(TCustomComboBox)
  private
    FGrid: TCustomGrid;
    FCol,FRow: Integer;
    FGridBorderStyle: TBorderStyle;
    procedure SetBorderStyle(const Value: TBorderStyle);
  protected
   // procedure WndProc(var TheMessage : TLMessage); override;
    procedure KeyDown(var Key : Word; Shift : TShiftState); override;
    procedure DropDown; override;
    procedure CloseUp; override;
    procedure Select; override;
   // procedure msg_GetValue(var Msg: TGridMessage); message GM_GETVALUE;
   // procedure msg_SetGrid(var Msg: TGridMessage); message GM_SETGRID;
  //  procedure msg_SetValue(var Msg: TGridMessage); message GM_SETVALUE;
  //  procedure msg_SetPos(var Msg: TGridMessage); message GM_SETPOS;
  public
  //  procedure EditingDone; override;
    property BorderStyle:TBorderStyle read FGridBorderStyle write SetBorderStyle default bsSingle;

  end;



 TSDADBGrid = class(TCustomDBGrid)
  private
  FEditor: TWinControl;
  FStringEditor: TStringCellEditor;
  FPickListEditor: TPickListCellEditor;
  FDataLink: TComponentDataLink;
    fBorderColor: TColor;
    FDefaultTextStyle: TTextStyle;
    FExtendedColSizing: boolean;
    FFastEditing :boolean;
    FFocusColor: TColor;
    FFocusRectVisible: Boolean;
    FGridLineColor: TColor;
    FGridLineStyle: TPenStyle;
    FSelectedColor : TColor;
    FAlternateColor: TColor;
    FAutoAdvance: TAutoAdvance;
    FAutoEdit: Boolean;
    FAutoFillColumns: boolean;
    FBorderSpacing: word;
    FFixedHotColor: TColor;
    FFlat: Boolean;
    FHeaderHotZones: TGridZoneSet;
    FHeaderPushZones: TGridZoneSet;
    FExtraOptions: TDBGridExtraOptions;
    FTitleStyle: TTitleStyle;
    FUseXORFeatures: boolean;
    FOnColumnSized: TNotifyEvent;
    FOnFieldEditMask: TGetDbEditMaskEvent;
    FOnPrepareCanvas: TPrepareDbGridCanvasEvent;
    FOnTitleClick: TDBGridClickEvent;
    FOnSelectEditor: TDbGridSelEditorEvent;
    FOnUserCheckboxBitmap: TUserCheckboxBitmapEvent;
    FGridStatus: TDBGridStatus;

    procedure SetBorderColor(const Value: TColor);
    function GetEditorBorderStyle: TBorderStyle;

    procedure SetEditorBorderStyle(const Value: TBorderStyle);
    procedure SetFocusColor(const Value: TColor);
    procedure SetFocusRectVisible(const Value: Boolean);
    procedure SetGridLineColor(const Value: TColor);
    procedure SetGridLineStyle(const Value: TPenStyle);
    function GetSelectedColor: TColor;
    procedure SetSelectedColor(const Value: TColor);
    function IsAltColorStored: Boolean;
    procedure SetAlternateColor(const Value: TColor);
    procedure SetAutoEdit(const Value: Boolean);
    procedure SetAutoFillColumns(const Value: boolean);
    procedure SetBorderSpacing(const Value: word);
    procedure SetFlat(const Value: Boolean);
    procedure SetExtraOptions(const AValue: TDBGridExtraOptions);
    procedure SetTitleStyle(const Value: TTitleStyle);
    procedure SetUseXorFeatures(const Value: boolean);
   protected
    procedure AddAutomaticColumns;
    procedure UpdateActive; virtual;

  public
    property BorderColor : TColor read fBorderColor write SetBorderColor default clWindow;
    property Canvas;
    property DefaultTextStyle: TTextStyle read FDefaultTextStyle write FDefaultTextStyle;
    property EditorBorderStyle: TBorderStyle read GetEditorBorderStyle write SetEditorBorderStyle;
    property EditorMode;
    procedure EditorPos;

    property ExtendedColSizing: boolean read FExtendedColSizing write FExtendedColSizing;
    property FastEditing: boolean read FFastEditing write FFastEditing;
    property FocusColor: TColor read FFocusColor write SetFocusColor;
    property FocusRectVisible: Boolean read FFocusRectVisible write SetFocusRectVisible;
    property GridLineColor: TColor read FGridLineColor write SetGridLineColor default clSilver;
     property GridLineStyle: TPenStyle read FGridLineStyle write SetGridLineStyle;
    property SelectedColor: TColor read GetSelectedColor write SetSelectedColor;

    property SelectedRows;
  published
    property Align;
    property AlternateColor: TColor read FAlternateColor write SetAlternateColor stored IsAltColorStored;
    property Anchors;
    property AutoAdvance: TAutoAdvance read FAutoAdvance write FAutoAdvance default aaRight;
    property AutoEdit: Boolean read FAutoEdit write SetAutoEdit;
    property AutoFillColumns: boolean read FAutoFillColumns write SetAutoFillColumns;

    //property BiDiMode;
   property BorderSpacing: word read FBorderSpacing write SetBorderSpacing;

    property BorderStyle;
    property Color;
    property Columns; // stored false;
    property Constraints;
    property DataSource;
    property DefaultDrawing;
    property DefaultRowHeight;
    property DragCursor;
    //property DragKind;
    property DragMode;
    property Enabled;
    property FixedColor;
    property FixedCols;
    property FixedHotColor: TColor read FFixedHotColor write FFixedHotColor default cl3DLight;

    property Flat: Boolean read FFlat write SetFlat default false;

    property Font;
     property HeaderHotZones: TGridZoneSet read FHeaderHotZones write FHeaderHotZones default [gzFixedCols];

   property HeaderPushZones: TGridZoneSet read FHeaderPushZones write FHeaderPushZones default [gzFixedCols];
    //property ImeMode;
    //property ImeName;
    property Options;
     property OptionsExtra: TDbGridExtraOptions read FExtraOptions
                           write SetExtraOptions default [dgeAutoColumns, dgeCheckboxColumn];


    //property ParentBiDiMode;
    property ParentColor default false;
    property ParentFont;
    //property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property Scrollbars default ssBoth;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TitleFont;
     property TitleStyle: TTitleStyle read FTitleStyle write SetTitleStyle default tsLazarus;

    property UseXORFeatures: boolean read FUseXORFeatures write SetUseXorFeatures default false;

    property Visible;
    property OnCellClick;
    property OnColEnter;
    property OnColExit;
    property OnColumnMoved;
    property OnColumnSized: TNotifyEvent read FOnColumnSized write FOnColumnSized;

    property OnDrawColumnCell;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditButtonClick;
    //property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnFieldEditMask: TGetDbEditMaskEvent read FOnFieldEditMask write FOnFieldEditMask;

    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnPrepareCanvas: TPrepareDbGridCanvasEvent read FOnPrepareCanvas write FOnPrepareCanvas;

   property OnSelectEditor: TDbGridSelEditorEvent read FOnSelectEditor write FOnSelectEditor;

    //property OnStartDock;
    property OnStartDrag;
    property OnTitleClick: TDBGridClickEvent read FOnTitleClick write FOnTitleClick;

    property OnUserCheckboxBitmap: TUserCheckboxBitmapEvent read FOnUserCheckboxBitmap write FOnUserCheckboxBitmap;

  //  property OnUTF8KeyPress;
  end;



implementation

{ TSDADBGrid }

procedure TSDADBGrid.AddAutomaticColumns;
var
  i: Integer;
  F: TField;
begin
  // add as many columns as there are fields in the dataset
  // do this only at runtime.
  if (csDesigning in ComponentState) or not FDatalink.Active or
    (gsRemovingAutoColumns in FGridStatus) or
    not (dgeAutoColumns in OptionsExtra)
  then
    exit;
  Include(FGridStatus, gsAddingAutoColumns);
  try
    for i:=0 to FDataLink.DataSet.FieldCount-1 do begin

      F:= FDataLink.DataSet.Fields[i];

      //if TDBGridColumns(Columns).ColumnFromField(F) <> nil then
        // this field is already in the collection. This could only happen
        // if AddAutomaticColumns was called out of LayoutChanged.
        // to avoid duplicate columns skip this field.
       // continue;

   {   if (F<>nil) then begin
        with TDBGridColumns(Columns).Add do begin
          FIsAutomaticColumn := True;
          Field := F;
          Visible := F.Visible;
        end; }
    //  end;

    end;
    // honor the field.index
  //  TDBGridColumns(Columns).ResetColumnsOrder(coFieldIndexOrder);
  finally
    Exclude(FGridStatus, gsAddingAutoColumns);
  end;


end;

procedure TSDADBGrid.EditorPos;
//var
 // msg: TGridMessage;
begin
  {$ifdef dbgGrid} DebugLn('Grid.EditorPos INIT');{$endif}
  if FEditor<>nil then begin

    // send editor position
  //  Msg.LclMsg.msg:=GM_SETPOS;
  //  Msg.Grid:=Self;
  //  Msg.Col:=FCol;
  //  Msg.Row:=FRow;
  //  FEditor.Dispatch(Msg);

    // send editor bounds
  //  Msg.CellRect:=CellRect(FCol,FRow);
  //  if (Msg.CellRect.Top<FGCache.FixedHeight) or
  //    (Msg.CellRect.Left<FGCache.FixedWidth) then
  //  begin
      // editor is not in visible area, hide it complety
      // to avoid showing it in fixed cell area
 {     with msg.CellRect do
        Msg.CellRect := Rect(-Right, -Bottom, -Left, -Top);
    end;
    if FEditorOptions and EO_AUTOSIZE = EO_AUTOSIZE then begin
      if EditorBorderStyle = bsNone then
          InflateRect(Msg.CellRect, -1, -1);
      FEditor.BoundsRect := Msg.CellRect;
    end else begin
      Msg.LclMsg.msg:=GM_SETBOUNDS;
      Msg.Grid:=Self;
      Msg.Col:=FCol;
      Msg.Row:=FRow;
      FEditor.Dispatch(Msg);
    end;}
  end;


end;

function TSDADBGrid.GetEditorBorderStyle: TBorderStyle;
begin
  result := bsSingle;
  if FEditor = FstringEditor then
    Result := FStringEditor.BorderStyle
  else if FEditor = FPickListEditor then
    Result := FStringEditor.BorderStyle;

end;

function TSDADBGrid.GetSelectedColor: TColor;
begin
   Result:=FSelectedColor;

end;

function TSDADBGrid.IsAltColorStored: Boolean;
begin
  result := FAlternateColor <> Color;

end;

procedure TSDADBGrid.SetAlternateColor(const Value: TColor);
begin
  FAlternateColor := Value;
end;

procedure TSDADBGrid.SetAutoEdit(const Value: Boolean);
begin
  FAutoEdit := Value;
end;

procedure TSDADBGrid.SetAutoFillColumns(const Value: boolean);
begin
  FAutoFillColumns := Value;
end;

procedure TSDADBGrid.SetBorderColor(const Value: TColor);
begin
  fBorderColor := Value;
end;

procedure TSDADBGrid.SetBorderSpacing(const Value: word);
begin
  FBorderSpacing := Value;
end;

procedure TSDADBGrid.SetEditorBorderStyle(const Value: TBorderStyle);
begin
  if FStringEditor.BorderStyle<>Value then begin
    FStringEditor.BorderStyle := Value;
    if (FEditor = FStringEditor) and EditorMode then
      EditorPos;
  end;
  if FPicklistEditor.BorderStyle<>Value then begin
    FPicklistEditor.BorderStyle := Value;
    if (FEditor = FPicklistEditor) and EditorMode then
      EditorPos;
  end;

end;


procedure TSDADBGrid.SetExtraOptions(const AValue: TDBGridExtraOptions);
var
  OldOptions: TDBGridExtraOptions;

  function IsOptionChanged(Op: TDBGridExtraOption): boolean;
  begin
    result := ((op in OldOptions) and not (op in AValue)) or
      (not (op in OldOptions) and (op in AValue));
  end;

begin
  if FExtraOptions=AValue then exit;
  OldOptions := FExtraOptions;
  FExtraOptions := AValue;

  if IsOptionChanged(dgeCheckboxColumn) then
    Invalidate;

  if IsOptionChanged(dgeAutoColumns) then begin
    if dgeAutoColumns in aValue then
      AddAutomaticColumns  ;
  //  else// if TDBGridColumns(Columns).HasAutomaticColumns then
    //  RemoveAutomaticColumns;
    UpdateActive;
  end;

end;

procedure TSDADBGrid.SetFlat(const Value: Boolean);
begin
  FFlat := Value;
end;

procedure TSDADBGrid.SetFocusColor(const Value: TColor);
begin
  FFocusColor := Value;
end;

procedure TSDADBGrid.SetFocusRectVisible(const Value: Boolean);
begin
  FFocusRectVisible := Value;
end;

procedure TSDADBGrid.SetGridLineColor(const Value: TColor);
begin
  FGridLineColor := Value;
end;

procedure TSDADBGrid.SetGridLineStyle(const Value: TPenStyle);
begin
  FGridLineStyle := Value;
end;

procedure TSDADBGrid.SetSelectedColor(const Value: TColor);
begin

end;

procedure TSDADBGrid.SetTitleStyle(const Value: TTitleStyle);
begin
    if FTitleStyle=Value then exit;
  FTitleStyle:=Value;
  Invalidate;

end;

procedure TSDADBGrid.SetUseXorFeatures(const Value: boolean);
begin
   if FUseXORFeatures=Value then exit;
  FUseXORFeatures:=Value;
  Invalidate;

end;

procedure TSDADBGrid.UpdateActive;
var
  PrevRow: Integer;
begin
  if (csDestroying in ComponentState) or
    (FDatalink=nil) or (not FDatalink.Active) or
    (FDatalink.ActiveRecord<0) then
    exit;
  {$IfDef dbgDBGrid}
  DebugLn(Name,'.UpdateActive: ActiveRecord=', dbgs(FDataLink.ActiveRecord),
            ' FixedRows=',dbgs(FixedRows), ' Row=', dbgs(Row));
  {$endif}
  PrevRow := Row;
  Row:= FixedRows + FDataLink.ActiveRecord;
  if PrevRow<>Row then
    InvalidateCell(0, PrevRow);//(InvalidateRow(PrevRow);
  InvalidateRow(Row);


end;

{ TPickListCellEditor }

procedure TPickListCellEditor.CloseUp;
begin
  inherited;
//
end;

procedure TPickListCellEditor.DropDown;
begin
  inherited;
 //
end;

procedure TPickListCellEditor.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  //
end;

procedure TPickListCellEditor.Select;
begin
  inherited;
   //
end;

procedure TPickListCellEditor.SetBorderStyle(const Value: TBorderStyle);
begin
  FGridBorderStyle := Value;
end;

{ TComponentDataLink }

function TComponentDataLink.GetFields(Index: Integer): TField;
begin
  if (index>=0)and(index<DataSet.FieldCount) then result:=DataSet.Fields[index];
end;

function TComponentDataLink.GetDataSetName: string;
begin
  Result:=FDataSetName;
  if DataSet<>nil then Result:=DataSet.Name;
end;

procedure TComponentDataLink.SetDataSetName(const AValue: string);
begin
  if FDataSetName<>AValue then FDataSetName:=AValue;
end;

procedure TComponentDataLink.RecordChanged(Field: TField);
begin
  {$ifdef dbgDBGrid}
  DebugLn('TComponentDataLink.RecordChanged');
  {$endif}
  if Assigned(OnRecordChanged) then
    OnRecordChanged(Field);
end;

procedure TComponentDataLink.DataSetChanged;
begin
  {$ifdef dbgDBGrid}
  DebugLn('TComponentDataLink.DataSetChanged, FirstRecord=', dbgs(FirstRecord));
  {$Endif}
  // todo: improve this routine, for example: OnDatasetInserted
  if Assigned(OnDataSetChanged) then
    OnDataSetChanged(DataSet);
end;

procedure TComponentDataLink.ActiveChanged;
begin
  {$ifdef dbgDBGrid}
  DebugLn('TComponentDataLink.ActiveChanged');
  {$endif}
  if Active then begin
    fDataSet := DataSet;
    if DataSetName <> fDataSetName then begin
      fDataSetName := DataSetName;
      if Assigned(fOnNewDataSet) then fOnNewDataSet(DataSet);
    end else
      if Assigned(fOnDataSetOpen) then fOnDataSetOpen(DataSet);
  end else begin
    BufferCount := 0;
    if (DataSource = nil)then begin
      if Assigned(fOnInvalidDataSource) then fOnInvalidDataSource(fDataSet);
      fDataSet := nil;
      fDataSetName := '[???]';
    end else begin
      if (DataSet=nil)or(csDestroying in DataSet.ComponentState) then begin
        if Assigned(fOnInvalidDataSet) then fOnInvalidDataSet(fDataSet);
        fDataSet := nil;
        fDataSetName := '[???]';
      end else begin
        if Assigned(fOnDataSetClose) then fOnDataSetClose(DataSet);
        if DataSet <> nil then FDataSetName := DataSetName;
      end;
    end;
  end;
end;

procedure TComponentDataLink.LayoutChanged;
begin
  {$ifdef dbgDBGrid}
  DebugLn('TComponentDataLink.LayoutChanged');
  {$Endif}
  if Assigned(OnLayoutChanged) then
    OnLayoutChanged(DataSet);
end;

procedure TComponentDataLink.DataSetScrolled(Distance: Integer);
begin
  {$ifdef dbgDBGrid}
  DebugLn('TComponentDataLink.DataSetScrolled(',IntToStr(Distance),')');
  {$endif}
  if Assigned(OnDataSetScrolled) then
    OnDataSetScrolled(DataSet, Distance);
end;

procedure TComponentDataLink.FocusControl(Field: TFieldRef);
begin
  {$ifdef dbgDBGrid}
  DebugLn('TComponentDataLink.FocusControl');
  {$endif}
end;

procedure TComponentDataLink.CheckBrowseMode;
begin
  {$ifdef dbgDBGrid}
  DebugLn(ClassName,'.CheckBrowseMode');
  {$endif}
  inherited CheckBrowseMode;
end;

procedure TComponentDataLink.EditingChanged;
begin
  {$ifdef dbgDBGrid}
  DebugLn(ClassName,'.EditingChanged');
  {$endif}
  if Assigned(OnEditingChanged) then
    OnEditingChanged(DataSet);
end;

procedure TComponentDataLink.UpdateData;
begin
  {$ifdef dbgDBGrid}
  DebugLn(ClassName,'.UpdateData');
  {$endif}
  if Assigned(OnUpdatedata) then
    OnUpdateData(DataSet);
end;

function TComponentDataLink.MoveBy(Distance: Integer): Integer;
begin
  (*
  {$ifdef dbgDBGrid}
  DebugLn(ClassName,'.MoveBy  INIT: Distance=',Distance);
  {$endif}
  *)
  Result:=inherited MoveBy(Distance);
  (*
  {$ifdef dbgDBGrid}
  DebugLn(ClassName,'.MoveBy  END: Distance=',Distance);
  {$endif}
  *)
end;


end.
