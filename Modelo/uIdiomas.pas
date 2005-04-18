unit uIdiomas;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, uLista;

type
  TIdioma = class (TObject)
  private
    bandera: TBitmap;
    codigo: string;
    nombre: string;
  public
    constructor Create;
    destructor Destroy; override;
    function getBandera: TBitmap;
    function getCodigo: string;
    function getNombre: string;
    procedure setCodigo(codigo:string);
    procedure setNombre(nombre:string);
  end;
  
  TListaIdiomas = class (TLista)
  public
    procedure agregar(unIdioma:TIdioma);
    function buscar(unIdioma:string): TIdioma;
    function existe(unIdioma:TIdioma): Boolean;
    function primero: TIdioma;
    procedure quitarIdioma(unIdioma:TIdioma);
    procedure quitarTodos;
    function siguiente: TIdioma;
  end;
  
  TControlIdiomas = class (TObject)
  private
    listaIdiomas: TListaIdiomas;
  protected
    constructor CreateInstance;
    class function AccessInstance(Request: Integer): TControlIdiomas;
  public
    constructor Create;
    destructor Destroy; override;
    function buscar(unIdioma:string): TIdioma;
    class function Instance: TControlIdiomas;
    class procedure ReleaseInstance;
  end;
  

procedure Register;

implementation

procedure Register;
begin
end;

{
*********************************** TIdioma ************************************
}
constructor TIdioma.Create;
begin
  bandera := TBitmap.Create;
end;

destructor TIdioma.Destroy;
begin
  bandera.Free;
end;

function TIdioma.getBandera: TBitmap;
begin
  result := bandera;
end;

function TIdioma.getCodigo: string;
begin
  result := codigo;
end;

function TIdioma.getNombre: string;
begin
  result := nombre;
end;

procedure TIdioma.setCodigo(codigo:string);
begin
  self.codigo := codigo;
end;

procedure TIdioma.setNombre(nombre:string);
begin
  self.nombre := nombre;
end;

{
******************************** TListaIdiomas *********************************
}
procedure TListaIdiomas.agregar(unIdioma:TIdioma);
begin
  inherited agregar(unIdioma);
end;

function TListaIdiomas.buscar(unIdioma:string): TIdioma;
var
  aux: TIdioma;
begin
  aux := primero;
  while Assigned(aux) and (aux.codigo <> unIdioma) do
    aux := siguiente;
  result:=aux;
end;

function TListaIdiomas.existe(unIdioma:TIdioma): Boolean;
begin
  result:=Assigned(buscar(unIdioma.codigo));
end;

function TListaIdiomas.primero: TIdioma;
var
  aux: TObject;
begin
  aux:=inherited primero;
  if Assigned(aux) then
    result := TIdioma(aux)
  else
    result := nil;
end;

procedure TListaIdiomas.quitarIdioma(unIdioma:TIdioma);
begin
  inherited eliminar(unIdioma);
end;

procedure TListaIdiomas.quitarTodos;
begin
  inherited eliminarTodos;
end;

function TListaIdiomas.siguiente: TIdioma;
var
  aux: TObject;
begin
  aux:=inherited siguiente;
  if Assigned(aux) then
    result:=TIdioma(aux)
  else
    result := nil;
end;

{
******************************* TControlIdiomas ********************************
}
constructor TControlIdiomas.Create;
begin
  inherited Create;
  raise Exception.CreateFmt('Access class %s through Instance only', 
          [ClassName]);
end;

constructor TControlIdiomas.CreateInstance;
var
  aux: TIdioma;
begin
  inherited Create;
  listaIdiomas := TListaIdiomas.Create;
  {TODO -oEzequiel : Cargar los idiomas de un archivo de config }
  aux:=TIdioma.Create; aux.codigo := 'es'; aux.nombre := 'Español'; listaIdiomas.agregar(aux);
  aux:=TIdioma.Create; aux.codigo := 'en'; aux.nombre := 'English'; listaIdiomas.agregar(aux);
  aux:=TIdioma.Create; aux.codigo := 'fr'; aux.nombre := 'Françoise'; listaIdiomas.agregar(aux);
  aux:=TIdioma.Create; aux.codigo := 'de'; aux.nombre := 'Deustch'; listaIdiomas.agregar(aux);
  aux:=TIdioma.Create; aux.codigo := 'it'; aux.nombre := 'Italiano'; listaIdiomas.agregar(aux);
  aux:=TIdioma.Create; aux.codigo := 'ja'; aux.nombre := 'Japan'; listaIdiomas.agregar(aux);
end;

destructor TControlIdiomas.Destroy;
begin
  if AccessInstance(0) = Self then AccessInstance(2);
  inherited Destroy;
end;

class function TControlIdiomas.AccessInstance(Request: Integer): 
        TControlIdiomas;
  
  const FInstance: TControlIdiomas = nil;
  
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

function TControlIdiomas.buscar(unIdioma:string): TIdioma;
begin
  result := listaIdiomas.buscar(unIdioma);
end;

class function TControlIdiomas.Instance: TControlIdiomas;
begin
  Result := AccessInstance(1);
end;

class procedure TControlIdiomas.ReleaseInstance;
begin
  AccessInstance(0).Free;
end;


end.
