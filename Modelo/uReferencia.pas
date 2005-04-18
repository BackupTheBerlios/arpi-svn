unit uReferencia;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, uTipos, uIdiomas, XMLIntf;

type
  TReferencia = class (TTipo)
  public
    constructor Create; override;
    destructor Destroy; override;
    function getValor(unIdioma:string): string; override;
    procedure setValor(unValor, unIdioma: string); override;
    procedure setXML(XML:IXMLNode); override;
  end;
  
  TListaReferencias = class (TTipo)
  public
    constructor Create; override;
    procedure abrir(nombreListaReferencias:string);
    procedure agregar(unaReferencia:TReferencia);
    function buscar(unaReferencia: string): TReferencia;
    function extraer(unaReferencia: string): TReferencia;
    procedure guardar(nombreListaReferencias:string);
    function primero: TReferencia;
    procedure setValor(unValor, unIdioma: string); override;
    function siguiente: TReferencia;
  end;
  
  TReferenciaComponente = class (TReferencia)
  private
    componente: string;
  public
    procedure setValor(unValor, unIdioma: string); override;
  end;
  
  TReferenciaArchivo = class (TReferencia)
  private
    archivo: string;
  public
    procedure setValor(unValor, unIdioma: string); override;
  end;
  
  TReferenciaArchivoImagen = class (TReferenciaArchivo)
  end;
  
  TReferenciaArchivoMatriz = class (TReferenciaArchivo)
  end;
  
procedure Register;

implementation

procedure Register;
begin
end;

{
********************************* TReferencia **********************************
}
constructor TReferencia.Create;
begin
end;

destructor TReferencia.Destroy;
begin
end;

function TReferencia.getValor(unIdioma:string): string;
begin
  result := ''; {TODO: Anular TODO ESTO}
end;

procedure TReferencia.setValor(unValor, unIdioma: string);
begin
end;

procedure TReferencia.setXML(XML:IXMLNode);
begin
  {TODO: Verificar que no haya nada que levantar}
end;

{
****************************** TListaReferencias *******************************
}
constructor TListaReferencias.Create;
begin
end;

procedure TListaReferencias.abrir(nombreListaReferencias:string);
begin
end;

procedure TListaReferencias.agregar(unaReferencia:TReferencia);
begin
  //  inherited agregar(unaReferencia);
end;

function TListaReferencias.buscar(unaReferencia: string): TReferencia;
begin
end;

function TListaReferencias.extraer(unaReferencia: string): TReferencia;
begin
end;

procedure TListaReferencias.guardar(nombreListaReferencias:string);
begin
end;

function TListaReferencias.primero: TReferencia;
begin
end;

procedure TListaReferencias.setValor(unValor, unIdioma: string);
begin
end;

function TListaReferencias.siguiente: TReferencia;
begin
end;

{
**************************** TReferenciaComponente *****************************
}
procedure TReferenciaComponente.setValor(unValor, unIdioma: string);
begin
  componente := unValor;
end;

{
****************************** TReferenciaArchivo ******************************
}
procedure TReferenciaArchivo.setValor(unValor, unIdioma: string);
begin
  archivo := unValor;
end;



end.
