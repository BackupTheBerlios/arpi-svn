unit uLenguajes;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, XMLIntf, uLista;

type
  TLenguaje = class (TObject)
  private
    definicion: string;
    entrada: string;
    extension: string;
    nombre: string;
    plantilla: AnsiString;
    salida: string;
  public
    procedure abrir(lenguaje:string);
    function getExtension: AnsiString;
    function getNombre: string;
    function getPlantilla: AnsiString;
    function parseParametroDefinicion(tipoParametro, nombreParametro, 
            valorParametro: string): string;
    function parseParametroEntrada(tipoParametro, nombreParametro, 
            valorParametro: string): string;
    function parseParametroSalida(tipoParametro, nombreParametro, 
            valorParametro: string): string;
  end;
  
  TListaLenguajes = class (TLista)
  public
    procedure agregar(unLenguaje:TLenguaje);
    function buscar(unLenguaje:string): TLenguaje;
    function primero: TLenguaje;
    function siguiente: TLenguaje;
  end;
  
  TCompilador = class (TObject)
  private
    lenguaje: TLenguaje;
    lineaComandos: string;
    nombre: string;
    ubicacion: string;
  public
    constructor Create;
    destructor Destroy; override;
    function compilarProyecto(unaUbicacion:string): string;
    function getLenguaje: TLenguaje;
    function getLineaComandos: string;
    function getNombre: string;
    function getUbicacion: string;
    procedure getXML(XML: IXMLNode);
    function parseParametroDefinicion(tipoParametro, nombreParametro, 
            valorParametro: string): string;
    function parseParametroEntrada(tipoParametro, nombreParametro, 
            valorParametro: string): string;
    function parseParametroSalida(tipoParametro, nombreParametro, 
            valorParametro: string): string;
    procedure setLenguaje(unLenguaje:TLenguaje);
    procedure setLineaComandos(unaLineaComandos:string);
    procedure setNombre(nombreCompilador:string);
    procedure setUbicacion(unaUbicacion:string);
    procedure setXML(XML: IXMLNode);
  end;
  
  TListaCompiladores = class (TLista)
  public
    procedure agregar(unCompilador:TCompilador);
    function buscar(unCompilador:string): TCompilador;
    function primero: TCompilador;
    function siguiente: TCompilador;
  end;
  
  TControlLenguajes = class (TObject)
  private
    listaLenguajes: TListaLenguajes;
  protected
    constructor CreateInstance;
    class function AccessInstance(Request: Integer): TControlLenguajes;
  public
    constructor Create;
    destructor Destroy; override;
    function buscar(unLenguaje:string): TLenguaje;
    class function Instance: TControlLenguajes;
    function mostrarLenguajes: TStrings;
    class procedure ReleaseInstance;
  end;
  

procedure Register;

implementation

procedure Register;
begin
end;

{
********************************** TLenguaje ***********************************
}
procedure TLenguaje.abrir(lenguaje:string);
begin
end;

function TLenguaje.getExtension: AnsiString;
begin
  result:=extension;
end;

function TLenguaje.getNombre: string;
begin
  result:=nombre;
end;

function TLenguaje.getPlantilla: AnsiString;
begin
  result:=plantilla;
end;

function TLenguaje.parseParametroDefinicion(tipoParametro, nombreParametro, 
        valorParametro: string): string;
  
  function tipoReal(unValor: string): string;
  begin
    unValor:= lowercase(unValor);
    if unValor = 'tnumero' then result := 'double'
    else if unValor = 'tnumeroentero' then result := 'integer'
    else if unValor = 'tletra' then result := 'char'
    else raise Exception.Create('Todavía no se implementó el tipo que quiere utilizar '+unValor);
  end;
  
begin
  //ingresa al reves: nombre: tipo;
  result:=format(definicion, [nombreParametro, tipoReal(tipoParametro), valorParametro]);
end;

function TLenguaje.parseParametroEntrada(tipoParametro, nombreParametro, 
        valorParametro: string): string;
  
  function tipoReal(unValor: string): string;
  begin
    unValor:= lowercase(unValor);
    if unValor = 'tnumero' then result := 'pdouble'
    else if unValor = 'tnumeroentero' then result := 'pinteger'
    else if unValor = 'tletra' then result := 'pchar'
    else raise Exception.Create('Todavía no se implementó el tipo que quiere utilizar '+unValor);
  end;
  
begin
  result:=format(entrada, [nombreParametro, tiporeal(tipoParametro), valorParametro]);
end;

function TLenguaje.parseParametroSalida(tipoParametro, nombreParametro, 
        valorParametro: string): string;
  
  function tipoReal(unValor: string): string;
  begin
    unValor:= lowercase(unValor);
    if unValor = 'tnumero' then result := 'pdouble'
    else if unValor = 'tnumeroentero' then result := 'pinteger'
    else if unValor = 'tletra' then result := 'pchar'
    else raise Exception.Create('Todavía no se implementó el tipo que quiere utilizar '+unValor);
  end;
  
begin
  result:=format(salida, [tiporeal(tipoParametro), nombreParametro, valorParametro]);
end;

{
******************************* TListaLenguajes ********************************
}
procedure TListaLenguajes.agregar(unLenguaje:TLenguaje);
begin
  inherited agregar(unLenguaje);
end;

function TListaLenguajes.buscar(unLenguaje:string): TLenguaje;
var
  aux: TLenguaje;
begin
  aux := TLenguaje(inherited primero);
  while Assigned(aux) and (aux.getNombre <> unLenguaje) do
    aux := TLenguaje(inherited siguiente);
  result:=aux;
end;

function TListaLenguajes.primero: TLenguaje;
var
  aux: TObject;
begin
  aux:=inherited primero;
  if Assigned(aux) then
    result:=TLenguaje(aux)
  else
    result := nil;
end;

function TListaLenguajes.siguiente: TLenguaje;
var
  aux: TObject;
begin
  aux:=inherited siguiente;
  if Assigned(aux) then
    result:=TLenguaje(aux)
  else
    result := nil;
end;

{
********************************* TCompilador **********************************
}
constructor TCompilador.Create;
begin
end;

destructor TCompilador.Destroy;
begin
end;

function TCompilador.compilarProyecto(unaUbicacion:string): string;
var
  SA: TSecurityAttributes;
  SI: TStartupInfo;
  PI: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  Buffer: array[0..255] of Char;
  BytesRead: Cardinal;
  WorkDir, Line: string;
  CommandLine: string;
  
  {Capturing all of the Output from a Console application
  http://www.delphi3000.com/articles/article_2112.asp
  
  John W. Long (johnwlong@characterlink.net)
  
  Code recieved from Mike Lischke (Team JEDI) in response to a question I asked
  on the borland winapi newsgroup.  It came from his app "Compiler Generator"
  (www.lischke-online.de/DCG.html) and then was converted to the GetDosOutput
  function by me.}
  
begin
  CommandLine := StringReplace(lineaComandos, '%f', '"'+unaUbicacion+'"', [rfReplaceAll, rfIgnoreCase]);
  
  Application.ProcessMessages;
  with SA do
  begin
    nLength := SizeOf(SA);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  // create pipe for standard output redirection
  CreatePipe(StdOutPipeRead,  // read handle
             StdOutPipeWrite, // write handle
             @SA,             // security attributes
             0                // number of bytes reserved for pipe - 0 default
             );
  try
    // Make child process use StdOutPipeWrite as standard out,
    // and make sure it does not show on screen.
    with SI do
    begin
      FillChar(SI, SizeOf(SI), 0);
      cb := SizeOf(SI);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect std input
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;
  
    // launch the command line compiler
    WorkDir := ExtractFilePath(unaUbicacion);
    WasOK := CreateProcess(nil, PChar(CommandLine), nil, nil, True, 0, nil, PChar(WorkDir), SI, PI);
  
    // Now that the handle has been inherited, close write to be safe.
    // We don't want to read or write to it accidentally.
    CloseHandle(StdOutPipeWrite);
    // if process could be created then handle its output
    if not WasOK then
      raise Exception.CreateFmt('No se pudo ejecutar la línea de comando'#13#10'%s',[CommandLine])
    else
      try
        // get all output until dos app finishes
        Line := '';
        repeat
          // read block of characters (might contain carriage returns and line feeds)
          WasOK := ReadFile(StdOutPipeRead, Buffer, 255, BytesRead, nil);
  
          // has anything been read?
          if BytesRead > 0 then
          begin
            // finish buffer to PChar
            Buffer[BytesRead] := #0;
            // combine the buffer with the rest of the last run
            Line := Line + Buffer;
          end;
        until not WasOK or (BytesRead = 0);
        // wait for console app to finish (should be already at this point)
        WaitForSingleObject(PI.hProcess, INFINITE);
      finally
        // Close all remaining handles
        CloseHandle(PI.hThread);
        CloseHandle(PI.hProcess);
      end;
  finally
    result:= StringReplace(Line, #10#13, #10, [rfReplaceAll]);
    result:= StringReplace(result, #13#13#10, #13#10, [rfReplaceAll]);
    CloseHandle(StdOutPipeRead);
  end;
end;

function TCompilador.getLenguaje: TLenguaje;
begin
  result:=lenguaje;
end;

function TCompilador.getLineaComandos: string;
begin
  result:= lineaComandos;
end;

function TCompilador.getNombre: string;
begin
  result := nombre;
end;

function TCompilador.getUbicacion: string;
begin
  result := ubicacion;
end;

procedure TCompilador.getXML(XML: IXMLNode);
var
  compilador: IXMLNode;
begin
  compilador := XML.AddChild('Compilador');
  compilador.Attributes['nombre'] := nombre;
  compilador.Attributes['ubicacion'] := ubicacion;
  compilador.Attributes['lenguaje'] := lenguaje.getNombre;
  compilador.Text := lineaComandos;
end;

function TCompilador.parseParametroDefinicion(tipoParametro, nombreParametro, 
        valorParametro: string): string;
begin
  result := lenguaje.parseParametroDefinicion(tipoParametro, nombreParametro, valorParametro);
end;

function TCompilador.parseParametroEntrada(tipoParametro, nombreParametro, 
        valorParametro: string): string;
begin
  result:=lenguaje.parseParametroEntrada(tipoParametro, nombreParametro, valorParametro);
end;

function TCompilador.parseParametroSalida(tipoParametro, nombreParametro, 
        valorParametro: string): string;
begin
  result:=lenguaje.parseParametroSalida(tipoParametro, nombreParametro, valorParametro);
end;

procedure TCompilador.setLenguaje(unLenguaje:TLenguaje);
begin
  lenguaje := unLenguaje;
end;

procedure TCompilador.setLineaComandos(unaLineaComandos:string);
begin
  lineaComandos:= unaLineaComandos;
end;

procedure TCompilador.setNombre(nombreCompilador:string);
begin
  nombre:=nombreCompilador;
end;

procedure TCompilador.setUbicacion(unaUbicacion:string);
begin
  ubicacion := unaUbicacion;
end;

procedure TCompilador.setXML(XML: IXMLNode);
begin
  nombre := XML.Attributes['nombre'];
  ubicacion := XML.Attributes['ubicacion'];
  lenguaje := TControlLenguajes.Instance.buscar(XML.Attributes['lenguaje']);
  lineaComandos := XML.Text;
end;

{
****************************** TListaCompiladores ******************************
}
procedure TListaCompiladores.agregar(unCompilador:TCompilador);
begin
  inherited agregar(unCompilador);
end;

function TListaCompiladores.buscar(unCompilador:string): TCompilador;
var
  aux: TCompilador;
begin
  aux := TCompilador(inherited primero);
  while Assigned(aux) and (aux.getNombre <> unCompilador) do
    aux := TCompilador(inherited siguiente);
  result:=aux;
end;

function TListaCompiladores.primero: TCompilador;
var
  aux: TObject;
begin
  aux:=inherited primero;
  if Assigned(aux) then
    result := TCompilador(aux)
  else
    result := nil;
end;

function TListaCompiladores.siguiente: TCompilador;
var
  aux: TObject;
begin
  aux:=inherited siguiente;
  if Assigned(aux) then
    result := TCompilador(aux)
  else
    result := nil;
end;

{
****************************** TControlLenguajes *******************************
}
constructor TControlLenguajes.Create;
begin
  inherited Create;
  raise Exception.CreateFmt('Access class %s through Instance only', 
          [ClassName]);
end;

constructor TControlLenguajes.CreateInstance;
var
  aux: TLenguaje;
begin
  inherited Create;
  listaLenguajes := TListaLenguajes.Create;
  {TODO: Agregar acá la lista de lenguajes Leerlos de un archivo de config o a mano!!}
  aux:=TLenguaje.Create; aux.nombre := 'c'; aux.extension := '.c';
  aux.plantilla := 'library %s'; listaLenguajes.agregar(aux);
  aux:=TLenguaje.Create; aux.nombre := 'pascal'; aux.extension := '.dpr';
  aux.plantilla :=
      'library {NOMBREARCHIVO};'#13#10+
      'uses ShareMem, SysUtils, Classes, uCommon in "D:\ARPI\Fuentes\EntornoEjecucion\uCommon.pas";'#13#10+
      'function _Ejecutar(var pin:pnodo):pnodo;'#13#10+
      'var'#13#10+
      'nodo, cola:pnodo;'#13#10+
      '{PROCESARDEFINICION}'#13#10+
      'begin'#13#10+
      'nodo:=pin;'#13#10+
      '{PROCESARIN}'#13#10+
      '{Por favor escriba entre este comentario y el siguiente la funci'#243'n principal}'#13#10#13#10+
      '{Fin de la funci'#243'n principal}'#13#10+
      'result:=nil;'#13#10+
      'cola := nil;'#13#10+
      '{PROCESAROUT}'#13#10+
      'end;'#13#10#13#10#13#10#13#10#13#10+
      'function _Nombre:PChar; stdcall;'#13#10+
      'begin result := PChar({NOMBRE});end;'#13#10+
      'function _Descripcion:PChar; stdcall;'#13#10+
      'begin result := PChar({DESCRIPCION});end;'#13#10+
      'function _Idiomas:PChar; stdcall;'#13#10+
      'begin result := PChar({IDIOMAS});end;'#13#10+
      'function _formularioDFM:PChar; stdcall;'#13#10+
      'begin result := PChar({FORMULARIODFM});end;'#13#10+
      'exports'#13#10+
      '  _Nombre,'#13#10+
      '  _Idiomas,'#13#10+
      '  _Descripcion,'#13#10+
      '  _FormularioDFM,'#13#10+
      '  _Ejecutar;'#13#10+
      'end.';
    aux.entrada := '%s:=%s(nodo.valor)^;'#13#10#13#10'nodo:=nodo.siguiente;'#13#10;
    aux.salida := 'nodo := new(pnodo);'#13#10'nodo.valor:= new(%s);'#13#10'%0:s(nodo.valor)^:= %s;'#13#10'nodo.siguiente := nil;'#13#10'if not assigned(result) then'#13#10#9'result := nodo'#13#10'else'#13#10#9'cola.siguiente := nodo;'#13#10'cola:= nodo;'#13#10;
    aux.definicion := '%s: %s;'#13#10;
  listaLenguajes.agregar(aux);
end;

destructor TControlLenguajes.Destroy;
begin
  if AccessInstance(0) = Self then AccessInstance(2);
  listaLenguajes.Free;
  inherited Destroy;
end;

class function TControlLenguajes.AccessInstance(Request: Integer): 
        TControlLenguajes;
  
  const FInstance: TControlLenguajes = nil;
  
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

function TControlLenguajes.buscar(unLenguaje:string): TLenguaje;
begin
  result:=listaLenguajes.buscar(unLenguaje);
end;

class function TControlLenguajes.Instance: TControlLenguajes;
begin
  Result := AccessInstance(1);
end;

function TControlLenguajes.mostrarLenguajes: TStrings;
var
  lenguaje: TLenguaje;
begin
  result := TStringList.Create;
  lenguaje := listaLenguajes.primero;
  while Assigned(lenguaje) do
  begin
    result.Add(lenguaje.getNombre);
    lenguaje := listaLenguajes.siguiente;
  end;
end;

class procedure TControlLenguajes.ReleaseInstance;
begin
  AccessInstance(0).Free;
end;


end.
