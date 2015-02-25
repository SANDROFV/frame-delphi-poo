unit frm_MenuPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SDATemplateMenu, XPMenu, Menus, SDAMenus, ComCtrls;

type
  TfrmMenuPrincipal = class(TfrmSDATemplateMenu)
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMenuPrincipal: TfrmMenuPrincipal;

implementation

uses dm_Principal;

{$R *.dfm}

procedure TfrmMenuPrincipal.FormActivate(Sender: TObject);
begin
  inherited;
  if dm.Conectado then
    sbPrincipal.Panels[0].Text := dm.Base;
end;

end.
