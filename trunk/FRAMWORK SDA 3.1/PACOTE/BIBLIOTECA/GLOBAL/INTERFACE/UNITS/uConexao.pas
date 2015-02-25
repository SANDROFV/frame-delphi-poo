unit uConexao;

interface

uses SysUtils,forms,IniFiles,Controls;

type
  TConexao = class
  private
    FCaminhoIni                     : string;
    Ini                             : TIniFile;
    FHost                           : string;
    FAlias                          : string;
    FCamDados                       : string;
    FUsuario                        : string;
    FSenha                          : string;
    FOwner                          : string;
    FConectado                      : Boolean;
    FModalResult                    : Boolean;
    FMensagemSaida                  : Boolean;
    FMensagemOperacao               : Boolean;
    FParametrosOpcionais            : Boolean;
    FDuploCliqueAlteracao           : Boolean;
    procedure SetAlias(const Value  : string);
    procedure SetOwner(const Value  : string);
    procedure SetSenha(const Value  : string);
    procedure SetUsuario(const Value: string);
    function GetVazio               : boolean;
    procedure SetHost(const Value: string);
    procedure SetCamDados(const Value: string);
  public

    Constructor create(PFCaminhoIni : string);
    Destructor Destroy; override;
    procedure CarregaPametros;
    procedure GravaParametros;
//    procedure Execute;
    procedure ExecuteC0nfig;
    property Host                 : string read FHost write SetHost;
    property CamDados                 : string read FCamDados write SetCamDados;

    property Alias                : string read FAlias write SetAlias;
    property Owner                : string read FOwner write SetOwner;
    property Usuario              : string read FUsuario write SetUsuario;
    property Senha                : string read FSenha write SetSenha;
    property MensagemSaida        : Boolean read FMensagemSaida write FMensagemSaida;
    property MensagemOperacao     : Boolean read FMensagemOperacao write FMensagemOperacao;
    property ParametrosOpcionais  : Boolean read FParametrosOpcionais write FParametrosOpcionais;
    property DuploCliqueAlteracao : Boolean read FDuploCliqueAlteracao write FDuploCliqueAlteracao;
    property Vazio                : boolean read GetVazio;
    property Conectado            : boolean read FConectado write FConectado;
    property ModalResult          : boolean read FModalResult write FModalResult;
  end;

implementation



procedure TConexao.CarregaPametros;
begin
  CamDados             := Ini.ReadString('configurações de banco - SDA','CamDados','');
  Host                 := Ini.ReadString('configurações de banco - SDA','Host','');
  Usuario              := Ini.ReadString('configurações de banco - SDA','Login','');
  Senha                := Ini.ReadString('configurações de banco - SDA','Senha','');

end;

constructor TConexao.create(PFCaminhoIni : string);
begin
  FCaminhoIni := PFCaminhoIni;
  Ini         := TIniFile.Create(FCaminhoIni);

  CarregaPametros;
end;

destructor TConexao.Destroy;
begin
  Ini.Free;
end;


procedure TConexao.ExecuteC0nfig;
begin
 { frmConfig := TfrmConfig.Create(nil);

  frmConfig.MensagemSaida        := MensagemSaida;
  frmConfig.MensagemOperacao     := MensagemOperacao;
  frmConfig.ParametrosOpcionais  := ParametrosOpcionais;
  frmConfig.DuploCliqueAlteracao := DuploCliqueAlteracao;

  FModalResult := false;
                            }
{  if frmConfig.ShowModal  = mrOK then
  begin
    MensagemSaida          := frmConfig.MensagemSaida;
    MensagemOperacao       := frmConfig.MensagemOperacao;
    ParametrosOpcionais    := frmConfig.ParametrosOpcionais;
    DuploCliqueAlteracao   := frmConfig.DuploCliqueAlteracao;
    GravaParametros;
    FModalResult := True;
  end;
  FreeAndNil(frmConfig);}
end;

function TConexao.GetVazio : boolean;
begin
  if (CamDados <> '') or  (Host <> '') or (Usuario <> '') or (Senha <> '') then
    result := true
  else
    result := false;
end;

procedure TConexao.GravaParametros;
begin
  Ini.WriteString('configurações de banco - SDA','CamDados',CamDados);
  Ini.WriteString('configurações de banco - SDA','Host',Host);
  Ini.WriteString('configurações de banco - SDA','Login',Usuario);
  Ini.WriteString('configurações de banco - SDA','Senha',Senha);

end;

procedure TConexao.SetAlias(const Value: string);
begin
  FAlias := Value;
end;

procedure TConexao.SetCamDados(const Value: string);
begin
  FCamDados := Value;
end;

procedure TConexao.SetHost(const Value: string);
begin
  FHost := Value;
end;

procedure TConexao.SetOwner(const Value: string);
begin
  FOwner := Value;
end;

procedure TConexao.SetSenha(const Value: string);
begin
  FSenha := Value;
end;

procedure TConexao.SetUsuario(const Value: string);
begin
  FUsuario := Value;
end;

end.

