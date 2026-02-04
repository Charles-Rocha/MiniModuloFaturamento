unit Controller.NFe;

interface

uses System.SysUtils, FireDAC.Comp.Client, Data.DB, Model.NFe;

function ListarCodigoUltimaNFe(out erro: string): Integer;
procedure ListarNFes(mtNFe: TFDMemTable; out erro: string);
procedure ListarNFePorIdPedido(mtNFe: TFDMemTable; pIdPedido: integer; out erro: string);
function ListarIdNFePorIdPedido(pIdPedido: integer; out erro: string): Integer;
function InserirNFe(pIdNFe, pIdPedido, pSerie, pNumero: integer;
  pStatusAtual, pChaveAcesso, pCorrigir: string; out erro: string): boolean;
function EditarNFe(pIdNFe, pIdPedido, pSerie, pNumero: integer;
  pStatusAtual, pChaveAcesso, pCorrigir: string; out erro: string): boolean;
function DeletarNFe(pIdNFe: integer; out erro: string): boolean;

implementation

uses untDM;

procedure ListarNFes(mtNFe: TFDMemTable; out erro: string);
var
  nfe: TNFe;
  qry: TFDQuery;
begin
  try
    nfe := TNFe.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry := nfe.ListarNFes(erro);
    mtNFe.Data := qry.Data;
  finally
    qry.Free;
    nfe.Free;
  end;
end;

procedure ListarNFePorIdPedido(mtNFe: TFDMemTable; pIdPedido: integer; out erro: string);
var
  nfe: TNfe;
  qry: TFDQuery;
begin
  try
    nfe := TNfe.Create;
    nfe.IdPedido := pIdPedido;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry := nfe.ListarNFePorIdPedido(erro);
    mtNFe.Data := qry.Data;
  finally
    qry.Free;
    nfe.Free;
  end;
end;

function ListarCodigoUltimaNFe(out erro: string): Integer;
var
  nfe: TNfe;
begin
  result := 0;
  try
    nfe := TNfe.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  try
    result := nfe.ListarCodigoUltimaNFe(erro);
  finally
    nfe.Free;
  end;
end;

function ListarIdNFePorIdPedido(pIdPedido: integer; out erro: string): Integer;
var
  nfe: TNfe;
begin
  result := 0;
  try
    nfe := TNfe.Create;
    nfe.IdPedido := pIdPedido;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  try
    result := nfe.ListarIdNFePorIdPedido(erro);
  finally
    nfe.Free;
  end;
end;

function InserirNFe(pIdNFe, pIdPedido, pSerie, pNumero: integer;
  pStatusAtual, pChaveAcesso, pCorrigir: string; out erro: string): boolean;
var
  nfe: TNfe;
begin
  result := true;
  nfe := TNfe.Create;

  try
    try
      nfe.IdNFe := pIdNFe;
      nfe.IdPedido := pIdPedido;
      nfe.Serie := pSerie;
      nfe.Numero := pNumero;
      nfe.StatusAtual := pStatusAtual;
      nfe.ChaveAcesso := pChaveAcesso;
      nfe.Corrigir := pCorrigir;
      nfe.InserirNFe(erro);

      if erro <> EmptyStr then
        raise Exception.Create(erro);

    except on e: exception do
      begin
        result := false;
      end;
    end;
  finally
    nfe.Free;
  end;
end;

function EditarNFe(pIdNFe, pIdPedido, pSerie, pNumero: integer;
  pStatusAtual, pChaveAcesso, pCorrigir: string; out erro: string): boolean;
var
  nfe: TNFe;
begin
  result := true;
  nfe := TNFe.Create;

  try
    try
      nfe.IdNFe := pIdNFe;
      nfe.IdPedido := pIdPedido;
      nfe.Serie := pSerie;
      nfe.Numero := pNumero;
      nfe.StatusAtual := pStatusAtual;
      nfe.ChaveAcesso := pChaveAcesso;
      nfe.Corrigir := pCorrigir;
      nfe.EditarNFe(erro);

      if erro <> EmptyStr then
        raise Exception.Create(erro);

    except on e: exception do
      begin
        result := false;
      end;
    end;
  finally
    nfe.Free;
  end;
end;

function DeletarNFe(pIdNFe: integer; out erro: string): boolean;
var
  nfe: TNFe;
begin
  result := false;
  try
    nfe := TNFe.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  try
    try
      nfe.IdNFe := pIdNFe;
      nfe.DeletarNFe(erro);

      if erro <> EmptyStr then
        raise Exception.Create(erro)
      else
        result := true;

    except on e: exception do
      begin
        erro := 'Erro ao deletar lançamento: ' + e.Message;
      end;
    end;

  finally
    nfe.Free;
  end;
end;

end.

