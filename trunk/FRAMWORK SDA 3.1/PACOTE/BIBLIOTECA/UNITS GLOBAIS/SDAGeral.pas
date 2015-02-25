unit SDAGeral;


interface

 uses Windows, Messages, SysUtils, Controls, Forms, Classes;


type
  TSDAControlHook = function(var Msg: TMessage): Boolean of object;
  TSDAHookMessageEvent = procedure(Sender: TObject; var Msg: TMessage;
    var Handled: Boolean) of object;

  TSDAHookOrder = (hoBeforeMsg, hoAfterMsg);

  function RegisterWndProcHook(AControl: TControl; Hook: TSDAControlHook; const Order: TSDAHookOrder): Boolean; overload;
  function UnRegisterWndProcHook(AControl: TControl; Hook: TSDAControlHook;const Order: TSDAHookOrder): Boolean; overload;

 type
  TSDAWindowHook = class(TComponent)
  private
    FActive: Boolean;
    FControl: TControl;
    FBeforeMessage: TSDAHookMessageEvent;
    FAfterMessage: TSDAHookMessageEvent;
    procedure SetActive(Value: Boolean);
    procedure SetControl(Value: TControl);
    function IsForm: Boolean;
    function NotIsForm: Boolean;
    procedure ReadForm(Reader: TReader);
    procedure WriteForm(Writer: TWriter);
    procedure SetAfterMessage(const Value: TSDAHookMessageEvent);
    procedure SetBeforeMessage(const Value: TSDAHookMessageEvent);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    function DoAfterMessage(var Msg: TMessage): Boolean; dynamic;
    function DoBeforeMessage(var Msg: TMessage): Boolean; dynamic;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure HookControl;
    procedure UnHookControl;
  published
    property Active: Boolean read FActive write SetActive default True;
    property Control: TControl read FControl write SetControl stored NotIsForm;
    property BeforeMessage: TSDAHookMessageEvent read FBeforeMessage write SetBeforeMessage;
    property AfterMessage: TSDAHookMessageEvent read FAfterMessage write SetAfterMessage;
  end;







implementation


type
  PSDAHookInfo = ^TSDAHookInfo;
  TSDAHookInfo = record
    Hook: TSDAControlHook;
    Next: PSDAHookInfo;
  end;

  PHookInfoList = ^THookInfoList;
  THookInfoList = array [0..MaxInt div 4 - 1] of PSDAHookInfo;

  TSDAWndProcHook = class;
  TSDAHookInfos = class(TObject)
  private
    FFirst: array [TSDAHookOrder] of PSDAHookInfo;
    FLast: array [TSDAHookOrder] of PSDAHookInfo;
    FStack: PHookInfoList;
    FStackCapacity: Integer;
    FStackCount: Integer;
    FHandle: HWND;
    FControl: TControl;
    FControlDestroyed: Boolean;
    FOldWndProc: TWndMethod;
    FHooked: Boolean;
    FController: TSDAWndProcHook;
    procedure SetController(const Value: TSDAWndProcHook);
  protected
    procedure WindowProc(var Msg: TMessage);
    procedure HookControl;
    procedure UnHookControl;
    procedure IncDepth;
    procedure DecDepth;
  public
    constructor Create(AControl: TControl); overload;
    constructor Create(AHandle: HWND); overload;
    destructor Destroy; override;
    procedure Add(const Order: TSDAHookOrder; Hook: TSDAControlHook);
    procedure Delete(const Order: TSDAHookOrder; Hook: TSDAControlHook);
    procedure ControlDestroyed;
    property Control: TControl read FControl;
    property Controller: TSDAWndProcHook read FController write SetController;
    property Handle: HWND read FHandle;
  end;

//  TSDAWndProcHook = class;
  TSDAWndProcHook = class(TComponent)
  private
    FHookInfos: TList;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function IndexOf(AControl: TControl): Integer; overload;
    function IndexOf(AHandle: HWND): Integer; overload;
    function Find(AControl: TControl): TSDAHookInfos; overload;
    function Find(AHandle: HWND): TSDAHookInfos; overload;

    procedure Remove(AHookInfos: TSDAHookInfos);
    procedure Add(AHookInfos: TSDAHookInfos);
  public
    destructor Destroy; override;
    function RegisterWndProc(AControl: TControl; Hook: TSDAControlHook;const Order: TSDAHookOrder): Boolean; overload;
    function RegisterWndProcHook(AControl: TControl; Hook: TSDAControlHook;const Order: TSDAHookOrder): Boolean; //overload;
    //function RegisterWndProcHook(AHandle: HWND; Hook: TSDAControlHook;const Order: TSDAHookOrder): Boolean; overload;

    function UnRegisterWndProc(AControl: TControl; Hook: TSDAControlHook;const Order: TSDAHookOrder): Boolean; overload;
     function UnRegisterWndProcHook(AControl: TControl; Hook: TSDAControlHook;const Order: TSDAHookOrder): Boolean; //overload;
    procedure ReleaseObj(AObject: TObject);
  end;


var
  GSDAWndProcHook: TSDAWndProcHook = nil;
function WndProcHook: TSDAWndProcHook;
begin
  if GSDAWndProcHook = nil then
    GSDAWndProcHook := TSDAWndProcHook.Create(nil);
  Result := GSDAWndProcHook;
end;

function RegisterWndProcHook(AControl: TControl; Hook: TSDAControlHook;
  const Order: TSDAHookOrder): Boolean;
begin
  Result := WndProcHook.RegisterWndProc(AControl, Hook, Order);
end;


function UnRegisterWndProcHook(AControl: TControl; Hook: TSDAControlHook;
  const Order: TSDAHookOrder): Boolean;
begin
  Result := WndProcHook.UnRegisterWndProc(AControl, Hook, Order);
end;
 {
function RegisterWndProcHook(AHandle: HWND; Hook: TSDAControlHook;
  const Order: TSDAHookOrder): Boolean;
begin
  Result := WndProcHook.RegisterWndProc(AHandle, Hook, Order);
end;



function UnRegisterWndProcHook(AHandle: HWND; Hook: TSDAControlHook;
  const Order: TSDAHookOrder): Boolean;
begin
  Result := WndProcHook.UnRegisterWndProc(AHandle, Hook, Order);
end;
 }
 
{ TSDAWndProcHook }



function TSDAWndProcHook.Find(AControl: TControl): TSDAHookInfos;
var
  I: Integer;
begin
  I := IndexOf(AControl);
  if I < 0 then
    Result := nil
  else
    Result := TSDAHookInfos(FHookInfos[I]);
end;

function TSDAWndProcHook.Find(AHandle: HWND): TSDAHookInfos;
 
var
  I: Integer;
begin
  I := IndexOf(AHandle);
  if I < 0 then
    Result := nil
  else
    Result := TSDAHookInfos(FHookInfos[I]);
end;

function TSDAWndProcHook.IndexOf(AControl: TControl): Integer;
begin
  Result := 0;
  while (Result < FHookInfos.Count) and
    (TSDAHookInfos(FHookInfos[Result]).Control <> AControl) do
    Inc(Result);
  if Result = FHookInfos.Count then
    Result := -1;
end;

function TSDAWndProcHook.IndexOf(AHandle: HWND): Integer;
begin
  Result := 0;
  while (Result < FHookInfos.Count) and
    (TSDAHookInfos(FHookInfos[Result]).Handle <> AHandle) do
    Inc(Result);
  if Result = FHookInfos.Count then
    Result := -1;
end;

procedure TSDAWndProcHook.Notification(AComponent: TComponent;
  Operation: TOperation);

var
  I: Integer;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FHookInfos <> nil) and (AComponent is TControl) then
  begin
    I := IndexOf(TControl(AComponent));
    if I >= 0 then
 
      TSDAHookInfos(FHookInfos[I]).ControlDestroyed;
  end;
end;

function TSDAWndProcHook.RegisterWndProc(AControl: TControl;
  Hook: TSDAControlHook; const Order: TSDAHookOrder): Boolean;
var
  HookInfos: TSDAHookInfos;
begin
  Result := False;
  if not Assigned(AControl) or
    (csDestroying in AControl.ComponentState) or not Assigned(Hook) then
    Exit;

  if FHookInfos = nil then
    FHookInfos := TList.Create;

  // find the control:
  HookInfos := Find(AControl);
  if not Assigned(HookInfos) then
  begin
    HookInfos := TSDAHookInfos.Create(AControl);
    HookInfos.Controller := Self;
    AControl.FreeNotification(Self);
  end;
  HookInfos.Add(Order, Hook);

  Result := True;

end;

procedure TSDAWndProcHook.Add(AHookInfos: TSDAHookInfos);
var
  I: Integer;
begin
  I := FHookInfos.IndexOf(AHookInfos);
  if I < 0 then
    FHookInfos.Add(AHookInfos);

end;

destructor TSDAWndProcHook.Destroy;
begin
  if FHookInfos <> nil then
  begin
    while FHookInfos.Count > 0 do
      { If you free a hook info, it will remove itself from the list }
      TSDAHookInfos(FHookInfos[0]).Free;

    FHookInfos.Free;
  end;
  inherited Destroy;
end;


 



function TSDAWndProcHook.RegisterWndProcHook(AControl: TControl;
  Hook: TSDAControlHook; const Order: TSDAHookOrder): Boolean;
begin
//
end;



procedure TSDAWndProcHook.Remove(AHookInfos: TSDAHookInfos);

 var
  I: Integer;
begin
  I := FHookInfos.IndexOf(AHookInfos);
  if I >= 0 then
    FHookInfos.Delete(I);
end;
 

procedure TSDAWndProcHook.ReleaseObj(AObject: TObject);
begin

end;

function TSDAWndProcHook.UnRegisterWndProcHook(AControl: TControl;
  Hook: TSDAControlHook; const Order: TSDAHookOrder): Boolean;
begin

end;

function TSDAWndProcHook.UnRegisterWndProc(AControl: TControl;
  Hook: TSDAControlHook; const Order: TSDAHookOrder): Boolean;
 
var
  HookInfos: TSDAHookInfos;
begin
  Result := False;
  if not Assigned(AControl) or not Assigned(Hook) or not Assigned(FHookInfos) then
    Exit;
  // find the control:
  HookInfos := Find(AControl);
  Result := Assigned(HookInfos);
  if Result then
    // Maybe delete HookInfos if HookInfos.FFirst.. = nil?
    HookInfos.Delete(Order, Hook);
end;

{ TSDAWindowHook }

constructor TSDAWindowHook.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FActive := True;

end;

procedure TSDAWindowHook.DefineProperties(Filer: TFiler);
begin
  inherited;

end;

destructor TSDAWindowHook.Destroy;
begin

  inherited;
end;

function TSDAWindowHook.DoAfterMessage(var Msg: TMessage): Boolean;
begin

end;

function TSDAWindowHook.DoBeforeMessage(var Msg: TMessage): Boolean;
begin

end;

procedure TSDAWindowHook.HookControl;
begin
  SetActive(True);
end;

function TSDAWindowHook.IsForm: Boolean;
begin

end;

procedure TSDAWindowHook.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

end;

function TSDAWindowHook.NotIsForm: Boolean;
begin

end;

procedure TSDAWindowHook.ReadForm(Reader: TReader);
begin

end;

procedure TSDAWindowHook.SetActive(Value: Boolean);
begin

end;

procedure TSDAWindowHook.SetAfterMessage(
  const Value: TSDAHookMessageEvent);
begin

end;

procedure TSDAWindowHook.SetBeforeMessage(
  const Value: TSDAHookMessageEvent);
begin

end;

procedure TSDAWindowHook.SetControl(Value: TControl);
begin

end;

procedure TSDAWindowHook.UnHookControl;
begin

end;

procedure TSDAWindowHook.WriteForm(Writer: TWriter);
begin

end;

{ TSDAHookInfos }

procedure TSDAHookInfos.Add(const Order: TSDAHookOrder;
  Hook: TSDAControlHook);
begin

end;

procedure TSDAHookInfos.ControlDestroyed;
begin

end;

constructor TSDAHookInfos.Create(AHandle: HWND);
begin

end;

constructor TSDAHookInfos.Create(AControl: TControl);
begin

end;

procedure TSDAHookInfos.DecDepth;
begin

end;

procedure TSDAHookInfos.Delete(const Order: TSDAHookOrder;
  Hook: TSDAControlHook);
begin

end;

destructor TSDAHookInfos.Destroy;
begin

  inherited;
end;

procedure TSDAHookInfos.HookControl;
begin

end;

procedure TSDAHookInfos.IncDepth;
begin

end;

procedure TSDAHookInfos.SetController(const Value: TSDAWndProcHook);
begin
  if Value <> FController then
  begin
    if Assigned(FController) then
      FController.Remove(Self);

    FController := Value;

    if Assigned(FController) then
      FController.Add(Self);
  end;  
end;

procedure TSDAHookInfos.UnHookControl;
begin

end;

procedure TSDAHookInfos.WindowProc(var Msg: TMessage);
begin

end;

end.


