unit SDATemplateMenu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SDATemplateTelaPrincipal, ComCtrls, XPMenu, Menus, SDAMenus
  ;

type
  TfrmSDATemplateMenu = class(TfrmSDATemplateTelaPrincipal)
    sbPrincipal: TStatusBar;
    XPMm: TXPMenu;
    mmPrincipal: TSDAMainMenu;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSDATemplateMenu: TfrmSDATemplateMenu;

implementation

uses dm_Principal;

{$R *.dfm}

procedure TfrmSDATemplateMenu.FormCreate(Sender: TObject);
begin
  inherited;
  if dm.Conectado then
    sbPrincipal.Panels[0].Text := dm.Base;
end;

end.
