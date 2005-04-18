unit uSatelite;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs;

type
  TSatelite = class (TObject)
  private
    FdireccionDeConexion: string;
    Fnombre: string;
  public
    constructor Create;
    destructor Destroy;
    procedure setDireccionDeConexion(unaDireccion: string);
    procedure setNombre(unNombre:string);
    property direccionDeConexion: string read FdireccionDeConexion write 
            FdireccionDeConexion;
    property nombre: string read Fnombre write Fnombre;
  end;
  

procedure Register;

implementation

procedure Register;
begin
end;

{
********************************** TSatelite ***********************************
}
constructor TSatelite.Create;
begin
end;

destructor TSatelite.Destroy;
begin
end;

procedure TSatelite.setDireccionDeConexion(unaDireccion: string);
begin
end;

procedure TSatelite.setNombre(unNombre:string);
begin
end;


end.
