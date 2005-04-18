unit uEntornoEjecucion;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, uLista, uTipos, uAlgoritmo, uIdiomas, uPortapapeles,
  uComponentes, uReferencia, uSatelite, ComCtrls, XMLIntf, XMLDOc, uConsts,
  Contnrs, GR32, GR32_Bytemaps, GR32_Image;

type
  TNotifyActualizarAlgoritmo = procedure (algoritmo:string) of object;
  TCategoria = class;
  TBuscadorSatelites = class (TObject)
  public
    procedure buscarSatelites(parametrosDeBusqueda: string);
  end;
  
  TListaEstructuras = class (TLista)
  public
    procedure agregar(unaEstructura: TEstructura);
    function buscar(unaEstructura:string): TEstructura;
    function primero: TEstructura;
    function quitarEstructura(unaEstructura: string): TEstructura;
    function siguiente: TEstructura;
    procedure _agregarMatriz(unaMatriz:integer);
    function _buscarMatriz(unaMatriz:integer): TMatriz;
  end;
  
  TListaCategorias = class (TLista)
  public
    procedure agregar(unaCategoria: TCategoria);
    function buscar(unaCategoria:string): TCategoria;
    function extraer(unaCategoria:integer): TCategoria;
    procedure limpiar;
    function primero: TCategoria;
    function siguiente: TCategoria;
  end;
  
  {{
  El idioma se lo tiene q mandar el entornoEjecucion?
  El idioma por defecto lo almacena este?
  El nombre es una descripcion ingresada por el usuario?
  Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre, 
  md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
  el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
  }
  TNodoAlgoritmo = class (TObject)
  private
    id: string;
    idioma: TIdioma;
    nombre: string;
    ubicacion: string;
    class function updateNumero(numero:integer = -1): Word;
  public
    constructor Create(unaUbicacion: String);
    destructor Destroy; override;
    function abrir: TAlgoritmo;
    procedure getArbol(Arbol: TTreeNodes; Padre: TTreeNode);
    function getNombre: string;
    function getUbicacion: string;
    procedure getXML(XML: IXMLNode);
    procedure getXMLNombre(XML: IXMLNode);
    procedure guardarConfiguracion(unAlgoritmo: TAlgoritmo);
    procedure setIdioma(unIdioma: TIdioma);
    procedure setNombre(unNombre: string);
    procedure setXML(XML: IXMLNode);
  end;
  
  TListaNodosAlgoritmos = class (TLista)
  public
    procedure agregar(unAlgoritmo:TNodoAlgoritmo);
    function buscar(unAlgoritmo:string): TNodoAlgoritmo;
    procedure getXML(XML: IXMLNode);
    procedure limpiar;
    function primero: TNodoAlgoritmo;
    procedure reset;
    function siguiente: TNodoAlgoritmo;
  end;
  
  TCategoria = class (TObject)
  private
    idCategoria: Integer;
    listaAlgoritmos: TListaNodosAlgoritmos;
    listaCategorias: TListaCategorias;
    nombre: string;
    procedure getSubArbol(Arbol: TTreeNodes; Padre: TTreeNode);
    procedure getXMLInt(XML: IXMLNode);
    procedure guardarHijos(nArbol: TTreeNode; nodoCat: TCategoria);
    procedure setXMLInt(XML: IXMLNode;unaListaAlgoritmos: 
            TListaNodosAlgoritmos);
  public
    constructor Create;
    destructor Destroy; override;
    procedure abrir;
    procedure agregar(unaCategoria:integer);
    procedure agregarAlgoritmo(unAlgoritmo:TNodoAlgoritmo);
    function agregarAlgoritmoACategoria(unAlgoritmo:TNodoAlgoritmo; 
            unaCategoria:string; terminado: boolean = false): Boolean;
    procedure agregarCategoria(unaCategoria: TCategoria);
    procedure borrarCategoria(unaCategoria: integer; terminado: boolean = 
            false);
    function buscar(unaCategoria:integer): TCategoria;
    procedure copiarArbol(arbolOrigen: TTreeNodes; unaListaAlgoritmos: 
            TListaNodosAlgoritmos);
    procedure copiarSubArbol(subArbol: TTreeNode; unaListaAlgoritmos: 
            TListaNodosAlgoritmos);
    procedure crearCategoria(nombreCategoria:string; categoriaPadre:integer; 
            terminado: boolean = false);
    function Extraer(unaCategoria:integer): TCategoria;
    procedure getArbol(Arbol: TTreeNodes);
    function getCategoria: string;
    function getNombre: string;
    procedure getXML(XML: IXMLNode);
    procedure limpiar;
    procedure moverCategoria(unaCategoria:integer ; categoriaDestino:integer);
    function otraCategoria(nombreCategoria:string): Boolean;
    function quitarAlgoritmo(unAlgoritmo:string): Boolean;
    function quitarAlgoritmoCategoria(unAlgoritmo: string; unaCategoria: 
            string): Boolean;
    procedure renombrar(unaCategoria: integer; nombreCategoria:string; 
            terminado: boolean = false);
    procedure setArbol(arbol: TTreeNodes);
    procedure SetIdCategoria(unIdCategoria:string);
    procedure setNombre(unNombre:String);
    procedure setXML(XML: IXMLNode; unaListaAlgoritmos: TListaNodosAlgoritmos);
  end;
  
  TControlListaDePasos = class (TObject)
  private
    listaPasos: TObjectList;
    listaSecuencias: TListaSecuencias;
    function buscarPaso(unPaso: string): TPaso;
  public
    constructor Create;
    destructor Destroy; override;
    procedure abrirListaPasos(NombreListaPasos: string; mantener:boolean=false);
    procedure abrirListaReferencias(unPaso, unParametro, 
            nombreListaReferencias: string);
    procedure actualizarPaso(unPaso: string; unaListaParametros: 
            TListaParametros);
    procedure agregarListaPasos(NombreListaPasos: string);
    procedure agregarListaReferencias(unPaso, unParametro, 
            nombreListaReferencias: string);
    procedure agregarReferenciaALista(unPaso, unParametro, unValor: string);
    procedure crearPaso(unaListaParametros: TListaParametros; unaUbicacion, 
            unComentario:string);
    procedure duplicarPaso(unPaso: string);
    procedure duplicarPasoPosicion(posicion: integer);
    procedure ejecutar(ubicacionSalida, formatoSalida: string);
    procedure eliminarPaso(unPaso: string);
    procedure eliminarPasoPosicion(posicion:integer);
    procedure eliminarReferenciaDeLista(unPaso, unParametro, unaReferencia: 
            string);
    function getComentarioPasoPosicion(Posicion: integer): string;
    function getDescListaPasos: TStringList;
    procedure guardarListaPasos(NombreListaPasos: string);
    procedure guardarListaReferencias(unPaso, unParametro, 
            nombreListaReferencias: string);
    procedure moverPaso(unPaso: string; nuevaPosicion: integer);
    procedure setComentarioPasoPosicion(Posicion:integer; 
            nuevoComentario:string);
  end;
  
  TControladorProcesamiento = class (TObject)
  private
    listaDisponibles: TListaProcesadores;
    listaNoDisponibles: TListaProcesadores;
  public
    constructor Create;
    procedure agregarProcesador(unProcesador:TProcesador);
    procedure agregarProcesadorError(unProcesador: TProcesador);
    procedure agregarProcesadores(unaListaSatelites: TListaProcesadores);
    function getProcesador: TProcesador;
  end;
  
  {{
  Que paso con la lista de resultados?
  }
  TOrganizadorEjecucion = class (TObject)
  private
    controladorProcesamiento: TControladorProcesamiento;
    estado: Integer;
    interrumpir: Boolean;
    listaAcciones: TListaAccion;
    listaAccionesPendientes: TListaAccion;
    procedure ejecutar;
  protected
    constructor CreateInstance;
    class function AccessInstance(Request: Integer): TOrganizadorEjecucion;
  public
    constructor Create;
    destructor Destroy; override;
    procedure detenerEjecucion;
    procedure ejecutarAccion(unaAccion:TAccion);
    procedure errorEjecucion(IDAccion:string);
    procedure finEjecucion(IDAccion: string; 
            unaListaResultados:TListaParametros);
    function getEstado: Integer;
    class function Instance: TOrganizadorEjecucion;
    procedure interrumpirEjecucion;
    procedure reanudarEjecucion;
    class procedure ReleaseInstance;
    procedure setControl(unControladorProcesamiento: TControladorProcesamiento);
    procedure setestado(estado:integer);
  end;
  
  TEntornoEjecucion = class (TObject)
  private
    builderIdioma: TControlIdiomas;
    cantidadProcesadoresLocales: Integer;
    control: TControladorProcesamiento;
    criterioIdioma: string;
    DirectorioAlgoritmos: string;
    DirectorioTrabajo: string;
    FControlListaDePasos: TControlListaDePasos;
    FonRefresh: TNotifyActualizarAlgoritmo;
    IdiomaActual: TIdioma;
    listaAlgoritmos: TListaNodosAlgoritmos;
    listaAlgoritmosAbiertos: TListaAlgoritmos;
    listaCategorias: TCategoria;
    listaDePasos: TControlListaDePasos;
    listaEstructuras: TListaEstructuras;
    listaIdiomas: TListaIdiomas;
    listaProcesadoresLocales: TListaProcesadores;
    listaProcesadoresRemotos: TListaProcesadores;
    listaReferencias: TListaReferencias;
    organizadorEjecucion: TOrganizadorEjecucion;
    portapapeles: Tportapapeles;
    respetarIdiomaEntorno: Boolean;
    procedure SetControlListaDePasos(Value: TControlListaDePasos);
  protected
    constructor CreateInstance;
    class function AccessInstance(Request: Integer): TEntornoEjecucion;
  public
    constructor Create;
    destructor Destroy; override;
    function abrirAlgoritmo(unAlgoritmo: string): AnsiString;
    function abrirImagen(nombreImagen:string): TBitmap32;
    procedure abrirListaPasos(NombreListaPasos: string);
    procedure abrirListaReferencias(unPaso, unParametro, 
            nombreListaReferencias: string);
    function abrirMatriz(nombreMatriz:string): string;
    function abrirPaso(unPaso: string): AnsiString;
    procedure actualizarListaCategorias(arbol: TTreeNodes);
    procedure actualizarPaso(unAlgoritmo, unPaso:string);
    function adquirirImagen(imagen:TBitmap32): string;
    procedure agregarAlgoritmoACategoria(unAlgoritmo, unaCategoria: string);
    procedure agregarListaPasos(NombreListaPasos: string);
    procedure agregarListaReferencias(unPaso, unParametro, 
            nombreListaReferencias: string);
    procedure agregarRefenciaALista(unPaso, unParametro, unValor: string);
    procedure agregarSatelite(unNombre, direccionDeConexion: string);
    procedure agregarVinculacionAComponente(unAlgoritmo, unComponente, 
            unaReferencia: string);
    procedure almacenarPaso(unAlgoritmo , unComentario: string);
    procedure borrarCategoria(unaCategoria: integer);
    procedure buscarSatelites(parametrosDeBusqueda:string);
    procedure cambiarIdiomaAlgoritmo(unAlgoritmo, unIdioma: string);
    procedure cambiarIdiomaAlgoritmos(unIdioma: string);
    procedure cambiarIdiomaEjecucion(unIdioma:string);
    function cantidadColumnasMatriz(IDM:string): Integer;
    function cantidadFilasMatriz(IDM: string): Integer;
    procedure cerrarAlgoritmo(unAlgoritmo: string);
    procedure cerrarMatriz(unaMatriz: string);
    procedure configurarDirectorioAlgoritmos(unaUbicacion: string);
    procedure configurarDirectorioTrabajoEjecucion(unaUbicacion: string);
    procedure configurarDirectorioTrabajoSatelite(unaUbicacion: string);
    procedure copiarAlgoritmoACategoria(unAlgoritmo, unaCategoria: string);
    procedure copiarArbol(arbolOrigen: TTreeNodes);
    procedure copiarImagen(unaImagen:string);
    procedure copiarMatriz(unaMatriz: string; unaFilaIncial, unaFilaFinal, 
            unaColumnaIncial, unaColumnaFinal: integer);
    function cortarImagen(unaImagen: string): Boolean;
    procedure cortarMatriz(unaMatriz: string; unaFilaInicial, unaFilaFinal, 
            unaColumnaInicial, unaColumnaFinal: integer);
    procedure crearCategoria(nombreCategoria:string; categoriaPadre:integer);
    function crearMatriz(nroFilas, nroColumnas: integer; tipoDato, 
            valorInicial: string): string;
    procedure deshacerImagen(unaImagen: string);
    procedure deshacerMatriz(unaMatriz: string);
    procedure detenerEjecucion;
    procedure duplicarPaso(unPaso: string);
    procedure duplicarPasoPosicion(Posicion: integer);
    procedure ejecutarAlgoritmo(unAlgoritmo: string);
    procedure ejecutarListaPasos(tipoControl, ubicacionSalida, formatoSalida: 
            string);
    procedure eliminarColumnas(unaMatriz: string; columnaIncial, columnaFinal: 
            integer);
    procedure eliminarFilas(unaMatriz: string; filaIncial, filaFinal: integer);
    procedure eliminarPaso(unPaso: string);
    procedure eliminarPasoPosicion(posicion: integer);
    procedure eliminarRefenciaDeLista(unPaso, unParametro, unaReferencia: 
            string);
    procedure eliminarSatelite(nombreSatelite: string);
    procedure getArbol(Arbol: TTreeNodes);
    function getComentarioPasoPosicion(Posicion:integer): string;
    function GetControlListaDePasos: TControlListaDePasos;
    function getDescAlgoritmo(unAlgoritmo:string): string;
    function getDescListaPasos: TStringList;
    function getDirectorioAlgoritmos: string;
    function getDirectorioTrabajo: string;
    function getEstado: Integer;
    function getIdiomaAlgoritmo(unAlgoritmo:string): string;
    function getImagen(unaImagen:string): TImagen;
    procedure getListaAlgoritmos(lista: TListItems);
    function getListaIdiomasAlgoritmo(unAlgoritmo:string): TStringList;
    function getListaImagenes: TStrings;
    function getListaMatrices: TStrings;
    function getMatriz(unaMatriz: string): uTipos.TMString;
    function getTipoDatoMatriz(IDMatriz:string): string;
    function getValorInicialMatriz(IDMatriz:string): string;
    function getValorParametro(unAlgoritmo, unComponente, unIdioma:string): 
            string;
    procedure guardarImagen(unaImagen, nombreImagen: string);
    procedure guardarListaPasos(NombreListaPasos: string);
    procedure guardarListaReferencias(unPaso, unParametro, 
            nombreListaReferencias: string);
    procedure guardarMatriz(unaMatriz, nombreMatriz: string);
    procedure guardarVector(unVector, nombreVector: string);
    procedure imprimirImagen(unaImagen: string);
    procedure imprimirMatriz(unaMatriz: string);
    procedure imprimirVector(unVector: string);
    procedure ingregarValor(unAlgoritmo, unComponente, unValor: string);
    procedure ingresarValor(unAlgoritmo, unComponente, unValor: string);
    procedure insertarColumnas(unaMatriz: string; columnaInicial, 
            cantidadColumnas: integer);
    procedure insertarFilas(unaMatriz: string; filaInicial, cantidadFilas: 
            integer);
    class function Instance: TEntornoEjecucion;
    procedure interrumpirEjecucion;
    procedure modificarCeldaMatriz(unaMatriz: string; unaFila, unaColumna: 
            integer; unValor: string);
    function mostrarFormularioAlgoritmo(unAlgoritmo:string): WideString;
    procedure moverAlgoritmoACategoria(unAlgoritmo, categoriaOrigen, 
            categoriaDestino: string);
    procedure moverCategoria(unaCategoria:integer ; categoriaDestino:integer);
    procedure moverPaso(unPaso: string; nuevaPosicion: integer);
    procedure nuevaListaPasos;
    procedure pegarComoImagen;
    procedure pegarImagen(unaImagen: string; unaPosicion: TPoint);
    procedure pegarMatriz(unaMatriz: string; unaFilaIncial, unaFilaFinal, 
            unaColumnaInicial, unaColumnaFinal: integer);
    procedure quitarAlgoritmodeCategoria(unAlgoritmo, unaCategoria: string);
    procedure quitarImagen(unaImagen: string);
    procedure quitarVinculacionAComponente(unAlgoritmo, unComponente: string);
    procedure reanudarEjecucion;
    procedure rechacerMatriz(unaMatriz: string);
    procedure refrescarListados(unaListaAlgoritmos, unaListaCategorias: 
            IXMLNode);
    procedure rehacerImagen(unaImagen: string);
    procedure rehacerMatriz(unaMatriz: string);
    procedure reinicializarMatriz(IDMatriz: string; Filas,Columnas: integer; 
            TipoDato, ValorInicial: string);
    class procedure ReleaseInstance;
    procedure renombrarCategoria(unaCategoria:integer; nombreCategoria:string);
    procedure setComentarioPasoPosicion(Posicion: integer; nuevoComentario: 
            string);
    procedure setestado(estado:integer);
    function tieneDeshacerMatriz(IDMatriz:string): Boolean;
    function tieneRehacerMatriz(IDMatriz:string): Boolean;
    property ControlListaDePasos: TControlListaDePasos read 
            FControlListaDePasos write SetControlListaDePasos;
    property onRefresh: TNotifyActualizarAlgoritmo read FonRefresh write 
            FonRefresh;
  end;
  
  TReferenciaEstructura = class (TReferencia)
  private
    estructura: TEstructura;
  public
    procedure setValor(unValor, unIdioma: string); override;
    procedure setXML(XML: IXMLNode); override;
  end;
  
  TReferenciaEstructuraMatriz = class (TReferenciaEstructura)
  public
    procedure getXML(var XML: IXMLNode); override;
  end;
  
  TReferenciaEstructuraImagen = class (TReferenciaEstructura)
  public
    procedure getXML(var XML: IXMLNode); override;
  end;
  
  TReceptorResultados = class (TObject)
  private
    organizadorEjecucion: TOrganizadorEjecucion;
  public
    procedure finEjecucion(IDAccion: string; listaResultados:TListaParametros);
  end;
  

procedure Register;

implementation

procedure Register;
begin
end;

{
****************************** TListaEstructuras *******************************
}
procedure TListaEstructuras.agregar(unaEstructura: TEstructura);
begin
  inherited agregar(unaEstructura);
end;

function TListaEstructuras.buscar(unaEstructura:string): TEstructura;
var
  aux: TEstructura;
begin
  aux := TEstructura(inherited primero);
  while Assigned(aux) and (aux.getNombre <> unaEstructura) do
    aux := TEstructura(inherited siguiente);
  result:=aux;
end;

function TListaEstructuras.primero: TEstructura;
var
  aux: TObject;
begin
  aux:=inherited primero;
  if Assigned(aux) then
    result:=TEstructura(aux)
  else
    result := nil;
end;

function TListaEstructuras.quitarEstructura(unaEstructura: string): TEstructura;
begin
  
end;

function TListaEstructuras.siguiente: TEstructura;
var
  aux: TObject;
begin
  aux:=inherited siguiente;
  if Assigned(aux) then
    result:=TEstructura(aux)
  else
    result := nil;
end;

procedure TListaEstructuras._agregarMatriz(unaMatriz:integer);
begin
end;

function TListaEstructuras._buscarMatriz(unaMatriz:integer): TMatriz;
begin
end;


{
****************************** TBuscadorSatelites ******************************
}
procedure TBuscadorSatelites.buscarSatelites(parametrosDeBusqueda: string);
begin
  {TODO: Definir como vamos a buscar los satelites}
end;

{
******************************* TListaCategorias *******************************
}
procedure TListaCategorias.agregar(unaCategoria: TCategoria);
begin
  inherited agregar(unaCategoria);
end;

function TListaCategorias.buscar(unaCategoria:string): TCategoria;
var
  aux: TCategoria;
begin
  aux := primero;
  while Assigned(aux) and (aux.getNombre <> unaCategoria) do
    aux := siguiente;
  result:=aux;
end;

function TListaCategorias.extraer(unaCategoria:integer): TCategoria;
begin
end;

procedure TListaCategorias.limpiar;
  
  //var
  //  nodoCaT: TCategoria;
  
begin
  vaciar;
  
  {  nodoCat := primero;
    while nodoCaT <> nil do
    begin
      nodoCaT.limpiar;
      nodoCaT.Free;
      nodoCaT := siguiente;
    end;
   }
    {TODO: HACER!}
end;

function TListaCategorias.primero: TCategoria;
var
  aux: TObject;
begin
  aux:=inherited primero;
  if Assigned(aux) then
    result :=TCategoria(aux)
  else
    result := nil;
end;

function TListaCategorias.siguiente: TCategoria;
var
  aux: TObject;
begin
  aux:=inherited siguiente;
  if Assigned(aux) then
    result :=TCategoria(aux)
  else
    result := nil;
end;



{{
El idioma se lo tiene q mandar el entornoEjecucion?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre,
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{{
El idioma se lo tiene q mandar el entornoEjecucion?
El idioma por defecto lo almacena este?
El nombre es una descripcion ingresada por el usuario?
Md5? si estan duplicadas? seria archivo+md5? --> si archivo cambia de nombre, 
md5 no lo identifica (xq es nombre+md5), entonces vale la pena md5?
el idioma lo almaceno... q uso? 'esp', etc, o numero q tendria q ser fijo?
}
{
******************************** TNodoAlgoritmo ********************************
}
constructor TNodoAlgoritmo.Create(unaUbicacion: String);
var
  HandleDLL: THandle;
  
  nom : function: PChar; stdcall;
  //  nom : function: PChar; stdcall; //es necesario y no lo acepta el modelmaker!
  ci: TControlIdiomas;
  
begin
    try
      id := 'NodoAlgoritmo'+ IntToStr(updateNumero);
      ubicacion := unaUbicacion;
      //Idioma :=nil; // si el idioma no existe el argoritmo abre el de defecto
      ci :=  TControlIdiomas.Instance;
      Idioma := ci.buscar('esp');
      HandleDLL:=LoadLibrary(PChar(unaUbicacion));
      if HandleDLL = 0 then
        raise Exception.Create('No se pudo cargar la DLL');
      @nom :=GetProcAddress(HandleDLL, '_Nombre');
      if not assigned(nom) then
          raise Exception.Create('No se encontraron las funciones en la DLL'+#13+
                                 'Cannot find the required DLL functions');
      nombre:=string(nom);
    except
      raise Exception.Create('Error al intentar abrir el archivo '+unaUbicacion);
  end;
end;

destructor TNodoAlgoritmo.Destroy;
begin
  
  inherited;
end;

function TNodoAlgoritmo.abrir: TAlgoritmo;
begin
  result:=TAlgoritmo.Create(ubicacion, idioma);
end;

procedure TNodoAlgoritmo.getArbol(Arbol: TTreeNodes; Padre: TTreeNode);
var
  aux: TTreeNode;
  pUbicacion: ^string;
begin
  aux:= Arbol.AddChild(Padre, nombre); {TODO: dato q aparece en la lista}
  new (pUbicacion);
  pUbicacion^ := ExtractFileName(ubicacion);
  aux.Data := pUbicacion;
end;

function TNodoAlgoritmo.getNombre: string;
begin
  result := nombre;
end;

function TNodoAlgoritmo.getUbicacion: string;
begin
  Result := ubicacion;
end;

procedure TNodoAlgoritmo.getXML(XML: IXMLNode);
var
  nodo: IXMLNode;
begin
  nodo:=XML.AddChild('algoritmo');
  nodo.Attributes['nombreArch']:= ExtractFileName(ubicacion);
  //  nodo.Attributes['ubicacion']:=ubicacion;
  nodo.Attributes['idioma']:=idioma.getCodigo;
end;

procedure TNodoAlgoritmo.getXMLNombre(XML: IXMLNode);
var
  nodo: IXMLNode;
begin
  nodo:=XML.AddChild('algoritmo');
  nodo.Attributes['nombreArch']:= ExtractFileName(ubicacion);
end;

procedure TNodoAlgoritmo.guardarConfiguracion(unAlgoritmo: TAlgoritmo);
begin
  idioma := unAlgoritmo.getIdiomaActual;
end;

procedure TNodoAlgoritmo.setIdioma(unIdioma: TIdioma);
begin
  if unIdioma <> nil then
    idioma := unIdioma;
  {TODO: de donde saco el listado de idiomas disponibles?}
end;

procedure TNodoAlgoritmo.setNombre(unNombre: string);
begin
  nombre := unNombre;
end;

procedure TNodoAlgoritmo.setXML(XML: IXMLNode);
begin
  idioma := TControlIdiomas.Instance.buscar(XML.Attributes['idioma'])
  // ese o este:?
  //  alg.setIdioma(listaIdiomas.buscar(lista.Attributes['idioma']));
end;

class function TNodoAlgoritmo.updateNumero(numero:integer = -1): Word;
  
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
**************************** TListaNodosAlgoritmos *****************************
}
procedure TListaNodosAlgoritmos.agregar(unAlgoritmo:TNodoAlgoritmo);
begin
  inherited agregar(TObject(unAlgoritmo));
end;

function TListaNodosAlgoritmos.buscar(unAlgoritmo:string): TNodoAlgoritmo;
var
  aux: TNodoAlgoritmo;
begin
  aux := primero;
  while Assigned(aux) and (ExtractFileName(aux.ubicacion) <> ExtractFileName(unAlgoritmo)) do
    aux := siguiente;
  result:=aux;
end;

procedure TListaNodosAlgoritmos.getXML(XML: IXMLNode);
var
  nodoAlg: TNodoAlgoritmo;
begin
  nodoAlg := primero;
  while Assigned(nodoAlg) do
  begin
    nodoAlg.getXML(XML);
    nodoAlg := siguiente;
  end;{while}
end;

procedure TListaNodosAlgoritmos.limpiar;
var
  alg: TNodoAlgoritmo;
  i: Integer;
  
  {reset no llama a los destructores de los elementos contenidos, limpiar si!}
  
begin
  vaciar;
  {  alg := primero;
    while alg <> nil do
    begin
      FreeAndNil(alg);
      alg := siguiente;
    end;
   }
end;

function TListaNodosAlgoritmos.primero: TNodoAlgoritmo;
var
  aux: TObject;
begin
  aux:=inherited primero;
  if Assigned(aux) then
    result := TNodoAlgoritmo(aux)
  else
    result := nil;
end;

procedure TListaNodosAlgoritmos.reset;
begin
  deleteAll;
end;

function TListaNodosAlgoritmos.siguiente: TNodoAlgoritmo;
var
  aux: TObject;
begin
  aux:=inherited siguiente;
  if Assigned(aux) then
    result := TNodoAlgoritmo(aux)
  else
    result := nil;
end;

{
********************************** TCategoria **********************************
}
constructor TCategoria.Create;
begin
  inherited;
  listaAlgoritmos:= TListaNodosAlgoritmos.Create;
  listaCategorias:= TListaCategorias.Create;
end;

destructor TCategoria.Destroy;
begin
  
  inherited Destroy;
end;

procedure TCategoria.abrir;
begin
end;

procedure TCategoria.agregar(unaCategoria:integer);
begin
end;

procedure TCategoria.agregarAlgoritmo(unAlgoritmo:TNodoAlgoritmo);
begin
  listaAlgoritmos.agregar(unAlgoritmo);
end;

function TCategoria.agregarAlgoritmoACategoria(unAlgoritmo:TNodoAlgoritmo; 
        unaCategoria:string; terminado: boolean = false): Boolean;
begin
end;

procedure TCategoria.agregarCategoria(unaCategoria: TCategoria);
begin
  if unaCategoria <> nil then
    listaCategorias.agregar(unaCategoria);
end;

procedure TCategoria.borrarCategoria(unaCategoria: integer; terminado: boolean 
        = false);
var
  categoria: TCategoria;
begin
  //categoria := listaCategorias.buscar(unaCategoria);
  if categoria <> nil then
  begin
    FreeAndNil(categoria); {DONE:deberia llamar a free}
    terminado := true;
  end
  else
  begin
    categoria := listaCategorias.primero; {DONE: poner listaCategorias.primero}
    while (categoria <> nil) and (not terminado) do
    begin
      categoria.borrarCategoria(unaCategoria,terminado);
      categoria := listaCategorias.siguiente;
    end;
  end;
end;

function TCategoria.buscar(unaCategoria:integer): TCategoria;
begin
  result := listaCategorias.primero;
  while (result <> nil) and (result.idCategoria <> unaCategoria) do
    result := listaCategorias.siguiente;
end;

procedure TCategoria.copiarArbol(arbolOrigen: TTreeNodes; unaListaAlgoritmos: 
        TListaNodosAlgoritmos);
var
  nodo: TTreeNode;
  i: Integer;
  categAux: TCategoria;
  algoAux: TNodoAlgoritmo;
begin
  for i:= 0 to arbolOrigen.Count-1 do
   if arbolOrigen.Item[i].Parent = nil then
     if not Assigned(arbolOrigen.Item[i].Data) then
     begin
       categAux := TCategoria.Create;
       categAux.setNombre(arbolOrigen.Item[i].Text);{TODO: copia Datos aca}
       listaCategorias.agregar(categAux);
       categAux.copiarSubArbol(arbolOrigen.Item[i], unaListaAlgoritmos);
     end
     else
     begin
       algoAux := unaListaAlgoritmos.buscar(StrPas(arbolOrigen.Item[i].Data));
       {algoAux.setNombre} {TODO: falta setNombre y el resto de las prop}
       listaAlgoritmos.agregar(algoAux);
     end;
end;

procedure TCategoria.copiarSubArbol(subArbol: TTreeNode; unaListaAlgoritmos: 
        TListaNodosAlgoritmos);
var
  i: Integer;
  nodoAux: TTreeNode;
  categAux: TCategoria;
  algoAux: TNodoAlgoritmo;
begin
  nodoAux := subArbol.getFirstChild;
  while nodoAux <> nil do
  begin
    if not Assigned(nodoAux.Data) then
    begin
      {nil es categoria}
      categAux := TCategoria.Create;
      categAux.setNombre(nodoAux.Text);{o copia arriba o copia aca}
      listaCategorias.agregar(categAux);
      categAux.copiarSubArbol(nodoAux, unaListaAlgoritmos);
    end
    else
    begin
      {tiene valor es algoritmo}
      algoAux := unaListaAlgoritmos.buscar(StrPas(nodoAux.Data));
      {algoAux.setNombre} {TODO: falta seteo de algoritmo}
      listaAlgoritmos.agregar(algoAux);
    end;
    nodoAux := subArbol.GetNextChild(nodoAux);
  end;
end;

procedure TCategoria.crearCategoria(nombreCategoria:string; 
        categoriaPadre:integer; terminado: boolean = false);
var
  categoria: TCategoria;
begin
  if categoriaPadre = idCategoria then
  begin
    categoria := TCategoria.Create;
    categoria.setNombre(nombreCategoria);
    listaCategorias.agregar(categoria); {DONE: Agregue metodo! ok?}
    terminado := true;
  end
  else
  begin
  //    if listaCategorias.buscar(categoriaPadre) = nil then {Si no existe el nodo en su lista}
    begin                                                {TODO: esta parte va?}
      categoria := TCategoria.Create;
      categoria.setNombre(nombreCategoria);
      listaCategorias.agregar(categoria);
  //    end
  //    else
  //    begin
      categoria := listaCategorias.primero;
      while (categoria <> nil) and (not terminado)do
      begin
        categoria.crearCategoria(nombreCategoria,categoriaPadre, terminado);
        categoria := listaCategorias.siguiente;
      end;
    end;
  end;
end;

function TCategoria.Extraer(unaCategoria:integer): TCategoria;
begin
end;

procedure TCategoria.getArbol(Arbol: TTreeNodes);
var
  nodoCat: TCategoria;
  nodoAlg: TNodoAlgoritmo;
begin
  nodoCat := listaCategorias.primero;
  if nodoCat <> nil then
  begin
    Arbol.Clear;
    while nodoCat <> nil do
    begin
      nodoCat.getSubArbol(Arbol, nil);
      {tendria q llamar al nodo hijo p q haga lo mismo}
      nodoCat := listaCategorias.siguiente;
    end;{while}
  end;{if}
  nodoAlg := listaAlgoritmos.primero;
  while nodoAlg <> nil do
  begin
    nodoAlg.getArbol(Arbol, nil);
    nodoAlg := listaAlgoritmos.siguiente;
  end;{while}
end;

function TCategoria.getCategoria: string;
begin
  result:=inttostr(idCategoria);
end;

function TCategoria.getNombre: string;
begin
  result:=nombre;
end;

procedure TCategoria.getSubArbol(Arbol: TTreeNodes; Padre: TTreeNode);
var
  nodoCat: TCategoria;
  nodoAlg: TNodoAlgoritmo;
  aux: TTreeNode;
begin
  if Assigned(Padre) then
    aux:= Arbol.AddChild(Padre, nombre) {TODO: dato q aparece en la lista}
  else
    aux:= Arbol.Add(Padre, nombre);
  aux.Data := nil;
  
  nodoCat := listaCategorias.primero;
  while nodoCat <> nil do
  begin
    {tendria q llamar al nodo hijo p q haga lo mismo}
    nodoCat.getSubArbol(Arbol, aux);
    nodoCat := listaCategorias.siguiente;
  end;{while}
  nodoAlg := listaAlgoritmos.primero;
  while nodoAlg <> nil do
  begin
    nodoAlg.getArbol(Arbol, aux);
    nodoAlg := listaAlgoritmos.siguiente;
  end;{while}
end;

procedure TCategoria.getXML(XML: IXMLNode);
var
  nodoCat: TCategoria;
  nodoAlg: TNodoAlgoritmo;
begin
  nodoCat := listaCategorias.primero;
  while nodoCat <> nil do
  begin
    nodoCat.getXMLInt(XML);
      {tendria q llamar al nodo hijo p q haga lo mismo}
    nodoCat := listaCategorias.siguiente;
  end;{while}
  nodoAlg := listaAlgoritmos.primero;
  while nodoAlg <> nil do
  begin
  //    nodoAlg.getXML(XML); // ese lo llama la lista de algoritosmo porq guarda todos los datos
    nodoAlg.getXMLNombre(XML);
    nodoAlg := listaAlgoritmos.siguiente;
  end;{while}
end;

procedure TCategoria.getXMLInt(XML: IXMLNode);
var
  nodo: IXMLNode;
begin
  nodo:=XML.AddChild('categoria');
  nodo.Attributes['nombre']:=nombre;
  getXML(nodo);
end;

procedure TCategoria.guardarHijos(nArbol: TTreeNode; nodoCat: TCategoria);
var
  auxCat: TCategoria;
  auxAlg: TNodoAlgoritmo;
begin
  if nArbol <> nil then
    if nArbol.Data = nil then //es categoria
    begin
      auxCat := TCategoria.Create;
      auxCat.setNombre(nArbol.Text);
      nodoCat.agregarCategoria(auxCat);
    end
    else //es algoritmo
    begin
      auxAlg := TNodoAlgoritmo.Create(string(nArbol.Data^));
      nodoCat.agregarAlgoritmo(auxAlg);
    end;
    nArbol := nArbol.getFirstChild;
    while nArbol <> nil do
    begin
      guardarHijos(nArbol,auxCat);
      nArbol := nArbol.getNextSibling;
    end;
end;

procedure TCategoria.limpiar;
begin
  listaCategorias.limpiar;
  //  listaAlgoritmos.limpiar;
  listaAlgoritmos.reset;
end;

procedure TCategoria.moverCategoria(unaCategoria:integer ; 
        categoriaDestino:integer);
var
  categoria, categDestino: TCategoria;
begin
  categoria := listaCategorias.extraer(unaCategoria);
  categDestino := listaCategorias.extraer(categoriaDestino);
  if categoria = nil then
  begin
    categoria := listaCategorias.primero;
    while (categoria <> nil) {and (not terminado)} do
    begin
  {      categoria.Extraer(unaCategoria);
        if categoria
          categoria :=}
    end;
  end;
end;

function TCategoria.otraCategoria(nombreCategoria:string): Boolean;
begin
end;

function TCategoria.quitarAlgoritmo(unAlgoritmo:string): Boolean;
begin
end;

function TCategoria.quitarAlgoritmoCategoria(unAlgoritmo: string; unaCategoria: 
        string): Boolean;
begin
end;

procedure TCategoria.renombrar(unaCategoria: integer; nombreCategoria:string; 
        terminado: boolean = false);
var
  categoria: TCategoria;
begin
  //  categoria := listaCategorias.buscar(unaCategoria);
  if categoria <> nil then
  begin
    categoria.setNombre(nombreCategoria);
    terminado := true;
  end
  else
  begin
    categoria := listaCategorias.primero; {DONE: poner listaCategorias.primero}
    while (categoria <> nil) and (not terminado) do
    begin
      categoria.renombrar(unaCategoria, nombreCategoria, terminado);
      categoria := listaCategorias.siguiente;
    end;
  end;
end;

procedure TCategoria.setArbol(arbol: TTreeNodes);
var
  nodoCat: TCategoria;
  nodoAlg: TNodoAlgoritmo;
  nodoArbol, nodoHijo: TTreeNode;
begin
  //borrar listaCategorias
  if Assigned(listaCategorias) then
    listaCategorias.limpiar;
  listaCategorias := TlistaCategorias.Create;
  listaAlgoritmos.reset; //llama a reset porq no debe llamar a los destructores de los elementos contenidos en los nodos
    //listaAlgoritmos := TListaNodosAlgoritmos.Create; //no se necesita xq no se borra
  nodoArbol := arbol.GetFirstNode;
  while nodoArbol <> nil do
  begin
    if nodoArbol.Data = nil then // si es categoria
    begin
      nodoCat := TCategoria.Create;
      nodoCat.nombre := nodoArbol.Text;
      listaCategorias.agregar(nodoCat);
      if nodoArbol.HasChildren then
      begin
        nodoHijo := nodoArbol.getFirstChild;
        while (nodoHijo <> nil) {and (nodoHijo.Parent <> nil)} do
        begin
          guardarHijos(nodoHijo, nodoCat);
          nodoHijo := nodoHijo.getNextSibling;
        end;
      end;
  //      nodoArbol := nodoArbol.getNextSibling;
    end
    else //sino es algoritmo
    begin
      nodoAlg := TNodoAlgoritmo.Create(string(nodoArbol.Data^));//de donde lo saco?
      listaAlgoritmos.agregar(nodoAlg);
    end;
    nodoArbol :=  nodoArbol.getNextSibling;
  end;
end;

procedure TCategoria.SetIdCategoria(unIdCategoria:string);
begin
  idCategoria:=strtoint(unIdCategoria);{TODO: esto no deberia existir}
end;

procedure TCategoria.setNombre(unNombre:String);
begin
  nombre:=unNombre;
end;

procedure TCategoria.setXML(XML: IXMLNode; unaListaAlgoritmos: 
        TListaNodosAlgoritmos);
var
  i: Integer;
  nodoCat: TCategoria;
  nodoAlg: TNodoAlgoritmo;
begin
  for i:= 0 to XML.ChildNodes.Count-1 do
  begin
    if Uppercase(XML.ChildNodes.Nodes[i].NodeName) = 'CATEGORIA' then
    begin
      nodoCat:=TCategoria.Create;
      if not assigned(listaCategorias.buscar(XML.ChildNodes.Nodes[i].GetAttributeNS('nombre',''))) then
        listaCategorias.agregar(nodoCat);
      nodoCat.setXMLInt(XML.ChildNodes.Nodes[i], unaListaAlgoritmos);
    end
    else
    if Uppercase(XML.ChildNodes.Nodes[i].NodeName) = 'ALGORITMO' then
    begin
      nodoAlg:=unaListaAlgoritmos.buscar(XML.ChildNodes.Nodes[i].GetAttributeNS('nombreArch',''));
      if Assigned(nodoAlg) then
      begin
        //nodoAlg.setXML(XML.ChildNodes.Nodes[i]); //ya estan seteados de la lista de algoritmos
        listaAlgoritmos.agregar(nodoAlg);
      end;
    end
  end;
end;

procedure TCategoria.setXMLInt(XML: IXMLNode;unaListaAlgoritmos: 
        TListaNodosAlgoritmos);
begin
  nombre:= XML.GetAttributeNS('nombre','');
  setXML(XML, unaListaAlgoritmos);
end;

{
***************************** TControlListaDePasos *****************************
}
constructor TControlListaDePasos.Create;
begin
  listaPasos := TObjectList.Create;
  listaSecuencias := TListaSecuencias.Create;
end;

destructor TControlListaDePasos.Destroy;
begin
  listaPasos.Free;
  listaSecuencias.Free;
  inherited Destroy;
end;

procedure TControlListaDePasos.abrirListaPasos(NombreListaPasos: string; 
        mantener:boolean=false);
var
  paso: TPaso;
  XML: IXMLDocument;
  nodoListaPasos, nodoPaso: IXMLNode;
  i: Integer;
begin
  if not mantener then
  begin
    listaPasos.Clear;
  //    listaPasos := TObjectList.Create;
  end;
    {TODO: Abrir el XMLDoc}
  XML := TXMLDocument.Create(NombreListaPasos);
  nodoListaPasos := XML.DocumentElement;
  for i := 0 to nodoListaPasos.ChildNodes.Count -1 do
  begin
      {DONE:Crear el paso}
    paso := TPaso.Create();
      {DONE:Setear el XML al paso}
    paso.setXML(nodoListaPasos.ChildNodes.Nodes[i]);
      {TODO:agregar el paso a la lista}
    listaPasos.Add(paso);
  end;
end;

procedure TControlListaDePasos.abrirListaReferencias(unPaso, unParametro, 
        nombreListaReferencias: string);
var
  paso: TPaso;
begin
  paso := buscarPaso(unPaso);
  paso.abrirListaReferencias(unParametro, nombreListaReferencias);
end;

procedure TControlListaDePasos.actualizarPaso(unPaso: string; 
        unaListaParametros: TListaParametros);
var
  paso: TPaso;
  parametro: TParametro;
begin
  paso := buscarPaso(unPaso);
  if assigned(paso) then
    paso.setListaParametros(unaListaParametros);
end;

procedure TControlListaDePasos.agregarListaPasos(NombreListaPasos: string);
  
  //var
    //paso: TPaso;
  
begin
  abrirListaPasos(NombreListaPasos,true);
    {TODO: Abrir el XMLDoc}
    {TODO:Recorrer los ChildNodes del XMLDoc.Root}
    {DONE:Crear el paso}
  //  paso := TPaso.Create();
    {TODO:Setear el XML al paso}
    //paso.setXML();
    {TODO:agregar el paso a la lista}
  //  listaPasos.Add(paso);
end;

procedure TControlListaDePasos.agregarListaReferencias(unPaso, unParametro, 
        nombreListaReferencias: string);
var
  paso: TPaso;
begin
  paso := buscarPaso(unPaso);
  if Assigned(paso) then
    paso.abrirListaReferencias(unParametro,nombreListaReferencias)
  else
    raise Exception.CreateFmt('Error, el paso %s no existe',[unPaso]);
end;

procedure TControlListaDePasos.agregarReferenciaALista(unPaso, unParametro, 
        unValor: string);
var
  paso: TPaso;
begin
  paso := buscarPaso(unPaso);
  if Assigned(paso) then
    paso.agregarRefenciaALista(unParametro,unValor)
  else
    raise Exception.Createfmt('Error al buscar el paso %s',[unPaso]);
end;

function TControlListaDePasos.buscarPaso(unPaso: string): TPaso;
var
  paso: TPaso;
  i: Integer;
  terminar: Boolean;
begin
  result := nil;
  i := 0;
  while (i < listaPasos.Count) and not assigned(result)do
  begin
    if (listaPasos.Items[i] as TPaso).getID = unPaso then
      result := listaPasos.Items[i] as TPaso;
    inc(i);
  end;
end;

procedure TControlListaDePasos.crearPaso(unaListaParametros: TListaParametros; 
        unaUbicacion, unComentario:string);
var
  paso: TPaso;
begin
  paso := TPaso.Create(unaListaParametros);
  paso.setUbicacion(unaUbicacion);
  paso.setComentario(unComentario);
  listaPasos.Add(paso);
end;

procedure TControlListaDePasos.duplicarPaso(unPaso: string);
var
  paso, pasoAux: TPaso;
begin
  paso := buscarPaso(unPaso);
  if Assigned(paso) then
  begin
    pasoAux := paso.duplicar;
    listaPasos.Add(pasoAux);
  end
  else
    raise Exception.CreateFmt('Error al buscar el paso %s', [unPaso]);
end;

procedure TControlListaDePasos.duplicarPasoPosicion(posicion: integer);
var
  paso: TPaso;
begin
  paso := listaPasos.Items[posicion] as TPaso;
  duplicarPaso(paso.getID);
end;

procedure TControlListaDePasos.ejecutar(ubicacionSalida, formatoSalida: string);
var
  paso, pasoAux: TPaso;
  unaSecuencia: TSecuencia;
  minimasRef, i, j, referencias: Integer;
begin
  minimasRef := 0;
  //  paso := (listaPasos.Items[0] as TPaso);
  for i := 0 to listaPasos.Count -1 do
  begin
    paso := (listaPasos.Items[i] as TPaso);
    if minimasRef < paso.getCantidadReferencias then
      minimasRef := paso.getCantidadReferencias;
  end;
  for i := 1 to minimasRef do
  begin
    unaSecuencia := TSecuencia.Create;
    for j := 0 to listaPasos.Count - 1 do
    begin
      paso := listaPasos.Items[j] as TPaso;
      pasoAux := paso.getPaso(unaSecuencia);
      unaSecuencia.agregarPaso(pasoAux);
    end;
    listaSecuencias.agregar(unaSecuencia);
    unaSecuencia.ejecutar(ubicacionSalida,formatoSalida);
  end;
end;

procedure TControlListaDePasos.eliminarPaso(unPaso: string);
var
  paso: TPaso;
begin
  paso := buscarPaso(unPaso);
  listaPasos.Remove(paso);
  FreeAndNil(paso);
end;

procedure TControlListaDePasos.eliminarPasoPosicion(posicion:integer);
var
  paso: TPaso;
begin
  //  paso :=
  paso := TPaso(listaPasos.Items[posicion]);
  listaPasos.Delete(posicion);
   // FreeAndNil(paso);
end;

procedure TControlListaDePasos.eliminarReferenciaDeLista(unPaso, unParametro, 
        unaReferencia: string);
var
  paso: TPaso;
begin
  paso := buscarPaso(unPaso);
  if Assigned(paso) then
    paso.eliminarRefenciaDeLista(unParametro,unaReferencia)
  else
    raise Exception.CreateFmt('Error, no existe el paso %s',[unPaso]);
  
end;

function TControlListaDePasos.getComentarioPasoPosicion(Posicion: integer): 
        string;
var
  paso: TPaso;
begin
  paso := TPaso(listaPasos.Items[posicion]);
  result := paso.getComentario;
end;

function TControlListaDePasos.getDescListaPasos: TStringList;
var
  i: Integer;
  aux: TStringList;
begin
  aux := TStringList.Create;
  for i := 0 to listaPasos.Count-1 do
  begin
    aux.Add(TPaso(listaPasos.Items[i]).getID + '|' + TPaso(listaPasos.Items[i]).getUbicacion + '|' + TPaso(listaPasos.Items[i]).getComentario);
  end;
  result := aux;
end;

procedure TControlListaDePasos.guardarListaPasos(NombreListaPasos: string);
var
  i: Integer;
  paso: TPaso;
  XML: IXMLDocument;
  aux, nodoPaso: IXMLNode;
  dm: TDataModule;
begin
  //  try
  XML := TXMLDocument.Create(nil);
  XML.Active := true;
  aux := XML.AddChild('ListaDePasos');
  for i := 0 to listaPasos.Count -1 do
  begin
    nodoPaso := aux.AddChild('Paso');
    paso := (listaPasos.items[i] as TPaso);
    paso.getXML(nodoPaso);
  end;
  XML.SaveToFile(NombreListaPasos);
end;

procedure TControlListaDePasos.guardarListaReferencias(unPaso, unParametro, 
        nombreListaReferencias: string);
var
  paso: TPaso;
begin
  paso := buscarPaso(unPaso);
  if Assigned(paso) then
    paso.guardarReferencias(unParametro,nombreListaReferencias)
  else
    raise Exception.CreateFmt('Error, el paso %s no existe.',[unPaso]);
end;

procedure TControlListaDePasos.moverPaso(unPaso: string; nuevaPosicion: 
        integer);
var
  paso: TPaso;
begin
  paso := buscarPaso(unPaso);
  if Assigned(paso) then
    listaPasos.move(listaPasos.indexOf(paso), nuevaPosicion)
  else
    raise Exception.CreateFmt('Error: paso %s no existe!',[unPaso]);
end;

procedure TControlListaDePasos.setComentarioPasoPosicion(Posicion:integer; 
        nuevoComentario:string);
begin
  (listaPasos.Items[Posicion] as TPaso).setComentario(nuevoComentario);
end;

{
************************** TControladorProcesamiento ***************************
}
constructor TControladorProcesamiento.Create;
begin
  listaDisponibles:= TListaProcesadores.create;
  listaNoDisponibles:= TListaProcesadores.create;
end;

procedure TControladorProcesamiento.agregarProcesador(unProcesador:TProcesador);
begin
  listaDisponibles.agregar(unProcesador);
end;

procedure TControladorProcesamiento.agregarProcesadorError(unProcesador: 
        TProcesador);
begin
  listaNoDisponibles.agregar(unProcesador);
end;

procedure TControladorProcesamiento.agregarProcesadores(unaListaSatelites: 
        TListaProcesadores);
var
  aux: TProcesador;
begin
  aux:=unaListaSatelites.primero;
  while aux <> nil do
  begin
    listaDisponibles.agregar(aux);
    aux:=unaListaSatelites.siguiente;
  end;
end;

function TControladorProcesamiento.getProcesador: TProcesador;
var
  aux: TProcesador;
begin
  aux:=listaDisponibles.primero;
  { TODO : ver porque esta línea borra la referencia al procesador listaDisponibles.quitar (aux);}
  result := aux;
end;

{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{{
Que paso con la lista de resultados?
}
{
**************************** TOrganizadorEjecucion *****************************
}
constructor TOrganizadorEjecucion.Create;
begin
  inherited Create;
  raise Exception.CreateFmt('Access class %s through Instance only',
          [ClassName]);
end;

constructor TOrganizadorEjecucion.CreateInstance;
var
  procesador: TProcesador;
begin
  inherited Create;
  controladorProcesamiento:= TControladorProcesamiento.Create;
  procesador := TProcesadorLocal.Create;
  controladorProcesamiento.agregarProcesador(procesador);
  listaAcciones:= TListaAccion.Create;
  listaAccionesPendientes:= TListaAccion.Create;
  estado:=1; // 1= en uso
end;

destructor TOrganizadorEjecucion.Destroy;
begin
  if AccessInstance(0) = Self then AccessInstance(2);
  inherited Destroy;
end;

class function TOrganizadorEjecucion.AccessInstance(Request: Integer): 
        TOrganizadorEjecucion;
  
  const FInstance: TOrganizadorEjecucion = nil;
  
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

procedure TOrganizadorEjecucion.detenerEjecucion;
var
  accion: TAccion;
begin
  accion := listaAccionesPendientes.siguiente;
  accion.detener;
  FreeAndNil(accion); {TODO: verificar si es correcto el metodo}
end;

procedure TOrganizadorEjecucion.ejecutar;
begin
end;

procedure TOrganizadorEjecucion.ejecutarAccion(unaAccion:TAccion);
var
  procesador: TProcesador;
begin
  if listaAccionesPendientes.count > 0 then // ya estaban esperando acciones, directamente agrego a la lista
    listaAccionesPendientes.agregar(unaAccion)
  else
  begin
    procesador := controladorProcesamiento.getProcesador;
    if procesador = nil then
      listaAccionesPendientes.agregar(unaAccion)
    else
    begin
      listaAcciones.agregar(unaAccion);
      unaAccion.ejecutar(procesador);
    end;
  end;
end;

procedure TOrganizadorEjecucion.errorEjecucion(IDAccion:string);
begin
end;

procedure TOrganizadorEjecucion.finEjecucion(IDAccion: string; 
        unaListaResultados:TListaParametros);
var
  ua: TAccion;
  procesador: TProcesador;
begin
  ua:= listaAcciones.remover(IDAccion);
  ua.setResultados(unaListaResultados);
  procesador:=ua.getProcesador;
  if listaAccionesPendientes.count > 0 then
  begin
    ua:=listaAccionesPendientes.siguiente;
    ua.ejecutar(procesador);
  end
  else
    controladorProcesamiento.agregarProcesador(procesador);
  if Assigned(TEntornoEjecucion.Instance.FonRefresh) then
    TEntornoEjecucion.Instance.FonRefresh(ua.getPadreID);
end;

function TOrganizadorEjecucion.getEstado: Integer;
begin
  result:=estado;
end;

class function TOrganizadorEjecucion.Instance: TOrganizadorEjecucion;
begin
  Result := AccessInstance(1);
end;

procedure TOrganizadorEjecucion.interrumpirEjecucion;
begin
  interrumpir := true;
  {TODO: algo mas?}
end;

procedure TOrganizadorEjecucion.reanudarEjecucion;
begin
  {TODO: Como interrumpimos y sabremos como reanudar}
end;

class procedure TOrganizadorEjecucion.ReleaseInstance;
begin
  AccessInstance(0).Free;
end;

procedure TOrganizadorEjecucion.setControl(unControladorProcesamiento: 
        TControladorProcesamiento);
begin
  controladorProcesamiento := unControladorProcesamiento;
end;

procedure TOrganizadorEjecucion.setestado(estado:integer);
begin
  self.estado:= estado;
end;


{
****************************** TEntornoEjecucion *******************************
}
constructor TEntornoEjecucion.Create;
begin
  inherited Create;
  raise Exception.CreateFmt('Access class %s through Instance only', 
          [ClassName]);
end;

constructor TEntornoEjecucion.CreateInstance;
var
  idioma: TIdioma;
  XMLDoc: IXMLDocument;
  config, lista: IXMLNode;
  i: Integer;
  auxCat: TCategoria;
begin
  inherited Create;
    builderIdioma:= TControlIdiomas.Instance;
    control := nil; //se crea despues en la ejecucion
    IdiomaActual:= TIdioma.Create;
    listaAlgoritmos:= TListaNodosAlgoritmos.Create;
    listaAlgoritmosAbiertos:= TListaAlgoritmos.Create;
    listaCategorias:= TCategoria.Create;
    listaEstructuras:= TListaEstructuras.Create;
    listaIdiomas:= TListaIdiomas.Create;
    listaDePasos := TControlListaDePasos.Create;
    organizadorEjecucion:= TOrganizadorEjecucion.Instance;
    portapapeles:= Tportapapeles.instance;
                {Leer las variables guardadas}
                {Abro el archivo de config}
    if FileExists(ExtractFilePath(Application.ExeName)+ARCHIVOCONFIG) then
    begin
      try
        XMLDoc:= TXMLDocument.Create(ExtractFilePath(Application.ExeName)+ARCHIVOCONFIG);
                  {Busco la sección Desarrollo}
        //    XMLDoc.Active := true;
        //    config:= XMLDoc.DocumentElement.ChildNodes.FindNode('ListaIdiomas');
                  // listaDeIdiomas soportado por el Entorno
        lista := XMLDoc.DocumentElement.ChildNodes.FindNode('ListaIdiomas');
        if lista <> nil then
          for i:= 0 to lista.ChildNodes.Count -1 do
          begin
            idioma := TControlIdiomas.Instance.buscar(lista.ChildNodes.Nodes[i].Text);
            listaIdiomas.agregar(idioma);
          end;
                    // IdiomaActual
  
        IdiomaActual := TControlIdiomas.Instance.buscar(XMLDoc.DocumentElement.Attributes['IdiomaActual']);
  
                    // directorioTrabajo
  
        directorioTrabajo := XMLDoc.DocumentElement.Attributes['DirectorioTrabajo'];
  
                    //DirectorioAlgoritmos
  
        DirectorioAlgoritmos := XMLDoc.DocumentElement.Attributes['DirectorioAlgoritmos'];
  
                    {TODO: Recorrer el directorio DirectorioAlgoritmos
                    para cada dll que se encuentre allí:
                      crear un TNodoAlgoritmo como nodo
                      nodo.ubicacion=nombreArchivo
                      abrir la dll
                      nodo.descripcion=dll.getDescripcion
                      cierro la dll
                      }
  
          //actualizo listados
  
      except
        raise Exception.CreateFmt('El archivo %s no tiene la estructura esperada.',[ARCHIVOCONFIG]);
      end;
  
      refrescarListados(XMLdoc.DocumentElement.ChildNodes.FindNode('ListaAlgoritmos'), XMLDoc.DocumentElement.ChildNodes.FindNode('ListaCategorias'));
  
            {
                alg := TNodoAlgoritmo.Create;
                alg.ubicacion := DirectorioAlgoritmos+'\pirulo2.dll';
                alg.nombre := 'pirulo2';
                listaAlgoritmos.agregar(alg);
            }
                  // listaCategorias soportado por el Entorno
    end
    else
    begin
                  //Carga una configuración alternativa!
      idioma := TControlIdiomas.instance.buscar('esp');
      listaIdiomas.agregar(idioma);
      IdiomaActual := idioma;
      DirectorioAlgoritmos :=ExtractFilePath(Application.ExeName);
      DirectorioTrabajo :=ExtractFilePath(Application.ExeName);
  //      auxCat := TCategoria.Create;
  //      auxCat.setNombre('Principal');
  //      listaCategorias.agregarCategoria(auxCat);
    end;
end;

destructor TEntornoEjecucion.Destroy;
var
  XMLDoc: IXMLDocument;
  config, lista, nodo: IXMLNode;
  idioma: TIdioma;
  categoria: TCategoria;
  tmpFile: TextFile;
begin
  try
      XMLDoc:= TXMLDocument.Create(nil);
      XMLDoc.Active := true;
          {Creo la sección Ejecucion}
      config := XMLDoc.AddChild('Ejecucion');
      config.Attributes['IdiomaActual'] := IdiomaActual.getCodigo;
      config.Attributes['DirectorioTrabajo'] := DirectorioTrabajo;
      config.Attributes['DirectorioAlgoritmos'] := DirectorioAlgoritmos;
  
      lista := config.AddChild('ListaIdiomas');
  
      idioma := listaIdiomas.primero;
      while assigned(idioma) do
      begin
        nodo := lista.AddChild('Idioma');
        nodo.Text := idioma.getCodigo;
        idioma := listaIdiomas.siguiente;
      end;
  
        // listaCategorias soportado por el Entorno
  
      lista := config.AddChild('ListaCategorias');
  
      listaCategorias.getXML(lista);
  
      lista := config.AddChild('ListaAlgoritmos');
  
      listaAlgoritmos.getXML(lista);
  
      XMLDoc.SaveToFile(ExtractFilePath(Application.ExeName)+ARCHIVOCONFIG);
      {Destruyo todos los objetos}
  except on e:Exception do
      MessageDlg('No se pudo guardar la configuración.'#13#13+E.Message,
                  mtError, [mbOk], 0)
  end;
  if AccessInstance(0) = Self then AccessInstance(2);
  inherited Destroy;
end;

function TEntornoEjecucion.abrirAlgoritmo(unAlgoritmo: string): AnsiString;
var
  nodo: TNodoAlgoritmo;
  algoritmo: TAlgoritmo;
begin
  nodo := listaAlgoritmos.buscar(unAlgoritmo);
  if nodo <> nil then
  begin
    algoritmo := nodo.abrir;
    listaAlgoritmosAbiertos.agregar(algoritmo);
    result := algoritmo.getId;
  end
  else
    raise Exception.CreateFmt('"No se pudo abrir el algoritmo %s',[unAlgoritmo]);
end;

function TEntornoEjecucion.abrirImagen(nombreImagen:string): TBitmap32;
var
  imagen: TImagen;
begin
  imagen := TImagen.Create;
  imagen.setNombre(nombreImagen);
  listaEstructuras.agregar(imagen);
  result:=imagen.abrir(nombreImagen);
end;

procedure TEntornoEjecucion.abrirListaPasos(NombreListaPasos: string);
begin
  listaDePasos.abrirListaPasos(NombreListaPasos);
end;

procedure TEntornoEjecucion.abrirListaReferencias(unPaso, unParametro, 
        nombreListaReferencias: string);
begin
  listaDePasos.abrirListaReferencias(unPaso, unParametro, nombreListaReferencias);
end;

function TEntornoEjecucion.abrirMatriz(nombreMatriz:string): string;
var
  matriz: TMatriz;
begin
  matriz := TMatriz.Create;
  matriz.abrir(nombreMatriz);
  listaEstructuras.agregar(matriz);
  result := matriz.getNombre//getIDNombre;
end;

function TEntornoEjecucion.abrirPaso(unPaso: string): AnsiString;
var
  paso: TPaso;
  algoritmo: TAlgoritmo;
begin
  paso := listaDePasos.buscarPaso(unPaso);
  if assigned(Paso) then
  begin
    result := abrirAlgoritmo(paso.getUbicacion);
    algoritmo := listaAlgoritmosAbiertos.buscar(result);
    algoritmo.setResultados(paso.getListaParametros);
  end
  else
    raise Exception.CreateFmt('"No se pudo abrir el Paso %s',[unPaso]);
end;

class function TEntornoEjecucion.AccessInstance(Request: Integer): 
        TEntornoEjecucion;
  
  const FInstance: TEntornoEjecucion = nil;
  
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

procedure TEntornoEjecucion.actualizarListaCategorias(arbol: TTreeNodes);
begin
  listaCategorias.setArbol(arbol);
end;

procedure TEntornoEjecucion.actualizarPaso(unAlgoritmo, unPaso:string);
var
  algoritmo: TAlgoritmo;
begin
  algoritmo := listaAlgoritmosAbiertos.buscar(unAlgoritmo);
  if assigned(algoritmo) then
    listaDePasos.actualizarPaso(unPaso, algoritmo.getListaParametros);
  //  listaDePasos.actualizarPaso(unPaso,unParametro,unValor);
end;

function TEntornoEjecucion.adquirirImagen(imagen:TBitmap32): string;
var
  imagen1: TImagen;
  nombreImagen: string;
begin
  {NOTA:
   * EL ENTORNO DE EJECUCION GRAFICO DEBE TENER EL SIGUIENTE
  PROCEDIMIENTO DEFINIDO:
  
      procedure DelphiTwain1TwainAcquire(Sender: TObject;
        const Index: Integer; Image: TBitmap; var Cancel: Boolean);
  
  ---- EN IMPLEMENTACION:
  
  procedure TForm1.DelphiTwain1TwainAcquire(Sender: TObject;
    const Index: Integer; Image: TBitmap; var Cancel: Boolean);
  var
    formulario: TfrmImagen;
  begin
      formulario:= TfrmImagen.Create(Form1);
      formulario.image1.Picture.Assign(Image);
      entorno.adquirirImagen(image);
      formulario.Height:=formulario.image1.Picture.Bitmap.Height+35;
      formulario.Width:=formulario.image1.Picture.Bitmap.Width+9;
      formulario.Show;
      Cancel := TRUE;
  end;
  
  SIENDO TFRMIMAGEN EL FROMULARIO MDI DE LAS IMAGENES
  
   * EL EVENTO DE ADQUISICION, SEA EL BOTON O DESDE EL MENU
   DEBER CONTENER:
  
  var
    DelphiTwain1:TDelphiTwain;
    SourceIndex: Integer;
    Source: TTwainSource;
  begin
    //Make sure that the library and Source Manager
    //are loaded
    DelphiTwain1:=TDelphiTwain.Create(nil);
    DelphiTwain1.LibraryLoaded := TRUE;
    DelphiTwain1.TransferMode:= ttmNative;
  
    DelphiTwain1.OnTwainAcquire := form1.DelphiTwain1TwainAcquire;
    DelphiTwain1.SourceManagerLoaded := TRUE;
    //SelectSource method displays a common Twain dialog
    //to allow the user to select one of the avaliable
    //sources and returns it's index or -1 if either
    //the user pressed Cancel or if there were no sources
    SourceIndex := DelphiTwain1.SelectSource();
    if (SourceIndex <> -1) then
    begin
       //Now that we know the index of the source, we'll
       //get the object for this source
       Source := DelphiTwain1.Source[SourceIndex];
       //Load source and acquire image
       Source.Loaded := TRUE;
       Source.Enabled := TRUE;
    end //if (SourceIndex <> -1)
  end;
  
  }
  
  nombreImagen:='scan'+DateToStr(date);
  imagen1 := TImagen.Create;
  imagen1.setNombre(nombreImagen);
  listaEstructuras.agregar(imagen1);
  imagen1.adquirirImagen(imagen);
  result:= nombreImagen;
end;

procedure TEntornoEjecucion.agregarAlgoritmoACategoria(unAlgoritmo, 
        unaCategoria: string);
var
  algoritmo: TNodoAlgoritmo;
begin
  algoritmo := listaAlgoritmos.buscar(unAlgoritmo);
  if not (listaCategorias.agregarAlgoritmoACategoria(algoritmo,unaCategoria)) then
    ShowMessage('Se produjo un error al intentar agregar algoritmo a categoria');
  
end;

procedure TEntornoEjecucion.agregarListaPasos(NombreListaPasos: string);
begin
  listaDePasos.agregarListaPasos(NombreListaPasos);
end;

procedure TEntornoEjecucion.agregarListaReferencias(unPaso, unParametro, 
        nombreListaReferencias: string);
begin
  listaDePasos.agregarListaReferencias(unPaso,unParametro,nombreListaReferencias);
end;

procedure TEntornoEjecucion.agregarRefenciaALista(unPaso, unParametro, unValor: 
        string);
begin
  listaDePasos.agregarReferenciaALista(unPaso,unParametro,unValor);
end;

procedure TEntornoEjecucion.agregarSatelite(unNombre, direccionDeConexion: 
        string);
var
  ProcRemoto: TProcesadorRemoto;
  satelite: TSatelite;
begin
  satelite := TSatelite.Create;
  satelite.setNombre(unNombre);
  satelite.setDireccionDeConexion(direccionDeConexion);
  ProcRemoto:= TProcesadorRemoto.Create;
  ProcRemoto.satelite:= satelite;
  listaProcesadoresRemotos.agregar(ProcRemoto) {DONE: falta TListaSatelites}
end;

procedure TEntornoEjecucion.agregarVinculacionAComponente(unAlgoritmo, 
        unComponente, unaReferencia: string);
var
  algoritmo: TAlgoritmo;
  referencia: TReferencia;
begin
  algoritmo := listaAlgoritmosAbiertos.buscar(unAlgoritmo);
  referencia := TReferencia.Create;
  {TODO: referencia.setValor cual?}
  //algoritmo.ingresarValor(unComponente,referencia);
  {TODO: Referencia o string?}
end;

procedure TEntornoEjecucion.almacenarPaso(unAlgoritmo , unComentario: string);
var
  ual: TAlgoritmo;
begin
  ual := listaAlgoritmosAbiertos.buscar(unAlgoritmo);
  if Assigned(ual) then
    listaDePasos.crearPaso(ual.getListaParametros,ual.getUbicacion,unComentario)
  else
    raise Exception.Create('Error: No se encontró el algoritmo en la lista de algoritmos');
end;

procedure TEntornoEjecucion.borrarCategoria(unaCategoria: integer);
begin
end;

procedure TEntornoEjecucion.buscarSatelites(parametrosDeBusqueda:string);
begin
  {TODO: buscador de satelites existe todo el tiempo? o solo para buscar? falta el atributo}
end;

procedure TEntornoEjecucion.cambiarIdiomaAlgoritmo(unAlgoritmo, unIdioma: 
        string);
var
  algoritmo: TAlgoritmo;
  idioma: TIdioma;
  nodo: TNodoAlgoritmo;
begin
  algoritmo := listaAlgoritmosAbiertos.buscar(unAlgoritmo);
  if Assigned(algoritmo) then
  begin
    idioma := algoritmo.setIdioma(unIdioma);
    nodo := listaAlgoritmos.buscar(algoritmo.getUbicacion);
    if Assigned(algoritmo) then
      nodo.setIdioma(idioma)
    else
      raise Exception.CreateFmt('No se encontró el nodo en la lista de algoritmos',[])
  end
  else
    raise Exception.CreateFmt('No se encontró el algoritmo %s en la lista de algoritmos abiertos',[unAlgoritmo])
end;

procedure TEntornoEjecucion.cambiarIdiomaAlgoritmos(unIdioma: string);
var
  idioma: TIdioma;
  algoritmo: TAlgoritmo;
  nodo: TNodoAlgoritmo;
begin
  algoritmo := listaAlgoritmosAbiertos.primero;
  while Assigned(algoritmo) do
  begin
    idioma := algoritmo.setIdioma(unIdioma);
    nodo:=listaAlgoritmos.buscar(algoritmo.getUbicacion);
    nodo.setIdioma(idioma);
    algoritmo := listaAlgoritmosAbiertos.siguiente;
  end;{while}
end;

procedure TEntornoEjecucion.cambiarIdiomaEjecucion(unIdioma:string);
begin
  IdiomaActual := listaIdiomas.buscar(unIdioma);
end;

function TEntornoEjecucion.cantidadColumnasMatriz(IDM:string): Integer;
begin
  result := TMatriz(listaEstructuras.buscar(IDM)).getCantidadColumnas;
end;

function TEntornoEjecucion.cantidadFilasMatriz(IDM: string): Integer;
begin
  result := TMatriz(listaEstructuras.buscar(IDM)).getCantidadFilas;
end;

procedure TEntornoEjecucion.cerrarAlgoritmo(unAlgoritmo: string);
var
  algoritmo: TAlgoritmo;
  nodoAlg: TNodoAlgoritmo;
begin
  algoritmo := listaAlgoritmosAbiertos.buscar(unAlgoritmo);
  nodoAlg := listaAlgoritmos.buscar(algoritmo.getUbicacion);
  nodoAlg.guardarConfiguracion(algoritmo);
  algoritmo.cerrar;
end;

procedure TEntornoEjecucion.cerrarMatriz(unaMatriz: string);
begin
  listaEstructuras.buscar(unaMatriz).Destroy;
end;

procedure TEntornoEjecucion.configurarDirectorioAlgoritmos(unaUbicacion: 
        string);
begin
  {DONE: verificar si es valido el path}
  if DirectoryExists(unaUbicacion) then
  begin
      DirectorioAlgoritmos := unaUbicacion;
      refrescarListados(nil, nil);
  end
  else
    raise Exception.Create('Error: El directorio de algoritmos no existe.');
end;

procedure TEntornoEjecucion.configurarDirectorioTrabajoEjecucion(unaUbicacion: 
        string);
begin
  if DirectoryExists(unaUbicacion) then
      directorioTrabajo:=unaUbicacion
  else
    raise Exception.Create('Error: El directorio de trabajo no existe.');
end;

procedure TEntornoEjecucion.configurarDirectorioTrabajoSatelite(unaUbicacion: 
        string);
begin
  DirectorioTrabajo := unaUbicacion;
end;

procedure TEntornoEjecucion.copiarAlgoritmoACategoria(unAlgoritmo, 
        unaCategoria: string);
begin
end;

procedure TEntornoEjecucion.copiarArbol(arbolOrigen: TTreeNodes);
begin
  listaCategorias.copiarArbol(arbolOrigen, listaAlgoritmos);
end;

procedure TEntornoEjecucion.copiarImagen(unaImagen:string);
var
  imagen: TImagen;
  
  //  Datos: PValorImagen;
  
begin
  imagen := (listaEstructuras.buscar(unaImagen) as TImagen);
  if imagen.getSeleccion <> nil then
  begin
    portapapeles.agregarImagen(imagen.getSeleccion);
    portapapeles.agregarImagen(imagen.getSeleccionAsObject);
  end
  else
    MessageDlg('No se ha encontrado una seleccion',mtWarning,[mbOk],0);
end;

procedure TEntornoEjecucion.copiarMatriz(unaMatriz: string; unaFilaIncial, 
        unaFilaFinal, unaColumnaIncial, unaColumnaFinal: integer);
var
  matriz: TMatriz;
  
  {  matrizAux: TMatrizSimple;}
  
begin
  {  matriz := listaEstructuras.buscar(unaMatriz) as TMatriz;
    matrizAux := matriz.copiarMatriz(unaFilaIncial,unaFilaFinal,unaColumnaIncial, unaColumnaFinal);
    portapapeles.agregarMatriz(matrizAux);}
  matriz := listaEstructuras.buscar(unaMatriz) as TMatriz;
  portapapeles.agregarMatriz(matriz.copiarMatriz(unaFilaIncial,unaFilaFinal,unaColumnaIncial, unaColumnaFinal));
end;

function TEntornoEjecucion.cortarImagen(unaImagen: string): Boolean;
var
  imagen: TImagen;
begin
  imagen := listaEstructuras.buscar(unaImagen) as TImagen;
  if imagen.getSeleccion <> nil then
  begin
    portapapeles.agregarImagen(imagen.getSeleccion);
    portapapeles.agregarImagen(imagen.getSeleccionAsObject);
    imagen.borrarSeleccion;
    result:= true;
  end
  else
  begin
    MessageDlg('No se ha encontrado una seleccion',mtWarning,[mbOk],0);
    result:= False;
  end;
end;

procedure TEntornoEjecucion.cortarMatriz(unaMatriz: string; unaFilaInicial, 
        unaFilaFinal, unaColumnaInicial, unaColumnaFinal: integer);
var
  matriz: TMatriz;
  
  {  matrizAux: TMatrizSimple;}
  
begin
  {  matriz := listaEstructuras.buscar(unaMatriz) as TMatriz;
    matrizAux := matriz.copiarMatriz(unaFilaIncial,unaFilaFinal,unaColumnaIncial, unaColumnaFinal);
    portapapeles.agregarMatriz(matrizAux);}
  matriz := listaEstructuras.buscar(unaMatriz) as TMatriz;
  portapapeles.agregarMatriz(matriz.cortarMatriz(unaFilaInicial,unaFilaFinal,unaColumnaInicial, unaColumnaFinal));
end;

procedure TEntornoEjecucion.crearCategoria(nombreCategoria:string; 
        categoriaPadre:integer);
begin
  listaCategorias.crearCategoria(nombreCategoria,categoriaPadre);
end;

function TEntornoEjecucion.crearMatriz(nroFilas, nroColumnas: integer; tipoDato,
        valorInicial: string): string;
var
  matriz: TMatriz;
begin
  matriz := TMatriz.Create;
  matriz.inicializa(nroFilas,nroColumnas,tipoDato,valorInicial);
  listaEstructuras.agregar(matriz);
  result := matriz.getNombre//getIDNombre;
end;

procedure TEntornoEjecucion.deshacerImagen(unaImagen: string);
var
  imagen: TImagen;
begin
  imagen := ListaEstructuras.buscar(unaImagen) as TImagen;
  imagen.deshacer;
end;

procedure TEntornoEjecucion.deshacerMatriz(unaMatriz: string);
begin
  (listaEstructuras.buscar(unaMatriz) as TMatriz).deshacer;
end;

procedure TEntornoEjecucion.detenerEjecucion;
begin
  if organizadorEjecucion <> nil then
    organizadorEjecucion.detenerEjecucion;
end;

procedure TEntornoEjecucion.duplicarPaso(unPaso: string);
begin
  listaDePasos.duplicarPaso(unPaso);
end;

procedure TEntornoEjecucion.duplicarPasoPosicion(Posicion: integer);
begin
  listaDePasos.duplicarPasoPosicion(Posicion)
end;

procedure TEntornoEjecucion.ejecutarAlgoritmo(unAlgoritmo: string);
begin
  listaAlgoritmosAbiertos.buscar(unAlgoritmo).ejecutar;
end;

procedure TEntornoEjecucion.ejecutarListaPasos(tipoControl, ubicacionSalida, 
        formatoSalida: string);
begin
  control := TControladorProcesamiento.Create;
      {todo: definido tipoRemoto? deberia ser cte}
  if tipoControl <> 'tipoRemoto' then
    control.agregarProcesadores(listaProcesadoresLocales);
  if tipoControl <> 'tipoLocal' then
    control.agregarProcesadores(listaProcesadoresRemotos);
  {DONE: falta lista de satelites}
  organizadorEjecucion.setControl(control);
  listaDePasos.ejecutar(ubicacionSalida,formatoSalida);
end;

procedure TEntornoEjecucion.eliminarColumnas(unaMatriz: string; columnaIncial, 
        columnaFinal: integer);
begin
  (listaEstructuras.buscar(unaMatriz) as TMatriz).eliminarColumnas(columnaIncial,columnaFinal);
end;

procedure TEntornoEjecucion.eliminarFilas(unaMatriz: string; filaIncial, 
        filaFinal: integer);
begin
  (listaEstructuras.buscar(unaMatriz) as TMatriz).eliminarFilas(filaIncial,filaFinal);
end;

procedure TEntornoEjecucion.eliminarPaso(unPaso: string);
begin
  listaDePasos.eliminarPaso(unPaso);
end;

procedure TEntornoEjecucion.eliminarPasoPosicion(posicion: integer);
begin
  listaDePasos.eliminarPasoPosicion(posicion);
end;

procedure TEntornoEjecucion.eliminarRefenciaDeLista(unPaso, unParametro, 
        unaReferencia: string);
begin
  listaDePasos.eliminarReferenciaDeLista(unPaso,unParametro,unaReferencia);
end;

procedure TEntornoEjecucion.eliminarSatelite(nombreSatelite: string);
var
  ProcRem: TProcesador;
begin
  ProcRem:=listaProcesadoresRemotos.primero;
  while ProcRem <> nil do
  begin
    if TProcesadorRemoto(ProcRem).satelite.nombre =nombreSatelite then
    begin
      listaProcesadoresRemotos.eliminar(TProcesadorRemoto(ProcRem));
      TProcesadorRemoto(ProcRem).Free;
      break
    end;
    ProcRem:=listaProcesadoresRemotos.siguiente;
  end;
end;

procedure TEntornoEjecucion.getArbol(Arbol: TTreeNodes);
begin
  listaCategorias.getArbol(Arbol);
end;

function TEntornoEjecucion.getComentarioPasoPosicion(Posicion:integer): string;
begin
  result := listaDePasos.getComentarioPasoPosicion(Posicion);
end;

function TEntornoEjecucion.GetControlListaDePasos: TControlListaDePasos;
begin
  Result := ControlListaDePasos; // DONE: Implement Method
end;

function TEntornoEjecucion.getDescListaPasos: TStringList;
begin
  result := listaDePasos.getDescListaPasos;
end;

function TEntornoEjecucion.getDirectorioAlgoritmos: string;
begin
  result := DirectorioAlgoritmos;
end;

function TEntornoEjecucion.getDirectorioTrabajo: string;
begin
  Result := DirectorioTrabajo;
end;

function TEntornoEjecucion.getEstado: Integer;
begin
  result:=organizadorEjecucion.getEstado;
end;

function TEntornoEjecucion.getIdiomaAlgoritmo(unAlgoritmo:string): string;
var
  algoritmo: TAlgoritmo;
begin
  algoritmo:=listaAlgoritmosAbiertos.buscar(unAlgoritmo);
  if assigned(algoritmo) then
    result := algoritmo.getIdiomaActual.getCodigo
  else
    result := '';
end;

function TEntornoEjecucion.getImagen(unaImagen:string): TImagen;
begin
  result := listaEstructuras.buscar(unaImagen) as TImagen;
end;

procedure TEntornoEjecucion.getListaAlgoritmos(lista: TListItems);
var
  alg: TNodoAlgoritmo;
  item: TListItem;
  pUbicacion: ^string;
begin
  alg := listaAlgoritmos.primero;
  if alg <> nil then
  begin
    lista.Clear;
    while alg <> nil do
    begin
      item := lista.Add;
      item.Caption := alg.getNombre;
      new (pUbicacion);
      pUbicacion^ := ExtractFileName(alg.getUbicacion);
      item.Data := pUbicacion;
      alg := listaAlgoritmos.siguiente;
    end;
  end
  else
  begin
    lista.clear;
    item:= lista.Add;
    item.Caption:='-- No se encontró ningún algoritmo--';
  end;
end;

function TEntornoEjecucion.getListaImagenes: TStrings;
var
  elemento: TEstructura;
begin
  //Creo el objeto resultado
  result := TstringList.Create;
  //para cada elemento de la lista estructuras, si es imagen, lo devuelvo
  elemento:=listaEstructuras.primero;
  while Assigned(elemento) do
  begin
  //{TODO:    if elemento.esimagen then
    result.Add(elemento.getNombre);
    elemento:=listaEstructuras.siguiente;
  end;
end;

function TEntornoEjecucion.getListaMatrices: TStrings;
var
  elemento: TEstructura;
begin
  //Creo el objeto resultado
  result := TstringList.Create;
  //para cada elemento de la lista estructuras, si es imagen, lo devuelvo
  elemento:=listaEstructuras.primero;
  while Assigned(elemento) do
  begin
  //{TODO:    if elemento.esmatriz then
    result.Add(elemento.getNombre);
    elemento:=listaEstructuras.siguiente;
  end;
end;

function TEntornoEjecucion.getMatriz(unaMatriz: string): uTipos.TMString;
var
  mat: TMatriz;
begin
  mat := TMatriz(listaEstructuras.buscar(unaMatriz));
  result := nil;
  if mat <> nil then
    result := mat.getArrayString
  else
    raise Exception.CreateFmt('Error al intentar recuperar la matriz %s', [unaMatriz]);
end;

function TEntornoEjecucion.getTipoDatoMatriz(IDMatriz:string): string;
begin
  Result := TMatriz(listaEstructuras.buscar(IDMatriz)).getTipoDato;
end;

function TEntornoEjecucion.getValorInicialMatriz(IDMatriz:string): string;
begin
  Result := TMatriz(listaEstructuras.buscar(IDMatriz)).getValorInicial;
end;

function TEntornoEjecucion.getValorParametro(unAlgoritmo, unComponente, 
        unIdioma:string): string;
var
  algoritmo: TAlgoritmo;
  componente: TComponente;
begin
  algoritmo:=listaAlgoritmosAbiertos.buscar(unAlgoritmo);
  result := algoritmo.getValorParametro(unComponente, unIdioma);
end;

procedure TEntornoEjecucion.guardarImagen(unaImagen, nombreImagen: string);
var
  imagen: TEstructura;
begin
  imagen := listaEstructuras.buscar(unaImagen);
  if assigned(imagen) then
    (imagen as TImagen).guardar(nombreImagen);
end;

procedure TEntornoEjecucion.guardarListaPasos(NombreListaPasos: string);
begin
  listaDePasos.guardarListaPasos(NombreListaPasos);
end;

procedure TEntornoEjecucion.guardarListaReferencias(unPaso, unParametro, 
        nombreListaReferencias: string);
begin
  listaDePasos.guardarListaReferencias(unPaso,unParametro,nombreListaReferencias);
end;

procedure TEntornoEjecucion.guardarMatriz(unaMatriz, nombreMatriz: string);
begin
  listaEstructuras.buscar(unaMatriz).guardar(nombreMatriz);
end;

procedure TEntornoEjecucion.guardarVector(unVector, nombreVector: string);
begin
  listaEstructuras.buscar(unVector).guardar(nombreVector);
end;

procedure TEntornoEjecucion.imprimirImagen(unaImagen: string);
var
  imagen: TEstructura;
begin
  imagen := listaEstructuras.buscar(unaImagen);
  (imagen as TImagen).imprimir;
  {lanza excepcion si no pudo!}
end;

procedure TEntornoEjecucion.imprimirMatriz(unaMatriz: string);
begin
  listaEstructuras.buscar(unaMatriz).imprimir;
end;

procedure TEntornoEjecucion.imprimirVector(unVector: string);
begin
  listaEstructuras.buscar(unVector).imprimir;
end;

procedure TEntornoEjecucion.ingregarValor(unAlgoritmo, unComponente, unValor: 
        string);
begin
  listaAlgoritmosAbiertos.buscar(unAlgoritmo).ingresarValor(unComponente,unValor);
end;

procedure TEntornoEjecucion.ingresarValor(unAlgoritmo, unComponente, unValor: 
        string);
begin
  listaAlgoritmosAbiertos.buscar(unAlgoritmo).ingresarValor(unComponente,unValor);
end;

procedure TEntornoEjecucion.insertarColumnas(unaMatriz: string; columnaInicial, 
        cantidadColumnas: integer);
begin
  (listaEstructuras.buscar(unaMatriz) as TMatriz).insertarColumnas(columnaInicial, cantidadColumnas);
end;

procedure TEntornoEjecucion.insertarFilas(unaMatriz: string; filaInicial, 
        cantidadFilas: integer);
begin
  (listaEstructuras.buscar(unaMatriz) as TMatriz).insertarFilas(filaInicial,cantidadFilas);
end;

class function TEntornoEjecucion.Instance: TEntornoEjecucion;
begin
  Result := AccessInstance(1);
end;

procedure TEntornoEjecucion.interrumpirEjecucion;
begin
  if organizadorEjecucion <> nil then
    organizadorEjecucion.interrumpirEjecucion;
end;

procedure TEntornoEjecucion.modificarCeldaMatriz(unaMatriz: string; unaFila, 
        unaColumna: integer; unValor: string);
begin
  (listaEstructuras.buscar(unaMatriz) as TMatriz).modificarCelda(unaFila,unaColumna,unValor);
end;

function TEntornoEjecucion.mostrarFormularioAlgoritmo(unAlgoritmo:string): 
        WideString;
var
  algoritmo: TAlgoritmo;
begin
  algoritmo := listaAlgoritmosAbiertos.buscar(unAlgoritmo);
  if Assigned(algoritmo) then
    result := algoritmo.mostrarFormulario
  else
    result := '';
end;

procedure TEntornoEjecucion.moverAlgoritmoACategoria(unAlgoritmo, 
        categoriaOrigen, categoriaDestino: string);
begin
  self.quitarAlgoritmodeCategoria(unAlgoritmo,categoriaOrigen);
  self.agregarAlgoritmoACategoria(unAlgoritmo,categoriaDestino);
end;

procedure TEntornoEjecucion.moverCategoria(unaCategoria:integer ; 
        categoriaDestino:integer);
begin
  listaCategorias.moverCategoria(unaCategoria,categoriaDestino);
end;

procedure TEntornoEjecucion.moverPaso(unPaso: string; nuevaPosicion: integer);
var
  paso: TPaso;
begin
  listaDePasos.moverPaso(unPaso,nuevaPosicion);
end;

procedure TEntornoEjecucion.nuevaListaPasos;
begin
  listaDePasos.Free;
  listaDePasos := TControlListaDePasos.Create;
end;

procedure TEntornoEjecucion.pegarComoImagen;
var
  imagen: TImagen;
begin
  //  imagen := TImagen.Create;
    {TODO:Seteo El nombre}
  //  imagen := portapapeles.getImagen;
  //  listaEstructuras.agregar(imagen);
end;

procedure TEntornoEjecucion.pegarImagen(unaImagen: string; unaPosicion: TPoint);
var
  imagen, imagenAux: TImagen;
begin
  imagen := listaEstructuras.buscar(unaImagen) as TImagen;
  //  imagenAux:= TImagen.Create;
  imagenAux := portapapeles.getImagen;
  imagen.setImagen(imagenAux,unaPosicion);
  //  imagenAux.Free;
end;

procedure TEntornoEjecucion.pegarMatriz(unaMatriz: string; unaFilaIncial, 
        unaFilaFinal, unaColumnaInicial, unaColumnaFinal: integer);
begin
  (listaEstructuras.buscar(unaMatriz) as TMatriz).pegarMatriz(unaFilaIncial,unaFilaFinal,unaColumnaInicial,unaColumnaFinal);
end;

procedure TEntornoEjecucion.quitarAlgoritmodeCategoria(unAlgoritmo, 
        unaCategoria: string);
begin
  if not (listaCategorias.quitarAlgoritmoCategoria(unAlgoritmo,unaCategoria)) then
    ShowMessage('Se produjo un error al intentar crear categoria');
end;

procedure TEntornoEjecucion.quitarImagen(unaImagen: string);
var
  imagen: TEstructura;
begin
  {Var}
  {imagen: TImagen;}
  {imagen := TEstructura(listaEstructuras.buscar(unaImagen)) as TImagen;
  imagen.Destroy;}
  {imagen.Free //En teoria}
  {----------- otra forma + OOP -----------}
  imagen := listaEstructuras.buscar(unaImagen);
  listaEstructuras.eliminar(imagen);
  {imagen.Free //En teoria}
end;

procedure TEntornoEjecucion.quitarVinculacionAComponente(unAlgoritmo, 
        unComponente: string);
begin
  listaAlgoritmosAbiertos.buscar(unAlgoritmo).quitarVinculacion(unComponente);
end;

procedure TEntornoEjecucion.reanudarEjecucion;
begin
  if organizadorEjecucion <> nil then
    organizadorEjecucion.reanudarEjecucion
  else
    raise Exception.Create('Error al intentar acceder ak organizador de ejecución');
end;

procedure TEntornoEjecucion.rechacerMatriz(unaMatriz: string);
begin
  (listaEstructuras.buscar(unaMatriz) as TMatriz).rehacer;
end;

procedure TEntornoEjecucion.refrescarListados(unaListaAlgoritmos, 
        unaListaCategorias: IXMLNode);
var
  sr: TSearchRec;
  alg: TNodoAlgoritmo;
  nodo: IXMLNode;
  docXML: IXMLDocument;
  encontro: Boolean;
  msg: string;
begin
  try
    listaAlgoritmos.limpiar;
    listaCategorias.limpiar;
    if SysUtils.findFirst(IncludeTrailingBackslash(DirectorioAlgoritmos)+'*.dll', faArchive,sr) = 0 then
    begin
      msg := '';
      repeat
        try
          alg := TNodoAlgoritmo.Create(IncludeTrailingBackslash(DirectorioAlgoritmos)+ sr.Name);
        except on E:exception do
          msg := msg + #13 + E.Message;
        end;
        if assigned(alg) then
        begin
          encontro := false;
          if Assigned(unaListaAlgoritmos) then
            nodo := unaListaAlgoritmos.ChildNodes.First;
          while Assigned(unaListaAlgoritmos) and Assigned(nodo) and not encontro do
          begin
            if nodo.Attributes['nombreArch'] = sr.Name then
              encontro := true
            else
              nodo := nodo.NextSibling;
          end;
    //        nodo := docXML.DocumentElement.ChildNodes.FindNode(sr.Name);//busca el nombre del archivo
          if nodo <> nil then //si estaba anteriormente
            alg.setXML(nodo);
                //lo agrega a la lista de algoritmos
          if not assigned(listaAlgoritmos.buscar(alg.ubicacion)) then
            listaAlgoritmos.agregar(alg);
        end;
      until SysUtils.FindNext(sr) <> 0;
        SysUtils.FindClose(sr);
      if msg <> '' then
        Showmessage('Errores ocurridos al intentar abrir las librerías:'+msg);
    end;{if}
  
    //seteo las categorias
    if Assigned(unaListaCategorias) then
      listaCategorias.setXML(unaListaCategorias, listaAlgoritmos);
    except
      raise Exception.CreateFmt('El archivo %s no tiene la estructura esperada.',[ARCHIVOCONFIG]);
    end;
end;

procedure TEntornoEjecucion.rehacerImagen(unaImagen: string);
var
  imagen: TImagen;
begin
  imagen := ListaEstructuras.buscar(unaImagen) as TImagen;
  imagen.rehacer;
end;

procedure TEntornoEjecucion.rehacerMatriz(unaMatriz: string);
begin
  (listaEstructuras.buscar(unaMatriz) as TMatriz).rehacer;
end;

procedure TEntornoEjecucion.reinicializarMatriz(IDMatriz: string; Filas,
        Columnas: integer; TipoDato, ValorInicial: string);
begin
  TMatriz(listaEstructuras.buscar(IDMatriz)).reInicializar(Filas, Columnas,TipoDato,ValorInicial);
end;

class procedure TEntornoEjecucion.ReleaseInstance;
begin
  AccessInstance(0).Free;
end;

procedure TEntornoEjecucion.renombrarCategoria(unaCategoria:integer; 
        nombreCategoria:string);
begin
  listaCategorias.renombrar(unaCategoria,nombreCategoria);
end;

procedure TEntornoEjecucion.setComentarioPasoPosicion(Posicion: integer; 
        nuevoComentario: string);
begin
  listaDePasos.setComentarioPasoPosicion(Posicion,nuevoComentario);
end;

procedure TEntornoEjecucion.SetControlListaDePasos(Value: TControlListaDePasos);
begin
end;

procedure TEntornoEjecucion.setestado(estado:integer);
begin
  organizadorEjecucion.setestado(estado);
end;

function TEntornoEjecucion.tieneDeshacerMatriz(IDMatriz:string): Boolean;
begin
  result := TMatriz(listaEstructuras.buscar(IDMatriz)).existeDeshacer;
end;

function TEntornoEjecucion.tieneRehacerMatriz(IDMatriz:string): Boolean;
begin
  result := TMatriz(listaEstructuras.buscar(IDMatriz)).existeRehacer;
end;

{
**************************** TReferenciaEstructura *****************************
}
procedure TReferenciaEstructura.setValor(unValor, unIdioma: string);
var
  aux: TEstructura;
begin
  aux:=TEntornoEjecucion.Instance.listaEstructuras.buscar(unValor);
  if Assigned(aux) then
    estructura := aux
  else
    raise Exception.CreateFmt('No se pudo encontrar una estructura con el nombre %s',[unValor]);
end;

procedure TReferenciaEstructura.setXML(XML: IXMLNode);
begin
end;

{
***************************** TReceptorResultados ******************************
}
procedure TReceptorResultados.finEjecucion(IDAccion: string; 
        listaResultados:TListaParametros);
begin
  organizadorEjecucion.finEjecucion(IDAccion,listaResultados);
end;

{ TReferenciaEstructuraMatriz }

{
************************* TReferenciaEstructuraMatriz **************************
}
procedure TReferenciaEstructuraMatriz.getXML(var XML: IXMLNode);
begin
  XML.AddChild('referenciaEstructuraMatriz');
end;

{ TReferenciaEstructuraImagen }

{
************************* TReferenciaEstructuraImagen **************************
}
procedure TReferenciaEstructuraImagen.getXML(var XML: IXMLNode);
begin
  XML.AddChild('referenciaEstructuraImagen');
end;

function TEntornoEjecucion.getListaIdiomasAlgoritmo(unAlgoritmo:string): TStringList;
var
  algoritmo: TAlgoritmo;
begin
  algoritmo:=listaAlgoritmosAbiertos.buscar(unAlgoritmo);
  if assigned(algoritmo) then
    result := algoritmo.getListaIdiomas
  else
    result := TStringList.Create;
end;

function TEntornoEjecucion.getDescAlgoritmo(unAlgoritmo:string): string;
var
  algoritmo: TAlgoritmo;
begin
  result := '';
  algoritmo:= listaAlgoritmosAbiertos.primero;
  while Assigned(Algoritmo) do
  begin
    result := result + algoritmo.getId;
    algoritmo:= listaAlgoritmosAbiertos.siguiente;
  end;
end;

end.
