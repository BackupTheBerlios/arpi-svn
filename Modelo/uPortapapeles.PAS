unit uPortapapeles;
// TODO: QUE CORNO HAGO CON LA IMAGEN EN TPORTAPAPELES CUANDO CIERRO IMAGEN
// TODO: PREGUNTAR SI QUIERO MANTENERLA EN EL PORTAPAPELES, GRACIAS DARIO!!!
interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, GR32_Image, GR32, uTipos, GifImage;

type
  Tportapapeles = class (TObject)
  private
    Imagenpp: TImagen;
  protected
    constructor CreateInstance;
    class function AccessInstance(Request: Integer): TPortapapeles;
  public
    constructor Create;
    destructor Destroy; override;
    procedure agregarImagen(unaImagen:TBitmap32); overload;
    procedure agregarImagen(unaImagen:TImagen); overload;
    procedure agregarMatriz(unaMatriz:TMatrizSimple);
    procedure agregarVector(unVector: TMatrizSimple);
    function getImagen: TImagen;
    function getMatriz: TMatrizSimple;
    function getVector: TMatrizSimple;
    class function Instance: TPortapapeles;
    class procedure ReleaseInstance;
  end;
  

procedure Register;

implementation
uses Clipbrd;

procedure Register;
begin
end;

{
******************************** Tportapapeles *********************************
}
constructor Tportapapeles.Create;
begin
  inherited Create;
  raise Exception.CreateFmt('Access class %s through Instance only',
          [ClassName]);
end;

constructor Tportapapeles.CreateInstance;
begin
  inherited Create;
  imagenpp:= nil;
end;

destructor Tportapapeles.Destroy;
begin
  if AccessInstance(0) = Self then AccessInstance(2);
  inherited Destroy;
end;

class function Tportapapeles.AccessInstance(Request: Integer): TPortapapeles;
  
  const FInstance: TPortapapeles = nil;
  
begin
  case Request of
    0 : ;
    1 : if not Assigned(FInstance) then FInstance := CreateInstance;
    2 : FInstance := nil;
  else
    raise Exception.CreateFmt('Illegal request %d in AccessInstance',
            [Request]);
  end;
  Result := FInstance;
end;

procedure Tportapapeles.agregarImagen(unaImagen:TBitmap32);
var
  MyFormat: Word;
  bitmap: TBitmap;
  AData: THandle;
  APalette: HPALETTE;
begin
  bitmap:=TBitmap.Create;
  try
    unaimagen.SaveToFile('temporal.bmp');
    bitmap.LoadFromFile('temporal.bmp');
    bitmap.SaveToClipboardFormat(myformat,AData,APalette);
    ClipBoard.SetAsHandle(MyFormat	,AData);
  finally
    Bitmap.Free;
  end;
end;

procedure Tportapapeles.agregarImagen(unaImagen:TImagen);
begin
  Imagenpp:= unaImagen;
end;

procedure Tportapapeles.agregarMatriz(unaMatriz:TMatrizSimple);
begin
end;

procedure Tportapapeles.agregarVector(unVector: TMatrizSimple);
begin
end;

function Tportapapeles.getImagen: TImagen;
begin
  result:= Imagenpp;
end;

function Tportapapeles.getMatriz: TMatrizSimple;
begin
  {  if Clipboard.HasFormat(CF_TEXT) then
      Edit1.Text := Clipboard.AsText
    else
      MessageDlg('There is no text on the Clipboard', mtInformation,
          [mbOK],0);
  }
end;

function Tportapapeles.getVector: TMatrizSimple;
begin
  {  if Clipboard.HasFormat(CF_TEXT) then
      Edit1.Text := Clipboard.AsText
    else
      MessageDlg('There is no text on the Clipboard', mtInformation,
          [mbOK],0);
  }
end;

class function Tportapapeles.Instance: TPortapapeles;
begin
  Result := AccessInstance(1);
end;

class procedure Tportapapeles.ReleaseInstance;
begin
  AccessInstance(0).Free;
end;


end.
