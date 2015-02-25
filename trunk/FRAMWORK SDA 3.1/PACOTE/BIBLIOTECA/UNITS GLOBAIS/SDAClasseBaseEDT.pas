unit SDAClasseBaseEDT;

interface

Uses
  SysUtils, Classes, Controls, StdCtrls, ExtCtrls,Calendar, Graphics,
  Mask, Messages, Windows, Dialogs,  DB, Menus, SDABusca,SDAUtilitarios,Forms;

type
  TCustomFlatEdit = class(TCustomEdit)
  private
    FAutoClear       : Boolean;
    FRequired        : Boolean;
    FUseAdvColors: Boolean;
    FAdvColorFocused: TAdvColors;
    FAdvColorBorder: TAdvColors;
    FParentColor: Boolean;
    FFocusedColor: TColor;
    FBorderColor: TColor;
    FFlatColor: TColor;
    MouseInControl: Boolean;
    FRequiredColor: TColor;
    procedure SetColors (Index: Integer; Value: TColor);
    procedure SetAdvColors (Index: Integer; Value: TAdvColors);
    procedure SetUseAdvColors (Value: Boolean);
    procedure SetParentColor (Value: Boolean);
    procedure RedrawBorder (const Clip: HRGN);
    procedure NewAdjustHeight;
    procedure CMEnabledChanged (var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged (var Message: TMessage); message CM_FONTCHANGED;
    procedure CMMouseEnter (var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave (var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMSetFocus (var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus (var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMNCCalcSize (var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPaint (var Message: TMessage); message WM_NCPAINT;
    procedure CMSysColorChange (var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMParentColorChanged (var Message: TWMNoParams); message CM_PARENTCOLORCHANGED;
  protected
    procedure CalcAdvColors;
    procedure Loaded; override;
    property ColorFocused: TColor index 0 read FFocusedColor write SetColors default clWhite;
    property ColorBorder: TColor index 1 read FBorderColor write SetColors default $008396A0;
    property ColorFlat: TColor index 2 read FFlatColor write SetColors default $00E1EAEB;
    property ParentColor: Boolean read FParentColor write SetParentColor default false;
    property AdvColorFocused: TAdvColors index 0 read FAdvColorFocused write SetAdvColors default 10;
    property AdvColorBorder: TAdvColors index 1 read FAdvColorBorder write SetAdvColors default 50;
    property UseAdvColors: Boolean read FUseAdvColors write SetUseAdvColors default false;
    property CharCase;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property MaxLength;
    property OEMConvert;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;

    property OnChange;
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
   {$IFDEF DFS_DELPHI_4_UP}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
   {$ENDIF}
  public
    constructor Create (AOwner: TComponent); override;
  published
    property AutoClear         : Boolean read FAutoClear write FAutoClear;
    property Required          : Boolean read FRequired write FRequired;
    property RequiredColor     : TColor read FRequiredColor write FRequiredColor;
  end;
 TSDAEdit = class(TCustomFlatEdit)
  private
    FSDABusca         : TSDABusca;
  published
    property ColorFocused;
    property ColorBorder;
    property ColorFlat;
    property ParentColor;
    property AdvColorFocused;
    property AdvColorBorder;
    property UseAdvColors;
    property CharCase;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property MaxLength;
    property OEMConvert;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;

    property SDABusca  : TSDABusca read FSDABusca write FSDABusca default nil;

    property OnChange;
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
   {$IFDEF DFS_DELPHI_4_UP}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
   {$ENDIF}
  end;

TSDAMemo = class(TCustomMemo)
  private
    FUseAdvColors: Boolean;
    FAdvColorFocused: TAdvColors;
    FAdvColorBorder: TAdvColors;
    FParentColor: Boolean;
    FFocusedColor: TColor;
    FBorderColor: TColor;
    FFlatColor: TColor;
    MouseInControl: Boolean;
    procedure SetColors (Index: Integer; Value: TColor);
    procedure SetAdvColors (Index: Integer; Value: TAdvColors);
    procedure SetUseAdvColors (Value: Boolean);
    procedure SetParentColor (Value: Boolean);
    procedure CMEnabledChanged (var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMMouseEnter (var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave (var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMSetFocus (var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus (var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMNCCalcSize (var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPaint (var Message: TMessage); message WM_NCPAINT;
    procedure CMSysColorChange (var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMParentColorChanged (var Message: TWMNoParams); message CM_PARENTCOLORCHANGED;
  protected
    procedure CalcAdvColors;
    procedure RedrawBorder (const Clip: HRGN);
  public
    constructor Create (AOwner: TComponent); override;
  published
    property ColorFocused: TColor index 0 read FFocusedColor write SetColors default clWhite;
    property ColorBorder: TColor index 1 read FBorderColor write SetColors default $008396A0;
    property ColorFlat: TColor index 2 read FFlatColor write SetColors default $00E1EAEB;
    property ParentColor: Boolean read FParentColor write SetParentColor default false;
    property AdvColorFocused: TAdvColors index 0 read FAdvColorFocused write SetAdvColors default 10;
    property AdvColorBorder: TAdvColors index 1 read FAdvColorBorder write SetAdvColors default 50;
    property UseAdvColors: Boolean read FUseAdvColors write SetUseAdvColors default false;
    property Align;
    property Alignment;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property MaxLength;
    property OEMConvert;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property ScrollBars;
    property TabOrder;
    property TabStop;
    property Visible;
    property Lines;
    property WantReturns;
    property WantTabs;
    property WordWrap;

    property OnChange;
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
   {$IFDEF DFS_DELPHI_4_UP}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
   {$ENDIF}
  end;

  function  FieldFind(Find : TSDABusca; Component : TWinControl) : String;
  procedure ExecuteFindEdit(var FExecuteFind : Boolean ; fSDABusca : TSDABusca ;Component : TWinControl; Event: String);
implementation

{ TCustomFlatEdit }

constructor TCustomFlatEdit.Create(AOwner: TComponent);
begin
  inherited;
  ParentFont := True;
  FFocusedColor := clWhite;
  FBorderColor := $008396A0;
  FFlatColor := $00E1EAEB;
  FParentColor := True;
  AutoSize := false;
  Ctl3D := false;
  BorderStyle := bsNone;
  ControlStyle := ControlStyle - [csFramed];
  SetBounds(0, 0, 121, 19);
  FUseAdvColors := false;
  FAdvColorFocused := 10;
  FAdvColorBorder := 50;
end;


function FieldFind(Find : TSDABusca; Component : TWinControl) : String;
var
  j : integer;
begin
  for j := 0 to Find.FieldsResult.Count - 1 do
    if UpperCase(Find.FieldsResult[j].Controle.Name) = UpperCase(Component.Name) then
      Result := Find.FieldsResult[j].Field;

end;

procedure ExecuteFindEdit(var FExecuteFind : Boolean ;fSDABusca : TSDABusca ;Component : TWinControl; Event: String);
var
  TextComponent : String;
begin
  if Assigned(fSDABusca) then
  begin
    if not FExecuteFind then
      exit;

     if Event = 'OnExit' then
       if Trim(TCustomEdit(Component).Text) = '' then
       begin
         TSDABusca(fSDABusca).Clear;
         exit;
       end;

     if Assigned(TSDABusca(fSDABusca).BeforeExecute) then
       TSDABusca(fSDABusca).BeforeExecute(TCustomEdit(Component));

     if Not Assigned(TSDABusca(fSDABusca).SdaDataSet) then exit;
    {
     if Component is TSdaEditMultipleMask then
       TextComponent := TSdaEditMultipleMask(Component).Value
     else
       TextComponent := TCustomEdit(Component).Text;
        }
     if Trim(TextComponent) <> '' then
     begin
       if TSDABusca(fSDABusca).SdaDataSet.FieldByName(FieldFind(TSDABusca(fSDABusca), TCustomEdit(Component))).DataType = ftString then
          TSDABusca(fSDABusca).Filter := 'Not Atualize' + FieldFind(TSDABusca(fSDABusca),TCustomEdit(Component)) + ' = ''' + UpperCase(TextComponent) + '*'''
       else
          TSDABusca(fSDABusca).Filter := 'Not Atualize' + FieldFind(TSDABusca(fSDABusca),TCustomEdit(Component)) + ' = ' + UpperCase(TextComponent);
     end
     else
     begin
        if TSDABusca(fSDABusca).SdaDataSet.Filtered then
          TSDABusca(fSDABusca).SdaDataSet.Filtered := False;
     end;

     if TSDABusca(fSDABusca).SdaDataSet.RecordCount > 1 then
     begin
       if Trim(TextComponent) <> '' then
        TSDABusca(fSDABusca).Execute('Not Atualize' + TSDABusca(fSDABusca).Filter)
       else
        TSDABusca(fSDABusca).Execute('');

       if not TSDABusca(fSDABusca).ModalResult then
         TCustomEdit(Component).SetFocus;
     end
     else if TSDABusca(fSDABusca).SdaDataSet.RecordCount = 0 then
     begin
       if TextComponent <> '' then
       begin
         MessageDlg('Dado Inexiste ou Indisponível', mtWarning, [mbOk], 0);
         TSDABusca(fSDABusca).Clear;
         TCustomEdit(Component).Text := '';
         TCustomEdit(Component).SetFocus;
       end;
     end
     else if TSDABusca(fSDABusca).SdaDataSet.RecordCount = 1 then
     begin
       TSDABusca(fSDABusca).ModalResult := true;
       if Assigned(TSDABusca(fSDABusca).AfterFind) then
         TSDABusca(fSDABusca).AfterFind(TCustomEdit(Component));
     end;
  end;
end;
procedure TCustomFlatEdit.CalcAdvColors;
begin
  if FUseAdvColors then
  begin
    FFocusedColor := CalcAdvancedColor(FFlatColor, FFocusedColor, FAdvColorFocused, lighten);
    FBorderColor := CalcAdvancedColor(FFlatColor, FBorderColor, FAdvColorBorder, darken);
  end;
end;

procedure TCustomFlatEdit.CMEnabledChanged(var Message: TMessage);
const
  EnableColors: array[Boolean] of TColor= (clBtnFace, clWindow);
begin
  inherited;
  Color := EnableColors[Enabled];
  RedrawBorder(0);
end;

procedure TCustomFlatEdit.CMFontChanged(var Message: TMessage);
begin
  inherited;
  if not((csDesigning in ComponentState) and (csLoading in ComponentState)) then
    NewAdjustHeight;

end;

procedure TCustomFlatEdit.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if (GetActiveWindow <> 0) then
  begin
    MouseInControl := True;
    RedrawBorder(0);
  end;

end;

procedure TCustomFlatEdit.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  MouseInControl := False;
  RedrawBorder(0);

end;

procedure TCustomFlatEdit.CMParentColorChanged(var Message: TWMNoParams);
begin
if FUseAdvColors then
  begin
    if Parent <> nil then
      FFlatColor := TForm(Parent).Color;
    CalcAdvColors;
  end
  else
    if FParentColor then
    begin
      if Parent <> nil then
        FFlatColor := TForm(Parent).Color;
    end;
  RedrawBorder(0);
end;

procedure TCustomFlatEdit.CMSysColorChange(var Message: TMessage);
begin
  if FUseAdvColors then
  begin
    if Parent <> nil then
      FFlatColor := TForm(Parent).Color;
    CalcAdvColors;
  end
  else
    if FParentColor then
    begin
      if Parent <> nil then
        FFlatColor := TForm(Parent).Color;
    end;
  RedrawBorder(0);
end;



procedure TCustomFlatEdit.Loaded;
begin
  inherited;
  if not(csDesigning in ComponentState) then
    NewAdjustHeight;
end;

procedure TCustomFlatEdit.NewAdjustHeight;
var
  DC: HDC;
  SaveFont: HFONT;
  Metrics: TTextMetric;
begin
  DC := GetDC(0);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  Height := Metrics.tmHeight + 6;
end;

procedure TCustomFlatEdit.RedrawBorder(const Clip: HRGN);
var
  DC: HDC;
  R: TRect;
  BtnFaceBrush, WindowBrush, FocusBrush: HBRUSH;
begin
  DC := GetWindowDC(Handle);
  try
    GetWindowRect(Handle, R);
    OffsetRect(R, -R.Left, -R.Top);
    BtnFaceBrush := CreateSolidBrush(ColorToRGB(FBorderColor));
    WindowBrush := CreateSolidBrush(ColorToRGB(FFlatColor));
    FocusBrush := CreateSolidBrush(ColorToRGB(FFocusedColor));
    if (not(csDesigning in ComponentState) and
      (Focused or (MouseInControl and not(Screen.ActiveControl is TSDAEdit)))) then
    begin
      { Focus }
      Color := FFocusedColor;
      FrameRect(DC, R, BtnFaceBrush);
      InflateRect(R, -1, -1);
      FrameRect(DC, R, FocusBrush);
      InflateRect(R, -1, -1);
      FrameRect(DC, R, FocusBrush);
    end
    else
    begin
      { non Focus }
      Color := FFlatColor;
      FrameRect(DC, R, BtnFaceBrush);
      InflateRect(R, -1, -1);
      FrameRect(DC, R, WindowBrush);
      InflateRect(R, -1, -1);
      FrameRect(DC, R, WindowBrush);
    end;
  finally
    ReleaseDC(Handle, DC);
  end;
  DeleteObject(WindowBrush);
  DeleteObject(BtnFaceBrush);
  DeleteObject(FocusBrush);
end;



procedure TCustomFlatEdit.SetAdvColors(Index: Integer; Value: TAdvColors);
begin
  case Index of
    0: FAdvColorFocused := Value;
    1: FAdvColorBorder := Value;
  end;
  if FUseAdvColors then
  begin
    CalcAdvColors;
    RedrawBorder(0);
  end;
end;

procedure TCustomFlatEdit.SetColors(Index: Integer; Value: TColor);
begin
  case Index of
    0: FFocusedColor := Value;
    1: FBorderColor := Value;
    2: FFlatColor := Value;
  end;
  if Index = 2 then
    FParentColor := False;
  RedrawBorder(0);
end;

procedure TCustomFlatEdit.SetParentColor(Value: Boolean);
begin
  if Value <> FParentColor then
  begin
    FParentColor := Value;
    if FParentColor then
    begin
      if Parent <> nil then
        FFlatColor := TForm(Parent).Color;
      RedrawBorder(0);
    end;
  end;
end;

procedure TCustomFlatEdit.SetUseAdvColors(Value: Boolean);
begin
  if Value <> FUseAdvColors then
  begin
    FUseAdvColors := Value;
    ParentColor := Value;
    CalcAdvColors;
    RedrawBorder(0);
  end;
end;

procedure TCustomFlatEdit.WMKillFocus(var Message: TWMKillFocus);
begin
  if not(csDesigning in ComponentState) then
    RedrawBorder(0);
end;

procedure TCustomFlatEdit.WMNCCalcSize(var Message: TWMNCCalcSize);
begin
    InflateRect(Message.CalcSize_Params^.rgrc[0], -3, -3);
end;

procedure TCustomFlatEdit.WMNCPaint(var Message: TMessage);
begin
    RedrawBorder(HRGN(Message.WParam));
end;

procedure TCustomFlatEdit.WMSetFocus(var Message: TWMSetFocus);
begin
   if not(csDesigning in ComponentState) then
    RedrawBorder(0);
end;

{ TSDAMemo }

constructor TSDAMemo.Create (AOwner: TComponent);
begin
  inherited;
  ParentFont := True;
  FFocusedColor := clWhite;
  FBorderColor := $008396A0;
  FFlatColor := $00E1EAEB;
  FParentColor := True;
  AutoSize := False;
  Ctl3D := False;
  BorderStyle := bsNone;
  ControlStyle := ControlStyle - [csFramed];
  SetBounds(0, 0, 185, 89);
  FUseAdvColors := false;
  FAdvColorFocused := 10;
  FAdvColorBorder := 50;
end;

procedure TSDAMemo.SetParentColor (Value: Boolean);
begin
  if Value <> FParentColor then
  begin
    FParentColor := Value;
    if FParentColor then
    begin
      if Parent <> nil then
        FFlatColor := TForm(Parent).Color;
      RedrawBorder(0);
    end;
  end;
end;

procedure TSDAMemo.CMSysColorChange (var Message: TMessage);
begin
  if FUseAdvColors then
  begin
    if Parent <> nil then
      FFlatColor := TForm(Parent).Color;
    CalcAdvColors;
  end
  else
    if FParentColor then
    begin
      if Parent <> nil then
        FFlatColor := TForm(Parent).Color;
    end;
  RedrawBorder(0);
end;

procedure TSDAMemo.CMParentColorChanged (var Message: TWMNoParams);
begin
  if FUseAdvColors then
  begin
    if Parent <> nil then
      FFlatColor := TForm(Parent).Color;
    CalcAdvColors;
  end
  else
    if FParentColor then
    begin
      if Parent <> nil then
        FFlatColor := TForm(Parent).Color;
    end;
  RedrawBorder(0);
end;

procedure TSDAMemo.SetColors (Index: Integer; Value: TColor);
begin
  case Index of
    0: FFocusedColor := Value;
    1: FBorderColor := Value;
    2: FFlatColor := Value;
  end;
  if Index = 2 then
    FParentColor := False;
  RedrawBorder(0);
end;

procedure TSDAMemo.CalcAdvColors;
begin
  if FUseAdvColors then
  begin
    FFocusedColor := CalcAdvancedColor(FFlatColor, FFocusedColor, FAdvColorFocused, lighten);
    FBorderColor := CalcAdvancedColor(FFlatColor, FBorderColor, FAdvColorBorder, darken);
  end;
end;

procedure TSDAMemo.SetAdvColors (Index: Integer; Value: TAdvColors);
begin
  case Index of
    0: FAdvColorFocused := Value;
    1: FAdvColorBorder := Value;
  end;
  if FUseAdvColors then
  begin
    CalcAdvColors;
    RedrawBorder(0);
  end;
end;

procedure TSDAMemo.SetUseAdvColors (Value: Boolean);
begin
  if Value <> FUseAdvColors then
  begin
    FUseAdvColors := Value;
    ParentColor := Value;
    CalcAdvColors;
    RedrawBorder(0);
  end;
end;

procedure TSDAMemo.CMMouseEnter (var Message: TMessage);
begin
  inherited;
  if (GetActiveWindow <> 0) then
  begin
    MouseInControl := True;
    RedrawBorder(0);
  end;
end;

procedure TSDAMemo.CMMouseLeave (var Message: TMessage);
begin
  inherited;
  MouseInControl := False;
  RedrawBorder(0);
end;

procedure TSDAMemo.CMEnabledChanged (var Message: TMessage);
const
  EnableColors: array[Boolean] of TColor = (clBtnFace, clWindow);
begin
  inherited;
  Color := EnableColors[Enabled];
  RedrawBorder(0);
end;

procedure TSDAMemo.WMSetFocus (var Message: TWMSetFocus);
begin
  inherited;
  if not(csDesigning in ComponentState) then
    RedrawBorder(0);
end;

procedure TSDAMemo.WMKillFocus (var Message: TWMKillFocus);
begin
  inherited;
  if not(csDesigning in ComponentState) then
    RedrawBorder(0);
end;

procedure TSDAMemo.WMNCCalcSize (var Message: TWMNCCalcSize);
begin
  inherited;
  InflateRect(Message.CalcSize_Params^.rgrc[0], -3, -3);
end;

procedure TSDAMemo.WMNCPaint (var Message: TMessage);
begin
  inherited;
  RedrawBorder(HRGN(Message.WParam));
end;

procedure TSDAMemo.RedrawBorder (const Clip: HRGN);
var
  DC: HDC;
  R: TRect;
  BtnFaceBrush, WindowBrush, FocusBrush: HBRUSH;
begin
  DC := GetWindowDC(Handle);
  try
    GetWindowRect(Handle, R);
    OffsetRect(R, -R.Left, -R.Top);
    BtnFaceBrush := CreateSolidBrush(ColorToRGB(FBorderColor));
    WindowBrush := CreateSolidBrush(ColorToRGB(FFlatColor));
    FocusBrush := CreateSolidBrush(ColorToRGB(FFocusedColor));

    if (not(csDesigning in ComponentState) and
      (Focused or (MouseInControl and not(Screen.ActiveControl is TSDAMemo)))) then
    begin
      { Focus }
      Color := FFocusedColor;
      FrameRect(DC, R, BtnFaceBrush);
      InflateRect(R, -1, -1);
      FrameRect(DC, R, FocusBrush);
      InflateRect(R, -1, -1);
      FrameRect(DC, R, FocusBrush);
      if ScrollBars = ssBoth then
        FillRect(DC, Rect(R.Right - 17, R.Bottom - 17, R.Right - 1, R.Bottom - 1), FocusBrush);
    end
    else
    begin
      { non Focus }
      Color := FFlatColor;
      FrameRect(DC, R, BtnFaceBrush);
      InflateRect(R, -1, -1);
      FrameRect(DC, R, WindowBrush);
      InflateRect(R, -1, -1);
      FrameRect(DC, R, WindowBrush);
      if ScrollBars = ssBoth then
        FillRect(DC, Rect(R.Right - 17, R.Bottom - 17, R.Right - 1, R.Bottom - 1), WindowBrush);
    end;
  finally
    ReleaseDC(Handle, DC);
  end;
  DeleteObject(WindowBrush);
  DeleteObject(BtnFaceBrush);
  DeleteObject(FocusBrush);
end;

end.
