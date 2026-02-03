unit Controller.Cliente;

interface

uses System.SysUtils, FireDAC.Comp.Client, Data.DB, Model.Cliente;

procedure ListarClientes(mtCliente: TFDMemTable; out erro: string);
function ListarCodigoUltimoCliente(out erro: string): Integer;
function InserirCliente(pIdCliente: integer; pNome, pTipoPessoa, pCpfCnpj,
  pUF, pDataCadastro: string; out erro: string): boolean;
function EditarCliente(pIdCliente: integer; pNome, pTipoPessoa, pCpfCnpj,
  pUF, pDataCadastro: string; out erro: string): boolean;
function DeletarCliente(pIdCliente: integer; out erro: string): boolean;

implementation

uses untDM;

procedure ListarClientes(mtCliente: TFDMemTable; out erro: string);
var
  cliente: TCliente;
  qry: TFDQuery;
begin
  try
    cliente := TCliente.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry := cliente.ListarClientes(erro);
    mtCliente.Data := qry.Data;
  finally
    qry.Free;
    cliente.Free;
  end;
end;

function ListarCodigoUltimoCliente(out erro: string): Integer;
var
  cliente: TCliente;
begin
  result := 0;
  try
    cliente := TCliente.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  try
    result := cliente.ListarCodigoUltimoCliente(erro);
  finally
    cliente.Free;
  end;
end;

function InserirCliente(pIdCliente: integer; pNome, pTipoPessoa, pCpfCnpj,
  pUF, pDataCadastro: string; out erro: string): boolean;
var
  cliente: TCliente;
begin
  result := true;
  cliente := TCliente.Create;

  try
    try
      cliente.IdCliente := pIdCliente;
      cliente.Nome := pNome;
      cliente.TipoPessoa := pTipoPessoa;
      cliente.CpfCnpj := pCpfCnpj;
      cliente.UF := pUF;
      cliente.DataCadastro := pDataCadastro;
      cliente.InserirCliente(erro);

      if erro <> EmptyStr then
        raise Exception.Create(erro);

    except on e: exception do
      begin
        result := false;
      end;
    end;
  finally
    cliente.Free;
  end;
end;

function EditarCliente(pIdCliente: integer; pNome, pTipoPessoa, pCpfCnpj,
  pUF, pDataCadastro: string; out erro: string): boolean;
var
  cliente: TCliente;
begin
  result := true;
  cliente := TCliente.Create;

  try
    try
      cliente.IdCliente := pIdCliente;
      cliente.Nome := pNome;
      cliente.TipoPessoa := pTipoPessoa;
      cliente.CpfCnpj := pCpfCnpj;
      cliente.UF := pUF;
      cliente.DataCadastro := pDataCadastro;
      cliente.EditarCliente(erro);

      if erro <> EmptyStr then
        raise Exception.Create(erro);

    except on e: exception do
      begin
        result := false;
      end;
    end;
  finally
    cliente.Free;
  end;
end;

function DeletarCliente(pIdCliente: integer; out erro: string): boolean;
var
  cliente: TCliente;
begin
  result := false;
  try
    cliente := TCliente.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  try
    try
      cliente.IdCliente := pIdCliente;
      cliente.DeletarCliente(erro);

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
    cliente.Free;
  end;
end;

end.

