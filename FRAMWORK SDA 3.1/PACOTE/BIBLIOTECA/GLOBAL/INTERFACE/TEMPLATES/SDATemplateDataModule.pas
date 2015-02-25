unit SDATemplateDataModule;

interface

uses
  Forms, SysUtils, SqlGeral, IniFiles,uConexao,Classes;


type
   TSDA_DataSet = class(TSQLDataSet)
   private

   public
     Constructor Create(Owner : TComponent); override;
     Destructor Destroy; override;
   end;

type
  TDMGeral = class(TDataModule)
  private
    { Private declarations }

     cnx      : TConexao;
    function GetStConexao: boolean;
    function GetBase: String;

  public
    { Public declarations }

    fUsuario,
    fHost  ,
    fSenha ,
    fCaminhoBD : String;

    
    Constructor Create(Owner : TComponent); override;
    Destructor Destroy; override;

    property Conectado : boolean read GetStConexao;
    property Base : String read GetBase;


 end;

var
  DMGeral : TDMGeral;
   fConexao : TSQLConnection;
implementation

uses DB;

{$R *.dfm}

{ TDMGeral }

constructor TDMGeral.Create(Owner: TComponent);

begin
  inherited;
  cnx        := TConexao.create(ExtractFilePath(application.ExeName)+'\conexao.ini');

  fCaminhoBD :=   cnx.CamDados;
  fHost      :=   cnx.Host;
  fUsuario   :=   cnx.Usuario;
  fSenha     :=   cnx.Senha;


  fConexao := TSQLConnection.Create(self);
  with fConexao do
    begin
      ConnectionName := 'SDACnx';
      DriverName     := 'INTERBASE';
      LibraryName    := 'dbexpint.dll';
      VendorLib      := 'GDS32.DLL';
      GetDriverFunc  := 'getSQLDriverINTERBASE';
      Params.Add('User_Name='+fUsuario);
      Params.Add('Password='+fSenha );
      Params.Add('Database='+fHost+':'+fCaminhoBD);
      LoginPrompt    := False;
      Open;
    end;
end;

destructor TDMGeral.Destroy;
begin

  inherited;
end;

function TDMGeral.GetBase: String;
begin
  result := ExtractFileName(fCaminhoBD) ;
end;

function TDMGeral.GetStConexao: boolean;
begin
  result := fConexao.Connected;
end;

{ TSDADataSet }

constructor TSDA_DataSet.Create(Owner: TComponent);
begin
  inherited create(Owner);
  Self.SQLConnection := fConexao;


end;

destructor TSDA_DataSet.Destroy;
begin

  inherited;
end;

end.
