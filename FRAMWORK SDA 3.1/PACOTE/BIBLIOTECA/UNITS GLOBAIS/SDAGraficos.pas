unit SDAGraficos;

interface

uses
  Windows,
  Classes, SysUtils, GIFImage,
  Graphics;
 type
  TSDADesktopCanvas = class(TCanvas)
  private
    FDesktop: HDC;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  implementation
{ TSDADesktopCanvas }

constructor TSDADesktopCanvas.Create;
begin
  FDesktop := GetDC(HWND_DESKTOP);
  Handle := FDesktop;
end;

destructor TSDADesktopCanvas.Destroy;
begin
    Handle := 0;
  ReleaseDC(HWND_DESKTOP, FDesktop);
  inherited Destroy;
 
end;

end.
 
