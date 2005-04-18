unit uComponentes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, uTipos, uIdiomas, uLista, XMLIntf, uReferencia, uBuilderTipoDatos;

type
  TVariable = class (TObject)
  private
    nombre: string;
    tipo: TTipo;
  public
    constructor Create(unTipo: string); virtual;
    procedure agregarIdioma(unIdioma: TIdioma);
    function getDFM: string; virtual;
    function getNombre: string;
    function getValor(unIdioma:string): string; virtual;
    procedure getXML(var XML: IXMLNode); virtual;
    procedure quitarIdioma(unIdioma: TIdioma);
    procedure setNombre(const Value: string);
    procedure setValor(unValor, unIdioma:string); overload; virtual;
    procedure setValor(unValor:string; listaIdiomas:TListaIdiomas); overload; 
            virtual;
    procedure setXML(XML:IXMLNode); virtual;
  end;
  
  TPropiedad = class (TVariable)
    procedure getXML(var XML: IXMLNode); override;
  end;
  
  TListaPropiedades = class (TLista)
  public
    procedure agregar(unaPropiedad:TPropiedad);
    function buscar(unaPropiedad:string): TPropiedad;
    function primero: TPropiedad;
    function siguiente: TPropiedad;
  end;
  
  TParametro = class (TVariable)
  private
    listaReferencias: TListaReferencias;
  public
    constructor Create(datos: IXMLNode); reintroduce; overload;
    procedure abrirListaReferencias(nombreListaReferencias: string); overload;
    procedure agregarListaReferencias(nombreListaReferencias:string);
    procedure agregarRefenciaALista(unValor:string);
    function duplicar: TParametro;
    procedure eliminarRefenciaDeLista(unaReferencia:string);
    function esTipoEntrada: Boolean;
    function esTipoSalida: Boolean;
    function getParametro: TParametro;
    function getPointer: Pointer;
    function getReferencia(numero:integer): TParametro;
    function getTipo: string;
    procedure getXML(var XML: IXMLNode); override;
    procedure guardar(nombreListaReferencias:string); overload;
    procedure setPointer(puntero: Pointer);
    procedure setReferencias(unaListaReferencias: TListaReferencias); overload;
    procedure setValorInicial; overload;
  end;
  
  TParametroImagen = class (TParametro)
  public
    function abrir(nombreArchivo:string): TBitmap; overload;
    procedure borrarSeleccion;
    procedure deshacer;
    function getSeleccion: TImagen;
    procedure guardar(nombreListaReferencias:string); overload;
    procedure imprimir;
    procedure rehacer;
    procedure setImagen(unaImagen:TImagen; unaPosicion:TPoint);
    procedure setValor(valorImagen:RValorImagen); overload;
  end;
  
  TParametroMatriz = class (TParametro)
  public
    procedure inicializa(nroFilas, nroColumnas:integer; tipoDato, 
            valorInicial:string);
    procedure setValor(unValor, unIdioma:string); overload; override;
    procedure setValor(unValor:string; listaIdiomas:TListaIdiomas); overload; 
            override;
  end;
  
  TParametroVector = class (TParametro)
  public
    procedure inicializa(nroCeldas:integer; tipoDato, valorInicial:string);
    procedure setValor(unValor, unIdioma:string); overload; override;
    procedure setValor(unValor:string; listaIdiomas:TListaIdiomas); overload; 
            override;
  end;
  
  TListaParametros = class (TLista)
  public
    procedure agregar(unParametro:TParametro);
    function buscar(unParametro:string): TParametro;
    function duplicar: TListaParametros;
    function primero: TParametro;
    function siguiente: TParametro;
  end;
  
  TComponente = class (TObject)
  private
    listaPropiedades: TListaPropiedades;
    nombre: string;
    parametro: TParametro;
  public
    constructor Create(listaIdiomas: TListaIdiomas); virtual;
    destructor Destroy; override;
    procedure agregarIdioma(unIdioma:TIdioma);
    function getDFM: string; virtual; abstract;
    function getNombre: string;
    function getParametro: TParametro; overload;
    function getParametro(unIdioma:string): string; overload;
    function getPropiedad(unaPropiedad, unIdioma:string): string; virtual;
    procedure getXML(var XML: IXMLNode); virtual;
    procedure mostrar(unIdioma:TIdioma);
    procedure quitarIdioma(unIdioma:TIdioma);
    procedure quitarVinculacion;
    procedure setearParametro(nuevoValor, unIdioma:string); overload; virtual;
    procedure setearParametro(nuevoValor:string; listaIdiomas:TListaIdiomas); 
            overload; virtual;
    procedure setearPropiedad(unaPropiedad, nuevoValor, unIdioma:string); 
            overload; virtual;
    procedure setearPropiedad(unaPropiedad, nuevoValor:string; 
            listaIdiomas:TListaIdiomas); overload; virtual;
    procedure setNombre(unNombre:string);
    procedure setXML(XML: IXMLNode); virtual;
    procedure _setParametro(unParametro:TParametro);
    procedure _setPropiedad(nombrePropiedad, valor:string);
    procedure _setValor(unValor:string);
  end;
  
  TClaseComponente = class of TComponente;

  TListaComponentes = class (TLista)
  public
    procedure agregar(unComponente: TComponente);
    function buscar(unComponente: string): TComponente;
    procedure ordenar;
    function primero: TComponente;
    function siguiente: TComponente;
  end;
  
  TListaClasesComponentes = class (TListaClases)
  public
    function agregar(nombreClase:string; unaClase:TClaseComponente): Integer;
    function buscar(nombreClase:string): TClaseComponente;
    function existe(unaClase:string): Boolean;
    procedure insertar(nombreClase:string; unaClase:TClaseComponente; index: 
            integer);
  end;
  
  TCompCheckBox = class (TComponente)
  private
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create(listaIdiomas: TListaIdiomas); override;
    function getDFM: string; override;
    procedure getXML(var XML: IXMLNode); override;
  end;
  
  TCompComboBox = class (TComponente)
  private
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create(listaIdiomas: TListaIdiomas); override;
    function getDFM: string; override;
    procedure getXML(var XML: IXMLNode); override;
  end;
  
  TCompHistograma = class (TComponente)
  private
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create(listaIdiomas: TListaIdiomas); override;
    procedure getXML(var XML: IXMLNode); override;
  end;
  
  TCompEdit = class (TComponente)
  private
    tipo: string;
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create(listaIdiomas: TListaIdiomas); override;
    function getDFM: string; override;
    function getPropiedad(unaPropiedad, unIdioma:string): string; override;
    procedure getXML(var XML: IXMLNode); override;
    procedure setearPropiedad(unaPropiedad, nuevoValor, unIdioma:string); 
            overload; override;
    procedure setearPropiedad(unaPropiedad, nuevoValor:string; 
            listaIdiomas:TListaIdiomas); overload; override;
    procedure setXML(XML: IXMLNode); override;
  end;
  
  TCompGrilla = class (TComponente)
  private
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create(listaIdiomas: TListaIdiomas); override;
    procedure getXML(var XML: IXMLNode); override;
    procedure setearPropiedad(unaPropiedad, nuevoValor, unIdioma:string); 
            overload; override;
    procedure setearPropiedad(unaPropiedad, nuevoValor:string; 
            listaIdiomas:TListaIdiomas); overload; override;
  end;
  
  TCompImagen = class (TComponente)
  private
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create(listaIdiomas: TListaIdiomas); override;
    function getDFM: string; override;
    procedure getXML(var XML: IXMLNode); override;
  end;
  
  TCompLabel = class (TComponente)
  private
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create(listaIdiomas: TListaIdiomas); override;
    function getDFM: string; override;
    procedure getXML(var XML: IXMLNode); override;
    procedure setearPropiedad(unaPropiedad, nuevoValor, unIdioma:string); 
            overload; override;
    procedure setearPropiedad(unaPropiedad, nuevoValor:string; 
            listaIdiomas:TListaIdiomas); overload; override;
  end;
  
  TCompListBox = class (TComponente)
  private
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create(listaIdiomas: TListaIdiomas); override;
    function getDFM: string; override;
    procedure getXML(var XML: IXMLNode); override;
  end;
  
  TCompMatriz = class (TComponente)
  private
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create(listaIdiomas: TListaIdiomas); override;
    function getDFM: string; override;
    procedure getXML(var XML: IXMLNode); override;
  end;
  
  TCompMinMaxHistograma = class (TComponente)
  private
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create(listaIdiomas: TListaIdiomas); override;
    procedure getXML(var XML: IXMLNode); override;
  end;
  
  TCompRadioGroup = class (TComponente)
  private
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create(listaIdiomas: TListaIdiomas); override;
    function getDFM: string; override;
    procedure getXML(var XML: IXMLNode); override;
  end;
  
  TCompSlider = class (TComponente)
  private
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create(listaIdiomas: TListaIdiomas); override;
    procedure getXML(var XML: IXMLNode); override;
  end;
  
  TCompValorHistograma = class (TComponente)
  private
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create(listaIdiomas: TListaIdiomas); override;
    procedure getXML(var XML: IXMLNode); override;
  end;
  
procedure Register;

implementation

uses uConsts;
procedure Register;
begin
end;

function ordenarComponentes(Item1, Item2: pointer): Integer;
var
  arriba1, arriba2, izq1, izq2: integer;
begin
  arriba1 := strtoint(TComponente(Item1).getPropiedad(IDARRIBA,''));
  arriba2 := strtoint(TComponente(Item2).getPropiedad(IDARRIBA,''));
  izq1 := strtoint(TComponente(Item1).getPropiedad(IDIZQUIERDA,''));
  izq2 := strtoint(TComponente(Item2).getPropiedad(IDIZQUIERDA,''));
  if arriba1>arriba2 then
    result := 1
  else if arriba1<arriba2 then
    result := -1
  else if izq1>izq2 then
    result := 1
  else if izq1<izq2 then
    result := -1
  else
    result := 0;
end;

{
********************************** TVariable ***********************************
}
constructor TVariable.Create(unTipo: string);
var
  builderTipo: TBuilderTipoDato;
begin
  inherited Create;
  builderTipo:= TBuilderTipoDato.Instance;
  tipo := builderTipo.CreateTipo(unTipo);
end;

procedure TVariable.agregarIdioma(unIdioma: TIdioma);
begin
  tipo.agregarIdioma(unIdioma);
end;

function TVariable.getDFM: string;
begin
  result := tipo.getDFM;
end;

function TVariable.getNombre: string;
begin
  result := nombre
end;

function TVariable.getValor(unIdioma:string): string;
begin
  result := tipo.getValor(unIdioma);
end;

procedure TVariable.getXML(var XML: IXMLNode);
begin
  XML.Attributes['nombre']:=nombre;
  tipo.getXML(XML);
end;

procedure TVariable.quitarIdioma(unIdioma: TIdioma);
begin
  tipo.quitarIdioma(unIdioma);
end;

procedure TVariable.setNombre(const Value: string);
begin
  nombre := Value;
end;

procedure TVariable.setValor(unValor, unIdioma:string);
begin
  tipo.setValor(unValor, unIdioma)
end;

procedure TVariable.setValor(unValor:string; listaIdiomas:TListaIdiomas);
begin
  tipo.setValor(unValor, listaIdiomas);
end;

procedure TVariable.setXML(XML:IXMLNode);
begin
  nombre := XML.Attributes['nombre'];
  tipo:= TBuilderTipoDato.Instance.CreateTipo(XML.ChildNodes.Nodes[0].NodeName);
  tipo.setXML(XML.ChildNodes.Nodes[0]);
end;

{
****************************** TListaPropiedades *******************************
}
procedure TListaPropiedades.agregar(unaPropiedad:TPropiedad);
begin
  inherited agregar(unaPropiedad);
end;

function TListaPropiedades.buscar(unaPropiedad:string): TPropiedad;
var
  aux: TPropiedad;
begin
  aux := primero;
  while Assigned(aux) and (aux.getNombre <> unaPropiedad) do
    aux := siguiente;
  result:=aux;
end;

function TListaPropiedades.primero: TPropiedad;
var
  aux: TObject;
begin
  aux:=inherited primero;
  if Assigned(aux) then
    result := TPropiedad(aux)
  else
    result := nil;
end;

function TListaPropiedades.siguiente: TPropiedad;
var
  aux: TObject;
begin
  aux:=inherited siguiente;
  if Assigned(aux) then
    result := TPropiedad(aux)
  else
    result := nil;
end;

{
********************************** TParametro **********************************
}
constructor TParametro.Create(datos: IXMLNode);
var
  nodoXML: IXMLNode;
  referencia: TReferencia;
begin
  nodoXML :=datos.ChildNodes.First;
  while nodoXML <> nil do
  begin
    referencia := TReferencia.Create;
    referencia.setXML(nodoXML);
    listaReferencias.agregar(referencia);
    nodoXML := nodoXML.NextSibling;
  end;
end;

procedure TParametro.abrirListaReferencias(nombreListaReferencias: string);
var
  referencia: TReferencia;
begin
  FreeAndNil(Tipo);
  tipo := TListaReferencias.Create;
  {TODO : Implementar el sistema de apertura de archivos}
end;

procedure TParametro.agregarListaReferencias(nombreListaReferencias:string);
begin
end;

procedure TParametro.agregarRefenciaALista(unValor:string);
var
  referencia: TReferencia;
begin
  referencia := TReferencia.Create;
  referencia.setValor(unValor,'');
  listaReferencias.agregar(referencia);
end;

function TParametro.duplicar: TParametro;
begin
  {TODO: duplicar nombre}
  {TODO: duplicar TTipo}
  {TODO: duplicar listadereferencias}
end;

procedure TParametro.eliminarRefenciaDeLista(unaReferencia:string);
var
  referencia: TReferencia;
begin
  referencia := listaReferencias.extraer(unaReferencia);
  if Assigned(referencia) then
    FreeAndNil(referencia)
  else
    raise Exception.CreateFmt('Error al buscar la referencia %s', [unaReferencia]);
end;

function TParametro.esTipoEntrada: Boolean;
begin
end;

function TParametro.esTipoSalida: Boolean;
begin
end;

function TParametro.getParametro: TParametro;
begin
end;

function TParametro.getPointer: Pointer;
begin
  result := tipo.getPointer(nil);
end;

function TParametro.getReferencia(numero:integer): TParametro;
begin
end;

function TParametro.getTipo: string;
begin
  result := tipo.ClassName;
end;

procedure TParametro.getXML(var XML: IXMLNode);
var
  aux: IXMLNode;
begin
  aux:=XML.AddChild('parametro');
  inherited getXML(aux);
end;

procedure TParametro.guardar(nombreListaReferencias:string);
var
  referencia: TReferencia;
begin
  referencia := listaReferencias.primero;
  //  while Assigned (referencia) do
  //    referencia.getXML();
end;

procedure TParametro.setPointer(puntero: Pointer);
begin
  tipo.setPointer(puntero);
end;

procedure TParametro.setReferencias(unaListaReferencias: TListaReferencias);
begin
end;

procedure TParametro.setValorInicial;
begin
end;

{
******************************* TParametroImagen *******************************
}
function TParametroImagen.abrir(nombreArchivo:string): TBitmap;
begin
end;

procedure TParametroImagen.borrarSeleccion;
begin
end;

procedure TParametroImagen.deshacer;
begin
end;

function TParametroImagen.getSeleccion: TImagen;
begin
end;

procedure TParametroImagen.guardar(nombreListaReferencias:string);
begin
end;

procedure TParametroImagen.imprimir;
begin
end;

procedure TParametroImagen.rehacer;
begin
end;

procedure TParametroImagen.setImagen(unaImagen:TImagen; unaPosicion:TPoint);
begin
end;

procedure TParametroImagen.setValor(valorImagen:RValorImagen);
begin
end;

{
******************************* TParametroMatriz *******************************
}
procedure TParametroMatriz.inicializa(nroFilas, nroColumnas:integer; tipoDato, 
        valorInicial:string);
begin
  TMatriz(tipo).inicializa(nroFilas, nroColumnas, tipoDato, valorInicial);
end;

procedure TParametroMatriz.setValor(unValor, unIdioma:string);
begin
  inherited setValor(unValor, unIdioma);
  // TODO
  // hacer split de unvalor con ;
  // eliminar todas las filas y agregar los valores
end;

procedure TParametroMatriz.setValor(unValor:string; listaIdiomas:TListaIdiomas);
begin
  inherited setValor(unValor, listaIdiomas);
  // TODO
  // hacer split de unvalor con ;
  // eliminar todas las filas y agregar los valores
end;

{
******************************* TParametroVector *******************************
}
procedure TParametroVector.inicializa(nroCeldas:integer; tipoDato, 
        valorInicial:string);
begin
end;

procedure TParametroVector.setValor(unValor, unIdioma:string);
begin
  inherited setValor(unValor, unIdioma);
  // TODO
  // hacer split de unvalor con ;
  // eliminar todas las filas y agregar los valores
end;

procedure TParametroVector.setValor(unValor:string; listaIdiomas:TListaIdiomas);
begin
  inherited setValor(unValor, listaIdiomas);
  // TODO
  // hacer split de unvalor con ;
  // eliminar todas las filas y agregar los valores
end;

{
******************************* TListaParametros *******************************
}
procedure TListaParametros.agregar(unParametro:TParametro);
begin
  inherited agregar(unParametro);
end;

function TListaParametros.buscar(unParametro:string): TParametro;
var
  aux: TParametro;
begin
  aux := primero;
  while Assigned(aux) and (aux.getNombre <> unParametro) do
    aux := siguiente;
  result:=aux;
end;

function TListaParametros.duplicar: TListaParametros;
var
  param, paramAux: TParametro;
  lp: TListaParametros;
begin
  lp := TListaParametros.Create;
  param := primero;
  while param <> nil do
  begin
    paramAux := param.duplicar;
    lp.agregar(paramAux);
    param := siguiente;
  end;
end;

function TListaParametros.primero: TParametro;
var
  aux: TObject;
begin
  aux := inherited primero;
  if Assigned(aux) then
    result := TParametro(aux)
  else
    result := nil;
end;

function TListaParametros.siguiente: TParametro;
var
  aux: TObject;
begin
  aux:=inherited siguiente;
  if Assigned(aux) then
    result := TParametro(aux)
  else
    result := nil;
end;

{
********************************* TComponente **********************************
}
constructor TComponente.Create(listaIdiomas: TListaIdiomas);
begin
  inherited Create;
  listaPropiedades := TListaPropiedades.Create;
end;

destructor TComponente.Destroy;
var
  propiedad: TPropiedad;
begin
  propiedad:=ListaPropiedades.primero;
  while assigned(propiedad) do
  begin
       propiedad.Destroy;
       propiedad:=ListaPropiedades.siguiente;
  end;
  ListaPropiedades.Destroy;
  inherited Destroy;
end;

procedure TComponente.agregarIdioma(unIdioma:TIdioma);
var
  propiedad: TPropiedad;
begin
  propiedad := listaPropiedades.primero;
  while Assigned(propiedad) do
  begin
       propiedad.agregarIdioma(unIdioma);
       propiedad := listaPropiedades.siguiente;
  end;
end;

function TComponente.getNombre: string;
begin
  result:=nombre;
end;

function TComponente.getParametro: TParametro;
begin
  result := parametro;
end;

function TComponente.getParametro(unIdioma:string): string;
begin
  result := parametro.getValor(unIdioma);
end;

function TComponente.getPropiedad(unaPropiedad, unIdioma:string): string;
var
  propiedad: TPropiedad;
begin
  if nombre = unaPropiedad then //es una parámetro?
    result := parametro.getValor(unIdioma)
  else
  begin
    propiedad := listaPropiedades.buscar(unaPropiedad);
    if Assigned(propiedad) then
      result := propiedad.getValor(unIdioma)
    else
      raise Exception.CreateFmt('La propiedad %s no es parte del componente %s', [unaPropiedad, getNombre]);
  end;
end;

procedure TComponente.getXML(var XML: IXMLNode);
var
  propiedad: TPropiedad;
begin
  //supongo que cada componente creo el tag principal y ahora rellena las propiedades
  XML.Attributes['nombre']:= nombre;
  propiedad:=listaPropiedades.primero;
  while Assigned(propiedad) do
  begin
    propiedad.getXML(XML);
    propiedad:=listaPropiedades.siguiente;
  end;
  if Assigned(parametro) then
    parametro.getXML(XML);
end;

procedure TComponente.mostrar(unIdioma:TIdioma);
begin
end;

procedure TComponente.quitarIdioma(unIdioma:TIdioma);
var
  propiedad: TPropiedad;
begin
  propiedad := listaPropiedades.primero;
  while Assigned(propiedad) do
  begin
    propiedad.quitarIdioma(unIdioma);
    propiedad := listaPropiedades.siguiente;
  end;
end;

procedure TComponente.quitarVinculacion;
begin
end;

procedure TComponente.setearParametro(nuevoValor, unIdioma:string);
begin
  parametro.setValor(nuevoValor, unIdioma);
end;

procedure TComponente.setearParametro(nuevoValor:string; 
        listaIdiomas:TListaIdiomas);
begin
  parametro.setValor(nuevoValor, listaIdiomas);
end;

procedure TComponente.setearPropiedad(unaPropiedad, nuevoValor, 
        unIdioma:string);
var
  propiedad: TPropiedad;
begin
  if lowerCase(unaPropiedad)='name' then
  begin
    if IsValidIdent(nuevoValor) then
    begin
       setNombre(nuevoValor);
       if Assigned(parametro) then
         parametro.setNombre(nuevoValor);
    end
    else
      Exception.CreateFmt('%s no es un nombre válido',[nuevoValor]);
  end
  else
  if nombre = unaPropiedad then //es un parámetro
    parametro.setValor(nuevoValor, unIdioma)
  else
  begin
    propiedad:=listaPropiedades.buscar(unaPropiedad);
    if Assigned(propiedad) then
      propiedad.setValor(nuevoValor, unIdioma)
    else
      Exception.CreateFmt('No se pudo encontrar la propiedad %s en el componente %s',[unaPropiedad, nombre]);
  end;
end;

procedure TComponente.setearPropiedad(unaPropiedad, nuevoValor:string; 
        listaIdiomas:TListaIdiomas);
var
  propiedad: TPropiedad;
begin
  if lowerCase(unaPropiedad)='name' then
  begin
     setNombre(nuevoValor);
     parametro.setNombre(nuevoValor);
  end
  else
  begin
    propiedad:=listaPropiedades.buscar(unaPropiedad);
    if Assigned(propiedad) then
      propiedad.setValor(nuevoValor, listaIdiomas)
    else
      Exception.CreateFmt('No se pudo encontrar la propiedad %s en el componente %s',[unaPropiedad, nombre]);
  end;
end;

procedure TComponente.setNombre(unNombre:string);
begin
  nombre := unNombre;
end;

procedure TComponente.setXML(XML: IXMLNode);
var
  i: Integer;
  propiedad: TPropiedad;
begin
  nombre := XML.Attributes['nombre'];
  for i:= 0 to XML.ChildNodes.Count -1 do
    if lowercase(XML.ChildNodes.Nodes[i].NodeName) = 'propiedad' then
    begin
      propiedad := listaPropiedades.buscar(XML.ChildNodes.Nodes[i].Attributes['nombre']);
      propiedad.setXML(XML.ChildNodes.Nodes[i]);
    end
    else if lowercase(XML.ChildNodes.Nodes[i].NodeName) = 'parametro' then
      parametro.setXML(XML.ChildNodes.Nodes[i])
    else
      raise Exception.Create('Formulario mal formulario');
end;

procedure TComponente._setParametro(unParametro:TParametro);
begin
end;

procedure TComponente._setPropiedad(nombrePropiedad, valor:string);
begin
end;

procedure TComponente._setValor(unValor:string);
begin
end;

{
****************************** TListaComponentes *******************************
}
procedure TListaComponentes.agregar(unComponente: TComponente);
begin
  inherited agregar(unComponente);
end;

function TListaComponentes.buscar(unComponente: string): TComponente;
var
  aux: TComponente;
begin
  aux := primero;
  while Assigned(aux) and (aux.getNombre <> unComponente) do
    aux := siguiente;
  result:=aux;
end;

procedure TListaComponentes.ordenar;
begin
  ordenarInt(ordenarComponentes)
end;

function TListaComponentes.primero: TComponente;
var
  aux: TObject;
begin
  aux:=inherited primero;
  if Assigned(aux) then
    result := TComponente(aux)
  else
    result := nil;
end;

function TListaComponentes.siguiente: TComponente;
var
  aux: TObject;
begin
  aux:=inherited siguiente;
  if Assigned(aux) then
    result := TComponente(aux)
  else
    result := nil;
end;

{
******************************** TCompCheckBox *********************************
}
constructor TCompCheckBox.Create(listaIdiomas: TListaIdiomas);
var
  unaPropiedad: TPropiedad;
begin
  inherited Create(listaIdiomas);
  setNombre('CheckBox'+inttostr(updateNumero));
  //Acá hay que crear cada propiedad y agregarla a la lista de propiedades
  // *top left width height value(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('top');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top *left width height value(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('left');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left *width height value(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('width');
  unaPropiedad.setValor('85', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width *height value(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('height');
  unaPropiedad.setValor('40', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width height *caption value(par)
  unaPropiedad := TPropiedad.Create('texto');
  unaPropiedad.setNombre('caption');
  {TODO: ver como inicializar}
  unaPropiedad.setValor(getNombre{esp='+getNombre+'|eng='+getNombre}, listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width height *value(par)
  parametro := TParametro.Create('numeroentero');
  parametro.setNombre(getNombre);
  parametro.setValor('0', listaIdiomas);
end;

function TCompCheckBox.getDFM: string;
begin
  FmtStr(result,
  'object %s:TARPICheckBox Caption = ''%s'' Top = %s Left = %s Width = %s Height = %s Checked = %s end',
  [getNombre,
  listaPropiedades.buscar('caption').getDFM,
  listaPropiedades.buscar('top').getDFM,
  listaPropiedades.buscar('left').getDFM,
  listaPropiedades.buscar('width').getDFM,
  listaPropiedades.buscar('height').getDFM,
  BoolToStr(parametro.getValor('')='1', True)]);
end;

procedure TCompCheckBox.getXML(var XML: IXMLNode);
var
  componente: IXMLNode;
begin
  componente := XML.AddChild('componente');
  componente.Attributes['nombre']:= nombre;
  componente.Attributes['tipo']:= 'checkbox';
  inherited getXML(componente);
end;

class function TCompCheckBox.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

{
******************************** TCompComboBox *********************************
}
constructor TCompComboBox.Create(listaIdiomas: TListaIdiomas);
var
  unaPropiedad: TPropiedad;
begin
  inherited Create(listaIdiomas);
  setNombre('Combobox'+inttostr(updateNumero));
  //Acá hay que crear cada propiedad y agregarla a la lista de propiedades
  // *top left width items(multiline) itemindex(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('top');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top *left width items(multiline) itemindex(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('left');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left *width items(multiline) itemindex(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('width');
  unaPropiedad.setValor('85', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width *items(multiline) itemindex(par)
  unaPropiedad := TPropiedad.Create('texto');
  unaPropiedad.setNombre('items');
  unaPropiedad.setValor(getNombre, listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width items(multiline) *itemindex(par)
  parametro := TParametro.Create('numeroEntero');
  parametro.setNombre(getNombre);
  parametro.setValor('0', listaIdiomas);
end;

function TCompComboBox.getDFM: string;
begin
  FmtStr(result,
  'object %s:TARPIComboBox Top = %s Left = %s Width = %s Items.Strings = ( ''%s'' ) ItemIndex = %s end',
  [getNombre,
  listaPropiedades.buscar('top').getDFM,
  listaPropiedades.buscar('left').getDFM,
  listaPropiedades.buscar('width').getDFM,
  StringReplace(listaPropiedades.buscar('items').getDFM, '|', #39' '#39, [rfReplaceAll]),
  parametro.getDFM]);
end;

procedure TCompComboBox.getXML(var XML: IXMLNode);
var
  componente: IXMLNode;
begin
  componente := XML.AddChild('componente');
  componente.Attributes['nombre']:= nombre;
  componente.Attributes['tipo']:= 'combobox';
  inherited getXML(componente);
end;

class function TCompComboBox.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

{
******************************* TCompHistograma ********************************
}
constructor TCompHistograma.Create(listaIdiomas: TListaIdiomas);
var
  unaPropiedad: TPropiedad;
begin
  inherited Create(listaIdiomas);
  setNombre('HistogramEq'+inttostr(updateNumero));
  // Acá hay que crear cada propiedad y agregarla a la lista de propiedades
  // *top left width height imagen:TComponenteImagen matriz:Matriz(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('top');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top *left width height imagen:TComponenteImagen matriz:Matriz(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('left');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left *width height imagen:TComponenteImagen matriz:Matriz(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('width');
  unaPropiedad.setValor('85', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width *height imagen:TComponenteImagen matriz:Matriz(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('height');
  unaPropiedad.setValor('40', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width height *imagen:TComponenteImagen matriz:Matriz(par)
  unaPropiedad := TPropiedad.Create('referenciaComponente');
  unaPropiedad.setNombre('imagen');
  unaPropiedad.setValor('', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width height imagen:TComponenteImagen *matriz:Matriz(par)
  parametro := TParametroMatriz.Create('matriz');
  TParametroMatriz(parametro).setNombre(getNombre);
  TParametroMatriz(parametro).inicializa(1, 2, 'numeroentero', '0');
end;

procedure TCompHistograma.getXML(var XML: IXMLNode);
var
  componente: IXMLNode;
begin
  componente := XML.AddChild('componente');
  componente.Attributes['nombre']:= nombre;
  componente.Attributes['tipo']:= 'histograma';
  inherited getXML(componente);
end;

class function TCompHistograma.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

{
********************************** TCompEdit ***********************************
}
constructor TCompEdit.Create(listaIdiomas: TListaIdiomas);
var
  unaPropiedad: TPropiedad;
begin
  inherited Create(listaIdiomas);
  setNombre('Edit'+inttostr(updateNumero));
    //Acá hay que crear cada propiedad y agregarla a la lista de propiedades
    //*top left width height tipo=[numero, complejo, char, string] value(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('top');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
    //top *left width height tipo=[numero, complejo, char, string] value(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('left');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
    //top left *width height tipo=[numero, complejo, char, string] value(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('width');
  unaPropiedad.setValor('85', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
    //top left width *height tipo=[numero, complejo, char, string] value(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('height');
  unaPropiedad.setValor('40', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
    //top left width height *tipo=[numero, numeroentero, complejo, char, string] value(par)
  {  unaPropiedad := TPropiedad.Create('texto');
    unaPropiedad.setNombre('tipo');
    unaPropiedad.setValor('numeroentero', listaIdiomas);
    listaPropiedades.agregar(unaPropiedad);
  }
  tipo := 'numeroentero';
    //top left width height tipo=[numero, complejo, char, string] *value(par)
  parametro := TParametro.Create(tipo);
  parametro.setNombre(getNombre);
  parametro.setValor('0', listaIdiomas);
end;

function TCompEdit.getDFM: string;
begin
  FmtStr(result,
  'object %s:TARPIEdit Top = %s Left = %s Width = %s Height = %s  Tipo = %s Text = ''%s''end',
  [getNombre,
  listaPropiedades.buscar('top').getDFM,
  listaPropiedades.buscar('left').getDFM,
  listaPropiedades.buscar('width').getDFM,
  listaPropiedades.buscar('height').getDFM,
  tipo,
  parametro.getDFM
  ]);
end;

function TCompEdit.getPropiedad(unaPropiedad, unIdioma:string): string;
begin
  if lowercase(unaPropiedad) = 'tipo' then
    result := tipo
  else
    result := inherited getPropiedad(unaPropiedad, unIdioma);
end;

procedure TCompEdit.getXML(var XML: IXMLNode);
var
  componente: IXMLNode;
begin
  componente := XML.AddChild('componente');
  componente.Attributes['nombre']:= nombre;
  componente.Attributes['tipo']:= 'edit';
  componente.Attributes['tipoParametro']:= tipo;
  inherited getXML(componente);
end;

procedure TCompEdit.setearPropiedad(unaPropiedad, nuevoValor, unIdioma:string);
begin
  if lowercase(unaPropiedad) = 'tipo' then
  begin
    tipo := nuevoValor;
    parametro.free;
    parametro := TParametro.Create(nuevoValor);
    parametro.setNombre(getNombre);
  end
  else
    inherited setearPropiedad(unaPropiedad, nuevoValor, unIdioma);
end;

procedure TCompEdit.setearPropiedad(unaPropiedad, nuevoValor:string; 
        listaIdiomas:TListaIdiomas);
begin
  if lowercase(unaPropiedad)='tipo' then
  begin
    tipo := nuevoValor;
    parametro.free;
    parametro := TParametro.Create(nuevoValor);
    parametro.setNombre(getNombre);
  end
  else
    inherited setearPropiedad(unaPropiedad, nuevoValor, listaIdiomas);
end;

procedure TCompEdit.setXML(XML: IXMLNode);
begin
  tipo := XML.Attributes['tipoParametro'];
  parametro.Create(tipo);
  inherited;
end;

class function TCompEdit.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

{
********************************* TCompGrilla **********************************
}
constructor TCompGrilla.Create(listaIdiomas: TListaIdiomas);
var
  unaPropiedad: TPropiedad;
begin
  inherited Create(listaIdiomas);
  setNombre('Grid'+inttostr(updateNumero));
  //Acá hay que crear cada propiedad y agregarla a la lista de propiedades
  //*top left width height filas columnas tipo=[numero, complejo, char] value
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('top');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //top *left width height filas columnas tipo=[numero, complejo, char] value
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('left');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //top left *width height filas columnas tipo=[numero, complejo, char] value
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('width');
  unaPropiedad.setValor('85', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //top left width *height filas columnas tipo=[numero, complejo, char] value
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('height');
  unaPropiedad.setValor('40', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //top left width height *filas columnas tipo=[numero, complejo, char] value
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('filas');
  unaPropiedad.setValor('3', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //top left width height filas *columnas tipo=[numero, complejo, char] value
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('columnas');
  unaPropiedad.setValor('3', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //top left width height filas columnas *tipo=[numero, numeroentero, complejo, char] value
  unaPropiedad := TPropiedad.Create('texto');
  unaPropiedad.setNombre('tipo');
  unaPropiedad.setValor('numeroentero', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //top left width height filas columnas tipo=[numero, numeroentero, complejo, char] *value
  parametro := TParametro.Create('numeroentero');
  parametro.setNombre(getNombre);
  parametro.setValor('0', listaIdiomas);
end;

procedure TCompGrilla.getXML(var XML: IXMLNode);
var
  componente: IXMLNode;
begin
  componente := XML.AddChild('componente');
  componente.Attributes['nombre']:= nombre;
  componente.Attributes['tipo']:= 'grilla';
  inherited getXML(componente);
end;

procedure TCompGrilla.setearPropiedad(unaPropiedad, nuevoValor, 
        unIdioma:string);
begin
  inherited setearPropiedad(unaPropiedad, nuevoValor, unIdioma);
  if lowercase(unaPropiedad)='tipo' then
  begin
    parametro.free;
    parametro := TParametro.Create(nuevoValor);
    parametro.setNombre('value');
    parametro.setValor('', unIdioma);
  end;
end;

procedure TCompGrilla.setearPropiedad(unaPropiedad, nuevoValor:string; 
        listaIdiomas:TListaIdiomas);
begin
  inherited setearPropiedad(unaPropiedad, nuevoValor, listaIdiomas);
  if lowercase(unaPropiedad)='tipo' then
  begin
    parametro.free;
    parametro := TParametro.Create(nuevoValor);
    parametro.setNombre('value');
    parametro.setValor('', listaIdiomas);
  end;
end;

class function TCompGrilla.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

{
********************************* TCompImagen **********************************
}
constructor TCompImagen.Create(listaIdiomas: TListaIdiomas);
var
  unaPropiedad: TPropiedad;
begin
  inherited Create(listaIdiomas);
  setNombre('Image'+inttostr(updateNumero));
  //Acá hay que crear cada propiedad y agregarla a la lista de propiedades
  //*top left width value:Referencia
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('top');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //top *left width value:Referencia
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('left');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //top left *width value:Referencia
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('width');
  unaPropiedad.setValor('85', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //top left width *value:Referencia
  parametro := TParametro.Create('referenciaEstructuraImagen');
  parametro.setNombre(getNombre);
end;

function TCompImagen.getDFM: string;
begin
  FmtStr(result,
  'object %s:TARPIImagen Top = %s Left = %s Width = %s Text= ''%s'' end',
  [getNombre,
  listaPropiedades.buscar('top').getDFM,
  listaPropiedades.buscar('left').getDFM,
  listaPropiedades.buscar('width').getDFM,
  getNombre]);
end;

procedure TCompImagen.getXML(var XML: IXMLNode);
var
  componente: IXMLNode;
begin
  componente := XML.AddChild('componente');
  componente.Attributes['nombre']:= nombre;
  componente.Attributes['tipo']:= 'imagen';
  inherited getXML(componente);
end;

class function TCompImagen.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

{
********************************** TCompLabel **********************************
}
constructor TCompLabel.Create(listaIdiomas: TListaIdiomas);
var
  unaPropiedad: TPropiedad;
begin
  inherited Create(listaIdiomas);
  setNombre('Label'+inttostr(updateNumero));
    //Acá hay que crear cada propiedad y agregarla a la lista de propiedades
  //  *top left width height caption
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('top');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //  top *left width height caption
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('left');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //  top left *width height caption
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('width');
  unaPropiedad.setValor('85', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //  top left width *height caption
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('height');
  unaPropiedad.setValor('13', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //  top left width height *caption
  unaPropiedad := TPropiedad.Create('texto');
  unaPropiedad.setNombre('caption');
  {TODO: ver como inicializar}
  unaPropiedad.setValor(getNombre{esp='+getNombre+'|eng='+getNombre}, listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
end;

function TCompLabel.getDFM: string;
begin
    FmtStr(result,
    ' object %s:TARPILabel Top = %s Left = %s Width = %s Height = %s Caption = ''%s'' end',
    [getNombre,
    listaPropiedades.buscar('top').getDFM,
    listaPropiedades.buscar('left').getDFM,
    listaPropiedades.buscar('width').getDFM,
    listaPropiedades.buscar('height').getDFM,
    listaPropiedades.buscar('caption').getDFM
  ]);
end;

procedure TCompLabel.getXML(var XML: IXMLNode);
var
  componente: IXMLNode;
begin
  componente := XML.AddChild('componente');
  componente.Attributes['nombre']:= nombre;
  componente.Attributes['tipo']:= 'label';
  inherited getXML(componente);
end;

procedure TCompLabel.setearPropiedad(unaPropiedad, nuevoValor, unIdioma:string);
begin
  {  if lowercase(unaPropiedad)='name' then
      if parametro.getNombre = parametro.getValor(unIdioma) then
         parametro.setValor(nuevoValor, unIdioma);}
  inherited setearPropiedad(unaPropiedad, nuevoValor, unIdioma);
end;

procedure TCompLabel.setearPropiedad(unaPropiedad, nuevoValor:string; 
        listaIdiomas:TListaIdiomas);
var
  idioma: TIdioma;
begin
  if lowercase(unaPropiedad)='nombre' then
  begin
    idioma := listaIdiomas.primero;
    while Assigned(idioma) and (parametro.getNombre = parametro.getValor(idioma.getCodigo)) do
      idioma := listaIdiomas.siguiente;
    if Assigned(idioma) then
      parametro.setValor(nuevoValor, idioma.getCodigo);
  end;
  inherited setearPropiedad(unaPropiedad, nuevoValor, listaIdiomas);
end;

class function TCompLabel.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

{
********************************* TCompListBox *********************************
}
constructor TCompListBox.Create(listaIdiomas: TListaIdiomas);
var
  unaPropiedad: TPropiedad;
begin
  inherited Create(listaIdiomas);
  setNombre('ListBox'+inttostr(updateNumero));
  //Acá hay que crear cada propiedad y agregarla a la lista de propiedades
  // *top left height width items(multiline) itemindex(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('top');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top *left height width items(multiline) itemindex(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('left');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left *height width items(multiline) itemindex(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('height');
  unaPropiedad.setValor('21', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left height *width items(multiline) itemindex(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('width');
  unaPropiedad.setValor('85', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left height width *items(multiline) itemindex(par)
  unaPropiedad := TPropiedad.Create('texto');
  unaPropiedad.setNombre('items');
  unaPropiedad.setValor(getNombre, listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left height width items(multiline) *itemindex(par)
  parametro := TParametro.Create('numeroEntero');
  parametro.setNombre(getNombre);
  parametro.setValor('0', listaIdiomas);
end;

function TCompListBox.getDFM: string;
begin
  FmtStr(result,
  'object %s:TARPIListbox Top = %s Left = %s Width = %s Height = %s Items.Strings = (''%s'') ItemIndex = %s end',
  [getNombre,
  listaPropiedades.buscar('top').getDFM,
  listaPropiedades.buscar('left').getDFM,
  listaPropiedades.buscar('width').getDFM,
  listaPropiedades.buscar('height').getDFM,
  StringReplace(listaPropiedades.buscar('items').getDFM, '|', #39' '#39, [rfReplaceAll]),
  parametro.getDFM]);
end;

procedure TCompListBox.getXML(var XML: IXMLNode);
var
  componente: IXMLNode;
begin
  componente := XML.AddChild('componente');
  componente.Attributes['nombre']:= nombre;
  componente.Attributes['tipo']:= 'listbox';
  inherited getXML(componente);
end;

class function TCompListBox.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

{
********************************* TCompMatriz **********************************
}
constructor TCompMatriz.Create(listaIdiomas: TListaIdiomas);
var
  unaPropiedad: TPropiedad;
begin
  inherited Create(listaIdiomas);
  setNombre('Matrix'+inttostr(updateNumero));
  //Acá hay que crear cada propiedad y agregarla a la lista de propiedades
  //*top left width value:Referencia
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('top');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //top *left width value:Referencia
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('left');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //top left *width value:Referencia
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('width');
  unaPropiedad.setValor('85', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  //top left width *value:Referencia
  parametro := TParametro.Create('referenciaEstructuraMatriz');
  parametro.setNombre(getNombre);
end;

function TCompMatriz.getDFM: string;
begin
  FmtStr(result,
  'object %s:TARPIMatriz Top = %s Left = %s Width = %s Text = ''%s'' end',
  [getNombre,
  listaPropiedades.buscar('top').getDFM,
  listaPropiedades.buscar('left').getDFM,
  listaPropiedades.buscar('width').getDFM,
  getNombre]);
end;

procedure TCompMatriz.getXML(var XML: IXMLNode);
var
  componente: IXMLNode;
begin
  componente := XML.AddChild('componente');
  componente.Attributes['nombre']:= nombre;
  componente.Attributes['tipo']:= 'matriz';
  inherited getXML(componente);
end;

class function TCompMatriz.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

{
**************************** TCompMinMaxHistograma *****************************
}
constructor TCompMinMaxHistograma.Create(listaIdiomas: TListaIdiomas);
var
  unaPropiedad: TPropiedad;
begin
  inherited Create(listaIdiomas);
  setNombre('HistogramMinMax'+inttostr(updateNumero));
  // Acá hay que crear cada propiedad y agregarla a la lista de propiedades
  // *top left width height imagen:TComponenteImagen matriz:Matriz(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('top');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top *left width height imagen:TComponenteImagen matriz:Matriz(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('left');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left *width height imagen:TComponenteImagen matriz:Matriz(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('width');
  unaPropiedad.setValor('85', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width *height imagen:TComponenteImagen matriz:Matriz(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('height');
  unaPropiedad.setValor('40', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width height *imagen:TComponenteImagen matriz:Matriz(par)
  unaPropiedad := TPropiedad.Create('referenciaComponente');
  unaPropiedad.setNombre('imagen');
  unaPropiedad.setValor('', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width height imagen:TComponenteImagen *matriz:Matriz(par)
  parametro := TParametroMatriz.Create('matriz');
  TParametroMatriz(parametro).setNombre(getNombre);
  TParametroMatriz(parametro).inicializa(1, 2, 'numeroentero', '0');
end;

procedure TCompMinMaxHistograma.getXML(var XML: IXMLNode);
var
  componente: IXMLNode;
begin
  componente := XML.AddChild('componente');
  componente.Attributes['nombre']:= nombre;
  componente.Attributes['tipo']:= 'minmaxhistograma';
  inherited getXML(componente);
end;

class function TCompMinMaxHistograma.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

{
******************************* TCompRadioGroup ********************************
}
constructor TCompRadioGroup.Create(listaIdiomas: TListaIdiomas);
var
  unaPropiedad: TPropiedad;
begin
  inherited Create(listaIdiomas);
  setNombre('RadioGroup'+inttostr(updateNumero));
  //Acá hay que crear cada propiedad y agregarla a la lista de propiedades
  // *top left height width items(multiline) itemindex(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('top');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top *left height width items(multiline) itemindex(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('left');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left *height width items(multiline) itemindex(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('height');
  unaPropiedad.setValor('21', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left height *width items(multiline) itemindex(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('width');
  unaPropiedad.setValor('85', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width height *caption items(multiline) itemindex(par)
  unaPropiedad := TPropiedad.Create('texto');
  unaPropiedad.setNombre('caption');
  unaPropiedad.setValor(getNombre, listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width height caption *items(multiline) itemindex(par)
  unaPropiedad := TPropiedad.Create('texto');
  unaPropiedad.setNombre('items');
  unaPropiedad.setValor(getNombre, listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width height caption items(multiline) *itemindex(par)
  parametro := TParametro.Create('numeroentero');
  parametro.setNombre('itemindex');
  parametro.setValor('-1', listaIdiomas);
end;

function TCompRadioGroup.getDFM: string;
begin
  FmtStr(result,
  'object %s:TARPIRadioGroup Caption = ''%s'' Top = %s Left = %s Width = %s Height = %s Items.Strings = (''%s'') ItemIndex = %s end',
  [getNombre,
  listaPropiedades.buscar('caption').getDFM,
  listaPropiedades.buscar('top').getDFM,
  listaPropiedades.buscar('left').getDFM,
  listaPropiedades.buscar('width').getDFM,
  listaPropiedades.buscar('height').getDFM,
  StringReplace(listaPropiedades.buscar('items').getDFM, '|', #39' '#39, [rfReplaceAll]),
  parametro.getDFM]);
end;

procedure TCompRadioGroup.getXML(var XML: IXMLNode);
var
  componente: IXMLNode;
begin
  componente := XML.AddChild('componente');
  componente.Attributes['nombre']:= nombre;
  componente.Attributes['tipo']:= 'radiogroup';
  inherited getXML(componente);
end;

class function TCompRadioGroup.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

{
********************************* TCompSlider **********************************
}
constructor TCompSlider.Create(listaIdiomas: TListaIdiomas);
var
  unaPropiedad: TPropiedad;
begin
  inherited Create(listaIdiomas);
  setNombre('Slider'+inttostr(updateNumero));
  //Acá hay que crear cada propiedad y agregarla a la lista de propiedades
  // *top left width height min max paso value(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('top');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top *left width height min max paso value(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('left');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left *width height min max paso value(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('width');
  unaPropiedad.setValor('85', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width *height min max paso value(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('height');
  unaPropiedad.setValor('40', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width height *min max paso value(par)
  unaPropiedad := TPropiedad.Create('numero');
  unaPropiedad.setNombre('min');
  unaPropiedad.setValor('0', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width height min *max paso value(par)
  unaPropiedad := TPropiedad.Create('numero');
  unaPropiedad.setNombre('max');
  unaPropiedad.setValor('100', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width height min max *paso value(par)
  unaPropiedad := TPropiedad.Create('numero');
  unaPropiedad.setNombre('paso');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width height min max paso value(par)
  parametro := TParametro.Create('numero');
  parametro.setNombre(getNombre);
  parametro.setValor('0', listaIdiomas);
end;

procedure TCompSlider.getXML(var XML: IXMLNode);
var
  componente: IXMLNode;
begin
  componente := XML.AddChild('componente');
  componente.Attributes['nombre']:= nombre;
  componente.Attributes['tipo']:= 'slider';
  inherited getXML(componente);
end;

class function TCompSlider.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

{
***************************** TCompValorHistograma *****************************
}
constructor TCompValorHistograma.Create(listaIdiomas: TListaIdiomas);
var
  unaPropiedad: TPropiedad;
begin
  inherited Create(listaIdiomas);
  setNombre('HistogramValue'+inttostr(updateNumero));
  // Acá hay que crear cada propiedad y agregarla a la lista de propiedades
  // *top left width height imagen:TComponenteImagen matriz:Matriz(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('top');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top *left width height imagen:TComponenteImagen matriz:Matriz(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('left');
  unaPropiedad.setValor('1', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left *width height imagen:TComponenteImagen matriz:Matriz(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('width');
  unaPropiedad.setValor('85', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width *height imagen:TComponenteImagen matriz:Matriz(par)
  unaPropiedad := TPropiedad.Create('numeroentero');
  unaPropiedad.setNombre('height');
  unaPropiedad.setValor('40', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width height *imagen:TComponenteImagen matriz:Matriz(par)
  unaPropiedad := TPropiedad.Create('referenciaComponente');
  unaPropiedad.setNombre('imagen');
  unaPropiedad.setValor('', listaIdiomas);
  listaPropiedades.agregar(unaPropiedad);
  // top left width height imagen:TComponenteImagen *matriz:Matriz(par)
  parametro := TParametroMatriz.Create('numeroentero');
  parametro.setNombre(getNombre);
  parametro.setValor('-1', listaIdiomas);
end;

procedure TCompValorHistograma.getXML(var XML: IXMLNode);
var
  componente: IXMLNode;
begin
  componente := XML.AddChild('componente');
  componente.Attributes['nombre']:= nombre;
  componente.Attributes['tipo']:= 'valorhistograma';
  inherited getXML(componente);
end;

class function TCompValorHistograma.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

{ TPropiedad }

{
********************************** TPropiedad **********************************
}
procedure TPropiedad.getXML(var XML: IXMLNode);
var
  aux: IXMLNode;
begin
  aux:=XML.AddChild('propiedad');
  inherited getXML(aux);
end;

{ TListaClasesComponentes }

{
*************************** TListaClasesComponentes ****************************
}
function TListaClasesComponentes.agregar(nombreClase:string; 
        unaClase:TClaseComponente): Integer;
begin
  inherited agregar(nombreClase, unaClase);
end;

function TListaClasesComponentes.buscar(nombreClase:string): TClaseComponente;
var
  aux: TClass;
begin
  aux:= inherited buscar(nombreClase);
  if assigned(aux) then
    result := TClaseComponente(aux)
  else
    result := nil;
end;

function TListaClasesComponentes.existe(unaClase:string): Boolean;
begin
  result := inherited existe(unaClase);
end;

procedure TListaClasesComponentes.insertar(nombreClase:string; 
        unaClase:TClaseComponente; index: integer);
begin
  inherited insertar(nombreClase, unaClase, index);
end;

end.
