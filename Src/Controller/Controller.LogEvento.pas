unit Controller.LogEvento;

interface

uses System.SysUtils, FireDAC.Comp.Client, Data.DB, Model.LogEvento;

function ListarCodigoUltimoLogEvento(out erro: string): Integer;
procedure ListarLogEventoPorIdNFe(mtLogEvento: TFDMemTable; pNumeroNFe: integer; out erro: string);
function InserirLogEvento(pIdLog: integer; pEntidade, pAcao, pMensagem: string; out erro: string): boolean;

implementation

uses untDM;

function ListarCodigoUltimoLogEvento(out erro: string): Integer;
var
  log_evento: TLogEvento;
begin
  result := 0;
  try
    log_evento := TLogEvento.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  try
    result := log_evento.ListarCodigoUltimoLogEvento(erro);
  finally
    log_evento.Free;
  end;
end;

procedure ListarLogEventoPorIdNFe(mtLogEvento: TFDMemTable; pNumeroNFe: integer; out erro: string);
var
  log_evento: TLogEvento;
  qry: TFDQuery;
begin
  try
    log_evento := TLogEvento.Create;
    log_evento.NumeroNFe := pNumeroNFe;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry := log_evento.ListarLogEventoPorIdNFe(erro);
    mtLogEvento.Data := qry.Data;
  finally
    qry.Free;
    log_evento.Free;
  end;
end;

function InserirLogEvento(pIdLog: integer; pEntidade, pAcao, pMensagem: string; out erro: string): boolean;
var
  log_evento: TLogEvento;
begin
  result := true;
  log_evento := TLogEvento.Create;

  try
    try
      log_evento.IdLog := pIdLog;
      log_evento.Entidade := pEntidade;
      log_evento.Acao := pAcao;
      log_evento.Mensagem := pMensagem;
      log_evento.InserirLogEvento(erro);

      if erro <> EmptyStr then
        raise Exception.Create(erro);

    except on e: exception do
      begin
        result := false;
      end;
    end;
  finally
    log_evento.Free;
  end;
end;

end.

