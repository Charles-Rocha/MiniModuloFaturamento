unit Controller.EventoNfe;

interface

uses System.SysUtils, FireDAC.Comp.Client, Data.DB, Model.EventoNFe;

function ListarCodigoUltimoEventoNFe(out erro: string): Integer;
procedure ListarEventosNFe(mtEventoNfe: TFDMemTable; out erro: string);
procedure ListarEventosNFePorIdNFe(mtEventoNfe: TFDMemTable; pIdNFe: integer; out erro: string);
procedure ListarUltimoEventoNFePorIdNFe(mtEventoNfe: TFDMemTable; pIdNFe: integer; out erro: string);
function InserirEventoNFe(pIdNFeEvento, pIdNFe: integer; pStatusAntes,
  pStatusDepois, pMotivo: string; out erro: string): boolean;

implementation

uses untDM;

function ListarCodigoUltimoEventoNFe(out erro: string): Integer;
var
  evento_nfe: TEventoNFe;
begin
  result := 0;
  try
    evento_nfe := TEventoNFe.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  try
    result := evento_nfe.ListarCodigoUltimoEventoNFe(erro);
  finally
    evento_nfe.Free;
  end;
end;

procedure ListarEventosNFe(mtEventoNFe: TFDMemTable; out erro: string);
var
  evento_nfe: TEventoNFe;
  qry: TFDQuery;
begin
  try
    evento_nfe := TEventoNFe.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry := evento_nfe.ListarEventosNFe(erro);
    mtEventoNfe.Data := qry.Data;
  finally
    qry.Free;
    evento_nfe.Free;
  end;
end;

procedure ListarEventosNFePorIdNFe(mtEventoNFe: TFDMemTable; pIdNFe: integer; out erro: string);
var
  evento_nfe: TEventoNFe;
  qry: TFDQuery;
begin
  try
    evento_nfe := TEventoNFe.Create;
    evento_nfe.IdNFe := pIdNFe;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry := evento_nfe.ListarEventosNFePorIdNFe(erro);
    mtEventoNFe.Data := qry.Data;
  finally
    qry.Free;
    evento_nfe.Free;
  end;
end;

procedure ListarUltimoEventoNFePorIdNFe(mtEventoNFe: TFDMemTable; pIdNFe: integer; out erro: string);
var
  evento_nfe: TEventoNFe;
  qry: TFDQuery;
begin
  try
    evento_nfe := TEventoNFe.Create;
    evento_nfe.IdNFe := pIdNFe;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry := evento_nfe.ListarUltimoEventoNFePorIdNFe(erro);
    mtEventoNFe.Data := qry.Data;
  finally
    qry.Free;
    evento_nfe.Free;
  end;
end;

function InserirEventoNFe(pIdNFeEvento, pIdNFe: integer; pStatusAntes,
  pStatusDepois, pMotivo: string; out erro: string): boolean;
var
  evento_nfe: TEventoNFe;
begin
  result := true;
  evento_nfe := TEventoNFe.Create;

  try
    try
      evento_nfe.IdNFeEvento := pIdNFeEvento;
      evento_nfe.IdNFe := pIdNFe;
      evento_nfe.StatusAntes := pStatusAntes;
      evento_nfe.StatusDepois := pStatusDepois;
      evento_nfe.Motivo := pMotivo;
      evento_nfe.InserirEventoNfe(erro);

      if erro <> EmptyStr then
        raise Exception.Create(erro);

    except on e: exception do
      begin
        result := false;
      end;
    end;
  finally
    evento_nfe.Free;
  end;
end;

end.

