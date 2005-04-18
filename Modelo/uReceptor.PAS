unit uReceptor;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs;

type
  TReceptorExterno = class (TObject)
  public
    constructor create;
    function consultarEstado: Integer;
    procedure enviarResultado(concentrador, IDAccion, resultados: string);
    procedure procesarTrabajo(unTrabajo: string);
  end;
  

procedure Register;

implementation

uses
  uEntornoEjecucion, uAlgoritmo;

procedure Register;
begin
end;

{
******************************* TReceptorExterno *******************************
}
constructor TReceptorExterno.create;
begin
end;

function TReceptorExterno.consultarEstado: Integer;
begin
  result:= TEntornoEjecucion.Instance.getEstado;
end;

procedure TReceptorExterno.enviarResultado(concentrador, IDAccion, resultados: 
        string);
begin
  {TODO: Vamos a enviar todo en strings, y luego convertirlo???}
end;

procedure TReceptorExterno.procesarTrabajo(unTrabajo: string);
var
  trabajo: TTrabajo;
  ubicacion: string;
begin
  ubicacion:= TEntornoEjecucion.Instance.getDirectorioTrabajo;
  trabajo:= TTrabajo.Create(self, unTrabajo, ubicacion);
  {TODO: VER BIEN PROCESARTRABAJO XQ RECEPTOR REMOTO NO POSEE LISTA DE PARAMETROS,
  EN 3. LISTAPARAMETROPS := GETLISTAPARAMETROS Y ESO NO CONCUERDA}
end;


end.
