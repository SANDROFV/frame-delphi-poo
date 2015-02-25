program SDA_MODELO;

uses
  Forms,
  SDATemplateGeral in '..\..\..\GLOBAL\INTERFACE\TEMPLATES\SDATemplateGeral.pas' {frmSDATemplateGeral},
  SDATemplateTelaPrincipal in '..\..\..\GLOBAL\INTERFACE\TEMPLATES\SDATemplateTelaPrincipal.pas' {frmSDATemplateTelaPrincipal},
  SDATemplateFilhoGeral in '..\..\..\GLOBAL\INTERFACE\TEMPLATES\SDATemplateFilhoGeral.pas' {frmSDATemplateFilhoGeral},
  SDATemplateMenu in '..\..\..\GLOBAL\INTERFACE\TEMPLATES\SDATemplateMenu.pas' {frmSDATemplateMenu},
  SDATemplateChildGeral in '..\..\..\GLOBAL\INTERFACE\TEMPLATES\SDATemplateChildGeral.pas' {frmSDATemplateChildGeral},
  SDATemplateModalGeral in '..\..\..\GLOBAL\INTERFACE\TEMPLATES\SDATemplateModalGeral.pas' {frmSDATemplateModalGeral},
  SDATemplateChild in '..\TEMPLATES\SDATemplateChild.pas' {frmSDATemplateChild},
  SDATemplateModal in '..\TEMPLATES\SDATemplateModal.pas' {frmSDATemplateModal},
  frm_MenuPrincipal in 'frm_MenuPrincipal.pas' {frmMenuPrincipal},
  SDATemplateDataModule in '..\..\..\GLOBAL\INTERFACE\TEMPLATES\SDATemplateDataModule.pas' {DMGeral: TDataModule},
  dm_Principal in 'dm_Principal.pas' {dm: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmMenuPrincipal, frmMenuPrincipal);
  Application.Run;
end.
