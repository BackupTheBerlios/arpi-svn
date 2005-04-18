unit uTipos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Contnrs, ExtCtrls, Jpeg, uIdiomas, uLista,
  uConsts, XMLIntf, XMLDoc, GraphicEx;

type
  RComplejo = Record
    real, imaginario: extended;
  end;

  TMString = Array of Array of string;

  tbitmapbits = array [0..0] of byte;
  Pbitmapbits = ^tbitmapbits;

  RValorImagen = Record
    MDatos: Array of Array of Byte;
    Paleta: Array [0..255] of TRGBQuad;
    Mascara: Array of Array of Byte;
    Height, Width:integer;
  end;

  RSeleccionImagen = Record
  end;

  RCelda= record
    unaColumna: Integer;
    unaFila: Integer;
    unValor: string;
  end;

  TTipo = class (TObject)
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure agregarIdioma(unIdioma:TIdioma); virtual;
    function getDFM: string; virtual; abstract;
    function getNombre: string; virtual;
    function getValor(unIdioma:string): string; virtual; abstract;
    procedure getXML(var XML: IXMLNode); virtual; abstract;
    procedure quitarIdioma(unIdioma: TIdioma); virtual;
    procedure setValor(unValor, unIdioma: string); overload; virtual; abstract;
    procedure setValor(unValor: string; listaIdiomas: TlistaIdiomas); overload; 
            virtual; abstract;
    procedure setXML(XML:IXMLNode); virtual; abstract;
  end;
  
  RTipoCelda= record
    unaColumna: Integer;
    unaFila: Integer;
    unTipo: TTipo;
  end;

  TTipoContenible = class (TTipo)
  public
    constructor Create; override;
    destructor Destroy; override;
  end;
  
  TLetra = class (TTipoContenible)
  private
    valor: Char;
  public
    constructor Create; override;
    function getDFM: string; override;
    function getValor(unIdioma:string): string; override;
    procedure getXML(var XML: IXMLNode); override;
    procedure setValor(unValor, unIdioma: string); override;
    procedure setXML(XML:IXMLNode); override;
  end;
  
  TMatrizSimple = class (TObject)
  private
    listaCeldas: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure agregar(unaFila, unaColumna:integer; 
            unTipoContenible:TTipoContenible);
    function cantidadColumnas: Integer;
    function cantidadFilas: Integer;
    procedure eliminarCelda(unaFila, unaColumna:integer);
    procedure eliminarFila(unaFila:integer);
    function getArrayString: TMString;
    function getCelda(unaFila, unaColumna:integer): TTipoContenible;
    procedure getXML(var XML:IXMLNode);
    procedure insertarFila(unaFila:integer);
    procedure setValor(unaFila, unaColumna:integer; unValor:string);
    procedure setXML(XML:IXMLNode);
  end;
  

  TComando = class (TObject)
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; virtual; abstract;
  end;
  
  TListaComandos = class (TLista)
  public
    procedure agregar(unComando:TComando);
    procedure modificar(unComando:TComando);
    function primero: TComando;
    function siguiente: TComando;
  end;
  

  THistorialComandos = class (TObject)
  private
    indiceHistorial: Integer;
    listaComandos: TListaComandos;
  public
    constructor Create;
    destructor Destroy; override;
    procedure agregar(unComando:TComando);
    function deshacer: TComando;
    procedure modificar(unComando: TComando);
    function rehacer: TComando;
  end;
  
  TEstructura = class (TTipo)
  private
    nombre: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure abrir(nombreArchivo: string);
    procedure deshacer; virtual; abstract;
    function getIDNombre: string; virtual; abstract;
    function getNombre: string;
    procedure guardar(nombreArchivo: string); virtual;
    procedure imprimir; virtual; abstract;
    procedure rehacer; virtual; abstract;
    procedure setNombre(unNombre: string);
  end;
  
  TArreglo = class (TEstructura)
  private
    historial: THistorialComandos;
    Matriz: TMatrizSimple;
    tipoDato: string;
    valorInicial: string;
    function tipoEstructura: string; virtual; abstract;
  public
    constructor create(filas,columnas: integer; tipoDato, valorInicial: string);
    procedure abrir(nombreArchivo: String);
    function getArrayString: TMString;
    function getIDNombre: string; virtual; abstract;
    procedure setXML(XML: IXMLNode);
  end;
  

  TListaValorImagen = class (TObject)
  public
    constructor Create;
    destructor Destroy; override;
    procedure agregar(ValorImagen:RValorImagen);
    function siguiente: RValorImagen;
  end;
  

  THistorialImagen = class (TObject)
  private
    actualHistorial: Integer;
    listahistorial: TListaValorImagen;
  public
    constructor Create;
    destructor Destroy; override;
    procedure agregar(valorImagen:RValorImagen);
    function deshacer(valorImagen:RValorImagen): RValorImagen;
    function rehacer(valorImagen:RValorImagen): RValorImagen;
  end;
  
  TJpegToBmp = class (TComponent)
  private
    FBmp: TBitmap;
    FBmpFile: AnsiString;
    FImage: TImage;
    FJpeg: TJpegImage;
    FJpegFile: AnsiString;
    FStreamBmp: TStream;
    FStreamJpg: TStream;
  protected
    procedure FCopyJpegToBmp;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CopyJpegToBmp;
  published
    property BmpFile: AnsiString read FBmpFile write FBmpFile;
    property Image: TImage read FImage write FImage;
    property JpegFile: AnsiString read FJpegFile write FJpegFile;
  end;
  
  TImagen = class (TEstructura)
  private
    historial: THistorialImagen;
    seleccionImagen: RSeleccionImagen;
    valorImagen: RValorImagen;
    function generarBitmap(altura,ancho:integer;bitmapbits:Pbitmapbits; 
            valor:RValorImagen): TBitmap;
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create; override;
    destructor Destroy; override;
    function abrir(nombreArchivo:string): TBitmap; reintroduce; overload;
    procedure adquirirImagen(imagen:TBitmap);
    procedure borrarSeleccion;
    procedure deshacer; override;
    function getPointer: Pointer;
    function getSeleccion: TImagen;
    procedure getXML(var XML: IXMLNode); override;
    procedure guardar(nombreArchivo: string); override;
    procedure imprimir; override;
    procedure rehacer; override;
    procedure setImagen(unaImagen:TImagen; unaPosicion:TPoint);
    procedure setValor(unValor, unIdioma: string); overload; override;
    procedure setValor(valor:RValorImagen); overload;
    procedure setValor(unValor: string; listaIdiomas: TlistaIdiomas); overload; 
            override;
    procedure setXML(XML:IXMLNode); override;
  end;
  
  TListaTipos = class (TLista)
  public
    procedure agregar(tipoContenible: TTipoContenible);
    function buscar(unaFila, unaColumna:integer): TTipoContenible;
    procedure insertar(tipoContenible: TTipoContenible; index:integer);
    function primero: TTipoContenible;
    function siguiente: TTipoContenible;
  end;
  
  TCmdMatrizInsertarFila = class (TComando)
  private
    cantidadFilas: Integer;
    filaInicial: Integer;
    lista: array of RTipoCelda;
    tipoDato: string;
    unValor: string;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(filaInicial, cantidadFilas: integer; tipoDato, 
            unValor:string); overload;
    procedure inicializa(unaFila, unaColumna: integer; unTipo:TTipoContenible); 
            overload;
  end;
  
  TCmdMatrizCopiar = class (TComando)
  private
    columnaFinal: Integer;
    columnaInicial: Integer;
    filaFinal: Integer;
    filainicial: Integer;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(filainicial, columnaInicial, filaFinal, columnaFinal: 
            integer);
  end;
  
  TCmdMatrizCortar = class (TComando)
  private
    columnaFinal: Integer;
    columnaInicial: Integer;
    filaFinal: Integer;
    filainicial: Integer;
    valorInicial: string;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(filainicial, columnaInicial, filaFinal, columnaFinal: 
            integer; valorInicial: string);
  end;
  
  TCmdMatrizPegar = class (TComando)
  private
    columnaFinal: Integer;
    columnaInicial: Integer;
    filaFinal: Integer;
    filainicial: Integer;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(filaInicial, columnaInicial, filaFinal, 
            columnaFinal:integer);
  end;
  
  TCmdVectorPegar = class (TCmdMatrizPegar)
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
  end;
  
  TCmdMatrizModificar = class (TComando)
  private
    lista: array of RCelda;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(unaFila, unaColumna: integer; unValor:string);
  end;
  
  TCmdMatrizInsertarColumna = class (TComando)
  private
    cantidadColumnas: Integer;
    columnaInicial: Integer;
    lista: array of RTipoCelda;
    tipoDato: string;
    unValor: string;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(columnaInicial, cantidadColumnas: integer; tipoDato, 
            unValor:string); overload;
    procedure inicializa(unaFila, unaColumna: integer; unTipo:TTipoContenible); 
            overload;
  end;
  
  TCmdMatrizInicializar = class (TComando)
  private
    nroColumnas: Integer;
    nroFilas: Integer;
    tipoDato: string;
    valorInicial: string;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(nroFilas, nroColumnas:integer; tipoDato, 
            valorInicial:string);
  end;
  
  TCmdMatrizEliminarFila = class (TComando)
  private
    filaFinal: Integer;
    filainicial: Integer;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(filainicial, filaFinal: integer);
  end;
  
  TCmdMatrizEliminarColumna = class (TComando)
  private
    columnaFinal: Integer;
    columnaInicial: Integer;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(columnaInicial, columnaFinal: integer);
  end;
  
  TMatriz = class (TEstructura)
  private
    historial: THistorialComandos;
    Matriz: TMatrizSimple;
    tipoDato: string;
    valorInicial: string;
    function getIDNombre: string; override;
    function tipoEstructura: string;
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create; override;
    procedure abrir(nombreArchivo: String);
    function copiarMatriz(filaInicial, columnaInicial, filaFinal, 
            columnaFinal:integer): TMatrizSimple;
    function cortarMatriz(filaInicial, columnaInicial, filaFinal, 
            columnaFinal:integer): TMatrizSimple;
    procedure deshacer; override;
    procedure eliminarColumnas(columnaIncial, columnaFinal:integer);
    procedure eliminarFilas(filaIncial, filaFinal:integer);
    function getArrayString: TMString;
    procedure getXML(var XML: IXMLNode); override;
    procedure guardar(nombreArchivo: string); override;
    procedure imprimir; override;
    procedure inicializa(nroFilas, nroColumnas:integer; tipoDato, 
            valorInicial:string);
    procedure insertarColumnas(unaColumna, cantidadColumnas:integer);
    procedure insertarFilas(unaFila, cantidadFilas:integer);
    procedure modificarCelda(unaFila, unaColumna: integer; unValor:string);
    procedure pegarMatriz(filaInicial, columnaInicial, filaFinal, 
            columnaFinal:integer);
    procedure redimensionar(filas, columnas: integer);
    procedure rehacer; override;
    procedure setValor(unValor, unIdioma: string); overload; override;
    procedure setValor(unValor: string; listaIdiomas: TlistaIdiomas); overload; 
            override;
    procedure setXML(XML: IXMLNode);
    procedure _agregar(unTipoContenible:TTipoCOntenible);
    procedure _getValor(unaCelda:integer);
    procedure _setMatrizSimple(matrizSimple: TmatrizSimple);
  end;
  
  TVector = class (TEstructura)
  private
    function getIDNombre: string; override;
    function tipoEstructura: string;
    class function updateNumero(numero:integer=-1): Word;
  public
    destructor Destroy; override;
    procedure copiar(celdaInicial, celdaFinal:integer);
    procedure cortar(celdaInicial, celdaFinal:integer);
    procedure deshacer; override;
    procedure eliminarCeldas(celdaInicial, celdaFinal:integer);
    procedure getXML(var XML: IXMLNode); override;
    procedure guardar(nombreArchivo: string); override;
    procedure imprimir; override;
    procedure inicializa(nroCeldas:integer; tipoDato, valorInicial:string);
    procedure insertarCeldas(unaCelda, cantidadCeldas:integer);
    procedure modificarCelda(unaCelda:integer; unValor:string);
    procedure pegarVector(celdaInicial, celdaFinal:integer);
    procedure rehacer; override;
    procedure setValor(unValor, unIdioma: string); overload; override;
    procedure setValor(unValor: string; listaIdiomas: TlistaIdiomas); overload; 
            override;
    procedure _agregar(unTipoContenible:TTipoContenible);
    procedure _eliminarFilas(filaInicial, filaFinal:integer);
    procedure _getValor(unaCelda:integer);
    procedure _setVectorSimple(vectorSimple:TMatrizSimple);
  end;
  
  TTextoSimple = class (TObject)
  private
    idioma: TIdioma;
    valor: string;
  public
    function getDFM: string;
    function getIdioma: TIdioma;
    function getValor: string;
    procedure getXML(var XML: IXMLNode);
    procedure setIdioma(unIdioma:TIdioma);
    procedure setValor(unValor: string);
    procedure setXML(XML:IXMLNode);
  end;
  
  TListaTextos = class (TLista)
  public
    procedure agregar(unTexto: TTextoSimple);
    function buscar(unIdioma:TIdioma): TTextoSimple;
    function primero: TTextoSimple;
    function siguiente: TTextoSimple;
  end;
  
  TTexto = class (TTipo)
  private
    listaTextos: TListaTextos;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure agregarIdioma(unIdioma:TIdioma); override;
    function getDFM: string; override;
    function getValor(unIdioma:string): string; override;
    procedure getXML(var XML: IXMLNode); override;
    procedure quitarIdioma(unIdioma: TIdioma); override;
    procedure setValor(unValor, unIdioma: string); overload; override;
    procedure setValor(unValor: string; listaIdiomas: TlistaIdiomas); overload; 
            override;
    procedure setXML(XML:IXMLNode); override;
    function siguiente: TListaTextos;
    procedure _agregar(unTexto:string; unIdioma:TIdioma);
  end;
  
  TNumero = class (TTipoContenible)
  private
    valor: Double;
  public
    constructor Create; override;
    function getDFM: string; override;
    function getValor(unIdioma: string): string; override;
    procedure getXML(var XML: IXMLNode); override;
    procedure setValor(unValor, unIdioma: string); overload; override;
    procedure setValor(unValor: string; listaIdiomas: TlistaIdiomas); overload; 
            override;
    procedure setXML(XML:IXMLNode); override;
  end;
  
  TNumeroEntero = class (TNumero)
  public
    function getDFM: string; override;
    function getValor(unIdioma: string): string; override;
    procedure getXML(var XML: IXMLNode); override;
    procedure setValor(unValor, unIdioma: string); overload; override;
    procedure setValor(unValor: string; listaIdiomas: TlistaIdiomas); overload; 
            override;
    procedure setXML(XML:IXMLNode); override;
  end;
  
  TComplejo = class (TTipoContenible)
  private
    valor: RComplejo;
  public
    constructor Create; override;
    function getDFM: string; override;
    function getValor(unIdioma: string): string; override;
    procedure getXML(var XML: IXMLNode); override;
    procedure setValor(unValor, unIdioma: string); overload; override;
    procedure setValor(unValor: string; listaIdiomas: TlistaIdiomas); overload; 
            override;
    procedure setXML(XML:IXMLNode); override;
  end;
  

procedure Register;

implementation

uses
  Math, uBuilderTipoDatos, uPortapapeles;

procedure Register;
begin
  RegisterComponents('VCL', [TJpegToBmp]);
end;

{
************************************ TTipo *************************************
}
constructor TTipo.Create;
begin
end;

destructor TTipo.Destroy;
begin
end;

procedure TTipo.agregarIdioma(unIdioma:TIdioma);
begin
end;

function TTipo.getNombre: string;
begin
  result := 'Tipo';
end;

procedure TTipo.quitarIdioma(unIdioma: TIdioma);
begin
end;

{
******************************* TTipoContenible ********************************
}
constructor TTipoContenible.Create;
begin
end;

destructor TTipoContenible.Destroy;
begin
end;

{
************************************ TLetra ************************************
}
constructor TLetra.Create;
begin
  valor := 'a';
end;

function TLetra.getDFM: string;
begin
  result := valor;
end;

function TLetra.getValor(unIdioma:string): string;
begin
  result:=valor;
end;

procedure TLetra.getXML(var XML: IXMLNode);
var
  aux: IXMLNode;
begin
  aux:=XML.AddChild('letra');
  aux.Text := getValor('');
end;

procedure TLetra.setValor(unValor, unIdioma: string);
begin
  valor := unValor[1];
end;

procedure TLetra.setXML(XML:IXMLNode);
begin
  setValor(XML.ChildNodes.Nodes[0].Text,'');
end;

{
******************************** TListaComandos ********************************
}
procedure TListaComandos.agregar(unComando:TComando);
begin
  inherited agregar(unComando);
end;

procedure TListaComandos.modificar(unComando:TComando);
begin
  inherited modificar(unComando);
end;

function TListaComandos.primero: TComando;
var
  aux: TObject;
begin
  aux:=inherited primero;
  if Assigned(aux) then
    result :=TComando(aux)
  else
    result := nil;
end;

function TListaComandos.siguiente: TComando;
var
  aux: TObject;
begin
  aux:=inherited siguiente;
  if Assigned(aux) then
    result :=TComando(aux)
  else
    result := nil;
end;

{
****************************** THistorialComandos ******************************
}
constructor THistorialComandos.Create;
begin
  listaComandos := TListaComandos.Create;
  indiceHistorial := 0;
end;

destructor THistorialComandos.Destroy;
var
  comando: TComando;
begin
  comando := listaComandos.primero;
  while Assigned(comando) do
  begin
    FreeAndNil(comando);
    comando := listaComandos.siguiente;
  end;
  FreeAndNil(listaComandos);
end;

procedure THistorialComandos.agregar(unComando:TComando);
var
  i: Integer;
  comando: TComando;
begin
  comando:= listaComandos.primero;
  for i:= 0 to indiceHistorial+1 do
    comando:= listaComandos.siguiente;
  while Assigned(comando) do
  begin
    listaComandos.eliminar(comando);
    comando:= listaComandos.siguiente;
  end;
  listaComandos.agregar(unComando);
  inc(indiceHistorial);
end;

function THistorialComandos.deshacer: TComando;
var
  i: Integer;
  comando: TComando;
begin
  comando:= listaComandos.primero;
  for i:= 0 to indiceHistorial do
    comando := listaComandos.siguiente;
  result := comando;
  dec(indiceHistorial);
end;

procedure THistorialComandos.modificar(unComando: TComando);
begin
  listaComandos.modificar(unComando);
end;

function THistorialComandos.rehacer: TComando;
var
  i: Integer;
  comando: TComando;
begin
  comando:= listaComandos.primero;
  for i:= 0 to indiceHistorial+1 do
    comando := listaComandos.siguiente;
  result := comando;
  inc(indiceHistorial);
end;

{
********************************* TEstructura **********************************
}
constructor TEstructura.Create;
begin
end;

destructor TEstructura.Destroy;
begin
end;

procedure TEstructura.abrir(nombreArchivo: string);
begin
end;

function TEstructura.getNombre: string;
begin
  result := nombre;
end;

procedure TEstructura.guardar(nombreArchivo: string);
begin
end;

procedure TEstructura.setNombre(unNombre: string);
begin
  nombre:= unNombre;
end;

{
****************************** TListaValorImagen *******************************
}
constructor TListaValorImagen.Create;
begin
end;

destructor TListaValorImagen.Destroy;
begin
end;

procedure TListaValorImagen.agregar(ValorImagen:RValorImagen);
begin
end;

function TListaValorImagen.siguiente: RValorImagen;
begin
end;

{
******************************* THistorialImagen *******************************
}
constructor THistorialImagen.Create;
begin
  listaHistorial:= TListaValorImagen.Create;
end;

destructor THistorialImagen.Destroy;
begin
end;

procedure THistorialImagen.agregar(valorImagen:RValorImagen);
begin
end;

function THistorialImagen.deshacer(valorImagen:RValorImagen): RValorImagen;
begin
end;

function THistorialImagen.rehacer(valorImagen:RValorImagen): RValorImagen;
begin
end;

{
******************************** TMatrizSimple *********************************
}
constructor TMatrizSimple.Create;
begin
  listaCeldas:= TObjectList.Create;
end;

destructor TMatrizSimple.Destroy;
var
  i, j: Integer;
  tipo: TTipoContenible;
begin
  for i:= listaCeldas.Count-1 downto 0 do
  begin
    for j:= TObjectList(listaCeldas.Items[i]).Count-1 downto 0 do
    begin
      tipo:=TTipoContenible(TObjectList(listaCeldas.Items[i]).Items[j]);
      FreeAndNil(tipo);
    end;
    FreeAndNil(listaCeldas);
  end;
  FreeAndNil(listaCeldas);
end;

procedure TMatrizSimple.agregar(unaFila, unaColumna:integer; 
        unTipoContenible:TTipoContenible);
begin
  if (listaCeldas.Count < unaFila) or (TObjectList(listaCeldas.Items[unaFila-1]).Count<unaColumna) then
    TObjectList(listaCeldas.Items[unaFila-1]).Insert(unaColumna-1, unTipoContenible)
  else
    raise Exception.CreateFmt('No se puede agregar el valor en la celda [%d;%d]',[unaFila, unaColumna])
end;

function TMatrizSimple.cantidadColumnas: Integer;
begin
  result := TObjectList(listaCeldas.Items[0]).Count;
end;

function TMatrizSimple.cantidadFilas: Integer;
begin
  result := listaCeldas.Count;
end;

procedure TMatrizSimple.eliminarCelda(unaFila, unaColumna:integer);
begin
  TObjectList(listaCeldas.Items[unaFila-1]).Delete(unaColumna-1);
end;

procedure TMatrizSimple.eliminarFila(unaFila:integer);
begin
  listaCeldas.Delete(unaFila-1);
end;

function TMatrizSimple.getArrayString: TMString;
var
  i, j: Integer;
  aux: TMString;
begin
  SetLength(aux,cantidadFilas,cantidadColumnas);
  for i:= 0 to cantidadFilas do
    for j:= 0 to cantidadColumnas do
      aux[i,j] := TTipoContenible(getCelda(i,j)).getValor('');
  
end;

function TMatrizSimple.getCelda(unaFila, unaColumna:integer): TTipoContenible;
begin
  if (listaCeldas.Count < unaFila) or (TObjectList(listaCeldas.Items[unaFila-1]).Count<unaColumna) then
    result := TTipoContenible(TObjectList(listaCeldas.Items[unaFila-1]).Items[unaColumna-1])
  else
    raise Exception.CreateFmt('No se puede agregar el valor en la celda [%d;%d]',[unaFila, unaColumna])
end;

procedure TMatrizSimple.getXML(var XML:IXMLNode);
var
  fila, celda: IXMLNode;
  i, j: Integer;
begin
  for i:= 0 to listaCeldas.Count-1 do
  begin
    fila := XML.AddChild('fila');
    for j:= 0 to TObjectList(listaCeldas.Items[i]).Count-1 do
      TTipoContenible(TObjectList(listaCeldas.Items[i]).Items[j]).getXML(fila);
  end;
end;

procedure TMatrizSimple.insertarFila(unaFila:integer);
begin
  listaCeldas.Insert(unaFila, TObjectList.Create);
end;

procedure TMatrizSimple.setValor(unaFila, unaColumna:integer; unValor:string);
begin
  if (listaCeldas.Count < unaFila) or (TObjectList(listaCeldas.Items[unaFila-1]).Count<unaColumna) then
    TTipoContenible(TObjectList(listaCeldas.Items[unaFila-1]).Items[unaColumna-1]).setValor(unValor,'')
  else
    raise Exception.CreateFmt('No se puede cambiar el valor en la celda [%d;%d]',[unaFila, unaColumna])
end;

procedure TMatrizSimple.setXML(XML:IXMLNode);
var
  matriz, fila, celda: IXMLNode;
  i, j: Integer;
  tipo: TTipo;
begin
  for i:= 0 to XML.ChildNodes.Nodes[0].ChildNodes.Count-1 do
  begin
    listaCeldas.Add(TObjectList.Create);
    fila := XML.ChildNodes.Nodes[i];
    for j:= 0 to fila.ChildNodes.Nodes[0].ChildNodes.Count-1  do
    begin
      tipo:=TBuilderTipoDato.Instance.CreateTipo(fila.ChildNodes.Nodes[j].NodeName);
      tipo.setXML(fila.ChildNodes.Nodes[j]);
      listaCeldas.Add(tipo);
    end;
  end;
end;

{
********************************** TJpegToBmp **********************************
}
constructor TJpegToBmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FJpeg := TJpegImage.Create;
  FBmp  := TBitmap.Create;
end;

destructor TJpegToBmp.Destroy;
begin
  FJpeg.Free;
  FBmp.Free;
  inherited Destroy;
end;

procedure TJpegToBmp.CopyJpegToBmp;
begin
  FCopyJpegToBmp;
end;

procedure TJpegToBmp.FCopyJpegToBmp;
begin
  if FileExists(FBmpFile) then DeleteFile(FBmpFile);
  FStreamBmp := TFileStream.Create(FBmpFile,fmCreate);
  FStreamJpg := TFileStream.Create(FJpegFile, fmOpenRead);
  
  try
    FBmp.PixelFormat := pf8bit;
    FJpeg.LoadFromStream(FStreamJpg);
    FBmp.Width := FJpeg.Width;
    FBmp.Height := FJpeg.Height;
    FBmp.Canvas.Draw(0,0,FJpeg);
    FBmp.SaveToStream(FStreamBmp);
  finally
    FStreamJpg.Free;
    FStreamBmp.Free;
  end;
end;

{
*********************************** TImagen ************************************
}
constructor TImagen.Create;
begin
  historial := THistorialImagen.Create;
end;

destructor TImagen.Destroy;
begin
  with valorImagen do // no se si esta bien
  begin
  //     freemem(MDatos,Height*Width);
  //     freemem(Mascara,Height*Width);
  end;
end;

function TImagen.abrir(nombreArchivo:string): TBitmap;
var
  bitmapbits: Pbitmapbits;
  looprow, loopcol, colores: Integer;
  paleta: array [0..255] of TRGBQuad;
  cantentradas: Integer;
  JPG2BMP: TJpegToBmp;
  GraphicClass: TGraphicExGraphicClass;
  Graphic: TGraphic;
  ImagenBM: TBitmap;
  imagen1: Timage;
begin
  {DONE: Levanta BMP, PCX(256 greyscale), TIFF(256 greyscale), JPG}
  {DONE: Forzar a leer hasta que se obtengan los bits}
  imagen1:= TImage.Create(application);
  repeat
    GraphicClass := FileFormatList.GraphicFromContent(nombreArchivo);
    if GraphicClass = nil then
    begin // si falló, manualmente... damn!!
      if (uppercase(ExtractFileExt(nombreArchivo))='.JPG') or  (uppercase(ExtractFileExt(nombreArchivo))='.JPEG') then
      begin
        JPG2BMP:= TJpegToBmp.Create(Application);
        JPG2BMP.JpegFile:= nombreArchivo;
        JPG2BMP.BmpFile:='temporal.bmp';
        JPG2BMP.CopyJpegToBmp;
          // cargar imagen
        ImagenBM:=TBitmap.Create;
        ImagenBM.LoadFromFile('temporal.bmp');
        imagen1.Picture.LoadFromFile('temporal.bmp');
    //      TheBitmap := LoadImage(0,PChar('temporal.bmp'),IMAGE_BITMAP,0,0,LR_LOADFROMFILE);
        cantentradas := GetDIBColorTable(ImagenBM.Canvas.Handle,0,256,valorImagen.paleta);
        DeleteFile('temporal.bmp')
      end;
      if (uppercase(ExtractFileExt(nombreArchivo)) = '.BMP') then
      begin
        ImagenBM:=TBitmap.Create;
        Imagen1.Picture.LoadFromFile(nombreArchivo);
        ImagenBM.LoadFromFile(nombreArchivo);
        cantentradas := GetDIBColorTable(ImagenBM.Canvas.Handle,0,256,valorImagen.paleta);
      end;
      if (uppercase(ExtractFileExt(nombreArchivo))= '.PCX') then
      begin
        Graphic:= TPCXGraphic.Create;
        Graphic.LoadFromFile(nombreArchivo);
        Imagen1.Picture.Graphic := Graphic;
        GetPaletteEntries(Imagen1.Picture.Graphic.Palette,0,256,valorimagen.paleta);
        ImagenBM:=TBitmap.Create;
        ImagenBM.Assign(imagen1.Picture.Bitmap);
      end;
    end
    else
    begin
        // GraphicFromContent always returns TGraphicExGraphicClass
      Graphic := GraphicClass.Create;
      Graphic.LoadFromFile(nombreArchivo);
      Imagen1.Picture.Graphic := Graphic;
      GetPaletteEntries(Imagen1.Picture.Graphic.Palette,0,256,valorimagen.paleta);
      ImagenBM:=TBitmap.Create;
      ImagenBM.Assign(imagen1.Picture.Bitmap);
    end;
  
      // crear las matrices dinamicas de datos y mascara
    with valorImagen do
    begin
          // DATOS
      Height:=ImagenBM.Height;
      Width:=ImagenBM.Width;
      SetLength(Mdatos,ImagenBM.Height);
      for cantentradas:=low(Mdatos) to high(Mdatos) do
        SetLength(Mdatos[cantentradas],ImagenBM.Width);
          //MASCARA
      SetLength(Mascara,ImagenBM.Height);
      for cantentradas:=low(Mascara) to high(Mascara) do
        SetLength(Mascara[cantentradas],ImagenBM.Width); // GENERA UNA MATRIZ LLENA DE CEROS
          // fin crear las matrices dinamicas de datos y mascara
          // reservar espacio en memoria para la matriz  ImagenBM.Handle
      bitmapbits:=AllocMem(ImagenBM.Height*ImagenBM.Width);
      cantentradas:=GetBitmapBits(imagen1.Picture.Bitmap.Handle,Height*Width,bitmapbits);
          // fin reservar espacio en memoria para la matriz
          // almacenar matriz de valores
      for looprow:=0 to  Height-1 do
        for loopcol:= 0 to Width-1 do
        begin
            // pasarlos a la matriz -yuppi!!!!!!!!!!
        valorImagen.mdatos[looprow,loopcol]:=bitmapbits[looprow*Width+loopcol]
            // fin pasarlos a la matriz -yuppi!!!!!!!!!!
        end;
          // fin almacenar matriz de valores
    end;
  until cantentradas > 0;
  ImagenBM.Free;
  result:=generarBitmap(valorImagen.Height,valorImagen.Width,bitmapbits,valorimagen);
  FreeMem(bitmapbits,valorImagen.Height*valorImagen.Width);
end;

procedure TImagen.adquirirImagen(imagen:TBitmap);
var
  bitmapbits: Pbitmapbits;
  looprow, loopcol, colores: Integer;
  paleta: array [0..255] of TRGBQuad;
  cantentradas: Integer;
  ImagenBM: TBitmap;
begin
  with valorImagen do
  begin
      // DATOS
    Height:=imagen.Height;
    Width:=imagen.Width;
    SetLength(Mdatos,imagen.Height);
    for cantentradas:=low(Mdatos) to high(Mdatos) do
      SetLength(Mdatos[cantentradas],imagen.Width);
      //MASCARA
    SetLength(Mascara,imagen.Height);
    for cantentradas:=low(Mascara) to high(Mascara) do
      SetLength(Mascara[cantentradas],imagen.Width); // GENERA UNA MATRIZ LLENA DE CEROS
      // fin crear las matrices dinamicas de datos y mascara
      // reservar espacio en memoria para la matriz
    getmem(bitmapbits,imagen.Height*imagen.Width);
    GetBitmapBits(Imagen.Handle,imagen.Height*imagen.Width,bitmapbits);
      // fin reservar espacio en memoria para la matriz
  
      // almacenar matriz de valores
    for looprow:=0 to  Height-1 do
      for loopcol:= 0 to Width-1 do
      begin
        // pasarlos a la matriz -yuppi!!!!!!!!!!
      valorImagen.mdatos[looprow,loopcol]:=bitmapbits[looprow*Width+loopcol]
        // fin pasarlos a la matriz -yuppi!!!!!!!!!!
      end;
      // fin almacenar matriz de valores
  
      // almacenar paleta
    cantentradas := GetDIBColorTable(Imagen.Canvas.Handle,0,256,valorImagen.paleta);
      // fin almacenar paleta
  end;
end;

procedure TImagen.borrarSeleccion;
  
  type
    puntoseleccion = record
        x,y:integer;
    end;
  var
    srchH,srchV, fila, columna:integer;
    IzqArr,DerAbj:puntoseleccion;
    topf,botf:boolean;
  
begin
  topf:=false;
  botf:=false;
  // obtener el area seleccionada
  // utilizando busqueda desde el extremo superior izquierdo
  // al centro y del inferior derecho al centro, por filas
  for srchV:=0 to (valorImagen.Height-1) mod 2 do
    for srchH:=0 to (valorImagen.Width-1) do //en el inferior uso width-1-srchH
    begin
      if (valorimagen.Mascara[srchV,srchH] = 1)  and (not topf) then
      begin
        IzqArr.x:=srchH;
        IzqArr.y:=srchV;
        topf:= true;
      end;
      if (valorimagen.Mascara[((valorImagen.Height-1)-srchV),((valorImagen.Width-1)-srchH)] = 1)  and (not botf) then
      begin
        DerAbj.x:=((valorImagen.Width-1)-srchH);
        DerAbj.y:=((valorImagen.Height-1)-srchV);
        botf:= true;
      end;
      // obtenidos las esquinas superior/izq e inferior/derecha
      if topf and botf then
        Break;
    end;
      if topf and botf then
        for fila:= IzqArr.y to DerAbj.y do
          for columna:=IzqArr.x to DerAbj.x do
            valorImagen.mdatos[IzqArr.y,IzqArr.x]:= 0;
end;

procedure TImagen.deshacer;
var
  valorAux: RValorImagen;
begin
  valorAux:=valorImagen;
  inherited deshacer;
  valorImagen:=historial.deshacer(valorAux);
end;

function TImagen.generarBitmap(altura,ancho:integer;bitmapbits:Pbitmapbits; 
        valor:RValorImagen): TBitmap;
var
  ImagenBM: TBitmap;
  garbage: Integer;
begin
  ImagenBM:=TBitmap.Create;
  imagenbm.Height := altura;
  ImagenBM.Width:=ancho;
  ImagenBM.PixelFormat := pf8bit;
  garbage:=SetBitmapBits(ImagenBM.Handle,altura*ancho,bitmapbits);
  garbage:=SetDIBColorTable(ImagenBM.Canvas.Handle,0,255,valor.paleta);
  result:= ImagenBM;
end;

function TImagen.getPointer: Pointer;
var
  retorno: ^RValorImagen;
begin
  new(retorno);
  retorno.MDatos:=copy(valorImagen.MDatos);
  retorno.Mascara:=copy(valorImagen.Mascara);
  retorno.paleta:=valorImagen.paleta;
  result := retorno;
  {TODO: recordar dispose(estructura) cuando termina el algoritmo!!!}
end;

function TImagen.getSeleccion: TImagen;
  
  type
    puntoseleccion = record
        x,y:integer;
    end;
  var
    imagenaux:timagen;
    bitmapbits: Pbitmapbits;
    srchH,srchV, fila, columna:integer;
    IzqArr,DerAbj:puntoseleccion;
    topf,botf:boolean;
  
begin
  topf:=false;
  botf:=false;
  // obtener el area seleccionada
  // utilizando busqueda desde el extremo superior izquierdo
  // al centro y del inferior derecho al centro, por filas
  for srchV:=0 to (valorImagen.Height-1) mod 2 do
    for srchH:=0 to (valorImagen.Width-1) do //en el inferior uso width-1-srchH
    begin
      if (valorimagen.Mascara[srchV,srchH] = 1)  and (not topf) then
      begin
        IzqArr.x:=srchH;
        IzqArr.y:=srchV;
        topf:= true;
      end;
      if (valorimagen.Mascara[((valorImagen.Height-1)-srchV),((valorImagen.Width-1)-srchH)] = 1)  and (not botf) then
      begin
        DerAbj.x:=((valorImagen.Width-1)-srchH);
        DerAbj.y:=((valorImagen.Height-1)-srchV);
        botf:= true;
      end;
      // obtenidos las esquinas superior/izq e inferior/derecha
      if topf and botf then
        Break;
    end;
      if topf and botf then
      begin
        for fila:=0 to (DerAbj.y-IzqArr.y) do
          for columna:=0 to (DerAbj.x-IzqArr.x) do
            bitmapbits[fila*(DerAbj.x-IzqArr.x)+columna]:=valorImagen.mdatos[IzqArr.y,IzqArr.x];
        imagenaux:= TImagen.Create;
        imagenaux.adquirirImagen(generarBitmap((DerAbj.y-IzqArr.y),(DerAbj.x-IzqArr.x),bitmapbits,valorimagen));
        result:= imagenaux;
      end
      else
        result:=nil;
end;

procedure TImagen.getXML(var XML: IXMLNode);
begin
end;

procedure TImagen.guardar(nombreArchivo: string);
  
  type
    tbitmapbits = array [0..0] of byte;
  var
    thebitmap: THandle;
    bitmapbits: Pbitmapbits;
    looprow, loopcol, colores:integer;
    varjpg:TJPEGImage;
    ImagenBM:TBitmap;
    graphic:TGraphic;
    imagen1:TImage;
  
begin
  imagen1:=TImage.Create(nil);
  getmem(bitmapbits,valorImagen.Height*valorImagen.Width);
  for looprow:=0 to valorImagen.Height -1 do
    for loopcol:= 0 to valorImagen.Width-1 do
      bitmapbits[looprow*valorImagen.Width+loopcol]:=valorImagen.mdatos[looprow,loopcol];
  ImagenBM:=generarBitmap(valorImagen.Height,valorImagen.Width,bitmapbits,valorImagen);
  imagen1.Picture.Bitmap.Assign(ImagenBM);
  if (uppercase(ExtractFileExt(nombreArchivo)) = '.BMP') then
    ImagenBM.SaveToFile(nombreArchivo)
  else
  if (uppercase(ExtractFileExt(nombreArchivo)) = '.JPG') or (uppercase(ExtractFileExt(nombreArchivo)) = '.JPEG') then
  begin //jpg
    varjpg:= TJPEGImage.Create;
    varjpg.PixelFormat := jf8bit;
    varjpg.JPEGNeeded;
    varjpg.ProgressiveEncoding:= true;
    varjpg.Assign(ImagenBM);
    varjpg.SaveToFile(nombreArchivo);
  end
  else
    raise Exception.Create('Error Archivo de imagen erroneo!');
end;

procedure TImagen.imprimir;
begin
  inherited imprimir;
end;

procedure TImagen.rehacer;
var
  valorAux: RValorImagen;
begin
  valorAux:=valorImagen;
  inherited rehacer;
  valorImagen:=historial.rehacer(valorAux);
end;

procedure TImagen.setImagen(unaImagen:TImagen; unaPosicion:TPoint);
var
  x, y: Integer;
begin
  for y:= unaPosicion.Y to unaPosicion.Y+unaImagen.valorImagen.Height do
    for x:= unaPosicion.X to unaPosicion.X+unaImagen.valorImagen.Width do
      valorImagen.MDatos[x,y]:=unaImagen.valorImagen.MDatos[x-unaPosicion.X,y-unaPosicion.Y];
end;

procedure TImagen.setValor(unValor, unIdioma: string);
begin
end;

procedure TImagen.setValor(valor:RValorImagen);
begin
  valorImagen:=valor;
end;

procedure TImagen.setValor(unValor: string; listaIdiomas: TlistaIdiomas);
begin
  setValor(unValor,'');
end;

procedure TImagen.setXML(XML:IXMLNode);
begin
  inherited setXML(XML);
end;

class function TImagen.updateNumero(numero:integer=-1): Word;
  
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
********************************* TListaTipos **********************************
}
procedure TListaTipos.agregar(tipoContenible: TTipoContenible);
begin
end;

function TListaTipos.buscar(unaFila, unaColumna:integer): TTipoContenible;
begin
  {TODO: Implementar TListaTipos.buscar}
end;

procedure TListaTipos.insertar(tipoContenible: TTipoContenible; index:integer);
begin
  inherited insertar(tipoContenible, index);
end;

function TListaTipos.primero: TTipoContenible;
begin
  {TODO: Implementar TListaTipos.primero}
end;

function TListaTipos.siguiente: TTipoContenible;
begin
  {TODO: Implementar TListaTipos.siguiente}
end;

{
**************************** TCmdMatrizInsertarFila ****************************
}
function TCmdMatrizInsertarFila.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  cmdDeshacer: TCmdMatrizEliminarColumna;
  i, j, filaFinal: Integer;
  tipo: TTipoContenible;
begin
  if Length(lista)>0 then
  begin
    filaInicial:=MaxInt;
    filaFinal:=MinInt;
    for i:=low(lista) to high(lista) do
    begin
      if filaInicial>lista[i].unaColumna then
        filaInicial:=lista[i].unaColumna
      else
        if filaFinal<lista[i].unaColumna then
          filaFinal:=lista[i].unaColumna;
      unaMatriz.agregar(lista[i].unaFila, lista[i].unaColumna, TTipoContenible(lista[i].unTipo));
    end;
    cantidadFilas := filaFinal - filaInicial;
  end
  else
  begin
    tipo := TTipoContenible(TBuilderTipoDato.Instance.CreateTipo(tipoDato));
    tipo.setValor(unValor,'');
    for i:= 1  to cantidadFilas do
      for j:= 1  to unaMatriz.cantidadColumnas do
        unaMatriz.agregar(i, j, tipo);
  end;
  cmdDeshacer:= TCmdMatrizEliminarColumna.Create;
  cmdDeshacer.inicializa(filaInicial, cantidadFilas);
end;

procedure TCmdMatrizInsertarFila.inicializa(filaInicial, cantidadFilas: integer;
        tipoDato, unValor:string);
begin
  self.filaInicial  := filaInicial;
  self.cantidadFilas := cantidadFilas;
  self.tipoDato := tipoDato;
  self.unValor := unValor;
end;

procedure TCmdMatrizInsertarFila.inicializa(unaFila, unaColumna: integer; 
        unTipo:TTipoContenible);
begin
  SetLength(lista, length(lista)+1);
  lista[length(lista)-1].unaFila := unaFila;
  lista[length(lista)-1].unaColumna := unaColumna;
  lista[length(lista)-1].unTipo := unTipo;
end;

{
******************************* TCmdMatrizCopiar *******************************
}
function TCmdMatrizCopiar.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  matrizAux: TMatrizSimple;
  i: Integer;
  j: Integer;
begin
  //  matrizAux := TMatrizSimple.Create;
  //  for i:= filaInicial to filaFinal do
  //  begin
  //    matrizAux.insertarFila(i);
  //    for j:= columnaInicial to columnaFinal do
  //      matrizAux.agregar(i-filaInicial+1, j-columnaInicial+1, unaMatriz.getCelda(i, j));
  //  end;
  //  TPortapapeles.Instance.agregarVector(matrizAux);
end;

procedure TCmdMatrizCopiar.inicializa(filainicial, columnaInicial, filaFinal, 
        columnaFinal: integer);
begin
  self.filainicial := filainicial;
  self.columnaInicial := columnaInicial;
  self.filaFinal := filaFinal;
  self.columnaFinal := columnaFinal;
end;

{
******************************* TCmdMatrizCortar *******************************
}
function TCmdMatrizCortar.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  matrizAux: TMatrizSimple;
  i: Integer;
  j: Integer;
  cmdDeshacer: TCmdMatrizModificar;
begin
  //  matrizAux := TMatrizSimple.Create;
  //  cmdDeshacer := TCmdMatrizModificar.Create;
  //  for i:= filaInicial to filaFinal do
  //  begin
  //    matrizAux.insertarFila(i);
  //    for j:= columnaInicial to columnaFinal do
  //    begin
  //      matrizAux.agregar(i-filaInicial+1, j-columnaInicial+1, unaMatriz.getCelda(i, j));
  //      cmdDeshacer.inicializa(i-filaInicial+1,j-columnaInicial+1,unaMatriz.getCelda(i, j).getValor(''));
  //      unaMatriz.setValor(i, j, ValorInicial);
  //    end;
  //  end;
  //  TPortapapeles.Instance.agregarVector(matrizAux);
end;

procedure TCmdMatrizCortar.inicializa(filainicial, columnaInicial, filaFinal, 
        columnaFinal: integer; valorInicial: string);
begin
  self.filainicial := filainicial;
  self.columnaInicial := columnaInicial;
  self.filaFinal := filaFinal;
  self.columnaFinal := columnaFinal;
  self.valorInicial := valorInicial;
end;

{
******************************* TCmdMatrizPegar ********************************
}
function TCmdMatrizPegar.ejecutar(unaMatriz: TMatrizSimple): TComando;
begin
end;

procedure TCmdMatrizPegar.inicializa(filaInicial, columnaInicial, filaFinal, 
        columnaFinal:integer);
begin
  self.filainicial := filainicial;
  self.columnaInicial := columnaInicial;
  self.filaFinal := filaFinal;
  self.columnaFinal := columnaFinal;
end;

{
******************************* TCmdVectorPegar ********************************
}
function TCmdVectorPegar.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  matrizAux: TMatrizSimple;
  cmdDeshacer: TCmdMatrizModificar;
  i, j: Integer;
  valorAnt, valor: TTipoContenible;
begin
  matrizAux := TPortapapeles.Instance.getVector;
  cmdDeshacer:= TCmdMatrizModificar.Create;
  for i:=filaInicial to filaFinal do
    for j:=columnaInicial to columnaFinal do
    begin
      valorAnt := unaMatriz.getCelda(i, j);
      cmdDeshacer.inicializa(i-filainicial+1, j-columnaInicial+1, valorAnt.getValor(''));
      valor := matrizAux.getCelda(i-filainicial+1, j-columnaInicial+1);
      unaMatriz.setValor(i, j, valor.getValor(''));
    end;
  Result := inherited ejecutar(unaMatriz);
end;

{
***************************** TCmdMatrizModificar ******************************
}
function TCmdMatrizModificar.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  cmdDeshacer: TCmdMatrizModificar;
  valorAnt: TTipoContenible;
  i: Integer;
begin
  cmdDeshacer:= TCmdMatrizModificar.Create;
  for i := low(lista) to high(lista) do
  begin
    valorAnt := unaMatriz.getCelda(lista[i].unaFila, lista[i].unaColumna);
    cmdDeshacer.inicializa(lista[i].unaFila, lista[i].unaColumna, valorAnt.getValor(''));
    unaMatriz.setValor(lista[i].unaFila, lista[i].unaColumna, lista[i].unValor);
  end;
  result := cmdDeshacer;
end;

procedure TCmdMatrizModificar.inicializa(unaFila, unaColumna: integer; 
        unValor:string);
begin
  SetLength(lista, length(lista)+1);
  lista[length(lista)-1].unaFila := unaFila;
  lista[length(lista)-1].unaColumna := unaColumna;
  lista[length(lista)-1].unValor := unValor;
end;

{
************************** TCmdMatrizInsertarColumna ***************************
}
function TCmdMatrizInsertarColumna.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  cmdDeshacer: TCmdMatrizEliminarColumna;
  i, j, columnaFinal: Integer;
  tipo: TTipoContenible;
begin
  if Length(lista)>0 then
  begin
    columnaInicial:=MaxInt;
    columnaFinal:=MinInt;
    for i:=low(lista) to high(lista) do
    begin
      if columnaInicial>lista[i].unaColumna then
        columnaInicial:=lista[i].unaColumna
      else
        if columnaFinal<lista[i].unaColumna then
          columnaFinal:=lista[i].unaColumna;
      unaMatriz.agregar(lista[i].unaFila, lista[i].unaColumna, TTipoContenible(lista[i].unTipo));
    end;
    cantidadColumnas:= columnaFinal-columnaInicial;
  end
  else
  begin
    tipo := TTipoContenible(TBuilderTipoDato.Instance.CreateTipo(tipoDato));
    tipo.setValor(unValor,'');
    for i:= 1  to unaMatriz.cantidadFilas do
      for j:= 1  to cantidadColumnas do
        unaMatriz.agregar(i, j, tipo);
  end;
  cmdDeshacer:= TCmdMatrizEliminarColumna.Create;
  cmdDeshacer.inicializa(columnaInicial, cantidadColumnas);
end;

procedure TCmdMatrizInsertarColumna.inicializa(columnaInicial, 
        cantidadColumnas: integer; tipoDato, unValor:string);
begin
  self.columnaInicial := columnaInicial;
  self.cantidadColumnas := cantidadColumnas;
  self.tipoDato := tipoDato;
  self.unValor := unValor;
end;

procedure TCmdMatrizInsertarColumna.inicializa(unaFila, unaColumna: integer; 
        unTipo:TTipoContenible);
begin
  SetLength(lista, length(lista)+1);
  lista[length(lista)-1].unaFila := unaFila;
  lista[length(lista)-1].unaColumna := unaColumna;
  lista[length(lista)-1].unTipo := unTipo;
end;

{
**************************** TCmdMatrizInicializar *****************************
}
function TCmdMatrizInicializar.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  i, j: Integer;
  tipo: TTipoContenible;
begin
  for i:= 1 to nroFilas do
  begin
  //    unaMatriz.insertarFila(i,);
    for j:= 1 to nroColumnas do
    begin
      tipo := TTipoContenible(TBuilderTipoDato.Instance.CreateTipo(tipoDato));
      tipo.setValor(valorInicial,'');
      unaMatriz.agregar(i, j, tipo);
    end;
  end;
end;

procedure TCmdMatrizInicializar.inicializa(nroFilas, nroColumnas:integer; 
        tipoDato, valorInicial:string);
begin
  self.nroColumnas := nroColumnas;
  self.nroFilas := nroFilas;
  self.tipoDato := tipoDato;
  self.valorInicial := valorInicial;
end;

{
**************************** TCmdMatrizEliminarFila ****************************
}
function TCmdMatrizEliminarFila.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  cmdDeshacer: TCmdMatrizInsertarColumna;
  i, j: Integer;
begin
  cmdDeshacer:= TCmdMatrizInsertarColumna.Create;
  for i:= filaInicial to filaFinal do
  begin
    for j:= 1 to unaMatriz.cantidadColumnas do
      cmdDeshacer.inicializa(i-filaInicial+1, j, unaMatriz.getCelda(i,j));
    unaMatriz.eliminarfila(i);
  end;
  result := cmdDeshacer;
end;

procedure TCmdMatrizEliminarFila.inicializa(filainicial, filaFinal: integer);
begin
  self.filaInicial:= filaInicial;
  self.filaFinal := filaFinal;
end;

{
************************** TCmdMatrizEliminarColumna ***************************
}
function TCmdMatrizEliminarColumna.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  cmdDeshacer: TCmdMatrizInsertarColumna;
  i, j: Integer;
begin
  cmdDeshacer:= TCmdMatrizInsertarColumna.Create;
  for j:= columnaInicial to columnaFinal do
  begin
    for i:= 1 to unaMatriz.cantidadFilas do
    begin
      cmdDeshacer.inicializa(i, j, unaMatriz.getCelda(i,j));
      unaMatriz.eliminarCelda(i, j);
    end;
  end;
  result := cmdDeshacer;
end;

procedure TCmdMatrizEliminarColumna.inicializa(columnaInicial, columnaFinal: 
        integer);
begin
  self.columnaInicial:= columnaInicial;
  self.columnaFinal:= columnaFinal
end;


{
*********************************** TMatriz ************************************
}
constructor TMatriz.Create;
begin
  inherited create;
  nombre := 'Matriz' + IntToStr(updateNumero);
  //  historial:= THistorialComandos.Create;//lo hace el padre
  //  Matriz:= TMatrizSimple.Create;
end;

procedure TMatriz.abrir(nombreArchivo: String);
var
  XML: IXMLDocument;
  aux: IXMLNode;
begin
  XML:= TXMLDocument.Create(nombreArchivo);
  aux:= XML.DocumentElement;
  if LowerCase(aux.NodeName) = 'matriz' then
    Matriz.setXML(aux.ChildNodes.Nodes[0])
  else
    raise Exception.CreateFmt('El archivo %s no tiene la estructura de una Matriz', [nombreArchivo]);
end;

function TMatriz.copiarMatriz(filaInicial, columnaInicial, filaFinal, 
        columnaFinal:integer): TMatrizSimple;
var
  comando: TCmdMatrizCopiar;
begin
    try
      comando:= TCmdMatrizCopiar.Create;
      comando.inicializa(filaInicial, columnaInicial, filaFinal, columnaFinal);
      comando.ejecutar(matriz);
    finally
      FreeAndNil(comando);
  end
end;

function TMatriz.cortarMatriz(filaInicial, columnaInicial, filaFinal, 
        columnaFinal:integer): TMatrizSimple;
var
  comando: TCmdMatrizCortar;
  cmdDeshacer: TComando;
begin
  try
    comando:= TCmdMatrizCortar.Create;
    comando.inicializa(filaInicial, columnaInicial, filaFinal, columnaFinal, valorInicial);
    cmdDeshacer := comando.ejecutar(matriz);
    historial.agregar(cmdDeshacer);
  finally
    FreeAndNil(comando);
  end;
end;

procedure TMatriz.deshacer;
begin
  inherited deshacer;
end;

procedure TMatriz.eliminarColumnas(columnaIncial, columnaFinal:integer);
begin
end;

procedure TMatriz.eliminarFilas(filaIncial, filaFinal:integer);
begin
end;

function TMatriz.getArrayString: TMString;
begin
  result := Matriz.getArrayString;
end;

function TMatriz.getIDNombre: string;
begin
  result := 'Matriz' + IntToStr(updateNumero)
end;

procedure TMatriz.getXML(var XML: IXMLNode);
begin
  Matriz.getXML(XML);
end;

procedure TMatriz.guardar(nombreArchivo: string);
var
  XML: IXMLDocument;
  aux: IXMLNode;
  tmpFile: TextFile;
begin
  try
    AssignFile(tmpFile,nombreArchivo); //lets create the file before we continue....
                                               //i was unable to create it using the xml component...
    rewrite(tmpFile); //if the file exists empty it's content otherwise just open it in the "write" mode...
  
    //the header/structore of the xml file..
    writeln(tmpFile,'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    writeln(tmpFile,'<Matriz>');
    writeln(tmpFile,'</Matriz>');
  finally
    CloseFile(tmpFile); //close the file
  end;
  
  XML:= TXMLDocument.Create(nombreArchivo);
  aux:= XML.DocumentElement;
  matriz.getXML(aux);
end;

procedure TMatriz.imprimir;
begin
  inherited imprimir;
end;

procedure TMatriz.inicializa(nroFilas, nroColumnas:integer; tipoDato, 
        valorInicial:string);
var
  comando: TCmdMatrizInicializar;
begin
  self.tipoDato := tipoDato;
  self.valorInicial := valorInicial;
  //
  comando := TCmdMatrizInicializar.Create;
  comando.inicializa(nroFilas, nroColumnas, tipoDato, valorInicial);
    //  comando.ejecutar(vector);
  FreeAndNil(comando);
end;

procedure TMatriz.insertarColumnas(unaColumna, cantidadColumnas:integer);
begin
end;

procedure TMatriz.insertarFilas(unaFila, cantidadFilas:integer);
begin
  Matriz.insertarFila(unaFila,cantidadFilas, tipoDato,valorInicial);
end;

procedure TMatriz.modificarCelda(unaFila, unaColumna: integer; unValor:string);
begin
  Matriz.setValor(unaFila,unaColumna,unValor);
end;

procedure TMatriz.pegarMatriz(filaInicial, columnaInicial, filaFinal, 
        columnaFinal:integer);
begin
end;

procedure TMatriz.redimensionar(filas, columnas: integer);
var
  BuilderDato: TBuilderTipoDato;
  vContenible: TTipoContenible;
begin
  //  BuilderDato := TBuilderTipoDato.Instance;
  //  vContenible := BuilderDato.CreateTipo(tipoDato) as TTipoContenible;
  //  vContenible.setValor(valorInicial,'');
  Matriz.redimensionar(filas,columnas,tipoDato,valorInicial);
end;

procedure TMatriz.rehacer;
begin
  inherited rehacer;
end;

procedure TMatriz.setValor(unValor, unIdioma: string);
begin
end;

procedure TMatriz.setValor(unValor: string; listaIdiomas: TlistaIdiomas);
begin
  setValor(unValor,'');
end;

procedure TMatriz.setXML(XML: IXMLNode);
begin
  Matriz.setXML(XML);
end;

function TMatriz.tipoEstructura: string;
begin
  result := 'Matriz';
end;

class function TMatriz.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

procedure TMatriz._agregar(unTipoContenible:TTipoCOntenible);
begin
end;

procedure TMatriz._getValor(unaCelda:integer);
begin
end;

procedure TMatriz._setMatrizSimple(matrizSimple: TmatrizSimple);
begin
end;


{
*********************************** TVector ************************************
}
destructor TVector.Destroy;
begin
  //  FreeAndNil(vector);
  FreeAndNil(historial);
end;

procedure TVector.copiar(celdaInicial, celdaFinal:integer);
var
  comando: TCmdMatrizCopiar;
begin
    try
      comando:= TCmdMatrizCopiar.Create;
      comando.inicializa(1, celdaInicial, 1, celdaFinal);
  //      comando.ejecutar(vector);
    finally
      FreeAndNil(comando);
  end
end;

procedure TVector.cortar(celdaInicial, celdaFinal:integer);
var
  comando: TCmdMatrizCortar;
  cmdDeshacer: TComando;
begin
  try
    comando:= TCmdMatrizCortar.Create;
    comando.inicializa(1, celdaInicial, 1, celdaFinal, valorInicial);
  //    cmdDeshacer := comando.ejecutar(vector);
    historial.agregar(cmdDeshacer);
  finally
    FreeAndNil(comando);
  end;
end;

procedure TVector.deshacer;
var
  comando, cmdDeshacer: TComando;
begin
  comando := historial.deshacer;
  //  cmdDeshacer := comando.ejecutar(vector);
  historial.agregar(cmdDeshacer);
end;

procedure TVector.eliminarCeldas(celdaInicial, celdaFinal:integer);
var
  comando: TCmdMatrizEliminarColumna;
  cmdDeshacer: TComando;
begin
  comando:= TCmdMatrizEliminarColumna.Create;
  comando.inicializa(celdaInicial, celdaFinal);
  //  cmdDeshacer:= comando.ejecutar(vector);
  historial.agregar(cmdDeshacer);
end;

function TVector.getIDNombre: string;
begin
  nombre := 'Vector' + IntToStr(updateNumero);
end;

procedure TVector.getXML(var XML: IXMLNode);
begin
  //  Vector.getXML(XML);
end;

procedure TVector.guardar(nombreArchivo: string);
var
  XML: IXMLDocument;
  aux: IXMLNode;
  tmpFile: TextFile;
begin
  try
    AssignFile(tmpFile,nombreArchivo);
    rewrite(tmpFile);
    writeln(tmpFile,'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    writeln(tmpFile,'<Vector>');
    writeln(tmpFile,'</Vector>');
  finally
    CloseFile(tmpFile);
  end;
  XML:= TXMLDocument.Create(nombreArchivo);
  aux:= XML.DocumentElement;
  //  vector.getXML(aux);
end;

procedure TVector.imprimir;
begin
  {TODO}
  //  vector.imprimir;
end;

procedure TVector.inicializa(nroCeldas:integer; tipoDato, valorInicial:string);
var
  comando: TCmdMatrizInicializar;
begin
  self.valorInicial := valorInicial;
  self.tipoDato := tipoDato;
  comando := TCmdMatrizInicializar.Create;
  comando.inicializa(1, nroCeldas, tipoDato, valorInicial);
  //  comando.ejecutar(vector);
  FreeAndNil(comando);
end;

procedure TVector.insertarCeldas(unaCelda, cantidadCeldas:integer);
var
  cmdDeshacer: TComando;
  comando: TCmdMatrizInsertarColumna;
  i: Integer;
begin
  comando := TCmdMatrizInsertarColumna.Create;
  for i := 0 to cantidadCeldas do
  begin
    comando.inicializa(1, unaCelda, tipoDato, valorInicial);
  //    cmdDeshacer := comando.ejecutar(vector);
    historial.agregar(cmdDeshacer);
  end;
end;

procedure TVector.modificarCelda(unaCelda:integer; unValor:string);
var
  comando: TCmdMatrizModificar;
  cmdDeshacer: TComando;
begin
  comando := TCmdMatrizModificar.Create;
  comando.inicializa(1, unaCelda, unValor);
  //  cmdDeshacer := comando.ejecutar(vector);
  historial.agregar(cmdDeshacer);
  FreeAndNil(comando);
end;

procedure TVector.pegarVector(celdaInicial, celdaFinal:integer);
var
  comando: TCmdVectorPegar;
  cmdDeshacer: TComando;
begin
  comando := TCmdVectorPegar.Create;
  comando.inicializa(1, celdaInicial, 1, celdaFinal);
  //  cmdDeshacer := comando.ejecutar(vector);
  historial.agregar(cmdDeshacer);
end;

procedure TVector.rehacer;
var
  comando, cmdDeshacer: TComando;
begin
  comando := historial.deshacer;
  //  cmdDeshacer := comando.ejecutar(vector);
  historial.agregar(cmdDeshacer);
end;

procedure TVector.setValor(unValor, unIdioma: string);
begin
end;

procedure TVector.setValor(unValor: string; listaIdiomas: TlistaIdiomas);
begin
  setValor(unValor,'');
end;

function TVector.tipoEstructura: string;
begin
end;

class function TVector.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

procedure TVector._agregar(unTipoContenible:TTipoContenible);
begin
end;

procedure TVector._eliminarFilas(filaInicial, filaFinal:integer);
begin
end;

procedure TVector._getValor(unaCelda:integer);
begin
end;

procedure TVector._setVectorSimple(vectorSimple:TMatrizSimple);
begin
end;

{
********************************* TTextoSimple *********************************
}
function TTextoSimple.getDFM: string;
begin
  result := idioma.getCodigo +'='+ valor;
end;

function TTextoSimple.getIdioma: TIdioma;
begin
  result := idioma;
end;

function TTextoSimple.getValor: string;
begin
  result := valor;
end;

procedure TTextoSimple.getXML(var XML: IXMLNode);
var
  textoSimple: IXMLNode;
begin
  textoSimple:=XML.AddChild('textoSimple');
  textoSimple.SetAttributeNS('valor','', valor);
  textoSimple.SetAttributeNS('idioma','', idioma.getCodigo);
end;

procedure TTextoSimple.setIdioma(unIdioma:TIdioma);
begin
  idioma := unIdioma;
end;

procedure TTextoSimple.setValor(unValor: string);
begin
  valor:=unValor;
end;

procedure TTextoSimple.setXML(XML:IXMLNode);
begin
  valor:=XML.Attributes['valor'];
  idioma:= TControlIdiomas.Instance.buscar(XML.Attributes['idioma']);
end;

{
********************************* TListaTextos *********************************
}
procedure TListaTextos.agregar(unTexto: TTextoSimple);
begin
  inherited agregar(unTexto);
end;

function TListaTextos.buscar(unIdioma:TIdioma): TTextoSimple;
var
  aux: TTextoSimple;
begin
  aux := primero;
  while Assigned(aux) and Assigned(unIdioma) and (aux.getIdioma <> unIdioma) do
    aux := siguiente;
  result:=aux;
end;

function TListaTextos.primero: TTextoSimple;
var
  aux: TObject;
begin
  aux:=inherited primero;
  if Assigned(aux) then
    result :=TTextoSimple(aux)
  else
    result := nil;
end;

function TListaTextos.siguiente: TTextoSimple;
var
  aux: TObject;
begin
  aux:=inherited siguiente;
  if Assigned(aux) then
    result :=TTextoSimple(aux)
  else
    result := nil;
end;

{
************************************ TTexto ************************************
}
constructor TTexto.Create;
begin
  inherited;
  listaTextos := TListaTextos.Create;
end;

destructor TTexto.Destroy;
var
  aux: TTextoSimple;
begin
  aux:=listaTextos.primero;
  while Assigned(aux) do
  begin
    aux.Destroy;
    aux:=listaTextos.siguiente;
  end;
  listaTextos.Destroy;
  inherited;
end;

procedure TTexto.agregarIdioma(unIdioma:TIdioma);
var
  texto: TTextoSimple;
begin
  texto := TTextoSimple.Create;
  texto.setIdioma(unIdioma);
  texto.setValor(ConstInitValue);
  listaTextos.agregar(texto);
end;

function TTexto.getDFM: string;
var
  texto: TTextoSimple;
begin
  texto := listaTextos.primero;
  if assigned(texto) then
  begin
    result := texto.getDFM;
    texto := listaTextos.siguiente;
    while assigned(texto) do
    begin
      result := result + '|' + texto.getDFM;
      texto := listaTextos.siguiente;
    end;
  end;
end;

function TTexto.getValor(unIdioma:string): string;
var
  controlIdiomas: TControlIdiomas;
  aux: TTextoSimple;
begin
  controlIdiomas:= TControlIdiomas.Instance;
  aux := listaTextos.buscar(controlIdiomas.buscar(unIdioma));
  result := aux.getValor;
end;

procedure TTexto.getXML(var XML: IXMLNode);
var
  texto: IXMLNode;
  textoSimple: TTextoSimple;
begin
  texto := XML.AddChild('texto');
  textoSimple:=listaTextos.primero;
  while assigned(textoSimple) do
  begin
    textoSimple.getXML(texto);
    textoSimple:=listaTextos.siguiente;
  end;
end;

procedure TTexto.quitarIdioma(unIdioma: TIdioma);
var
  idioma: TIdioma;
begin
  listaTextos.eliminar(listaTextos.buscar(unIdioma));
end;

procedure TTexto.setValor(unValor, unIdioma: string);
var
  idioma: TIdioma;
  controlIdiomas: TControlIdiomas;
  texto: TTextoSimple;
begin
  controlIdiomas:=TcontrolIdiomas.Instance;
  idioma:= controlIdiomas.buscar(unIdioma);
  texto := listaTextos.buscar(idioma);
  if not Assigned(texto) then
  begin
    texto := TTextoSimple.Create;
    texto.setIdioma(idioma);
    listaTextos.agregar(texto);
  end;
  texto.setValor(unValor);
  //  controlIdiomas.ReleaseInstance;
end;

procedure TTexto.setValor(unValor: string; listaIdiomas: TlistaIdiomas);
var
  idioma: TIdioma;
  texto: TTextoSimple;
begin
  idioma:=listaIdiomas.primero;
  while Assigned(idioma) do   {TODO: Controlar que sea válido}
  begin
    texto := listaTextos.buscar(idioma);
    if not Assigned(texto) then
    begin
      texto := TTextoSimple.Create;
      texto.setIdioma(idioma);
      listaTextos.agregar(texto);
    end;
    texto.setValor(unValor);
    idioma:=listaIdiomas.siguiente;
  end;
end;

procedure TTexto.setXML(XML:IXMLNode);
var
  textoSimple: TTextoSimple;
  i: Integer;
begin
  for i:= 0 to XML.ChildNodes.Count -1 do
  begin
    textoSimple:=listaTextos.buscar(TControlIdiomas.Instance.buscar(XML.ChildNodes.Nodes[i].Attributes['idioma']));
    if not Assigned(textoSimple) then
    begin
      textoSimple:=TTextoSimple.Create;
      listaTextos.agregar(textoSimple);
    end;
    textoSimple.setXML(XML.ChildNodes.Nodes[i]);
  end;
end;

function TTexto.siguiente: TListaTextos;
begin
end;

procedure TTexto._agregar(unTexto:string; unIdioma:TIdioma);
begin
end;

{
*********************************** TNumero ************************************
}
constructor TNumero.Create;
begin
  valor := 0;
end;

function TNumero.getDFM: string;
begin
  result := floattostr(valor);
end;

function TNumero.getValor(unIdioma: string): string;
begin
  result := FloatToStr(valor);
end;

procedure TNumero.getXML(var XML: IXMLNode);
var
  aux: IXMLNode;
begin
  aux:=XML.AddChild('numero');
  aux.Text := getValor('');
end;

procedure TNumero.setValor(unValor, unIdioma: string);
var
  aux: RComplejo;
  LPart: string;
  LLeftover: string;
  LReal: Double;
  LImaginary: Double;
  LSign: Integer;
  
  const
    SCmplxCouldNotParseImaginary = 'Could not parse imaginary portion';
    SCmplxCouldNotParseSymbol = 'Could not parse required ''%s'' symbol';
    SCmplxCouldNotParsePlus = 'Could not parse required ''+'' (or ''-'') symbol';
    SCmplxCouldNotParseReal = 'Could not parse real portion';
    SCmplxUnexpectedEOS = 'Unexpected end of string [%s]';
    SCmplxUnexpectedChars = 'Unexpected characters';
    SCmplxErrorSuffix = '%s [%s<?>%s]';
  
  function ParseNumber(const AText: string; out ARest: string; out ANumber:
          Double): Boolean;
  var
    LAt: Integer;
    LFirstPart: string;
  begin
    Result := True;
    Val(AText, ANumber, LAt);
    if LAt <> 0 then
    begin
      ARest := Copy(AText, LAt, MaxInt);
      LFirstPart := Copy(AText, 1, LAt - 1);
      Val(LFirstPart, ANumber, LAt);
      if LAt <> 0 then
        Result := False;
    end;
  end;
  
  function parseWhiteSpace(const AText: string; out ARest: string): Boolean;
  var
    LAt: Integer;
  begin
    LAt := 1;
    if AText <> '' then
    begin
      while AText[LAt] = ' ' do
        Inc(LAt);
      ARest := Copy(AText, LAt, MaxInt);
    end;
    Result := ARest <> '';
  end;
  
  procedure ParseError(const AMessage: string);
  begin
    raise EConvertError.CreateFmt(SCmplxErrorSuffix, [AMessage,
      Copy(unValor, 1, Length(unValor) - Length(LLeftOver)),
      Copy(unValor, Length(unValor) - Length(LLeftOver) + 1, MaxInt)]);
  end;
  
begin
  {  //cargo la variable auxiliar
    LLeftover := trim(unValor);
  
    //parseo la parte real
    if not ParseNumber(LLeftover, LPart, LReal) then
      ParseError(SCmplxCouldNotParseReal);
  
    ParseWhiteSpace(LPart, LLeftover);
    //Verifico que no queden letras
    if LLeftover='' then
      valor:=LReal
    else
    //si quedan letras hay un error
      ParseError(SCmplxUnexpectedChars);}
  valor:= strtoFloat(unValor);
end;

procedure TNumero.setValor(unValor: string; listaIdiomas: TlistaIdiomas);
begin
  setValor(unValor,'');
end;

procedure TNumero.setXML(XML:IXMLNode);
begin
  setValor(XML.ChildNodes.Nodes[0].Text,'');
end;

{
******************************** TNumeroEntero *********************************
}
function TNumeroEntero.getDFM: string;
begin
  result := IntToStr(trunc(valor));
end;

function TNumeroEntero.getValor(unIdioma: string): string;
begin
  result := IntToStr(trunc(valor));
end;

procedure TNumeroEntero.getXML(var XML: IXMLNode);
var
  aux: IXMLNode;
begin
  aux:=XML.AddChild('numeroEntero');
  aux.Text := getValor('');
end;

procedure TNumeroEntero.setValor(unValor, unIdioma: string);
  
  {var
    aux: RComplejo;
    LPart: string;
    LLeftover: string;
    LEntero: Integer;
    LImaginary: Double;
    LSign: Integer;
  
    const
      SCmplxCouldNotParseImaginary = 'Could not parse imaginary portion';
      SCmplxCouldNotParseSymbol = 'Could not parse required ''%s'' symbol';
      SCmplxCouldNotParsePlus = 'Could not parse required ''+'' (or ''-'') symbol';
      SCmplxCouldNotParseReal = 'Could not parse real portion';
      SCmplxUnexpectedEOS = 'Unexpected end of string [%s]';
      SCmplxUnexpectedChars = 'Unexpected characters';
      SCmplxErrorSuffix = '%s [%s<?>%s]';
  
    function ParseNumber(const AText: string; out ARest: string; out ANumber:
            integer): Boolean;
    var
      LAt: Integer;
      LFirstPart: string;
    begin
      Result := True;
      Val(AText, ANumber, LAt);
      if LAt <> 0 then
      begin
        ARest := Copy(AText, LAt, MaxInt);
        LFirstPart := Copy(AText, 1, LAt - 1);
        Val(LFirstPart, ANumber, LAt);
        if LAt <> 0 then
          Result := False;
      end;
    end;
  
    function parseWhiteSpace(const AText: string; out ARest: string): Boolean;
    var
      LAt: Integer;
    begin
      LAt := 1;
      if AText <> '' then
      begin
        while AText[LAt] = ' ' do
          Inc(LAt);
        ARest := Copy(AText, LAt, MaxInt);
      end;
      Result := ARest <> '';
    end;
  
    procedure ParseError(const AMessage: string);
    begin
      raise EConvertError.CreateFmt(SCmplxErrorSuffix, [AMessage,
        Copy(unValor, 1, Length(unValor) - Length(LLeftOver)),
        Copy(unValor, Length(unValor) - Length(LLeftOver) + 1, MaxInt)]);
    end;
  
  begin
    //cargo la variable auxiliar
    LLeftover := trim(unValor);
  
    //parseo la parte real
    if not ParseNumber(LLeftover, LPart, LEntero) then
      ParseError(SCmplxCouldNotParseReal);
  
    if not ParseWhiteSpace(LPart, LLeftover) then
  
    //Verifico que no queden letras
    if LLeftover='' then
      valor:=LEntero
    else
    //si quedan letras hay un error
      ParseError(SCmplxUnexpectedChars);}
  
begin
  valor := StrToInt(unValor);
end;

procedure TNumeroEntero.setValor(unValor: string; listaIdiomas: TlistaIdiomas);
begin
  setValor(unValor,'');
end;

procedure TNumeroEntero.setXML(XML:IXMLNode);
begin
  setValor(XML.ChildNodes.Nodes[0].Text,'');
end;

{
********************************** TComplejo ***********************************
}
constructor TComplejo.Create;
begin
  valor.real := 0;
  valor.imaginario := 0;
end;

function TComplejo.getDFM: string;
var
  aux: string;
begin
  aux:= FloatToStr(valor.real);
  if valor.imaginario >= 0 then
    result:=aux+'+'+FloatToStr(valor.imaginario)+'i'
  else
    result:=aux+FloatToStr(valor.imaginario)+'i';
end;

function TComplejo.getValor(unIdioma: string): string;
var
  aux: string;
begin
  aux:= FloatToStr(valor.real);
  if valor.imaginario >= 0 then
    result:=aux+'+'+FloatToStr(valor.imaginario)+'i'
  else
    result:=aux+FloatToStr(valor.imaginario)+'i';
end;

procedure TComplejo.getXML(var XML: IXMLNode);
var
  aux: IXMLNode;
begin
  aux:=XML.AddChild('complejo');
  aux.Text := getValor('');
end;

procedure TComplejo.setValor(unValor, unIdioma: string);
var
  aux: RComplejo;
  LPart: string;
  LLeftover: string;
  LReal: Double;
  LImaginary: Double;
  LSign: Integer;
  
  const
    SCmplxCouldNotParseImaginary = 'Could not parse imaginary portion';
    SCmplxCouldNotParseSymbol = 'Could not parse required ''%s'' symbol';
    SCmplxCouldNotParsePlus = 'Could not parse required ''+'' (or ''-'') symbol';
    SCmplxCouldNotParseReal = 'Could not parse real portion';
    SCmplxUnexpectedEOS = 'Unexpected end of string [%s]';
    SCmplxUnexpectedChars = 'Unexpected characters';
    SCmplxErrorSuffix = '%s [%s<?>%s]';
  
  function ParseNumber(const AText: string; out ARest: string; out ANumber:
          Double): Boolean;
  var
    LAt: Integer;
    LFirstPart: string;
  begin
    Result := True;
    Val(AText, ANumber, LAt);
    if LAt <> 0 then
    begin
      ARest := Copy(AText, LAt, MaxInt);
      LFirstPart := Copy(AText, 1, LAt - 1);
      Val(LFirstPart, ANumber, LAt);
      if LAt <> 0 then
        Result := False;
    end;
  end;
  
  function parseWhiteSpace(const AText: string; out ARest: string): Boolean;
  var
    LAt: Integer;
  begin
    LAt := 1;
    if AText <> '' then
    begin
      while AText[LAt] = ' ' do
        Inc(LAt);
      ARest := Copy(AText, LAt, MaxInt);
    end;
    Result := ARest <> '';
  end;
  
  procedure ParseError(const AMessage: string);
  begin
    raise EConvertError.CreateFmt(SCmplxErrorSuffix, [AMessage,
      Copy(unValor, 1, Length(unValor) - Length(LLeftOver)),
      Copy(unValor, Length(unValor) - Length(LLeftOver) + 1, MaxInt)]);
  end;
  
  procedure ParseErrorEOS;
  begin
    raise EConvertError.CreateFmt(SCmplxUnexpectedEOS, [unValor]);
  end;
  
begin
  // where to start?
  LLeftover := unValor;
  
  // first get the real portion
  if not ParseNumber(LLeftover, LPart, LReal) then
    ParseError(SCmplxCouldNotParseReal);
  
  // is that it?
  if not ParseWhiteSpace(LPart, LLeftover) then
    aux.real:=LReal
  
  // if there is more then parse the complex part
  else
  begin
  
    // look for the concat symbol
    LSign := 1;
    if LLeftover[1] = '-' then
      LSign := -1
    else if LLeftover[1] <> '+' then
      ParseError(SCmplxCouldNotParsePlus);
    LPart := Copy(LLeftover, 2, MaxInt);
  
    // skip any whitespace
    ParseWhiteSpace(LPart, LLeftover);
  
    // imaginary part
    if not ParseNumber(LLeftover, LPart, LImaginary) then
      ParseError(SCmplxCouldNotParseImaginary);
  
    // correct for sign
    LImaginary := LImaginary * LSign;
  
    ParseWhiteSpace(LPart, LLeftover);
  
    // make sure there is symbol!
    if not AnsiSameText(Copy(LLeftOver, 1, 1), 'i') then
      ParseError(Format(SCmplxCouldNotParseSymbol, ['i']));
    LPart := Copy(LLeftover, Length('i') + 1, MaxInt);
  
    // make sure the rest of the string is whitespaces
    ParseWhiteSpace(LPart, LLeftover);
    if LLeftover <> '' then
      ParseError(SCmplxUnexpectedChars);
    aux.real:=LReal;
    aux.imaginario:=LImaginary;
    // make it then
    valor:=aux;
  end;
end;

procedure TComplejo.setValor(unValor: string; listaIdiomas: TlistaIdiomas);
begin
  setValor(unValor,'');
end;

procedure TComplejo.setXML(XML:IXMLNode);
begin
  getValor('');
end;

{ TArreglo }

{
*********************************** TArreglo ***********************************
}
constructor TArreglo.create(filas,columnas: integer; tipoDato, valorInicial: 
        string);
begin
  inherited create;
  self.tipoDato := tipoDato;
  self.valorInicial := valorInicial;
  historial:= THistorialComandos.create;
  Matriz:= TMatrizSimple.Create(filas,columnas,tipoDato,valorInicial);
  nombre := getIDNombre;
end;

procedure TArreglo.abrir(nombreArchivo: String);
var
  XML: IXMLDocument;
  aux: IXMLNode;
begin
  XML:= TXMLDocument.Create(nombreArchivo);
  aux:= XML.DocumentElement;
  if LowerCase(aux.NodeName) = tipoEstructura then
    Matriz.setXML(aux.ChildNodes.Nodes[0])
  else
    raise Exception.CreateFmt('El archivo %s no tiene la estructura de un %s', [nombreArchivo,tipoEstructura]);
end;

function TArreglo.getArrayString: TMString;
begin
  result := Matriz.getArrayString;
end;

procedure TArreglo.setXML(XML: IXMLNode);
begin
  Matriz.setXML(XML);
end;

end.
