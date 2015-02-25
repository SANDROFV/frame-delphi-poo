unit XPMenu;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, ComCtrls,  Forms,
  Menus, Messages, Commctrl, ExtCtrls, StdCtrls, Buttons;

type

  TXPContainer = (xcForm, xcToolbar, xcCoolbar, xcControlbar, xcPanel,
                  xcScrollBox, xcFrame, xcGroupBox, xcTabSheet);
  TXPContainers = set of TXPContainer;

  TXPControl = (xcMainMenu, xcPopupMenu, xcCToolbar, xcCControlbar, xcCombo,
    xcEdit, xcCheckBox, xcRadioButton, xcButton);

  TXPControls = set of TXPControl;

  // changes added by Heath Provost (Nov 20, 2001)
  // This is an object which "holds" the control controls
  // To allow subclassing to work
  TXPMenu = class;
  TControlSubClass = class(TObject)
  private
    Control: TWinControl;
    FBuilding: boolean;
    FMouseInControl: boolean;
    FLButtonBressed: boolean;
    FBressed: boolean;
    FIsKeyDown: boolean;
    orgWindowProc: TWndMethod;
    XPMenu: TXPMenu;
    BorderStyle: TBorderStyle;
    procedure ControlSubClass(var Message: TMessage);
    procedure PaintControlXP;
    procedure PaintCombo;
    procedure PaintEdit;
    procedure PaintCheckBox;
    procedure PaintRadio;
    procedure PaintButton;
  end;

  TXPMenu = class(TComponent)
  private
    FActive: boolean;
    {Changes MMK FForm to TScrollingWinControl}
    FForm: TScrollingWinControl;
    FFont: TFont;
    FColor: TColor;
    FIconBackColor: TColor;
    FMenuBarColor: TColor;
    FCheckedColor: TColor;
    FSeparatorColor: TColor;
    FSelectBorderColor: TColor;
    FSelectColor: TColor;
    FDisabledColor: TColor;
    FSelectFontColor: TColor;
    FIconWidth: integer;
    FDrawSelect: boolean;
    FUseSystemColors: boolean;

    FFColor, FFIconBackColor, FFSelectColor, FFSelectBorderColor,
    FFSelectFontColor, FCheckedAreaColor, FCheckedAreaSelectColor,
    FFCheckedColor, FFMenuBarColor, FFDisabledColor, FFSeparatorColor,
    FMenuBorderColor, FMenuShadowColor: TColor;

    Is16Bit: boolean;
    FOverrideOwnerDraw: boolean;
    FGradient: boolean;
    FFlatMenu: boolean;
    FAutoDetect: boolean;
    FXPContainers: TXPContainers;
    FXPControls: TXPControls;
    FGrayLevel: byte;
    FDimLevel: byte;

    procedure SetActive(const Value: boolean);
    procedure SetAutoDetect(const Value: boolean);
    procedure SetForm(const Value: TScrollingWinControl);
    procedure SetFont(const Value: TFont);
    procedure SetColor(const Value: TColor);
    procedure SetIconBackColor(const Value: TColor);
    procedure SetMenuBarColor(const Value: TColor);
    procedure SetCheckedColor(const Value: TColor);
    procedure SetDisabledColor(const Value: TColor);
    procedure SetSelectColor(const Value: TColor);
    procedure SetSelectBorderColor(const Value: TColor);
    procedure SetSeparatorColor(const Value: TColor);
    procedure SetSelectFontColor(const Value: TColor);
    procedure SetIconWidth(const Value: integer);
    procedure SetDrawSelect(const Value: boolean);
    procedure SetUseSystemColors(const Value: boolean);
    procedure SetOverrideOwnerDraw(const Value: boolean);
    procedure SetGradient(const Value: boolean);
    procedure SetFlatMenu(const Value: boolean);
    procedure SetXPContainers(const Value: TXPContainers);
    procedure SetXPControls(const Value: TXPControls);

  protected
    procedure InitMenueItems(wForm: TWinControl; Enable, Update: boolean);
    procedure DrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      Selected: Boolean);
    procedure MenueDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      Selected: Boolean);
    {$IFDEF VER5U}
    procedure ToolBarDrawButton(Sender: TToolBar;
      Button: TToolButton; State: TCustomDrawState; var DefaultDraw: Boolean);
    {$ENDIF}
    procedure ControlBarPaint(Sender: TObject; Control: TControl;
      Canvas: TCanvas; var ARect: TRect; var Options: TBandPaintOptions);

    procedure ActivateMenuItem(MenuItem: TMenuItem);
    procedure SetGlobalColor(ACanvas: TCanvas);
    procedure DrawTopMenuItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      BckColor:Tcolor; IsRightToLeft: boolean);
    procedure DrawCheckedItem(FMenuItem: TMenuItem; Selected,
     HasImgLstBitmap: boolean; ACanvas: TCanvas; CheckedRect: TRect);
    procedure DrawTheText(Sender: TObject; txt, ShortCuttext: string;
       ACanvas: TCanvas; TextRect: TRect;
       Selected, Enabled, Default, TopMenu, IsRightToLeft: boolean;
       var TxtFont: TFont; TextFormat: integer);
    procedure DrawIcon(Sender: TObject; ACanvas: TCanvas; B: TBitmap;
     IconRect: Trect; Hot, Selected, Enabled, Checked, FTopMenu,
     IsRightToLeft: boolean);
    procedure DrawArrow(ACanvas: TCanvas; X, Y: integer);
    procedure MeasureItem(Sender: TObject; ACanvas: TCanvas;
      var Width, Height: Integer);

    function GetImageExtent(MenuItem: TMenuItem): TPoint;
    function TopMenuFontColor(ACanvas: TCanvas; Color: TColor): TColor;
    procedure DrawGradient(ACanvas: TCanvas; ARect: TRect;
     IsRightToLeft: boolean);

    procedure DrawWindowBorder(hWnd: HWND; IsRightToLeft: boolean);

    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Form: TScrollingWinControl read FForm write SetForm;
  published
    property DimLevel: Byte read FDimLevel write FDimLevel;
    property GrayLevel: Byte read FGrayLevel write FGrayLevel;
    property Font: TFont read FFont write SetFont;
    property Color: TColor read FColor write SetColor;
    property IconBackColor: TColor read FIconBackColor write SetIconBackColor;
    property MenuBarColor: TColor read FMenuBarColor write SetMenuBarColor;
    property SelectColor: TColor read FSelectColor write SetSelectColor;
    property SelectBorderColor: TColor read FSelectBorderColor
     write SetSelectBorderColor;
    property SelectFontColor: TColor read FSelectFontColor
     write SetSelectFontColor;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor;
    property SeparatorColor: TColor read FSeparatorColor
     write SetSeparatorColor;
    property CheckedColor: TColor read FCheckedColor write SetCheckedColor;
    property IconWidth: integer read FIconWidth write SetIconWidth;
    property DrawSelect: boolean read FDrawSelect write SetDrawSelect;
    property UseSystemColors: boolean read FUseSystemColors
     write SetUseSystemColors;
    property OverrideOwnerDraw: boolean read FOverrideOwnerDraw
     write SetOverrideOwnerDraw;

    property Gradient: boolean read FGradient write SetGradient;
    property FlatMenu: boolean read FFlatMenu write SetFlatMenu;
    property AutoDetect: boolean read FAutoDetect write SetAutoDetect;
    property XPContainers: TXPContainers read FXPContainers write SetXPContainers
      default [xcToolbar,xcCoolbar,xcControlbar,xcPanel];
    property XPControls :TXPControls read FXPControls write SetXPControls
      default [xcMainMenu, xcPopupMenu, xccToolbar, xccControlbar, xcCombo,
        xcCheckBox, xcRadioButton, xcButton];

    property Active: boolean read FActive write SetActive;

  end;



function GetShadeColor(ACanvas: TCanvas; clr: TColor; Value: integer): TColor;
function NewColor(ACanvas: TCanvas; clr: TColor; Value: integer): TColor;
procedure DimBitmap(ABitmap: TBitmap; Value: integer);
function GrayColor(ACanvas: TCanvas; clr: TColor; Value: integer): TColor;

procedure GrayBitmap(ABitmap: TBitmap; Value: integer);
procedure DrawBitmapShadow(B: TBitmap; ACanvas: TCanvas; X, Y: integer;
  ShadowColor: TColor);



procedure GetSystemMenuFont(Font: TFont);
procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('XP', [TXPMenu]);
end;

{ TXPMenue }

constructor TXPMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFont := TFont.Create;
  GetSystemMenuFont(FFont);
  FForm := Owner as TScrollingWinControl;

  FUseSystemColors := true;


  FColor := clBtnFace;
  FIconBackColor := clBtnFace;
  FSelectColor := clHighlight;
  FSelectBorderColor := clHighlight;
  FMenuBarColor := clBtnFace;
  FDisabledColor := clInactiveCaption;
  FSeparatorColor := clBtnFace;
  FCheckedColor := clHighlight;
  FSelectFontColor := FFont.Color;
  FGrayLevel := 10;
  FDimLevel := 30;
  FIconWidth := 24;
  FDrawSelect := true;
  XPContainers := [xcToolbar,xcCoolbar,xcControlbar,xcPanel];
  XPControls := [xcMainMenu, xcPopupMenu, xccToolbar, xccControlbar, xcCombo,
                 xcCheckBox, xcRadioButton, xcButton];

  if FActive then
  begin
    InitMenueItems(FForm, true, false);
  end;

end;

destructor TXPMenu.Destroy;
begin
  InitMenueItems(FForm, false, false);
  FFont.Free;

  inherited;
end;


{to check for new sub items}
procedure TXPMenu.ActivateMenuItem(MenuItem: TMenuItem);

  procedure Activate(MenuItem: TMenuItem);
  begin
    if addr(MenuItem.OnDrawItem) <> addr(TXPMenu.DrawItem) then
    begin
      if (not assigned(MenuItem.OnDrawItem)) or (FOverrideOwnerDraw) then
        MenuItem.OnDrawItem := DrawItem;
      if (not assigned(MenuItem.OnMeasureItem)) or (FOverrideOwnerDraw) then
        MenuItem.OnMeasureItem := MeasureItem;
    end
  end;

var
  i, j: integer;
begin

  Activate(MenuItem);
  for i := 0 to MenuItem.Parent.Count -1 do
  begin
    Activate(MenuItem.Parent.Items[i]);
    for j := 0 to MenuItem.Parent.Items[i].Count - 1 do
      ActivateMenuItem(MenuItem.Parent.Items[i].Items[j]);
  end;

end;

procedure TXPMenu.InitMenueItems(wForm: TWinControl; Enable, Update: boolean );

  procedure Activate(MenuItem: TMenuItem);
  begin
    if Enable then
    begin
      if (not assigned(MenuItem.OnDrawItem)) or (FOverrideOwnerDraw) then
        MenuItem.OnDrawItem := DrawItem;
      if (not assigned(MenuItem.OnMeasureItem)) or (FOverrideOwnerDraw) then
        MenuItem.OnMeasureItem := MeasureItem;
    end
    else
    begin
      if addr(MenuItem.OnDrawItem) = addr(TXPMenu.DrawItem) then
        MenuItem.OnDrawItem := nil;
      if addr(MenuItem.OnMeasureItem) = addr(TXPMenu.MeasureItem) then
        MenuItem.OnMeasureItem := nil;
    end;
  end;

  procedure ItrateMenu(MenuItem: TMenuItem);
  var
    i: integer;
  begin
    Activate(MenuItem);
    for i := 0 to MenuItem.Count - 1 do
      ItrateMenu(MenuItem.Items[i]);
  end;

var
  i, x: integer;
  Comp: TComponent;
begin

  for i := 0 to wForm.ComponentCount - 1 do
  begin
    Comp := wForm.Components[i];

    if (Comp is TMainMenu) and (xcMainMenu in XPControls) then
    begin
      for x := 0 to TMainMenu(Comp).Items.Count - 1 do
      begin
        TMainMenu(Comp).OwnerDraw := Enable;
        Activate(TMainMenu(Comp).Items[x]);
        ItrateMenu(TMainMenu(Comp).Items[x]);
      end;
    end;

    if (Comp is TPopupMenu) and (xcPopupMenu in XPControls) then
    begin
      for x := 0 to TPopupMenu(Comp).Items.Count - 1 do
      begin
        TPopupMenu(Comp).OwnerDraw := Enable;
        Activate(TPopupMenu(Comp).Items[x]);
        ItrateMenu(TPopupMenu(Comp).Items[x]);

      end;
    end;

    {$IFDEF VER5U}
    if (Comp is TToolBar) and (xcCToolBar in FXPControls) then
      if not (csDesigning in ComponentState) then
      begin
        if not TToolBar(Comp).Flat then
          TToolBar(Comp).Flat := true;

        if Enable then
        begin
          for x := 0 to TToolBar(Comp).ButtonCount - 1 do
            if (not assigned(TToolBar(Comp).OnCustomDrawButton))
              or (FOverrideOwnerDraw) then
            begin
              TToolBar(Comp).OnCustomDrawButton :=
                ToolBarDrawButton;

            end;
        end
        else
        begin
          if addr(TToolBar(Comp).OnCustomDrawButton) =
            addr(TXPMenu.ToolBarDrawButton) then
          TToolBar(Comp).OnCustomDrawButton := nil;
        end;
        if Update then
          TToolBar(Comp).Invalidate;
      end;
    {$ENDIF}

    if (Comp is TControlBar) and (xcCControlBar in FXPControls) then
      if not (csDesigning in ComponentState) then
      begin
        if Enable then
        begin
          if (not assigned(TControlBar(Comp).OnBandPaint))
            or (FOverrideOwnerDraw) then
          begin
            TControlBar(Comp).OnBandPaint := ControlBarPaint;
          end;
        end
        else
        begin
          if addr(TControlBar(Comp).OnBandPaint) =
            addr(TXPMenu.ControlBarPaint) then
          TControlBar(Comp).OnBandPaint := nil;
        end;
        if Update then
          TControlBar(Comp).Invalidate;
      end;

    if not (csDesigning in ComponentState) then
      if {$IFDEF VER6U}
         ((Comp is TCustomCombo) and (xcCombo in FXPControls)) or
         {$ELSE}
         ((Comp is TCustomComboBox) and (xcCombo in FXPControls)) or
         {$ENDIF}
         ((Comp is TCustomEdit) and (xcEdit in FXPControls)) or
         ((Comp is TCustomCheckBox) and (xcCheckBox in FXPControls)) or
         ((Comp is TRadioButton) and (xcRadioButton in FXPControls)) or
         ((Comp is TButton) and (xcButton in FXPControls))
         then
        if ((TControl(Comp).Parent is TToolbar) and (xcToolBar in FXPContainers))or
           ((TControl(Comp).Parent is TCoolbar) and (xcCoolbar in FXPContainers)) or
           ((TControl(Comp).Parent is TPanel) and (xcPanel in FXPContainers)) or
           ((TControl(Comp).Parent is TControlbar) and (xcControlbar in FXPContainers)) or
           ((TControl(Comp).Parent is TScrollBox) and (xcScrollBox in FXPContainers)) or
           ((TControl(Comp).Parent is TCustomGroupBox) and (xcGroupBox in FXPContainers)) or
           ((TControl(Comp).Parent is TTabSheet) and (xcTabSheet in FXPContainers)) or
           ((TControl(Comp).Parent is TCustomForm) and (xcForm in FXPContainers))
           then
        begin
          if (Enable) and (Comp.Tag <> 999) and (TControl(Comp).Parent.Tag <> 999) then
                                      {skip if Control/Control.parent.tag = 999}
            with TControlSubClass.Create do
            begin
              Control := TWinControl(Comp);
              if Addr(Control.WindowProc) <> Addr(TControlSubClass.ControlSubClass) then
              begin
                orgWindowProc := Control.WindowProc;
                Control.WindowProc := ControlSubClass;
              end;
              XPMenu := self;

              if (Control is TCustomEdit) then
                BorderStyle:= TEdit(Control).BorderStyle;

            end;

          if Update then
            TWinControl(Comp).invalidate;

        end;

    // Recursive call for possible containers.
    {$IFDEF VER5U}
    if ((Comp is TCustomFrame) and (xcForm in FXPContainers)) then
      self.InitMenueItems(Comp as TWinControl, Enable, Update);
    {$ENDIF}
  end;
end;

procedure TXPMenu.DrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
  Selected: Boolean);
begin
  if FActive then
    MenueDrawItem(Sender, ACanvas, ARect, Selected);
end;



function TXPMenu.GetImageExtent(MenuItem: TMenuItem): TPoint;
var
  HasImgLstBitmap: boolean;
  B: TBitmap;
  FTopMenu: boolean;
begin
  FTopMenu := false;
  B := TBitmap.Create;
  B.Width := 0;
  B.Height := 0;
  Result.x := 0;
  Result.Y := 0;
  HasImgLstBitmap := false;

  {Changes MMK TForm and TFrame}
  if (FForm is TForm) and ((FForm as TForm).Menu <> nil) then
    if MenuItem.GetParentComponent.Name = (FForm as TForm).Menu.Name then
    begin
      FTopMenu := true;
      if (FForm as TForm).Menu.Images <> nil then
        if MenuItem.ImageIndex <> -1 then
          HasImgLstBitmap := true;

    end;

  {End Changes}


  if (MenuItem.Parent.GetParentMenu.Images <> nil)
  {$IFDEF VER5U}
  or (MenuItem.Parent.SubMenuImages <> nil)
  {$ENDIF}
  then
  begin
    if MenuItem.ImageIndex <> -1 then
      HasImgLstBitmap := true
    else
      HasImgLstBitmap := false;
  end;

  if HasImgLstBitmap then
  begin
  {$IFDEF VER5U}
    if MenuItem.Parent.SubMenuImages <> nil then
      MenuItem.Parent.SubMenuImages.GetBitmap(MenuItem.ImageIndex, B)
    else
  {$ENDIF}
      MenuItem.Parent.GetParentMenu.Images.GetBitmap(MenuItem.ImageIndex, B)
  end
  else
    if MenuItem.Bitmap.Width > 0 then
      B.Assign(TBitmap(MenuItem.Bitmap));

  Result.x := B.Width;
  Result.Y := B.Height;

  if not FTopMenu then
    if Result.x < FIconWidth then
      Result.x := FIconWidth;

  B.Free;
end;

procedure TXPMenu.MeasureItem(Sender: TObject; ACanvas: TCanvas;
  var Width, Height: Integer);
var
  s: string;
  W, H: integer;
  P: TPoint;
  IsLine: boolean;
begin
  if FActive then
  begin
    S := TMenuItem(Sender).Caption;

    if S = '-' then IsLine := true else IsLine := false;
    if IsLine then
      S := '';

    if Trim(ShortCutToText(TMenuItem(Sender).ShortCut)) <> '' then
      S := S + ShortCutToText(TMenuItem(Sender).ShortCut) + 'WWW';

    ACanvas.Font.Assign(FFont);
    W := ACanvas.TextWidth(s);
    if pos('&', s) > 0 then
      W := W - ACanvas.TextWidth('&');

    P := GetImageExtent(TMenuItem(Sender));

    W := W + P.x + 10;

    if Width < W then
      Width := W;

    if IsLine then
      Height := 4
    else
    begin
      H := ACanvas.TextHeight(s) + Round(ACanvas.TextHeight(s) * 0.75);
      if P.y + 6 > H then
        H := P.y + 6;

      if Height < H then
        Height := H;
    end;
  end;

end;

procedure TXPMenu.MenueDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
  Selected: Boolean);
var
  txt: string;
  B: TBitmap;
  IconRect, TextRect, CheckedRect: TRect;
  i, X1, X2: integer;
  TextFormat: integer;
  HasImgLstBitmap: boolean;
  FMenuItem: TMenuItem;
  FMenu: TMenu;
  FTopMenu: boolean;
  ISLine: boolean;
  ImgListHandle: HImageList;  {Commctrl.pas}
  ImgIndex: integer;
  hWndM: HWND;
  hDcM: HDC;
  OSVersionInfo: TOSVersionInfo;
begin


  FTopMenu := false;
  FMenuItem := TMenuItem(Sender);

  SetGlobalColor(ACanvas);

  if FMenuItem.Caption = '-' then IsLine := true else IsLine := false;

  FMenu := FMenuItem.Parent.GetParentMenu;

  if FMenu is TMainMenu then
    for i := 0 to FMenuItem.GetParentMenu.Items.Count - 1 do
      if FMenuItem.GetParentMenu.Items[i] = FMenuItem then
      begin
        FTopMenu := True;
        break;
      end;


  ACanvas.Font.Assign(FFont);
  if FMenu.IsRightToLeft then
    ACanvas.Font.Charset := ARABIC_CHARSET;

  Inc(ARect.Bottom, 1);
  TextRect := ARect;
  txt := ' ' + FMenuItem.Caption;

  B := TBitmap.Create;

  HasImgLstBitmap := false;


  if (FMenuItem.Parent.GetParentMenu.Images <> nil)
  {$IFDEF VER5U}
  or (FMenuItem.Parent.SubMenuImages <> nil)
  {$ENDIF}
  then
  begin
    if FMenuItem.ImageIndex <> -1 then
      HasImgLstBitmap := true
    else
      HasImgLstBitmap := false;
  end;



  if FMenu.IsRightToLeft then
  begin
    X1 := ARect.Right - FIconWidth;
    X2 := ARect.Right;
  end
  else
  begin
    X1 := ARect.Left;
    X2 := ARect.Left + FIconWidth;
  end;
  IconRect := Rect(X1, ARect.Top, X2, ARect.Bottom);


  if HasImgLstBitmap then
  begin
    CheckedRect := IconRect;
    Inc(CheckedRect.Left, 1);
    Inc(CheckedRect.Top, 2);
    Dec(CheckedRect.Right, 3);
    Dec(CheckedRect.Bottom, 2);

  end
  else
  begin
    CheckedRect.Left := IconRect.Left +
      (IConRect.Right - IconRect.Left - 10) div 2;
    CheckedRect.Top := IconRect.Top +
      (IConRect.Bottom - IconRect.Top - 10) div 2;
    CheckedRect.Right := CheckedRect.Left + 10;
    CheckedRect.Bottom := CheckedRect.Top + 10;

  end;


  if FMenu.IsRightToLeft then
  begin
    X1 := ARect.Left;
    X2 := ARect.Right - FIconWidth;
    if B.Width > FIconWidth then
      X2 := ARect.Right - B.Width - 4;
  end
  else
  begin
    X1 := ARect.Left + FIconWidth;
    if B.Width > X1 then
      X1 := B.Width + 4;
    X2 := ARect.Right;
  end;

  TextRect := Rect(X1, ARect.Top, X2, ARect.Bottom);

  if FTopMenu then
  begin
    if not HasImgLstBitmap then
    begin
      //Add 8 pixels for win2k
      GetVersionEx(OSVersionInfo);
      if OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
      begin
        if FMenu.IsRightToLeft then
          Dec(ARect.Left, 5)
        else
          Inc(ARect.Right, 8);
      end;
      TextRect := ARect;
    end
    else
    begin
      if FMenu.IsRightToLeft then
        TextRect.Right := TextRect.Right + 5
      else
        TextRect.Left := TextRect.Left - 5;
    end

  end;

  if FTopMenu then
  begin
    ACanvas.brush.color := FFMenuBarColor;
    ACanvas.Pen.Color := FFMenuBarColor;

    ACanvas.FillRect(ARect);
  end
  else
  begin
    if (Is16Bit and FGradient) then
    begin
      inc(ARect.Right,2);  //needed for RightToLeft
      DrawGradient(ACanvas, ARect, FMenu.IsRightToLeft);
      Dec(ARect.Right,2);

    end
    else
    begin
      ACanvas.brush.color := FFColor;
      if (not FMenuItem.Enabled) and (Selected) then
      else
        ACanvas.FillRect(ARect);

      ACanvas.brush.color := FFIconBackColor;
      if (not FMenuItem.Enabled) and (Selected) then
      else
        ACanvas.FillRect(IconRect);
    end;


//------------
  end;


  if FMenuItem.Enabled then
    ACanvas.Font.Color := FFont.Color
  else
    ACanvas.Font.Color := FDisabledColor;

  if Selected and FDrawSelect then
  begin
    ACanvas.brush.Style := bsSolid;
    if FTopMenu then
    begin
      DrawTopMenuItem(FMenuItem, ACanvas, ARect, FMenuBarColor, FMenu.IsRightToLeft);
    end
    else
      if FMenuItem.Enabled then
      begin

        Inc(ARect.Top, 1);
        Dec(ARect.Bottom, 1);
        if FFlatMenu then
          Dec(ARect.Right, 1);
        ACanvas.brush.color := FFSelectColor;
        ACanvas.FillRect(ARect);
        ACanvas.Pen.color := FFSelectBorderColor;
        ACanvas.Brush.Style := bsClear;
        ACanvas.RoundRect(Arect.Left, Arect.top, Arect.Right, Arect.Bottom, 0, 0);
        Dec(ARect.Top, 1);
        Inc(ARect.Bottom, 1);
        if FFlatMenu then
          Inc(ARect.Right, 1);
      end;
  end;

  DrawCheckedItem(FMenuItem, Selected, HasImgLstBitmap, ACanvas, CheckedRect);

//-----

  if HasImgLstBitmap then
  begin
  {$IFDEF VER5U}
    if FMenuItem.Parent.SubMenuImages <> nil then
    begin
      ImgListHandle := FMenuItem.Parent.SubMenuImages.Handle;
      ImgIndex := FMenuItem.ImageIndex;

      B.Width := FMenuItem.Parent.SubMenuImages.Width;
      B.Height := FMenuItem.Parent.SubMenuImages.Height;
      B.Canvas.Brush.Color := ACanvas.Brush.Color;
      B.Canvas.FillRect(Rect(0, 0, B.Width, B.Height));
      ImageList_DrawEx(ImgListHandle, ImgIndex,
        B.Canvas.Handle, 0, 0, 0, 0, clNone, clNone, ILD_Transparent);

    end
    else
  {$ENDIF}
    begin
      ImgListHandle := FMenuItem.Parent.GetParentMenu.Images.Handle;
      ImgIndex := FMenuItem.ImageIndex;

      B.Width := FMenuItem.Parent.GetParentMenu.Images.Width;
      B.Height := FMenuItem.Parent.GetParentMenu.Images.Height;
      B.Canvas.Brush.Color := ACanvas.Pixels[2,2];
      B.Canvas.FillRect(Rect(0, 0, B.Width, B.Height));
      ImageList_DrawEx(ImgListHandle, ImgIndex,
        B.Canvas.Handle, 0, 0, 0, 0, clNone, clNone, ILD_Transparent);

    end;


  end

  else
    if FMenuItem.Bitmap <> nil then
    begin
      B.Width := FMenuItem.Bitmap.Width;
      B.Height := FMenuItem.Bitmap.Height;
      B.Canvas.CopyRect (Rect(0, 0, B.Width, B.Height), FMenuItem.Bitmap.Canvas,
                         Rect(0, 0, B.Width, B.Height));
    end;

  DrawIcon(FMenuItem, ACanvas, B, IconRect,
    Selected, False, FMenuItem.Enabled, FMenuItem.Checked,
    FTopMenu, FMenu.IsRightToLeft);


  if not IsLine then
  begin

    if FMenu.IsRightToLeft then
    begin
      TextFormat := DT_RIGHT + DT_RTLREADING;
      Dec(TextRect.Right, 5);
    end
    else
    begin
      TextFormat := 0;
      Inc(TextRect.Left, 5);
    end;

    DrawTheText(FMenuItem, txt, ShortCutToText(FMenuItem.ShortCut),
      ACanvas, TextRect,
      Selected, FMenuItem.Enabled, FMenuItem.Default,
      FTopMenu, FMenu.IsRightToLeft, FFont, TextFormat);

  end
  else
  begin
    if FMenu.IsRightToLeft then
    begin
      X1 := TextRect.Left;
      X2 := TextRect.Right - 7;
    end
    else
    begin
      X1 := TextRect.Left + 7;
      X2 := TextRect.Right;
    end;

    ACanvas.Pen.Color := FFSeparatorColor;
    ACanvas.MoveTo(X1,
      TextRect.Top +
      Round((TextRect.Bottom - TextRect.Top) / 2));
    ACanvas.LineTo(X2,
      TextRect.Top +
      Round((TextRect.Bottom - TextRect.Top) / 2))
  end;

  B.free;

  if not (csDesigning in ComponentState) then
  begin
    if (FFlatMenu) and (not FTopMenu) then
    begin
      hDcM := ACanvas.Handle;
      hWndM := WindowFromDC(hDcM);
      if hWndM <> FForm.Handle then
      begin
        DrawWindowBorder(hWndM, FMenu.IsRightToLeft);
      end;
    end;
  end;

//-----
  ActivateMenuItem(FMenuItem);  // to check for new sub items

end;

{$IFDEF VER5U}
procedure TXPMenu.ToolBarDrawButton(Sender: TToolBar;
  Button: TToolButton; State: TCustomDrawState; var DefaultDraw: Boolean);

var
  ACanvas: TCanvas;

  ARect, HoldRect: TRect;
  B: TBitmap;
  HasBitmap: boolean;
  BitmapWidth: integer;
  TextFormat: integer;
  XButton: TToolButton;
  HasBorder: boolean;
  HasBkg: boolean;
  IsTransparent: boolean;
  FBSelectColor: TColor;

  procedure DrawBorder;
  var
    BRect, WRect: TRect;
    procedure DrawRect;
    begin
      ACanvas.Pen.color := FFSelectBorderColor;
      ACanvas.MoveTo(WRect.Left, WRect.Top);
      ACanvas.LineTo(WRect.Right, WRect.Top);
      ACanvas.LineTo(WRect.Right, WRect.Bottom);
      ACanvas.LineTo(WRect.Left, WRect.Bottom);
      ACanvas.LineTo(WRect.Left, WRect.Top);
    end;

  begin
    BRect := HoldRect;
    Dec(BRect.Bottom, 1);
    Inc(BRect.Top, 1);
    Dec(BRect.Right, 1);

    WRect := BRect;
    if Button.Style = tbsDropDown then
    begin
      Dec(WRect.Right, 13);
      DrawRect;

      WRect := BRect;
      Inc(WRect.Left, WRect.Right - WRect.Left - 13);
      DrawRect;
    end
    else
    begin

      DrawRect;
    end;
  end;

begin

  B := nil;

  HasBitmap := (Sender.Images <> nil) and
    (Button.ImageIndex <> -1) and
    (Button.ImageIndex <= Sender.Images.Count - 1);


  IsTransparent := Sender.Transparent;

  ACanvas := Sender.Canvas;

  SetGlobalColor(ACanvas);

  if (Is16Bit) and (not UseSystemColors) then
    FBSelectColor := NewColor(ACanvas, FSelectColor, 68)
  else
    FBSelectColor := FFSelectColor;


  HoldRect := Button.BoundsRect;

  ARect := HoldRect;

  if Is16Bit then
    ACanvas.brush.color := NewColor(ACanvas, Sender.Color, 16)
  else
    ACanvas.brush.color := Sender.Color;

  if not IsTransparent then
    ACanvas.FillRect(ARect);

  HasBorder := false;
  HasBkg := false;

  if (cdsHot in State) then
  begin
    if (cdsChecked in State) or (Button.Down) or (cdsSelected in State) then
      ACanvas.Brush.Color := FCheckedAreaSelectColor
    else
      ACanvas.brush.color := FBSelectColor;
    HasBorder := true;
    HasBkg := true;
  end;

  if ((cdsChecked in State) and not (cdsHot in State)) then
  begin
    ACanvas.Brush.Color := FCheckedAreaColor;
    HasBorder := true;
    HasBkg := true;
  end;

  if (cdsIndeterminate in State) and not (cdsHot in State) then
  begin
    ACanvas.Brush.Color := FBSelectColor;
    HasBkg := true;
  end;


  if (Button.MenuItem <> nil) and (State = []) then
  begin
    ACanvas.brush.color := Sender.Color;
    if not IsTransparent then
      HasBkg := true;
  end;


  Inc(ARect.Top, 1);



  if HasBkg then
    ACanvas.FillRect(ARect);

  if HasBorder then
    DrawBorder;


  if ((Button.MenuItem <> nil) or (Button.DropdownMenu <> nil))
    and (cdsSelected in State) then
  begin
    DrawTopMenuItem(Button, ACanvas, ARect, Sender.Color ,false);
    DefaultDraw := false;
  end;

  ARect := HoldRect;
  DefaultDraw := false;



  if Button.Style = tbsDropDown then
  begin
    ACanvas.Pen.Color := clBlack;
    DrawArrow(ACanvas, (ARect.Right - 14) + ((14 - 5) div 2),
      ARect.Top + ((ARect.Bottom - ARect.Top - 3) div 2) + 1);
  end;

  BitmapWidth := 0;
  if HasBitmap then
  begin

    try
      B := TBitmap.Create;

      B.Width := Sender.Images.Width;
      B.Height := Sender.Images.Height;
      B.Canvas.Brush.Color := ACanvas.Brush.Color;
      B.Canvas.FillRect(Rect(0, 0, B.Width, B.Height));
      ImageList_DrawEx(TToolBar(Button.Parent).Images.Handle, Button.ImageIndex,
        B.Canvas.Handle, 0, 0, 0, 0, clNone, clNone, ILD_Transparent);



      BitmapWidth := b.Width;

      if Button.Style = tbsDropDown then
        Dec(ARect.Right, 12);


      if TToolBar(Button.Parent).List then
      begin

        if Button.BiDiMode = bdRightToLeft then
        begin
          Dec(ARect.Right, 3);
          ARect.Left := ARect.Right - BitmapWidth;

        end
        else
        begin
          Inc(ARect.Left, 3);
          ARect.Right := ARect.Left + BitmapWidth
        end


      end
      else
        ARect.Left := Round(ARect.Left + (ARect.Right - ARect.Left - B.Width)/2);

      inc(ARect.Top, 2);
      ARect.Bottom := ARect.Top + B.Height + 6;

      DrawIcon(Button, ACanvas, B, ARect, (cdsHot in State),
       (cdsSelected in State), Button.Enabled, (cdsChecked in State), false,
       false);
    finally
      B.Free;
    end;
    ARect := HoldRect;
    DefaultDraw := false;
  end;
//-----------

  if Sender.ShowCaptions then
  begin

    if Button.Style = tbsDropDown then
      Dec(ARect.Right, 12);


    if not TToolBar(Button.Parent).List then
    begin
      TextFormat := DT_Center;
      ARect.Top := ARect.Bottom - ACanvas.TextHeight(Button.Caption) - 3;
    end
    else
    begin
      TextFormat := DT_VCENTER;
      if Button.BiDiMode = bdRightToLeft then
      begin
        TextFormat := TextFormat + DT_Right;
        Dec(ARect.Right, BitmapWidth + 7);
      end
      else
      begin
        Inc(ARect.Left, BitmapWidth + 6);
      end

    end;

    if (Button.MenuItem <> nil) then
    begin
      TextFormat := DT_Center;

    end;

    if Button.BiDiMode = bdRightToLeft then
      TextFormat := TextFormat + DT_RTLREADING;

    DrawTheText(Button, Button.Caption, '',
      ACanvas, ARect,
      (cdsSelected in State), Button.Enabled, false,
      (Button.MenuItem <> nil),
      (Button.BidiMode = bdRightToLeft), FFont, TextFormat);

    ARect := HoldRect;
    DefaultDraw := false;
  end;


  if Button.Index > 0 then
  begin
    XButton := {TToolBar(Button.Parent)}Sender.Buttons[Button.Index - 1];
    if (XButton.Style = tbsDivider) or (XButton.Style = tbsSeparator) then
    begin
      ARect := XButton.BoundsRect;
      if Is16Bit then
        ACanvas.brush.color := NewColor(ACanvas, Sender.Color, 16)
      else
        ACanvas.brush.color := Sender.Color;

      if not IsTransparent then
        ACanvas.FillRect(ARect);
     // if (XButton.Style = tbsDivider) then  // Can't get it.
      if XButton.Tag > 0 then
      begin
        Inc(ARect.Top, 2);
        Dec(ARect.Bottom, 1);

        ACanvas.Pen.color := GetShadeColor(ACanvas,Sender.Color,30);
        ARect.Left := ARect.Left + (ARect.Right - ARect.Left) div 2;
        ACanvas.MoveTo(ARect.Left, ARect.Top);
        ACanvas.LineTo(ARect.Left, ARect.Bottom);

      end;
      ARect := Button.BoundsRect;
      DefaultDraw := false;
    end;

  end;

  if Button.MenuItem <> nil then
    if (xcMainMenu in XPControls) then
      ActivateMenuItem(Button.MenuItem);
end;
{$ENDIF}

// Controlbar Paint. Added by Michiel van Oudheusden (27 sep 2001)
// Paints the bands of a controlbar like the office XP style
procedure TXPMenu.ControlBarPaint(Sender: TObject; Control: TControl;
  Canvas: TCanvas; var ARect: TRect; var Options: TBandPaintOptions);
var
  i: Integer;
  intInc: integer;
begin
  SetGlobalColor(Canvas);
  // No frame and grabber drawing. We do it ourselfes
  Options := [];

  // First background

  if Is16Bit then
    Canvas.brush.color := NewColor(Canvas, TControlBar(Sender).Color , 6)
  else
    Canvas.brush.color := TControlBar(Sender).Color;

  Canvas.FillRect(ARect);

  intInc := 30;
  for i := (ARect.Top + 5) to (ARect.Bottom - 5)do
  begin
    Canvas.Pen.Color := GetShadeColor(Canvas, TControlBar(Sender).Color, intInc);
    if i mod 2 = 0 then
    begin
      Canvas.MoveTo(ARect.Left + 3, i);
      Canvas.LineTo(ARect.Left + 6, i);
      Inc(intInc, 7);
    end;
  end;
  {The code was refacrtored by k. Shagrouni.}
end;

procedure TXPMenu.SetGlobalColor(ACanvas: TCanvas);
begin
//-----

  if GetDeviceCaps(ACanvas.Handle, BITSPIXEL) < 16 then
    Is16Bit := false
  else
    Is16Bit := true;


  FFColor := FColor;
  FFIconBackColor := FIconBackColor;

  if Is16Bit then
  begin
    FFSelectColor := NewColor(ACanvas, FSelectColor, 68);
    FCheckedAreaColor := NewColor(ACanvas, FSelectColor, 80);
    FCheckedAreaSelectColor := NewColor(ACanvas, FSelectColor, 50);

    FMenuBorderColor := GetShadeColor(ACanvas, clBtnFace, 90);
    FMenuShadowColor := GetShadeColor(ACanvas, clBtnFace, 76);
  end
  else
  begin
    FFSelectColor := FSelectColor;
    FCheckedAreaColor := clWhite;
    FCheckedAreaSelectColor := clSilver;
    FMenuBorderColor := clBtnShadow;
    FMenuShadowColor := clBtnShadow;
  end;

  FFSelectBorderColor := FSelectBorderColor;
  FFSelectFontColor := FSelectFontColor;
  FFMenuBarColor := FMenuBarColor;
  FFDisabledColor := FDisabledColor;
  FFCheckedColor := FCheckedColor;
  FFSeparatorColor := FSeparatorColor;



  if FUseSystemColors then
  begin
    GetSystemMenuFont(FFont);
    FFSelectFontColor := FFont.Color;
    if not Is16Bit then
    begin
      FFColor := clWhite;
      FFIconBackColor := clBtnFace;
      FFSelectColor := clWhite;
      FFSelectBorderColor := clHighlight;
      FFMenuBarColor := FFIconBackColor;
      FFDisabledColor := clBtnShadow;
      FFCheckedColor := clHighlight;
      FFSeparatorColor := clBtnShadow;
      FCheckedAreaColor := clWhite;
      FCheckedAreaSelectColor := clWhite;

    end
    else
    begin
      FFColor := NewColor(ACanvas, clBtnFace, 86);
      FFIconBackColor := NewColor(ACanvas, clBtnFace, 16);
      FFSelectColor := NewColor(ACanvas, clHighlight, 68);
      FFSelectBorderColor := clHighlight;
      FFMenuBarColor := clBtnFace;

      FFDisabledColor := NewColor(ACanvas, clBtnShadow, 10);
      FFSeparatorColor := NewColor(ACanvas, clBtnShadow, 25);
      FFCheckedColor := clHighlight;
      FCheckedAreaColor := NewColor(ACanvas, clHighlight, 80);
      FCheckedAreaSelectColor := NewColor(ACanvas, clHighlight, 50);

    end;
  end;

end;

procedure TXPMenu.DrawTopMenuItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; BckColor:Tcolor; IsRightToLeft: boolean);
var
  X1, X2: integer;
  DefColor, HoldColor: TColor;
begin
  X1 := ARect.Left;
  X2 := ARect.Right;


  ACanvas.brush.Style := bsSolid;
  ACanvas.brush.color :=  FFSelectColor;

  ACanvas.FillRect(ARect);
  ACanvas.Pen.Color := FFSelectBorderColor;

  if (not IsRightToLeft) and (Is16Bit) and (Sender is TMenuItem) then
  begin
    ACanvas.MoveTo(X1, ARect.Bottom - 1);
    ACanvas.LineTo(X1, ARect.Top);
    ACanvas.LineTo(X2 - 8, ARect.Top);
    ACanvas.LineTo(X2 - 8, ARect.Bottom);

    DefColor := FFMenuBarColor;


    HoldColor := GetShadeColor(ACanvas, DefColor, 10);
    ACanvas.Brush.Style := bsSolid;
    ACanvas.Brush.Color := HoldColor;
    ACanvas.Pen.Color := HoldColor;

    ACanvas.FillRect(Rect(X2 - 7, ARect.Top, X2, ARect.Bottom));

    HoldColor := GetShadeColor(ACanvas, DefColor, 30);
    ACanvas.Brush.Color := HoldColor;
    ACanvas.Pen.Color := HoldColor;
    ACanvas.FillRect(Rect(X2 - 7, ARect.Top + 3, X2 - 2, ARect.Bottom));

    HoldColor := GetShadeColor(ACanvas, DefColor, 40 + 20);
    ACanvas.Brush.Color := HoldColor;
    ACanvas.Pen.Color := HoldColor;
    ACanvas.FillRect(Rect(X2 - 7, ARect.Top + 5, X2 - 3, ARect.Bottom));

    HoldColor := GetShadeColor(ACanvas, DefColor, 60 + 40);
    ACanvas.Brush.Color := HoldColor;
    ACanvas.Pen.Color := HoldColor;
    ACanvas.FillRect(Rect(X2 - 7, ARect.Top + 6, X2 - 5, ARect.Bottom));

    //---

    ACanvas.Pen.Color := DefColor;
    ACanvas.MoveTo(X2 - 5, ARect.Top + 1);
    ACanvas.LineTo(X2 - 1, ARect.Top + 1);
    ACanvas.LineTo(X2 - 1, ARect.Top + 6);

    ACanvas.MoveTo(X2 - 3, ARect.Top + 2);
    ACanvas.LineTo(X2 - 2, ARect.Top + 2);
    ACanvas.LineTo(X2 - 2, ARect.Top + 3);
    ACanvas.LineTo(X2 - 3, ARect.Top + 3);



    ACanvas.Pen.Color := GetShadeColor(ACanvas, DefColor, 10);
    ACanvas.MoveTo(X2 - 6, ARect.Top + 3);
    ACanvas.LineTo(X2 - 3, ARect.Top + 3);
    ACanvas.LineTo(X2 - 3, ARect.Top + 6);
    ACanvas.LineTo(X2 - 4, ARect.Top + 6);
    ACanvas.LineTo(X2 - 4, ARect.Top + 3);

    ACanvas.Pen.Color := GetShadeColor(ACanvas, DefColor, 30);
    ACanvas.MoveTo(X2 - 5, ARect.Top + 5);
    ACanvas.LineTo(X2 - 4, ARect.Top + 5);
    ACanvas.LineTo(X2 - 4, ARect.Top + 9);

    ACanvas.Pen.Color := GetShadeColor(ACanvas, DefColor, 40);
    ACanvas.MoveTo(X2 - 6, ARect.Top + 5);
    ACanvas.LineTo(X2 - 6, ARect.Top + 7);

  end
  else
  begin
    ACanvas.Pen.Color := FFSelectBorderColor;
    ACanvas.Brush.Color := GetShadeColor(ACanvas, BckColor, 70);

    ACanvas.MoveTo(X1, ARect.Bottom - 1);
    ACanvas.LineTo(X1, ARect.Top);
    ACanvas.LineTo(X2 - 3, ARect.Top);
    ACanvas.LineTo(X2 - 3, ARect.Bottom);


    ACanvas.Pen.Color := ACanvas.Brush.Color;
    ACanvas.FillRect(Rect(X2 - 2, ARect.Top + 2, X2, ARect.Bottom));

    ACanvas.Brush.Color := BckColor;
    ACanvas.FillRect(Rect(X2 - 2, ARect.Top , X2, ARect.Top + 2));


  end;

end;


procedure TXPMenu.DrawCheckedItem(FMenuItem: TMenuItem; Selected,
 HasImgLstBitmap: boolean; ACanvas: TCanvas; CheckedRect: TRect);
var
  X1, X2: integer;
begin
  if FMenuItem.RadioItem then
  begin
    if FMenuItem.Checked then
    begin

      ACanvas.Pen.color := FFSelectBorderColor;
      if selected then
        ACanvas.Brush.Color := FCheckedAreaSelectColor
      else
        ACanvas.Brush.Color := FCheckedAreaColor;
      ACanvas.Brush.Style := bsSolid;
      if HasImgLstBitmap then
      begin
        ACanvas.RoundRect(CheckedRect.Left, CheckedRect.Top,
          CheckedRect.Right, CheckedRect.Bottom,
          6, 6);
      end
      else
      begin
        ACanvas.Ellipse(CheckedRect.Left, CheckedRect.Top,
          CheckedRect.Right, CheckedRect.Bottom);
      end;
    end;
  end
  else
  begin
    if (FMenuItem.Checked) then
      if (not HasImgLstBitmap) then
      begin
        ACanvas.Pen.color := FFCheckedColor;
        if selected then
          ACanvas.Brush.Color := FCheckedAreaSelectColor
        else
          ACanvas.Brush.Color := FCheckedAreaColor; ;
        ACanvas.Brush.Style := bsSolid;
        ACanvas.Rectangle(CheckedRect.Left, CheckedRect.Top,
          CheckedRect.Right, CheckedRect.Bottom);
        ACanvas.Pen.color := clBlack;
        x1 := CheckedRect.Left + 1;
        x2 := CheckedRect.Top + 5;
        ACanvas.MoveTo(x1, x2);

        x1 := CheckedRect.Left + 4;
        x2 := CheckedRect.Bottom - 2;
        ACanvas.LineTo(x1, x2);
        //--
        x1 := CheckedRect.Left + 2;
        x2 := CheckedRect.Top + 5;
        ACanvas.MoveTo(x1, x2);

        x1 := CheckedRect.Left + 4;
        x2 := CheckedRect.Bottom - 3;
        ACanvas.LineTo(x1, x2);
        //--
        x1 := CheckedRect.Left + 2;
        x2 := CheckedRect.Top + 4;
        ACanvas.MoveTo(x1, x2);

        x1 := CheckedRect.Left + 5;
        x2 := CheckedRect.Bottom - 3;
        ACanvas.LineTo(x1, x2);
        //-----------------

        x1 := CheckedRect.Left + 4;
        x2 := CheckedRect.Bottom - 3;
        ACanvas.MoveTo(x1, x2);

        x1 := CheckedRect.Right + 2;
        x2 := CheckedRect.Top - 1;
        ACanvas.LineTo(x1, x2);
        //--
        x1 := CheckedRect.Left + 4;
        x2 := CheckedRect.Bottom - 2;
        ACanvas.MoveTo(x1, x2);

        x1 := CheckedRect.Right - 2;
        x2 := CheckedRect.Top + 3;
        ACanvas.LineTo(x1, x2);

      end
      else
      begin
        ACanvas.Pen.color := FFSelectBorderColor;
        if selected then
          ACanvas.Brush.Color := FCheckedAreaSelectColor
        else
          ACanvas.Brush.Color := FCheckedAreaColor;
        ACanvas.Brush.Style := bsSolid;
        ACanvas.Rectangle(CheckedRect.Left, CheckedRect.Top,
          CheckedRect.Right, CheckedRect.Bottom);
      end;
  end;

end;

procedure TXPMenu.DrawTheText(Sender: TObject; txt, ShortCuttext: string;
    ACanvas: TCanvas; TextRect: TRect;
    Selected, Enabled, Default, TopMenu, IsRightToLeft: boolean;
    var TxtFont: TFont; TextFormat: integer);
var
  DefColor: TColor;
  B: TBitmap;
  BRect: TRect;
begin

  DefColor := TxtFont.Color;

  ACanvas.Font := TxtFont;


  if Enabled then
    DefColor := TxtFont.Color;

  if Selected then
    DefColor := FFSelectFontColor;

  If not Enabled then
  begin
    DefColor := FFDisabledColor;
    if (Sender is TToolButton) then
    begin
      B := TBitmap.Create;
      B.Width := TextRect.Right - TextRect.Left;
      B.Height := TextRect.Bottom - TextRect.Top;
      BRect := Rect(0,0,B.Width, B.Height);
      B.Canvas.Brush.Color := ACanvas.Brush.Color;
      B.Canvas.FillRect (BRect);
      B.Canvas.Font.color := DefColor;
      DrawtextEx(B.Canvas.Handle,
        PChar(txt),
        Length(txt),
        BRect, TextFormat, nil);
      ACanvas.CopyRect(TextRect, B.Canvas, BRect);
      B.Free;
      exit;
    end;
  end;

  if (TopMenu and Selected) then
    if FUseSystemColors then
    DefColor := TopMenuFontColor(ACanvas, FFIconBackColor);

  ACanvas.Font.color := DefColor;    // will not affect Buttons


  TextRect.Top := TextRect.Top +
    ((TextRect.Bottom - TextRect.Top) - ACanvas.TextHeight('W')) div 2;

  SetBkMode(ACanvas.Handle, TRANSPARENT);


  if Default and Enabled then
  begin

    Inc(TextRect.Left, 1);
    ACanvas.Font.color := GetShadeColor(ACanvas,
                              ACanvas.Pixels[TextRect.Left, TextRect.Top], 30);
    DrawtextEx(ACanvas.Handle,
      PChar(txt),
      Length(txt),
      TextRect, TextFormat, nil);
    Dec(TextRect.Left, 1);


    Inc(TextRect.Top, 2);
    Inc(TextRect.Left, 1);
    Inc(TextRect.Right, 1);


    ACanvas.Font.color := GetShadeColor(ACanvas,
                              ACanvas.Pixels[TextRect.Left, TextRect.Top], 30);
    DrawtextEx(ACanvas.Handle,
      PChar(txt),
      Length(txt),
      TextRect, TextFormat, nil);


    Dec(TextRect.Top, 1);
    Dec(TextRect.Left, 1);
    Dec(TextRect.Right, 1);

    ACanvas.Font.color := GetShadeColor(ACanvas,
                              ACanvas.Pixels[TextRect.Left, TextRect.Top], 40);
    DrawtextEx(ACanvas.Handle,
      PChar(txt),
      Length(txt),
      TextRect, TextFormat, nil);


    Inc(TextRect.Left, 1);
    Inc(TextRect.Right, 1);

    ACanvas.Font.color := GetShadeColor(ACanvas,
                              ACanvas.Pixels[TextRect.Left, TextRect.Top], 60);
    DrawtextEx(ACanvas.Handle,
      PChar(txt),
      Length(txt),
      TextRect, TextFormat, nil);

    Dec(TextRect.Left, 1);
    Dec(TextRect.Right, 1);
    Dec(TextRect.Top, 1);

    ACanvas.Font.color := DefColor;
  end;

  DrawtextEx(ACanvas.Handle,
      PChar(txt),
      Length(txt),
      TextRect, TextFormat, nil);


  txt := ShortCutText + ' ';

  if not Is16Bit then
    ACanvas.Font.color := DefColor
  else
    ACanvas.Font.color := GetShadeColor(ACanvas, DefColor, -40);



  if IsRightToLeft then
  begin
    Inc(TextRect.Left, 10);
    TextFormat := DT_LEFT
  end
  else
  begin
    Dec(TextRect.Right, 10);
    TextFormat := DT_RIGHT;
  end;


  DrawtextEx(ACanvas.Handle,
    PChar(txt),
    Length(txt),
    TextRect, TextFormat, nil);

end;

procedure TXPMenu.DrawIcon(Sender: TObject; ACanvas: TCanvas; B: TBitmap;
 IconRect: Trect; Hot, Selected, Enabled, Checked, FTopMenu,
 IsRightToLeft: boolean);
var
  DefColor: TColor;
  X1, X2: integer;
begin

  if B <> nil then
  begin
    X1 := IconRect.Left;
    X2 := IconRect.Top + 2;
    if Sender is TMenuItem then
    begin
      inc(X2, 2);
      if FIconWidth >= B.Width then
        X1 := X1 + ((FIconWidth - B.Width) div 2) - 1
      else
      begin
        if IsRightToLeft then
          X1 := IconRect.Right - b.Width - 2
        else
          X1 := IconRect.Left + 2;
      end;
    end;


    if (Hot) and (not FTopMenu) and (Enabled) and (not Checked) then
      if not Selected then
      begin
        dec(X1, 1);
        dec(X2, 1);
      end;

    if (not Hot) and (Enabled) and (not Checked) then
      if Is16Bit then
        DimBitmap(B, FDimLevel{30});


    if not Enabled then
    begin
      GrayBitmap(B, FGrayLevel {30});
      DimBitmap(B, 40);




    end;

    if (Hot) and (Enabled) and (not Checked) then
    begin
      if (Is16Bit) and (not UseSystemColors) and (Sender is TToolButton) then
        DefColor := NewColor(ACanvas, FSelectColor, 68)
      else
        DefColor := FFSelectColor;

      DefColor := GetShadeColor(ACanvas, DefColor, 50);
      DrawBitmapShadow(B, ACanvas, X1 + 2, X2 + 2, DefColor);
    end;

    B.Transparent := true;

    ACanvas.Draw(X1, X2, B);


  end;

end;

procedure TXPMenu.DrawArrow(ACanvas: TCanvas; X, Y: integer);
begin
  ACanvas.MoveTo(X, Y);
  ACanvas.LineTo(X + 4, Y);

  ACanvas.MoveTo(X + 1, Y + 1);
  ACanvas.LineTo(X + 4, Y);

  ACanvas.MoveTo(X + 2, Y + 2);
  ACanvas.LineTo(X + 3, Y);

end;

function TXPMenu.TopMenuFontColor(ACanvas: TCanvas; Color: TColor): TColor;
var
  r, g, b, avg: integer;
begin

  Color := ColorToRGB(Color);
  r := Color and $000000FF;
  g := (Color and $0000FF00) shr 8;
  b := (Color and $00FF0000) shr 16;

  Avg := (r + b) div 2;

  if (Avg > 150) or (g > 200) then
    Result := FFont.Color
  else
    Result := NewColor(ACanvas, Color, 90);

end;


procedure TXPMenu.SetActive(const Value: boolean);
begin
  if Value = FActive then exit;

  FActive := Value;
  if FActive then
    InitMenueItems(FForm, true, true)
  else
    InitMenueItems(FForm, false, true);

  if (FForm <> nil) and (TForm(FForm).Menu <> nil) then
    Windows.DrawMenuBar(FForm.Handle);
end;

procedure TXPMenu.SetAutoDetect(const Value: boolean);
begin
  FAutoDetect := Value;
end;

procedure TXPMenu.SetForm(const Value: TScrollingWinControl);
var
  Hold: boolean;
begin
  if Value <> FForm then
  begin
    Hold := Active;
    Active := false;
    FForm := Value;
    if Hold then
      Active := True;
  end;
end;

procedure TXPMenu.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  Windows.DrawMenuBar(FForm.Handle);

end;

procedure TXPMenu.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure TXPMenu.SetIconBackColor(const Value: TColor);
begin
  FIconBackColor := Value;
end;

procedure TXPMenu.SetMenuBarColor(const Value: TColor);
begin
  FMenuBarColor := Value;
  Windows.DrawMenuBar(FForm.Handle);
end;

procedure TXPMenu.SetCheckedColor(const Value: TColor);
begin
  FCheckedColor := Value;
end;

procedure TXPMenu.SetSeparatorColor(const Value: TColor);
begin
  FSeparatorColor := Value;
end;

procedure TXPMenu.SetSelectBorderColor(const Value: TColor);
begin
  FSelectBorderColor := Value;
end;

procedure TXPMenu.SetSelectColor(const Value: TColor);
begin
  FSelectColor := Value;
end;

procedure TXPMenu.SetDisabledColor(const Value: TColor);
begin
  FDisabledColor := Value;
end;

procedure TXPMenu.SetSelectFontColor(const Value: TColor);
begin
  FSelectFontColor := Value;
end;

procedure TXPMenu.SetIconWidth(const Value: integer);
begin
  FIconWidth := Value;
end;

procedure TXPMenu.SetDrawSelect(const Value: boolean);
begin
  FDrawSelect := Value;
end;



procedure TXPMenu.SetOverrideOwnerDraw(const Value: boolean);
begin
  FOverrideOwnerDraw := Value;
  if FActive then
    Active := True;
end;


procedure TXPMenu.SetUseSystemColors(const Value: boolean);
begin
  FUseSystemColors := Value;
  Windows.DrawMenuBar(FForm.Handle);
end;

procedure TXPMenu.SetGradient(const Value: boolean);
begin
  FGradient := Value;
end;

procedure TXPMenu.SetFlatMenu(const Value: boolean);
begin
  FFlatMenu := Value;
end;

procedure TXPMenu.SetXPContainers(const Value: TXPContainers);
begin
  if Value <> FXPContainers then
  begin
    if FActive then
    begin
      FActive := false;
      InitMenueItems(FForm, false, true);
      FActive := true;
      FXPContainers := Value;
      InitMenueItems(FForm, true, true);
    end;
  end;
  FXPContainers := Value;

end;

procedure TXPMenu.SetXPControls(const Value: TXPControls);
begin
  if Value <> FXPControls then
  begin
    if FActive then
    begin
      FActive := false;
      InitMenueItems(FForm, false, true);
      FActive := true;
      FXPControls := Value;
      InitMenueItems(FForm, true, true);
    end;
  end;
  FXPControls := Value;

end;


procedure GetSystemMenuFont(Font: TFont);
var
  FNonCLientMetrics: TNonCLientMetrics;
begin
  FNonCLientMetrics.cbSize := Sizeof(TNonCLientMetrics);
  if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @FNonCLientMetrics,0) then
  begin
    Font.Handle := CreateFontIndirect(FNonCLientMetrics.lfMenuFont);
    Font.Color := clMenuText;
    if Font.Name = 'MS Sans Serif' then
      Font.Name := 'Tahoma';
  end;
end;


procedure TXPMenu.DrawGradient(ACanvas: TCanvas; ARect: TRect;
 IsRightToLeft: boolean);
var
  i: integer;
  v: integer;
  FRect: TRect;
begin

  fRect := ARect;
  V := 0;
  if IsRightToLeft then
  begin
    fRect.Left := fRect.Right - 1;
    for i := ARect.Right Downto ARect.Left do
    begin
      if (fRect.Left < ARect.Right)
        and (fRect.Left > ARect.Right - FIconWidth + 5) then
        inc(v, 3)
      else
        inc(v, 1);

      if v > 96 then v := 96;
      ACanvas.Brush.Color := NewColor(ACanvas, FFIconBackColor, v);
      ACanvas.FillRect(fRect);

      fRect.Left := fRect.Left - 1;
      fRect.Right := fRect.Left - 1;
    end;
  end
  else
  begin
    fRect.Right := fRect.Left + 1;
    for i := ARect.Left to ARect.Right do
    begin
      if (fRect.Left > ARect.Left)
        and (fRect.Left < ARect.Left + FIconWidth + 5) then
        inc(v, 3)
      else
        inc(v, 1);

      if v > 96 then v := 96;
      ACanvas.Brush.Color := NewColor(ACanvas, FFIconBackColor, v);
      ACanvas.FillRect(fRect);

      fRect.Left := fRect.Left + 1;
      fRect.Right := fRect.Left + 1;
    end;
  end;
end;


procedure TXPMenu.DrawWindowBorder(hWnd: HWND; IsRightToLeft: boolean);
var
  WRect: TRect;
  dCanvas: TCanvas;
begin

  if hWnd <= 0 then
  begin
   exit;
  end;
  dCanvas := nil;
  try
    dCanvas := TCanvas.Create;
    dCanvas.Handle := GetWindowDC(GetDesktopWindow);

    GetWindowRect(hWnd, WRect);

    dCanvas.Brush.Style := bsClear;


    Dec(WRect.Right, 2);
    Dec(WRect.Bottom, 2);

    dCanvas.Pen.Color := FMenuBorderColor;
    dCanvas.Rectangle(WRect.Left, WRect.Top, WRect.Right, WRect.Bottom);

    if IsRightToLeft then
    begin
      dCanvas.Pen.Color := FFColor;
      dCanvas.Rectangle(WRect.Left + 1, WRect.Top + 1, WRect.Right - 2,
                        WRect.Top + 3);

      dCanvas.MoveTo(WRect.Left + 2, WRect.Top + 2);
      dCanvas.LineTo(WRect.Left + 2, WRect.Bottom - 2);


      dCanvas.Pen.Color := FFIconBackColor;
      dCanvas.MoveTo(WRect.Right - 2, WRect.Top + 2);
      dCanvas.LineTo(WRect.Right - 2, WRect.Bottom - 2);

      dCanvas.MoveTo(WRect.Right - 2, WRect.Top + 2);
      dCanvas.LineTo(WRect.Right - 1 - FIconWidth, WRect.Top + 2);
    end
    else
    begin
      if not FGradient then
      begin
        dCanvas.Pen.Color := FFColor;
        dCanvas.Rectangle(WRect.Left + 1, WRect.Top + 1, WRect.Right - 1,
                          WRect.Top + 3);

        dCanvas.Pen.Color := FFIconBackColor;
        dCanvas.MoveTo(WRect.Left + 1, WRect.Top + 2);
        dCanvas.LineTo(WRect.Left + 3 + FIconWidth, WRect.Top + 2);
      end
      else
        DrawGradient(dCanvas, Rect(WRect.Left + 1, WRect.Top + 1,
                                   WRect.Right - 3, WRect.Top + 3), IsRightToLeft);

      dCanvas.Pen.Color := FFIconBackColor;
      dCanvas.Rectangle(WRect.Left + 1, WRect.Top + 2,
                        WRect.Left + 3, WRect.Bottom - 1)

    end;

    Inc(WRect.Right, 2);
    Inc(WRect.Bottom, 2);

    dCanvas.Pen.Color := FMenuShadowColor;
    dCanvas.Rectangle(WRect.Left + 2, WRect.Bottom, WRect.Right, WRect.Bottom - 2);
    dCanvas.Rectangle(WRect.Right - 2, WRect.Bottom, WRect.Right, WRect.Top + 2);


    dCanvas.Pen.Color := clBtnFace ;
    dCanvas.Rectangle(WRect.Left, WRect.Bottom - 2, WRect.Left + 2, WRect.Bottom);
    dCanvas.Rectangle(WRect.Right - 2, WRect.Top, WRect.Right, WRect.Top + 2);
  finally
    ReleaseDC(GetDesktopWindow, dCanvas.Handle);
    dCanvas.Free;
  end;


end;


procedure TXPMenu.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if not FActive then exit;
  if not FAutoDetect then exit;
  if (Operation = opInsert) and
     ((AComponent is TMenuItem) or (AComponent is TToolButton) or
      (AComponent is TControlBar)) then
  begin
    if not (csDesigning in ComponentState) then
      Active := true;
     //else
     //if ComponentState = [] then
     //   Active := true ;
  end;
end;


function GetShadeColor(ACanvas: TCanvas; clr: TColor; Value: integer): TColor;
var
  r, g, b: integer;

begin
  clr := ColorToRGB(clr);
  r := Clr and $000000FF;
  g := (Clr and $0000FF00) shr 8;
  b := (Clr and $00FF0000) shr 16;

  r := (r - value);
  if r < 0 then r := 0;
  if r > 255 then r := 255;

  g := (g - value) + 2;
  if g < 0 then g := 0;
  if g > 255 then g := 255;

  b := (b - value);
  if b < 0 then b := 0;
  if b > 255 then b := 255;

  Result := Windows.GetNearestColor(ACanvas.Handle, RGB(r, g, b));
end;

function NewColor(ACanvas: TCanvas; clr: TColor; Value: integer): TColor;
var
  r, g, b: integer;

begin
  if Value > 100 then Value := 100;
  clr := ColorToRGB(clr);
  r := Clr and $000000FF;
  g := (Clr and $0000FF00) shr 8;
  b := (Clr and $00FF0000) shr 16;


  r := r + Round((255 - r) * (value / 100));
  g := g + Round((255 - g) * (value / 100));
  b := b + Round((255 - b) * (value / 100));

  Result := Windows.GetNearestColor(ACanvas.Handle, RGB(r, g, b));

end;

function GrayColor(ACanvas: TCanvas; Clr: TColor; Value: integer): TColor;
var
  r, g, b, avg: integer;

begin
  Result := clr;
  clr := ColorToRGB(clr);
  r := Clr and $000000FF;
  g := (Clr and $0000FF00) shr 8;
  b := (Clr and $00FF0000) shr 16;

  Avg := (r + g + b) div 3;
  Avg := Avg + Value;

  if Avg > 240 then Avg := 240;
  if ACanvas <> nil then
    Result := Windows.GetNearestColor (ACanvas.Handle,RGB(Avg, avg, avg));
end;


procedure GrayBitmap(ABitmap: TBitmap; Value: integer);
var
  x, y: integer;
  LastColor1, LastColor2, Color: TColor;
begin
  LastColor1 := 0;
  LastColor2 := 0;

  for y := 0 to ABitmap.Height do
    for x := 0 to ABitmap.Width do
    begin
      Color := ABitmap.Canvas.Pixels[x, y];
      if Color = LastColor1 then
        ABitmap.Canvas.Pixels[x, y] := LastColor2
      else
      begin
        LastColor2 := GrayColor(ABitmap.Canvas , Color, Value);
        ABitmap.Canvas.Pixels[x, y] := LastColor2;
        LastColor1 := Color;
      end;
    end;
end;

procedure DimBitmap(ABitmap: TBitmap; Value: integer);
var
  x, y: integer;
  LastColor1, LastColor2, Color: TColor;
begin
  if Value > 100 then Value := 100;
  LastColor1 := -1;
  LastColor2 := -1;

  for y := 0 to ABitmap.Height - 1 do
    for x := 0 to ABitmap.Width - 1 do
    begin
      Color := ABitmap.Canvas.Pixels[x, y];
      if Color = LastColor1 then
        ABitmap.Canvas.Pixels[x, y] := LastColor2
      else
      begin
        LastColor2 := NewColor(ABitmap.Canvas, Color, Value);
        ABitmap.Canvas.Pixels[x, y] := LastColor2;
        LastColor1 := Color;
      end;
    end;
end;

procedure DrawBitmapShadow(B: TBitmap; ACanvas: TCanvas; X, Y: integer;
  ShadowColor: TColor);
var
  BX, BY: integer;
  B2: TBitmap;
  BWidth, BHeight: integer;
  TransparentColor: TColor;
begin
  B2 := nil;
  try
    B2 := TBitmap.Create;

    BWidth := B.Width;
    BHeight := B.Height;

    B2.Width := BWidth;
    B2.Height := BHeight;

    TransparentColor := B.Canvas.Pixels[0, B.Height - 1];

    B2.Transparent := true;

    BY := 0;
    while BY < (BHeight) do
    begin
      BX := 0;
      while BX < (BWidth) do
      begin
        if B.Canvas.Pixels[BX, BY] <> TransparentColor then
          B2.Canvas.Pixels[0 + BX, 0 + BY] := ShadowColor;

        Inc(BX);
      end;
      Inc(BY);
    end;

    ACanvas.Draw(X, Y, B2);
  finally
    B2.Free;
  end;

end;



{ TCustomComboSubClass }
//By Heath Provost (Nov 20, 2001)
// ComboBox Subclass WndProc.
// Message processing to allow control to repond to
// messages needed to paint using Office XP style.
procedure TControlSubClass.ControlSubClass(var Message: TMessage);
begin
  //Call original WindowProc FIRST. We are trying to emulate inheritance, so
  //original WindowProc must handle all messages before we do.

  orgWindowProc(Message);

  if (not XPMenu.FActive) then
  begin
    try
      Control.WindowProc := orgWindowProc;
      if Control is TCustomEdit then
        TEdit(Control).BorderStyle := BorderStyle;

      Free;
      exit;
    except
    end;
  end;
  case Message.Msg of
    WM_DESTROY:
      begin
       if not FBuilding then
         Free;
       Exit;
      end;
    WM_PAINT:
      begin
        PaintControlXP;
      end;

    CM_MOUSEENTER:
      begin
        FmouseInControl := true;
        PaintControlXP;
      end;
    CM_MOUSELEAVE:
      begin
        FmouseInControl := false;
        PaintControlXP;
      end;

    WM_LBUTTONDOWN:
      begin
       FLButtonBressed := true;
       PaintControlXP;
      end;

    WM_LBUTTONUP:
      begin
       FLButtonBressed := false;
       PaintControlXP;
      end;


    WM_KEYDOWN:
      if Message.WParam = VK_SPACE then
      begin
       FBressed := true;
       if not FIsKeyDown then
         PaintControlXP;
       FIsKeyDown := true;
      end;

    WM_KEYUP:
      if Message.WParam = VK_SPACE then
      begin
        FBressed := false;
        FIsKeyDown := false;
        PaintControlXP;
      end;

    WM_SETFOCUS:
      begin
        FmouseInControl := true;
        PaintControlXP;
      end;
    WM_KILLFOCUS:
      begin
        FmouseInControl := false;
        PaintControlXP;
      end;
    CM_EXIT:
      begin
        FmouseInControl := false;
        PaintControlXP;
      end;

    BM_SETCHECK:
      begin
        FmouseInControl := false;
        PaintControlXP;
      end;
    BM_GETCHECK:
      begin
        FmouseInControl := false;
        PaintControlXP;
      end;

  end;

end;

// changes added by Heath Provost (Nov 20, 2001)
{ TCustomComboSubClass }
// paints an overlay over the control to make it mimic
// Office XP style.

procedure TControlSubClass.PaintControlXP;
begin
  {$IFDEF VER6U}
  if (Control is TCustomCombo) then
    PaintCombo;
  {$ELSE}
  if (Control is TCustomComboBox) then
    PaintCombo;
  {$ENDIF}
  if Control is TCustomEdit then
    PaintEdit;
  if Control is TCustomCheckBox then
    PaintCheckBox;
  if Control is TRadioButton then
    PaintRadio;
  if Control is TButton then
    PaintButton;
end;


procedure TControlSubClass.PaintCombo;
var
  C: TControlCanvas;
  R: TRect;
  SelectColor, BorderColor, ArrowColor: TColor;
  X: integer;
begin
  C := nil;
  try
    C := TControlCanvas.Create;
    C.Control := Control;

    XPMenu.SetGlobalColor(C);
    if Control.Enabled then ArrowColor := clBlack else ArrowColor := clWhite;


    if (FmouseinControl) then
    begin
      borderColor := XPMenu.FFSelectBorderColor;
      SelectColor := XPMenu.FFSelectColor;
    end
    else
    begin
      borderColor := TComboBox(Control).Color;
      selectColor := clBtnFace;
    end;
    if (not FmouseinControl) and (Control.Focused) then
    begin
      borderColor := NewColor(C, XPMenu.FFSelectBorderColor,60);
      SelectColor := XPMenu.FCheckedAreaColor;
    end;

    R := Control.ClientRect;

    C.Brush.Color := NewColor(C, clBtnFace, 16);
    C.FrameRect(R);
    InflateRect(R, -1, -1);
    C.FrameRect(R);
    InflateRect(R, 0, -1);


    if ( FmouseinControl or Control.Focused) then
      InflateRect(R, 1, 1);

    C.Brush.Color := TComboBox(Control).Color;;
    C.FrameRect(R);

    Inc(R.Bottom,1);
    C.Brush.Color := BorderColor;
    C.FrameRect(R);

    {$IFDEF VER6U}
    if TCustomCombo(Control).DroppedDown then
    {$ELSE}
    if TCustomComboBox(Control).DroppedDown then
    {$ENDIF}
   begin
      BorderColor := XPMenu.FFSelectBorderColor;
      ArrowColor := clWhite;
      SelectColor := XPMenu.FCheckedAreaSelectColor ;
    end;

    InflateRect(R, -1, -1);

    if Control.BiDiMode = bdRightToLeft then
      R.Right := R.Left + GetSystemMetrics(SM_CXHTHUMB) + 1
    else
      R.Left := R.Right - GetSystemMetrics(SM_CXHTHUMB) - 1;

    if ( FmouseinControl or Control.Focused) then
    begin
      if Control.BiDiMode = bdRightToLeft then
        Inc(R.Right, 2)
      else
        Dec(R.Left, 2);
    end;

    C.Brush.Color := SelectColor;
    C.FillRect(R);

    if Control.BiDiMode = bdRightToLeft then
      R.Left := R.Right - 5
    else
      R.Right := R.Left + 5;

    C.Brush.Color := TComboBox(Control).Color;
    C.FillRect(R);

    C.Pen.Color := BorderColor;

    if Control.BiDiMode = bdRightToLeft then
    begin
      C.Moveto(R.Left, R.Top);
      C.LineTo(R.Left, R.Bottom);
    end
    else
    begin
      C.Moveto(R.Right, R.Top);
      C.LineTo(R.Right, R.Bottom);
    end;
    C.Pen.Color := arrowColor;

    R := Control.ClientRect;

    if Control.BiDiMode = bdRightToLeft then
      X := R.Left + 5
    else
      X := R.Right - 10;

    C.Moveto(X + 0, R.Top + 10);
    C.LineTo(X + 5, R.Top + 10);
    C.Moveto(X + 1, R.Top + 11);
    C.LineTo(X + 4, R.Top + 11);
    C.Moveto(X + 2, R.Top + 12);
    C.LineTo(X + 3, R.Top + 12);

  finally
    C.Free;
  end;


end;

procedure TControlSubClass.PaintEdit;
var
  C: TControlCanvas;
  R: TRect;
  BorderColor: TColor;
begin
  C := nil;
  try
    C := TControlCanvas.Create;
    C.Control := Control;
    XPMenu.SetGlobalColor(C);

    if TEdit(Control).BorderStyle <> bsNone then
    begin
      FBuilding := true;
      TEdit(Control).BorderStyle := bsNone;
    end;

    if (FmouseinControl) or (Control.Focused) then
    begin
      borderColor := NewColor(C, XPMenu.FFSelectBorderColor,60);
    end
    else
    begin
      if BorderStyle = bsSingle then
        borderColor := GetShadeColor(C, clBtnFace, 30)
      else
        borderColor := clWindow;
    end;

    R := Control.ClientRect;

    C.Brush.Color := clBtnFace;
    C.FrameRect(R);
    C.Brush.Color := BorderColor;
    C.FrameRect(R);
  finally
    C.Free;
  end;
end;

procedure TControlSubClass.PaintCheckBox;
var
  C: TControlCanvas;
  R: TRect;
  SelectColor, BorderColor: TColor;
  X1, X2: integer;
begin

  C := nil;
  try
    C := TControlCanvas.Create;
    C.Control := Control;
    XPMenu.SetGlobalColor(C);

    if FMouseInControl then
    begin
      SelectColor := XPMenu.FFSelectColor;
      BorderColor := xpMenu.FFSelectBorderColor;
    end
    else
    begin
      SelectColor := clWindow;
      BorderColor := clBtnShadow;
    end;

    if (Control.Focused) then
    begin
      SelectColor := XPMenu.FFSelectColor;
      BorderColor := xpMenu.FFSelectBorderColor;
    end;
    if (FBressed) or (FLButtonBressed ) then
      SelectColor := XPMenu.FCheckedAreaSelectColor ;


    R := Control.ClientRect;
    InflateRect(R, 0, -3);
    R.Top := R.Top + ((R.Bottom - R.Top - GetSystemMetrics(SM_CXHTHUMB)) div 2);
    R.Bottom := R.Top + GetSystemMetrics(SM_CXHTHUMB);
    if Control.BiDiMode = bdRightToLeft then
      R.Left := R.Right - GetSystemMetrics(SM_CXHTHUMB) + 1
    else
      R.Right := R.Left + GetSystemMetrics(SM_CXHTHUMB) - 1;



    C.Brush.Color := TCheckBox(Control).Color;
    C.FillRect(R);
    InflateRect(R, -2, -2);
    C.Brush.Color := SelectColor;
    C.Pen.Color := BorderColor;
    C.Rectangle(R.Left, R.Top, R.Right, R.Bottom);

    if TCheckBox(Control).Checked then
    begin
      if Control.Enabled then
        if (FBressed) or (FLButtonBressed ) then
          C.Pen.color := clWindow
        else
          C.Pen.color := clHighlight;

      if not Control.Enabled then
        C.Pen.color := xpMenu.FFDisabledColor;


      x1 := R.Left + 2;
      x2 := R.Top + 6;
      C.MoveTo(x1, x2);

      x1 := R.Left + 4;
      x2 := R.Bottom - 3;
      C.LineTo(x1, x2);
         //--
      x1 := R.Left + 3;
      x2 := R.Top + 6;
      C.MoveTo(x1, x2);

      x1 := R.Left + 4;
      x2 := R.Bottom - 4;
      C.LineTo(x1, x2);
      //-----------------

      x1 := R.Left + 4;
      x2 := R.Bottom - 3;
      C.MoveTo(x1, x2);

      x1 := R.Right - 1;
      x2 := R.Top + 1;
      C.LineTo(x1, x2);
      //--
      x1 := R.Left + 4;
      x2 := R.Bottom - 2;
      C.MoveTo(x1, x2);

      x1 := R.Right - 2;
      x2 := R.Top + 2;
      C.LineTo(x1, x2);

    end;
  finally
    C.Free;
  end;


end;

procedure TControlSubClass.PaintRadio;
var
  C: TControlCanvas;
  R: TRect;
  SelectColor, BorderColor: TColor;
begin
  C := nil;
  try
    C := TControlCanvas.Create;
    C.Control := Control;
    XPMenu.SetGlobalColor(C);

    if FMouseInControl then
    begin
      SelectColor := XPMenu.FFSelectColor;
      BorderColor := xpMenu.FFSelectBorderColor;;
    end
    else
    begin
      SelectColor := clWindow;
      BorderColor := clBtnShadow;
    end;
    if  (Control.Focused) then
      SelectColor := XPMenu.FFSelectColor;

    R := Control.ClientRect;
    InflateRect(R, 0, -4);

    R.Top := R.Top + ((R.Bottom - R.Top - GetSystemMetrics(SM_CXHTHUMB)) div 2);
    R.Bottom := R.Top + GetSystemMetrics(SM_CXHTHUMB)-1;
    if Control.BiDiMode = bdRightToLeft then
      R.Left := R.Right - 14
    else
      R.Right := R.Left + 14;

    C.Brush.Color := TCheckBox(Control).Color;
    C.FillRect(R);


    InflateRect(R, -2, -2);
    C.Brush.Color := SelectColor;
    C.Pen.Color := BorderColor;


    C.Ellipse(R.Left, R.Top, R.Right, R.Bottom);
    if TRadioButton(Control).Checked then
    begin
      InflateRect(R, -2, -2);

      if Control.Enabled then
        C.Brush.Color := clHighlight
      else
        C.Brush.color := xpMenu.FFDisabledColor;

      C.Pen.Color := C.Brush.Color;
      C.Ellipse(R.Left, R.Top, R.Right, R.Bottom);
    end;
  finally
    C.Free;
  end;


end;

procedure TControlSubClass.PaintButton;
var
  C: TControlCanvas;
  R: TRect;
  SelectColor, BorderColor: TColor;
  Txt: string;
  TextRect, IconRect: TRect;
  TxtFont: TFont;
  B: TBitmap;
  CWidth, CHeight, BWidth, BHeight, TWidth, THeight, Space: integer;
  TextFormat: integer;

begin
  C := nil;
  try
    C := TControlCanvas.Create;
    C.Control := Control;
    XPMenu.SetGlobalColor(C);
    if FMouseInControl or FBressed then
    begin
      SelectColor := NewColor(C, clBtnFace, 60);
      BorderColor := NewColor(C, XPMenu.FFSelectBorderColor,60);
    end
    else
    begin
      SelectColor := XPMenu.FFIconBackColor;
      BorderColor := clBtnShadow;
    end;
    if (not FmouseinControl) and (Control.Focused) then
    begin
      BorderColor := NewColor(C, XPMenu.FFSelectBorderColor,60);
    end;

    TextFormat := 0;
    R := Control.ClientRect;

    CWidth := (R.Right - R.Left);
    CHeight := (R.Bottom - R.Top);

    C.Brush.Color := clBtnFace;
    C.FillRect(R);
    C.Brush.Color := SelectColor;


    C.Pen.Color := NewColor(C, BorderColor, 30);
    c.RoundRect(R.Left, R.Top, R.Right, R.Bottom, 6, 6);
    if (Control as TButton).Enabled then
    if (FLButtonBressed and FmouseinControl) or (FBressed) then
    begin
      C.Pen.Color :=  GetShadeColor(C, BorderColor, 50);
      C.MoveTo(R.Left , R.Bottom - 2);
      C.LineTo(R.Left , R.Top + 2);
      C.LineTo(R.Left + 2, R.Top );
      C.LineTo(R.Right - 2 , R.Top );
    end
    else
    begin
      C.Pen.Color :=  GetShadeColor(C, BorderColor, 50);
      C.MoveTo(R.Right - 1, R.Top + 2);
      C.LineTo(R.Right - 1, R.Bottom - 2);
      C.LineTo(R.Right - 2, R.Bottom - 1);
      C.LineTo(R.Left+1 , R.Bottom - 1);
    end;

    Txt := (Control as TButton).Caption;

    TextRect := R;

    TxtFont := (Control as TButton).Font;
    C.Font.Assign (TxtFont);

    TWidth := C.TextWidth(Txt);
    THeight := C.TextHeight(Txt);
    TextRect.Left := (CWidth - TWidth) div 2;

    if (Control as TButton).IsRightToLeft then
      TextFormat := DT_RTLREADING;


    if Control is TBitBtn then
      if (Control as TBitBtn).Glyph <> nil then
      begin
        B := TBitmap.Create;
        BWidth := (Control as TBitBtn).Glyph.Width div
                  (Control as TBitBtn).NumGlyphs;

        BHeight := (Control as TBitBtn).Glyph.Height;

        B.Width := BWidth;
        B.Height := BHeight;
        Space := (Control as TBitBtn).Spacing;
        IconRect := Rect(R.Left , R.Top, R.Left+BWidth, R.Top+BHeight);

        B.Canvas.CopyRect (Rect(0, 0, BWidth, BHeight),
                           (Control as TBitBtn).Glyph.Canvas,
                           Rect(0, 0, BWidth, BHeight));


        case (Control as TBitBtn).Layout of
          blGlyphLeft:
          begin
            IconRect.Left := (CWidth - (BWidth + Space + TWidth)) div 2;
            IconRect.Right := IconRect.Left + BWidth;
            IconRect.Top  := (CHeight - (BHeight)) div 2;
            IconRect.Bottom := IconRect.Top + BHeight;

            TextRect.Left := IconRect.Right + Space;
            TextRect.Right := TextRect.Left + TWidth;
          end;
          blGlyphRight:
          begin
            IconRect.Right := (CWidth + (BWidth + Space + TWidth)) div 2;
            IconRect.Left := IconRect.Right - BWidth;
            IconRect.Top  := (CHeight - (BHeight)) div 2;
            IconRect.Bottom := IconRect.Top + BHeight;

            TextRect.Right := IconRect.Left - Space;
            TextRect.Left := TextRect.Right - TWidth;
          end;
          blGlyphTop:
          begin
            IconRect.Left := (CWidth - BWidth) div 2;
            IconRect.Right := IconRect.Left + BWidth;
            IconRect.Top  := (CHeight - (BHeight + Space + THeight)) div 2;
            IconRect.Bottom := IconRect.Top + BHeight;

            TextRect.Left := (CWidth - (TWidth)) div 2;
            TextRect.Right := TextRect.Left + TWidth;
            TextRect.Top := IconRect.Bottom + Space;
            TextRect.Bottom := TextRect.Top + THeight;

          end;
          blGlyphBottom:
          begin
            IconRect.Left := (CWidth - BWidth) div 2;
            IconRect.Right := IconRect.Left + BWidth;
            IconRect.Bottom  := (CHeight + (BHeight + Space + THeight)) div 2;
            IconRect.Top := IconRect.Bottom - BHeight;

            TextRect.Left := (CWidth - (TWidth)) div 2;
            TextRect.Right := TextRect.Left + TWidth;
            TextRect.Bottom := IconRect.Top - Space;
            TextRect.Top := TextRect.Bottom - THeight;

          end;

        end;
        xpMenu.DrawIcon(Control, C , B, IconRect,
          FMouseinControl,
          Control.Focused,
          (Control as TBitBtn).Enabled,
          false,
          false,
          (Control as TButton).IsRightToLeft);

        B.Free;
      end;

    XPMenu.DrawTheText(Control,
                       Txt, '', C,
                       TextRect, false,
                       (Control as TButton).Enabled,
                       (Control as TButton).Default,
                       false,
                       (Control as TButton).IsRightToLeft,
                       TxtFont,
                       TextFormat);

  finally
    C.Free;
  end;

end;

end.



