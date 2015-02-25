unit SDAImagem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TSDAImagem = class(TImage)
  private
   FOnPicture: TPicture;
   FOffPicture: TPicture;
    { Private declarations }
  protected
   procedure SetOnPicture (Value: TPicture);
   procedure SetOffPicture (Value: TPicture);
   procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
   procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    { Protected declarations }
  public
   constructor Create (AOwner: TComponent); override;
   destructor Destroy; override;
   procedure SetVisibleOff;
    { Public declarations }
  published
    { Published declarations }
    property OnPicture: TPicture read FOnPicture write SetOnPicture;
    property OffPicture: TPicture read FOffPicture write SetOffPicture;
  end;

 

implementation



constructor TSDAImagem.Create (AOwner: TComponent);
Begin
 inherited Create(AOwner);
 FOnPicture := TPicture.Create;
 FOffPicture := TPicture.Create;
End;

destructor TSDAImagem.Destroy;
Begin
 FOnPicture.Free;
 FOffPicture.Free;
 inherited Destroy;
End;

procedure TSDAImagem.SetOnPicture (Value: TPicture);
Begin
 FonPicture.Assign (Value);
End;

procedure TSDAImagem.SetOffPicture (Value: TPicture);
Begin
 FoffPicture.Assign (Value);
 Picture:=Value;
End;

procedure TSDAImagem.CMMouseEnter(var Message: TMessage);
Begin
 if Enabled and Visible then
  Picture:=FOnPicture;
End;

procedure TSDAImagem.CMMouseLeave(var Message: TMessage);
Begin
 if Enabled and Visible then
  Picture:=FOffPicture;
End;

procedure TSDAImagem.SetVisibleOff;
Begin
 Visible:=false;
 Picture:=FOffPicture;
end;

end.


