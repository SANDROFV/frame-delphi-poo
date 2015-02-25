unit frm_Logon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls;

type
  TfrmLogon = class(TForm)
    pnlDados   : TPanel;
    pnlBotoes  : TPanel;
    btOk       : TSpeedButton;
    btCancelar : TSpeedButton;
    edServidor : TEdit;
    Label1     : TLabel;
    edAlias    : TEdit;
    edBd       : TEdit;
    Label2     : TLabel;
    Label3     : TLabel;
    GroupBox1  : TGroupBox;
    StaticText1: TStaticText;
    edUsuario  : TEdit;
    edSenha    : TEdit;
    Label4     : TLabel;
    Label5     : TLabel;
    procedure btOkClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
  private
    { Private declarations }
    function GetAlias: string;
    function GetHost: string;
    function GetSenha: string;
    function GetUsuario: string;
    procedure SetAlias(const Value: string);
    procedure SetHost(const Value: string);
    procedure SetSenha(const Value: string);
    procedure SetUsuario(const Value: string);
    function GetBase: string;
    procedure SetBase(const Value: string);
  public
    { Public declarations }
    property Alias   : string read GetAlias   write SetAlias;
    property Base   : string read GetBase   write SetBase;
    property Host   : string read GetHost   write SetHost;
    property Usuario : string read GetUsuario write SetUsuario;
    property Senha   : string read GetSenha   write SetSenha;
  end;

var
  frmLogon: TfrmLogon;

implementation

{$R *.dfm}

{ TfrmLogon }

function TfrmLogon.GetAlias: string;
begin
  result :=  edAlias.Text;
end;

function TfrmLogon.GetBase: string;
begin
   result := edBd.Text;
end;

function TfrmLogon.GetHost: string;
begin
  result := edServidor.Text;
end;

function TfrmLogon.GetSenha: string;
begin
   result := edSenha.Text;
end;

function TfrmLogon.GetUsuario: string;
begin
   result := edUsuario.Text;
end;

procedure TfrmLogon.SetAlias(const Value: string);
begin
  edAlias.Text:=  Value;
end;

procedure TfrmLogon.SetBase(const Value: string);
begin
 edBd.Text:=  Value;
end;

procedure TfrmLogon.SetHost(const Value: string);
begin
  edServidor.Text:=  Value;
end;

procedure TfrmLogon.SetSenha(const Value: string);
begin
  edSenha.Text:=  Value;
end;

procedure TfrmLogon.SetUsuario(const Value: string);
begin
 edUsuario.Text:=  Value;
end;

procedure TfrmLogon.btOkClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmLogon.btCancelarClick(Sender: TObject);
begin
   Close;
end;

end.
