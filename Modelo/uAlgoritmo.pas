unit uAlgoritmo;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, uTipos, uProyecto, uIdiomas, uSatelite, uLista,
  uComponentes, uReferencia, uReceptor, XMLIntf, XMLDoc, Contnrs,
  jclMIME,JclSysInfo, JclStrings;

type
  TProcesador = class (TObject)
  private
    listaParametros: TListaParametros;
  public
    constructor Create;
    procedure ejecutar; overload; virtual; abstract;
    procedure ejecutar(IDAccion, unaUbicacion: string; unaListaParametros: 
            TListaParametros); overload; virtual; abstract;
  end;
  
  TAccion = class (TObject)
  private
    ID: string;
    procesador: TProcesador;
    ubicacion: string;
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create; virtual;
    procedure detener;
    procedure ejecutar(unProcesador:TProcesador); virtual; abstract;
    function getID: string;
    function getPadreID: string; virtual; abstract;
    function getProcesador: TProcesador;
    procedure setEjecutar(unaUbicacion:string);
    procedure setParametros(unaListaParametros:TListaParametros);
    procedure setResultados(unaListaParametros:TListaParametros); virtual; 
            abstract;
  end;
  
  {{
  Este en teoria no almacena la ubicacion, lo hace el nodo!?
  }
  TAlgoritmo = class (TObject)
  private
    formularioInterfaz: TFormularioInterfaz;
    ID: AnsiString;
    IdiomaActual: TIdioma;
    listaAtributos: TListaAtributos;
    listaIdiomas: TListaIdiomas;
    ubicacion: string;
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create(unaUbicacion:string; unIdioma: TIdioma);
    procedure cerrar;
    procedure ejecutar;
    function getId: string;
    function getIdiomaActual: TIdioma;
    function getListaIdiomas: TStringList;
    function getListaParametros: TListaParametros;
    function getUbicacion: string;
    function getValorParametro(unComponente, unIdioma: string): string;
    procedure ingresarValor(unComponente, unValor:string);
    function mostrarFormulario: AnsiString;
    procedure quitarVinculacion(unComponente: string);
    function setIdioma(unIdioma: string): TIdioma;
    procedure setResultados(listaResultados: TListaParametros);
  end;
  
  {{
  Para remover... un buscar!?
  }

  TAccionAlgoritmo = class;

  {{
  Para remover... un buscar!?
  }
  TListaAccion = class (TLista)
  public
    procedure agregar(unaAccion: TAccion);
    procedure agregarPrimero(unaAccion: TAccion);
    function primero: TAccionAlgoritmo;
    function remover(IDAccion: string): TAccion;
    function siguiente: TAccionAlgoritmo;
  end;
  
  TListaAlgoritmos = class (TLista)
  public
    procedure agregar(unAlgoritmo:TAlgoritmo);
    function buscar(unAlgoritmo:string): TAlgoritmo;
    function primero: TAlgoritmo;
    procedure quitar(unAlgoritmo:TAlgoritmo);
    function siguiente: TAlgoritmo;
  end;
  
  TPaso = class;

  TSecuencia = class (TObject)
  private
    listaPasos: TObjectList;
    listaResultados: TListaParametros;
    procedure ejecutar; overload;
  public
    constructor Create;
    procedure agregarPaso(unPaso: TPaso);
    procedure ejecutar(ubicacionSalida, formatoSalida: string); overload;
    procedure setResultados(listaParametros: TListaParametros);
  end;
  
  TListaSecuencias = class (TObject)
  private
    function GetSecuencia(Index: Integer): TSecuencia;
    procedure SetSecuencia(Index: Integer; Value: TSecuencia);
  public
    procedure agregar(unaSecuencia: TSecuencia);
    function siguiente: TSecuencia;
    property Secuencia[Index: Integer]: TSecuencia read GetSecuencia write 
            SetSecuencia;
  end;
  
  TPaso = class (TObject)
  private
    comentario: string;
    detenerDespues: Boolean;
    listaParametros: TListaParametros;
    nroID: Word;
    ubicacion: string;
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create; overload;
    constructor Create(unaListaParametros:TListaParametros); overload;
    destructor Destroy; override;
    procedure abrirListaReferencias(unParametro, nombreListaReferencias: 
            string);
    procedure agregarListaReferencias(unParametro, nombreListaReferencias: 
            string);
    procedure agregarParametro(unParametro: TParametro);
    procedure agregarRefenciaALista(unParametro, unValor: string);
    function duplicar: TPaso;
    procedure ejecutar;
    procedure eliminarRefenciaDeLista(unParametro, unaReferencia: string);
    function getCantidadReferencias: Integer;
    function getComentario: string;
    function getDetenerDespues: Boolean;
    function getID: string;
    function getListaParametros: TListaParametros;
    function getPaso(secuencia: TSecuencia): TPaso;
    function getUbicacion: string;
    procedure getXML(nodo: IXMLNode);
    procedure guardarReferencias(unParametro, nombreListaReferencias: string); 
            overload;
    procedure setComentario(unComentario: string);
    procedure setDetenerDespues(valor: boolean);
    procedure setListaParametros(unaListaParametros: TListaParametros);
    procedure setReferencias(unParametro, listaReferencias: string); overload;
    procedure setUbicacion(unaUbicacion:string);
    procedure setValor(unParametro, unValor: string); overload;
    procedure setXML(XML: IXMLNode);
  end;
  
  _TListaPasos = class (TLista)
  public
    constructor Create;
    procedure agregar(unPaso: TPaso);
    function buscar(unPaso: string): TPaso;
    function getListaParametros: TListaParametros;
    function primero: TPaso;
    function siguiente: TPaso;
  end;
  
  TProcesadorLocal = class (TProcesador)
  public
    constructor Create;
    procedure ejecutar(IDAccion, unaUbicacion: string; unaListaParametros: 
            TListaParametros); overload; override;
  end;
  
  TProcesadorRemoto = class (TProcesador)
  private
    Fsatelite: TSatelite;
    paquete: IXMLDocument;
  public
    destructor destroy;
    procedure ejecutar; overload; override;
    procedure ejecutar(IDAccion, unaUbicacion: string; unaListaParametros: 
            TListaParametros); overload; override;
    property satelite: TSatelite read Fsatelite write Fsatelite;
  end;
  
  TListaProcesadores = class (TLista)
  public
    procedure agregar(unProcesador: TProcesador);
    function primero: TProcesador;
    procedure quitar(unProcesador: TProcesador);
    function siguiente: TProcesador;
  end;
  
  TTrabajo = class (TObject)
  private
    accion: TAccion;
    Fconcentrador: string;
    FIDAccion: Integer;
    listaParametros: TListaPropiedades;
    listaResultados: TListaPropiedades;
    Receptor: TReceptorExterno;
  public
    constructor Create(unReceptor: TReceptorExterno; unTrabajo: string; 
            unaUbicacion: string);
    function getListaParametros: TListaParametros;
    procedure setResultados(unaListaResultados: TListaPropiedades);
    property concentrador: string read Fconcentrador write Fconcentrador;
    property IDAccion: Integer read FIDAccion write FIDAccion;
  end;
  
  {{
  getProcesador deberia quitarselo!
  }
  TAccionAlgoritmo = class (TAccion)
  private
    algoritmo: Talgoritmo;
  public
    constructor Create(unAlgoritmo: TAlgoritmo);
    procedure ejecutar(unProcesador: TProcesador); override;
    function getPadreID: string; override;
    procedure setResultados(unaListaParametros:TListaParametros); override;
  end;
  
  TAccionSecuencia = class (TAccion)
  private
    secuencia: Tsecuencia;
  public
    constructor Create(unaSecuencia: TSecuencia);
    procedure ejecutar(unProcesador: TProcesador); override;
    function getPadreID: string; override;
    procedure setResultados(unaListaParametros:TListaParametros); override;
  end;
  
  TAccionTrabajo = class (TAccion)
  private
    trabajo: Ttrabajo;
  public
    constructor Create(unTrabajo: TTrabajo);
    procedure ejecutar(unProcesador:TProcesador); virtual;
    function getPadreID: string; override;
    procedure setResultados(unaListaParametros:TListaParametros); overload; 
            virtual;
  end;
  
procedure Register;

implementation
uses uEntornoEjecucion, uCommon;

procedure Register;
begin
end;

{
********************************* TProcesador **********************************
}
constructor TProcesador.Create;
begin
  listaParametros := TListaParametros.Create;
end;

{
*********************************** TAccion ************************************
}
constructor TAccion.Create;
begin
  ID := 'Accion'+intToStr(updateNumero());
end;

procedure TAccion.detener;
begin
end;

function TAccion.getID: string;
begin
  result := ID;
end;

function TAccion.getProcesador: TProcesador;
begin
  Result := procesador;
  procesador := nil;
end;

procedure TAccion.setEjecutar(unaUbicacion:string);
begin
  ubicacion:= unaUbicacion;
end;

procedure TAccion.setParametros(unaListaParametros:TListaParametros);
begin
end;

class function TAccion.updateNumero(numero:integer=-1): Word;
  
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
****************************** TProcesadorRemoto *******************************
}
destructor TProcesadorRemoto.destroy;
begin
  satelite.Free;
end;

procedure TProcesadorRemoto.ejecutar;
begin
  {TODO: NO FALTA EL EMISOR DEL TRABAJO??? HAY RECEPTOR DE RESULTADOS
  PERO NO EMISOR DE TRABAJO O ALGO POR EL ESTILO SI ES DEL MODELO DE INTERFAZ,
  CAGAMOS LO DE NO MANDAR MENSAJES DESDE EL DE DATOS A ARRIBA}
end;

procedure TProcesadorRemoto.ejecutar(IDAccion, unaUbicacion: string; 
        unaListaParametros: TListaParametros);
var
  unParametro: TParametro;
  i: Integer;
  concentradorXML, parametros, resultados, archivodll: IXMLNode;
begin
  paquete := NewXMLDocument;
  paquete.AddChild('root');
  archivodll := paquete.CreateNode(MimeEncodeString(FileToString(unaUbicacion)), ntCDATA);
  // crear el nodo XML del algoritmo
    {DONE: Codificar la DLL en XML}
  paquete.DocumentElement.ChildNodes.Add(archivodll);
  concentradorXML.AddChild('concentrador',GetIPAddress(GetLocalComputerName));
  paquete.DocumentElement.ChildNodes.Add(concentradorXML);
  // crear el nodo XML del algoritmo
  // crear el nodo XML de la lista de parametros
  unParametro:= unaListaParametros.primero;
  for i:= 1 to unaListaParametros.count do
  begin
    unParametro.getXML(parametros);
    unParametro:= unaListaParametros.siguiente;
  end;
  // crear el nodo XML de la lista de parametros
  paquete.DocumentElement.ChildNodes.Add(parametros);
  { QUESTION: la lista de parametros son todos, E/S o solo los de Entrada?
  de ser así, nos falta la lista de Salida y modificar en Tprocesador e hijos el metodo}
  
  // mandar a ejecutar al satelite
  self.ejecutar;
end;


{
****************************** TListaProcesadores ******************************
}
procedure TListaProcesadores.agregar(unProcesador: TProcesador);
begin
  inherited agregar(unProcesador);
end;

function TListaProcesadores.primero: TProcesador;
begin
  result := inherited primero as TProcesador;
end;

procedure TListaProcesadores.quitar(unProcesador: TProcesador);
begin
  inherited eliminar(unProcesador);
end;

function TListaProcesadores.siguiente: TProcesador;
begin
  result := inherited siguiente as TProcesador;
end;

{
*********************************** TTrabajo ***********************************
}
constructor TTrabajo.Create(unReceptor: TReceptorExterno; unTrabajo: string; 
        unaUbicacion: string);
var
  XMLDoc: IXMLDocument;
  trabajo, fdll, listapar, listares, concentradorXML: IXMLNode;
  i: Integer;
  parametro: TParametro;
  resultado: TPropiedad;
  
  // suponiendo que el ftp ya guardó el archivo XML
  
begin
  Receptor:=unReceptor;
  if FileExists(unaUbicacion+unTrabajo) then
  try
  //Crear el objeto XML
    XMLDoc:= TXMLDocument.Create(unaUbicacion+unTrabajo);
  //Parsear el XML:
    trabajo:= XMLDoc.DocumentElement.ChildNodes.FindNode('Trabajo'); // busco TTrabajo
    fdll:= XMLDoc.DocumentElement.ChildNodes.FindNode('Algoritmo'); // busco la DLL
    concentradorXML:= XMLDoc.DocumentElement.ChildNodes.FindNode('Concentrador'); // busco la DLL
  {DONE: Grabar la DLL?}
    stringtofile(unaUbicacion,fdll.Text);
    listapar:= XMLDoc.DocumentElement.ChildNodes.FindNode('Parametros');
    listares:= XMLDoc.DocumentElement.ChildNodes.FindNode('Resultados');
  // crear los atributos del TTrabajo
    accion:=TAccionTrabajo.Create(self);
    listaParametros:= TListaPropiedades.Create;
    listaResultados:= TListaPropiedades.Create;
  // crear los atributos del TTrabajo
    Fconcentrador:=trabajo.ChildNodes.Nodes[0].Text; // IP Address
    FIDAccion:= strtoint(accion.getID);
  // Crear ListaParametros
    for i:= 0 to listapar.ChildNodes.Count -1 do
    begin
      Parametro:= TParametro.Create(listapar.ChildNodes.Nodes[i].Text);
      listaParametros.agregar(Tpropiedad(parametro));
    end;
  // Crear ListaParametros
  // Crear ListaResultados
    for i:= 0 to listares.ChildNodes.Count -1 do
    begin
      Resultado:= TPropiedad.Create(listares.ChildNodes.Nodes[i].Text);
      listaResultados.agregar(Tpropiedad(Resultado));
    end;
  // Crear ListaResultados
    concentrador:=concentradorXML.Text;
    accion.setParametros(TListaParametros(listaparametros));
    accion.setEjecutar(unaUbicacion);
    TOrganizadorEjecucion.Instance.ejecutarAccion(accion);
  except
    raise Exception.CreateFmt('El archivo %s no tiene la estructura esperada.',[unTrabajo]);
  end;
end;

function TTrabajo.getListaParametros: TListaParametros;
begin
  result:= TListaParametros(listaParametros);
end;

procedure TTrabajo.setResultados(unaListaResultados: TListaPropiedades);
var
  resultados: string;
  i: Integer;
  resultado: TPropiedad;
begin
  listaResultados:= unaListaResultados;
  resultado := (listaResultados.primero as TPropiedad);
  resultados:=resultado.getValor(''); {TODO: no se si esta bien}
  for i:= 1 to listaResultados.count -1 do
  begin
    resultado := (listaResultados.siguiente as TPropiedad);
    resultados:=resultado.getValor(''); {TODO: no se si esta bien}
  end;
  Receptor.enviarResultado(concentrador,IntToStr(IDAccion),resultados);
end;

{{
getProcesador deberia quitarselo!
}
{{
getProcesador deberia quitarselo!
}
{{
getProcesador deberia quitarselo!
}
{{
getProcesador deberia quitarselo!
}
{{
getProcesador deberia quitarselo!
}
{{
getProcesador deberia quitarselo!
}
{{
getProcesador deberia quitarselo!
}
{{
getProcesador deberia quitarselo!
}
{{
getProcesador deberia quitarselo!
}
{
******************************* TAccionAlgoritmo *******************************
}
constructor TAccionAlgoritmo.Create(unAlgoritmo: TAlgoritmo);
begin
  inherited Create;
  if unAlgoritmo <> nil then
    algoritmo := unAlgoritmo
  else
    raise Exception.Create('Error, se intentó crear una acción sin asignarle un algoritmo');
end;

procedure TAccionAlgoritmo.ejecutar(unProcesador: TProcesador);
begin
  unProcesador.ejecutar(ID, algoritmo.getUbicacion, algoritmo.getListaParametros);
  {TODO: estan bien parametros?}
end;

function TAccionAlgoritmo.getPadreID: string;
begin
  result := algoritmo.getId;
end;

procedure TAccionAlgoritmo.setResultados(unaListaParametros:TListaParametros);
begin
  algoritmo.setResultados(unaListaParametros);
end;

{
******************************* TAccionSecuencia *******************************
}
constructor TAccionSecuencia.Create(unaSecuencia: TSecuencia);
begin
  inherited Create;
end;

procedure TAccionSecuencia.ejecutar(unProcesador: TProcesador);
begin
  {TODO: EJECUTAR SECUENCIA, DONDE SACA LA UBICACION??}
end;

function TAccionSecuencia.getPadreID: string;
begin
  { TODO :  result := secuencia.getId;}
end;

procedure TAccionSecuencia.setResultados(unaListaParametros:TListaParametros);
begin
end;

{{
Este en teoria no almacena la ubicacion, lo hace el nodo!?
}

{{
Este en teoria no almacena la ubicacion, lo hace el nodo!?
}
{{
Este en teoria no almacena la ubicacion, lo hace el nodo!?
}
{{
Este en teoria no almacena la ubicacion, lo hace el nodo!?
}
{{
Este en teoria no almacena la ubicacion, lo hace el nodo!?
}
{{
Este en teoria no almacena la ubicacion, lo hace el nodo!?
}
{{
Este en teoria no almacena la ubicacion, lo hace el nodo!?
}
{{
Este en teoria no almacena la ubicacion, lo hace el nodo!?
}
{{
Este en teoria no almacena la ubicacion, lo hace el nodo!?
}
{{
Este en teoria no almacena la ubicacion, lo hace el nodo!?
}
{
********************************** TAlgoritmo **********************************
}
constructor TAlgoritmo.Create(unaUbicacion:string; unIdioma: TIdioma);
var
  XML: IXMLDocument;
  formulario: AnsiString;
  atributo: TAtributo;
  idioma: TIdioma;
  
  nom : function: PChar; stdcall;
  HandleDLL: THandle;
  i: integer;
  
begin
  {TODO: llamar a la dll y obtener el string de datos}
  formularioInterfaz:= TFormularioInterfaz.Create;
  listaIdiomas := TListaIdiomas.Create;
  listaAtributos := TListaAtributos.Create;
  id := 'Algoritmo'+ IntToStr(updateNumero);
  ubicacion := unaUbicacion;
  
  try
    {Abrir la dll}
    HandleDLL:=LoadLibrary(PChar(unaUbicacion));
    if HandleDLL = 0 then
      raise Exception.Create('No se pudo cargar la DLL');
  
    {obtener el puntero al getIdiomas}
    @nom :=GetProcAddress(HandleDLL, '_Idiomas');
    if not assigned(nom) then
        raise Exception.Create('No se encontraron las funciones en la DLL'+#13+
                               'Cannot find the required DLL functions');
  
    {Crear el XML: XMLDocument}
    {Agregarle todo el string llamando a la funcion}
    XML:=LoadXMLData(StrPas(nom));
  
    {Parserar los atributos}
    for i:= 0 to XML.DocumentElement.ChildNodes.Count-1 do
    begin
      if i=0 then
      //el Idioma Predeterminado es el que viene en la primera posición.
      begin
        if Assigned(unIdioma) then
          idiomaActual := unIdioma
        else
          idiomaActual := TControlIdiomas.Instance.buscar(XML.DocumentElement.ChildNodes.Nodes[i].ChildNodes.Nodes[0].text);
      end;
      idioma := TControlIdiomas.Instance.buscar(XML.DocumentElement.ChildNodes.Nodes[i].ChildNodes.Nodes[0].text);
      listaIdiomas.agregar(idioma);
    end;
  
    {obtener el puntero al getAtributos}
    @nom :=GetProcAddress(HandleDLL, '_Descripcion');
    if not assigned(nom) then
        raise Exception.Create('No se encontraron las funciones en la DLL'+#13+
                               'Cannot find the required DLL functions');
  
    {Agregarle todo el string llamando a la funcion}
    XML:=LoadXMLData(StrPas(nom));
  
    {Parserar los atributos}
    for i:= 0 to XML.DocumentElement.ChildNodes.Count-1 do
    begin
      atributo:=TAtributo.Create;
      atributo.setXML(XML.DocumentElement.ChildNodes.Nodes[i]);
      {Agregarlos a la listaAtributos}
      listaAtributos.agregar(atributo);
    end;
  
    {obtener el puntero al getFormulario}
    @nom :=GetProcAddress(HandleDLL, '_formularioDFM');
    if not assigned(nom) then
        raise Exception.Create('No se encontraron las funciones en la DLL'+#13+
                               'Cannot find the required DLL functions');
    {Agregarle todo el string llamando a la funcion}
    XML:= LoadXMLData(strPas(nom));
    {parsear el XML que cree el formulario}
    formularioInterfaz.setFormulario(XML.DocumentElement, listaIdiomas);
    {Cierro la DLL}
    FreeLibrary(HandleDLL);
  except
    FreeLibrary(HandleDLL);
    raise Exception.Create('Error al intentar abrir el archivo '+unaUbicacion);
  end;
  
end;

procedure TAlgoritmo.cerrar;
begin
  FreeAndNil(formularioInterfaz);
  FreeAndNil(listaAtributos); {TODO: elimina nodos?}
  FreeAndNil(listaIdiomas);
end;

procedure TAlgoritmo.ejecutar;
var
  listaParam: TListaParametros;
  ua: TAccionAlgoritmo;
  organizadorEj: TOrganizadorEjecucion;
begin
  listaParam := formularioInterfaz.getListaParametros;
  ua := TAccionAlgoritmo.Create(Self);
  ua.setParametros(listaParam);
  ua.setEjecutar(ubicacion);
  organizadorEj := TOrganizadorEjecucion.Instance;
  organizadorEj.ejecutarAccion(ua);
end;

function TAlgoritmo.getId: string;
begin
  result := Id;
end;

function TAlgoritmo.getIdiomaActual: TIdioma;
begin
end;

function TAlgoritmo.getListaParametros: TListaParametros;
begin
  result := formularioInterfaz.getListaParametros;
end;

function TAlgoritmo.getUbicacion: string;
begin
  result := ubicacion;
end;

function TAlgoritmo.getValorParametro(unComponente, unIdioma: string): string;
begin
  result := formularioInterfaz.getPropiedad(unComponente, unComponente, unIdioma);
end;

procedure TAlgoritmo.ingresarValor(unComponente, unValor:string);
begin
  formularioInterfaz.ingresarValor(unComponente,unValor, idiomaActual.getCodigo);
end;

function TAlgoritmo.mostrarFormulario: AnsiString;
begin
  result := formularioInterfaz.getFormularioDFM;
end;

procedure TAlgoritmo.quitarVinculacion(unComponente: string);
begin
end;

function TAlgoritmo.setIdioma(unIdioma: string):TIdioma;
begin
  result := listaIdiomas.buscar(unIdioma);
  if IdiomaActual <> nil then
    IdiomaActual := result
  else
    raise Exception.CreateFmt('Error al intentar establecer el idioma %s al algoritmo %s',[unIdioma,ID]);
end;

procedure TAlgoritmo.setResultados(listaResultados: TListaParametros);
begin
  formularioInterfaz.setListaResultados(listaResultados);
end;

class function TAlgoritmo.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

{{
Para remover... un buscar!?
}
{{
Para remover... un buscar!?
}
{{
Para remover... un buscar!?
}
{{
Para remover... un buscar!?
}
{{
Para remover... un buscar!?
}
{{
Para remover... un buscar!?
}
{{
Para remover... un buscar!?
}
{{
Para remover... un buscar!?
}
{{
Para remover... un buscar!?
}
{{
Para remover... un buscar!?
}
{
********************************* TListaAccion *********************************
}
procedure TListaAccion.agregar(unaAccion: TAccion);
begin
  inherited agregar(unaAccion);
end;

procedure TListaAccion.agregarPrimero(unaAccion: TAccion);
begin
  inherited agregarPrimero(unaAccion);
end;

function TListaAccion.primero: TAccionAlgoritmo;
begin
  result:= inherited primero as TAccionAlgoritmo;
end;

function TListaAccion.remover(IDAccion: string): TAccion;
var
  acc: TAccionAlgoritmo;
begin
  acc := primero;
  result := nil;
  while Assigned(acc) and (acc.getID <> IDAccion) do
    acc := siguiente;
  if Assigned(acc) then
  begin // encontro la accion
    //eliminar(acc);
    result := acc;
  end;
end;

function TListaAccion.siguiente: TAccionAlgoritmo;
begin
  result := inherited siguiente as TAccionAlgoritmo;
end;

{
******************************* TListaAlgoritmos *******************************
}
procedure TListaAlgoritmos.agregar(unAlgoritmo:TAlgoritmo);
begin
  inherited agregar(unAlgoritmo);
end;

function TListaAlgoritmos.buscar(unAlgoritmo:string): TAlgoritmo;
var
  aux: TAlgoritmo;
begin
  aux := primero;
  while Assigned(aux) and (aux.getID <> unAlgoritmo) do
    aux := siguiente;
  result:=aux;
end;

function TListaAlgoritmos.primero: TAlgoritmo;
var
  aux: TObject;
begin
  aux:=inherited primero;
  if Assigned(aux) then
    result := TAlgoritmo(aux)
  else
    result := nil;
end;

procedure TListaAlgoritmos.quitar(unAlgoritmo:TAlgoritmo);
begin
  inherited eliminar(unAlgoritmo);
end;

function TListaAlgoritmos.siguiente: TAlgoritmo;
var
  aux: TObject;
begin
  aux:=inherited siguiente;
  if Assigned(aux) then
    result := TAlgoritmo(aux)
  else
    result := nil;
end;

{
******************************* TListaSecuencias *******************************
}
procedure TListaSecuencias.agregar(unaSecuencia: TSecuencia);
begin
end;

function TListaSecuencias.GetSecuencia(Index: Integer): TSecuencia;
begin
end;

procedure TListaSecuencias.SetSecuencia(Index: Integer; Value: TSecuencia);
begin
end;

function TListaSecuencias.siguiente: TSecuencia;
begin
end;

{
********************************** TSecuencia **********************************
}
constructor TSecuencia.Create;
begin
  listaPasos := TObjectList.Create;
  listaResultados := TListaParametros.Create;
end;

procedure TSecuencia.agregarPaso(unPaso: TPaso);
begin
  listaPasos.Add(unPaso);
end;

procedure TSecuencia.ejecutar;
begin
end;

procedure TSecuencia.ejecutar(ubicacionSalida, formatoSalida: string);
begin
end;

procedure TSecuencia.setResultados(listaParametros: TListaParametros);
begin
end;

{
************************************ TPaso *************************************
}
constructor TPaso.Create;
begin
  detenerDespues := false;
  nroID:=updateNumero;
  comentario :='';
  ubicacion := '';
  listaParametros := TListaParametros.Create;
end;

constructor TPaso.Create(unaListaParametros:TListaParametros);
begin
  detenerDespues := false;
  nroID:=updateNumero;
  comentario :='';
  ubicacion := '';
  listaParametros := unaListaParametros;
end;

destructor TPaso.Destroy;
begin
  updateNumero(nroID);
end;

procedure TPaso.abrirListaReferencias(unParametro, nombreListaReferencias: 
        string);
var
  param: TParametro;
begin
  param := listaParametros.buscar(unParametro);
  if param <> nil then
    param.abrirListaReferencias(nombreListaReferencias)
  else
    raise Exception.CreateFmt('Error al intentar buscar el parámetro %s',[unParametro]);
end;

procedure TPaso.agregarListaReferencias(unParametro, nombreListaReferencias: 
        string);
var
  param: TParametro;
begin
  param := listaParametros.buscar(unParametro);
  if Assigned(param) then
    param.agregarListaReferencias(nombreListaReferencias)
  else
    raise Exception.CreateFmt('Error al buscar el parámetro %s',[unParametro]);
end;

procedure TPaso.agregarParametro(unParametro: TParametro);
begin
end;

procedure TPaso.agregarRefenciaALista(unParametro, unValor: string);
var
  param: TParametro;
begin
  param := listaParametros.buscar(unParametro);
  if Assigned(param) then
    param.agregarRefenciaALista(unValor)
  else
    raise Exception.CreateFmt('Error al buscar el parámetro %s',[unParametro]);
end;

function TPaso.duplicar: TPaso;
var
  paso: TPaso;
  listaP: TListaParametros;
begin
  //listaP := TListaParametros.Create; //lo hace el duplicar
  listaP := listaParametros.duplicar;
  paso := TPaso.Create(listaP);
  paso.setComentario(comentario);
  paso.setUbicacion(ubicacion);
  Result := paso;
end;

procedure TPaso.ejecutar;
begin
end;

procedure TPaso.eliminarRefenciaDeLista(unParametro, unaReferencia: string);
var
  param: TParametro;
begin
  param := listaParametros.buscar(unParametro);
  if Assigned(param) then
    param.eliminarRefenciaDeLista(unaReferencia)
  else
    raise Exception.CreateFmt('Error al buscar el parámetro %s',[unParametro]);
end;

function TPaso.getCantidadReferencias: Integer;
begin
  result := listaParametros.count;
end;

function TPaso.getComentario: string;
begin
  result :=comentario;
end;

function TPaso.getDetenerDespues: Boolean;
begin
end;

function TPaso.getID: string;
begin
  result := 'Paso'+inttostr(nroID);
end;

function TPaso.getListaParametros: TListaParametros;
begin
  result := listaParametros;
end;

function TPaso.getPaso(secuencia: TSecuencia): TPaso;
begin
  
end;

function TPaso.getUbicacion: string;
begin
  Result := ubicacion;
end;

procedure TPaso.getXML(nodo: IXMLNode);
var
  nodoParam: IXMLNode;
begin
  nodo.Attributes['ubicacion'] := ubicacion;
  nodo.Attributes['comentario'] := comentario;
    {TODO:llamar a la lista de parametros!}
  //  nodoParam := nodo.AddChild('ListaParametros');
  //  listaParametros.getXML;
end;

procedure TPaso.guardarReferencias(unParametro, nombreListaReferencias: string);
var
  param: TParametro;
begin
  param := listaParametros.buscar(unParametro);
  if Assigned(param) then
    param.guardar(nombreListaReferencias)
  else
    raise Exception.CreateFmt('Error al buscar el parametro %s',[unParametro]);
end;

procedure TPaso.setComentario(unComentario: string);
begin
  comentario := unComentario;
end;

procedure TPaso.setDetenerDespues(valor: boolean);
begin
  detenerDespues := valor;
end;

procedure TPaso.setListaParametros(unaListaParametros: TListaParametros);
begin
  if Assigned(listaParametros) then
    listaParametros.Free;
  listaParametros := unaListaParametros;
end;

procedure TPaso.setReferencias(unParametro, listaReferencias: string);
begin
end;

procedure TPaso.setUbicacion(unaUbicacion:string);
begin
  ubicacion := unaUbicacion;
end;

procedure TPaso.setValor(unParametro, unValor: string);
var
  param: TParametro;
begin
  param := listaParametros.buscar(unParametro);
  if assigned(param) then
    param.setValor(unValor,'');
end;

procedure TPaso.setXML(XML: IXMLNode);
var
  param: TParametro;
  nodoAux: IXMLNode;
begin
  ubicacion := XML.Attributes['ubicacion'];
  comentario := XML.Attributes['comentario'];
  {TODO: es necesario chequear ubicacion! si no existe error!?}
  nodoAux := XML.ChildNodes.First;
  while nodoAux <> nil do {TODO: revisar como guarda lista de parametros}
  begin
    param := TParametro.Create(nodoAux);
    nodoAux := nodoAux.NextSibling;
  end;
end;

class function TPaso.updateNumero(numero:integer=-1): Word;
  
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
********************************* _TListaPasos *********************************
}
constructor _TListaPasos.Create;
begin
end;

procedure _TListaPasos.agregar(unPaso: TPaso);
begin
  inherited agregar(unPaso);
end;

function _TListaPasos.buscar(unPaso: string): TPaso;
begin
  
end;

function _TListaPasos.getListaParametros: TListaParametros;
begin
end;

function _TListaPasos.primero: TPaso;
var
  aux: TObject;
begin
  {  aux:=inherited primero;
    if Assigned(aux) then
      result := TPaso(aux)
    else
      result := nil;}
end;

function _TListaPasos.siguiente: TPaso;
var
  aux: TObject;
begin
  {  aux:=inherited siguiente;
    if Assigned(aux) then
      result := TPaso(aux)
    else
      result := nil;}
end;

{
******************************* TProcesadorLocal *******************************
}
constructor TProcesadorLocal.Create;
begin
end;

procedure TProcesadorLocal.ejecutar(IDAccion, unaUbicacion: string; 
        unaListaParametros: TListaParametros);
var
  HandleDLL: THandle;
  
  ejecutar : function(var pointer:pnodo): pnodo; stdcall;
  listaPunteros, listaRes , cola, nodo: pnodo;
  listaResultados: TListaParametros;
  parametro: TParametro;
  
begin
  listapunteros:=nil;
  
  try
    HandleDLL:=LoadLibrary(PChar(unaUbicacion));
    if HandleDLL = 0 then
      raise Exception.Create('No se pudo cargar la DLL');
    @ejecutar :=GetProcAddress(HandleDLL, '_Ejecutar');
    if not assigned(ejecutar) then
        raise Exception.Create('No se encontraron las funciones en la DLL'+#13+
                               'Cannot find the required DLL functions');
    parametro := unaListaParametros.primero;
    while Assigned(parametro) do
    begin
      nodo := new(pnodo);
      nodo.valor := parametro.getPointer;
      nodo.siguiente := nil;
      if not assigned(listaPunteros) then
      //primer nodo
        listaPunteros := nodo
      else
        cola.siguiente := nodo;
      cola:= nodo;
      parametro := unaListaParametros.siguiente;
    end;
  except
    raise Exception.Create('Error al intentar abrir el archivo '+unaUbicacion);
  end;
  
  try
    listaRes:=ejecutar(listaPunteros);
  except
    raise Exception.Create('Error al ejecutar el archivo '+unaUbicacion);
  end;
  
  try
    parametro := unaListaParametros.primero;
    nodo := listaRes;
    while Assigned(parametro) and assigned(nodo) do
    begin
      parametro.setPointer(nodo.valor);
  
      nodo := nodo.siguiente;
      parametro := unaListaParametros.siguiente;
    end;
  except
    raise Exception.Create('Error al recrear la lista de parámetros '+unaUbicacion);
  end;
  
  TOrganizadorEjecucion.Instance.finEjecucion(IDAccion, unaListaParametros);
  
end;

{
******************************** TAccionTrabajo ********************************
}
constructor TAccionTrabajo.Create(unTrabajo: TTrabajo);
begin
end;

procedure TAccionTrabajo.ejecutar(unProcesador:TProcesador);
begin
  unprocesador.ejecutar(self.ID,ubicacion,trabajo.getListaParametros);
end;

function TAccionTrabajo.getPadreID: string;
begin
  { TODO: result := trabajo.getId;}
end;

procedure TAccionTrabajo.setResultados(unaListaParametros:TListaParametros);
begin
  trabajo.setResultados(tlistapropiedades(unaListaParametros));
end;


function TAlgoritmo.getListaIdiomas: TStringList;
var
  idioma :TIdioma;
begin
  result:= TStringList.Create;
  idioma := listaIdiomas.primero;
  while Assigned(idioma) do
  begin
    result.Add(idioma.getCodigo);
    idioma := listaIdiomas.siguiente;
  end;
end;

end.
