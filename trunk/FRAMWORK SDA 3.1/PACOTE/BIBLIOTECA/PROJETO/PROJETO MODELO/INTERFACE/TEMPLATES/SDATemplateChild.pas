unit SDATemplateChild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SDATemplateChildGeral;

type
  TfrmSDATemplateChild = class(TfrmSDATemplateChildGeral)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSDATemplateChild: TfrmSDATemplateChild;

implementation

{$R *.dfm}

procedure TfrmSDATemplateChild.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

end.
