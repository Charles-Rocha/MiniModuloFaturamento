unit Controller.Pedido;

interface

uses System.SysUtils, FireDAC.Comp.Client, Data.DB, Model.Pedido;

procedure ListarPedidos(mtPedido: TFDMemTable; out erro: string);
procedure ListarPedidoItemPorIdPedido(mtPedidoItem: TFDMemTable; pIdPedido: integer; out erro: string);
function ListarCodigoUltimoPedido(out erro: string): Integer;
function ListarCodigoUltimoPedidoItem(out erro: string): Integer;
function InserirPedido(pIdPedido, pIdCliente: integer; pTotal: double; pStatus: string; out erro: string): boolean;
function InserirPedidoItem(pIdPedidoItem, pIdPedido, pIdProduto, pQuantidade: integer;
                           pValorUnitario, pValorTotal: double; out erro: string): boolean;
function EditarPedido(pIdPedido, pIdCliente: integer; pValorTotalPedido: double;
                      pStatus: string; out erro: string): boolean;
function DeletarPedido(pIdPedido: integer; out erro: string): boolean;
function DeletarPedidoItemPorIdPedido(pIdPedido: integer; out erro: string): boolean;

implementation

uses untDM;

procedure ListarPedidos(mtPedido: TFDMemTable; out erro: string);
var
  pedido: TPedido;
  qry: TFDQuery;
begin
  try
    pedido := TPedido.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry := pedido.ListarPedidos(erro);
    mtPedido.Data := qry.Data;
  finally
    qry.Free;
    pedido.Free;
  end;
end;

procedure ListarPedidoItemPorIdPedido(mtPedidoItem: TFDMemTable; pIdPedido: integer; out erro: string);
var
  pedido: TPedido;
  qry: TFDQuery;
begin
  try
    pedido := TPedido.Create;
    pedido.IdPedido := pIdPedido;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry := pedido.ListarPedidoItemPorIdPedido(erro);
    mtPedidoItem.Data := qry.Data;
  finally
    qry.Free;
    pedido.Free;
  end;
end;

function ListarCodigoUltimoPedido(out erro: string): Integer;
var
  pedido: TPedido;
begin
  result := 0;
  try
    pedido := TPedido.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  try
    result := pedido.ListarCodigoUltimoPedido(erro);
  finally
    pedido.Free;
  end;
end;

function ListarCodigoUltimoPedidoItem(out erro: string): Integer;
var
  pedido: TPedido;
begin
  result := 0;
  try
    pedido := TPedido.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  try
    result := pedido.ListarCodigoUltimoPedidoItem(erro);
  finally
    pedido.Free;
  end;
end;

function InserirPedido(pIdPedido, pIdCliente: integer; pTotal: double; pStatus: string; out erro: string): boolean;
var
  pedido: TPedido;
begin
  result := true;
  pedido := TPedido.Create;

  try
    try
      pedido.IdPedido := pIdPedido;
      pedido.IdCliente := pIdCliente;
      pedido.Total := pTotal;
      pedido.Status := pStatus;
      pedido.InserirPedido(erro);

      if erro <> EmptyStr then
        raise Exception.Create(erro);

    except on e: exception do
      begin
        result := false;
      end;
    end;
  finally
    pedido.Free;
  end;
end;

function InserirPedidoItem(pIdPedidoItem, pIdPedido, pIdProduto, pQuantidade: integer;
                           pValorUnitario, pValorTotal: double; out erro: string): boolean;
var
  pedido: TPedido;
begin
  result := true;
  pedido := TPedido.Create;

  try
    try
      pedido.IdPedidoItem := pIdPedidoItem;
      pedido.IdPedido := pIdPedido;
      pedido.IdProduto := pIdProduto;
      pedido.Quantidade := pQuantidade;
      pedido.ValorUnitario := pValorUnitario;
      pedido.ValorTotal := pValorTotal;
      pedido.InserirPedidoItem(erro);

      if erro <> EmptyStr then
        raise Exception.Create(erro);

    except on e: exception do
      begin
        result := false;
      end;
    end;
  finally
    pedido.Free;
  end;
end;

function EditarPedido(pIdPedido, pIdCliente: integer; pValorTotalPedido: double;
                      pStatus: string; out erro: string): boolean;
var
  pedido: TPedido;
begin
  result := true;
  pedido := TPedido.Create;

  try
    try
      pedido.IdPedido := pIdPedido;
      pedido.IdCliente := pIdCliente;
      pedido.ValorTotal := pValorTotalPedido;
      pedido.Status := pStatus;
      pedido.EditarPedido(erro);

      if erro <> EmptyStr then
        raise Exception.Create(erro);

    except on e: exception do
      begin
        result := false;
      end;
    end;

  finally
    pedido.Free;
  end;
end;

function DeletarPedido(pIdPedido: integer; out erro: string): boolean;
var
  pedido: TPedido;
begin
  result := false;
  try
    pedido := TPedido.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  try
    try
      pedido.IdPedido := pIdPedido;
      pedido.DeletarPedido(erro);

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
    pedido.Free;
  end;
end;

function DeletarPedidoItemPorIdPedido(pIdPedido: integer; out erro: string): boolean;
var
  pedido: TPedido;
begin
  result := false;
  try
    pedido := TPedido.Create;
  except on e: exception do
    begin
      erro := 'Erro encontrado: ' + e.Message;
      exit;
    end;
  end;

  try
    try
      pedido.IdPedido := pIdPedido;
      pedido.DeletarPedidoItemPorIdPedido(erro);

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
    pedido.Free;
  end;
end;

end.

