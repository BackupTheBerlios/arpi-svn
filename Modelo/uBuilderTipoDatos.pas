unit uBuilderTipoDatos;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, uTipos;

type
  TBuilderTipoDato = class (TObject)
  protected
    constructor CreateInstance;
    class function AccessInstance(Request: Integer): TBuilderTipoDato;
  public
    constructor Create;
    destructor Destroy; override;
    function CreateTipo(tipoDato:string): TTipo;
    class function Instance: TBuilderTipoDato;
    class procedure ReleaseInstance;
  end;
  

procedure Register;

implementation

uses
uEntornoEjecucion, uReferencia;

procedure Register;
begin
end;

{
******************************* TBuilderTipoDato *******************************
}
constructor TBuilderTipoDato.Create;
begin
  inherited Create;
  raise Exception.CreateFmt('Access class %s through Instance only',
          [ClassName]);
end;

constructor TBuilderTipoDato.CreateInstance;
begin
  inherited Create;
end;

destructor TBuilderTipoDato.Destroy;
begin
  if AccessInstance(0) = Self then AccessInstance(2);
  inherited Destroy;
end;

class function TBuilderTipoDato.AccessInstance(Request: Integer): 
        TBuilderTipoDato;
  
  const FInstance: TBuilderTipoDato = nil;
  
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

function TBuilderTipoDato.CreateTipo(tipoDato:string): TTipo;
begin
  if LowerCase(tipoDato)= 'imagen' then result := TImagen.Create
  else if LowerCase(tipoDato)= 'matriz' then result := TMatriz.Create
  else if LowerCase(tipoDato)= 'texto' then result := TTexto.Create
  else if LowerCase(tipoDato)= 'complejo' then result := TComplejo.Create
  else if LowerCase(tipoDato)= 'letra' then result := TLetra.Create
  else if LowerCase(tipoDato)= 'numero' then result := TNumero.Create
  else if LowerCase(tipoDato)= 'numeroentero' then result := TNumeroEntero.Create
  else if LowerCase(tipoDato)= 'referenciaarchivoimagen' then result := TReferenciaArchivoImagen.Create
  //  else if LowerCase(tipoDato)= 'referenciaarchivovector' then result := TReferenciaArchivoVector.Create
  else if LowerCase(tipoDato)= 'referenciaarchivomatriz' then result := TReferenciaArchivoMatriz.Create
  else if LowerCase(tipoDato)= 'referenciaestructuraimagen' then result := TReferenciaEstructuraImagen.Create
  //  else if LowerCase(tipoDato)= 'referenciaestructuravector' then result := TReferenciaEstructuraVector.Create
  else if LowerCase(tipoDato)= 'referenciaestructuramatriz' then result := TReferenciaEstructuraMatriz.Create
  else if LowerCase(tipoDato)= 'referenciacomponente' then result := TReferenciaComponente.Create
  else
      raise Exception.CreateFmt('Error tipo %s no puede ser creado!',[tipoDato]);
end;

class function TBuilderTipoDato.Instance: TBuilderTipoDato;
begin
  Result := AccessInstance(1);
end;

class procedure TBuilderTipoDato.ReleaseInstance;
begin
  AccessInstance(0).Free;
end;


end.
