unit Controller.Produto;

interface

uses System.SysUtils, FireDAC.Comp.Client, Data.DB, Model.Produto;

procedure ListarProdutos(mtProdutos: TFDMemTable; out erro: string);
function ListarCodigoUltimoProduto(out erro: string): Integer;
function InserirProduto(pIdProduto: integer; pDescricao, pNcm, pCfopPadrao: string;
  pPrecoVenda: double; out erro: string): boolean;
function EditarProduto(pIdProduto: integer; pDescricao, pNcm, pCfopPadrao: string;
  pPrecoVenda: double; out erro: string): boolean;
function DeletarProduto(pIdProduto: integer; out erro: string): boolean;

implementation

uses untDM;

procedure ListarProdutos(mtProdutos: TFDMemTable; out erro: string);
var
  produto: TProduto;
  qry: TFDQuery;
begin
  try
    produto := TProduto.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry := produto.ListarProdutos(erro);
    mtProdutos.Data := qry.Data;
  finally
    qry.Free;
    produto.Free;
  end;
end;

function ListarCodigoUltimoProduto(out erro: string): Integer;
var
  produto: TProduto;
begin
  result := 0;
  try
    produto := TProduto.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  try
    result := produto.ListarCodigoUltimoProduto(erro);
  finally
    produto.Free;
  end;
end;

function InserirProduto(pIdProduto: integer; pDescricao, pNcm, pCfopPadrao: string;
  pPrecoVenda: double; out erro: string): boolean;
var
  produto: TProduto;
begin
  result := true;
  produto := TProduto.Create;

  try
    try
      produto.IdProduto := pIdProduto;
      produto.Descricao := pDescricao;
      produto.Ncm := pNcm;
      produto.CfopPadrao := pCfopPadrao;
      produto.PrecoVenda := pPrecoVenda;
      produto.InserirProduto(erro);

      if erro <> EmptyStr then
        raise Exception.Create(erro);

    except on e: exception do
      begin
        result := false;
      end;
    end;
  finally
    produto.Free;
  end;
end;

function EditarProduto(pIdProduto: integer; pDescricao, pNcm, pCfopPadrao: string;
  pPrecoVenda: double; out erro: string): boolean;
var
  produto: TProduto;
begin
  result := true;
  produto := TProduto.Create;

  try
    try
      produto.IdProduto := pIdProduto;
      produto.Descricao := pDescricao;
      produto.Ncm := pNcm;
      produto.CfopPadrao := pCfopPadrao;
      produto.PrecoVenda := pPrecoVenda;
      produto.EditarProduto(erro);

      if erro <> EmptyStr then
        raise Exception.Create(erro);

    except on e: exception do
      begin
        result := false;
      end;
    end;

  finally
    produto.Free;
  end;
end;

function DeletarProduto(pIdProduto: integer; out erro: string): boolean;
var
  produto: TProduto;
begin
  result := false;
  try
    produto := TProduto.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  try
    try
      produto.IdProduto := pIdProduto;
      produto.DeletarProduto(erro);

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
    produto.Free;
  end;
end;

end.

