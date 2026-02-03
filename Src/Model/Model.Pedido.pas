unit Model.Pedido;

interface

uses
  System.SysUtils, Data.DB, FireDAC.Comp.Client, untDM, Model.Connection, FireDAC.Stan.Param;

type
  TPedido = class
    private
      FIdPedido: integer;
      FIdCliente: integer;
      FTotal: double;
      FStatus: string;
      FIdPedidoItem: integer;
      FIdProduto: integer;
      FQuantidade: integer;
      FValorUnitario: double;
      FValorTotal: double;
    public
      Constructor Create;
      Destructor Destroy; override;

      property IdPedido: Integer read FIdPedido write FIdPedido;
      property IdCliente: integer read FIdCliente write FIdCliente;
      property Total: double read FTotal write FTotal;
      property Status: string read FStatus write FStatus;
      property IdPedidoItem: Integer read FIdPedidoItem write FIdPedidoItem;
      property IdProduto: Integer read FIdProduto write FIdProduto;
      property Quantidade: Integer read FQuantidade write FQuantidade;
      property ValorUnitario: double read FValorUnitario write FValorUnitario;
      property ValorTotal: double read FValorTotal write FValorTotal;

      function ListarPedidos(out erro: string): TFDQuery;
      function ListarPedidoItemPorIdPedido(out erro: string): TFDQuery;
      function ListarCodigoUltimoPedido(out erro: string): Integer;
      function ListarCodigoUltimoPedidoItem(out erro: string): Integer;
      function InserirPedido(out erro: string): boolean;
      function InserirPedidoItem(out erro: string): boolean;
      function EditarPedido(out erro: string): boolean;
      procedure DeletarPedido(out erro: string);
      procedure DeletarPedidoItemPorIdPedido(out erro: string);
  end;

implementation

{ TAbastecimento }

uses untPrincipal;

constructor TPedido.Create;
begin
  Model.Connection.Conecta;
end;

destructor TPedido.Destroy;
begin
  Model.Connection.Desconecta;
end;

function TPedido.ListarPedidos(out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;

    with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('SELECT P.ID_PEDIDO, P.ID_CLIENTE, C.NOME_RAZAO, P.DT_EMISSAO, P.STATUS, P.TOTAL ');
        SQL.Add('FROM PEDIDO P ');
        SQL.Add('INNER JOIN CLIENTE C ON C.ID_CLIENTE = P.ID_CLIENTE ');
        SQL.Add('WHERE 1=1');
        SQL.Add('ORDER BY P.ID_PEDIDO');

        Active := true;
        FetchAll;
      end;

    erro := EmptyStr;
    result := qry;
  except on e: exception do
    begin
      erro := 'Erro na consulta: ' + e.Message;
      result := nil;
    end;
  end;
end;

function TPedido.ListarCodigoUltimoPedido(out erro: string): Integer;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;

    with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('SELECT MAX(ID_PEDIDO) AS ULTIMO_ID_PEDIDO FROM PEDIDO ');

        Active := true;
        FetchAll;
      end;

    erro := EmptyStr;

    if qry.IsEmpty then
      result := 0
    else
      result := qry.FieldByName('ULTIMO_ID_PEDIDO').AsInteger;
  except on e: exception do
    begin
      erro := 'Erro na consulta: ' + e.Message;
      result := -1;
    end;
  end;
end;

function TPedido.ListarCodigoUltimoPedidoItem(out erro: string): Integer;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;

    with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('SELECT MAX(ID_PEDIDO_ITEM) AS ULTIMO_ID_PEDIDO_ITEM FROM PEDIDO_ITEM ');

        Active := true;
        FetchAll;
      end;

    erro := EmptyStr;

    if qry.IsEmpty then
      result := 0
    else
      result := qry.FieldByName('ULTIMO_ID_PEDIDO_ITEM').AsInteger;
  except on e: exception do
    begin
      erro := 'Erro na consulta: ' + e.Message;
      result := -1;
    end;
  end;
end;

function TPedido.ListarPedidoItemPorIdPedido(out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;

    with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('SELECT PI.ID_PEDIDO_ITEM, PI.ID_PEDIDO, PI.ID_PRODUTO, P.NCM, ');
        SQL.Add('P.DESCRICAO, PI.QUANTIDADE, PI.VL_UNITARIO, PI.VL_TOTAL, P.CFOP_PADRAO ');
        SQL.Add('FROM PEDIDO_ITEM PI ');
        SQL.Add('INNER JOIN PRODUTO P ON P.ID_PRODUTO = PI.ID_PRODUTO ');
        SQL.Add('WHERE 1=1');
        SQL.Add('AND PI.ID_PEDIDO = :IdPedido');

        ParamByName('IdPedido').Value := FIdPedido;

        Active := true;
        FetchAll;
      end;

    erro := EmptyStr;
    result := qry;
  except on e: exception do
    begin
      erro := 'Erro na consulta: ' + e.Message;
      result := nil;
    end;
  end;
end;

function TPedido.InserirPedido(out erro: string): boolean;
var
  qry: TFDQuery;
begin
  erro := EmptyStr;
  result := true;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;

    with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('  INSERT INTO PEDIDO (ID_PEDIDO, ID_CLIENTE, DT_EMISSAO, STATUS, TOTAL) ');
        SQL.Add('  VALUES (:IdPedido, :IdCliente, CURRENT_TIMESTAMP, :Status, :Total); ');

        ParamByName('IdPedido').Value := FIdPedido;
        ParamByName('IdCliente').Value := FIdCliente;
        ParamByName('Status').Value := FStatus;
        ParamByName('Total').Value := FTotal;

        ExecSQL;
        //Active := true;
      end;

    qry.Free;
  except on e: exception do
    begin
      erro := 'Erro ao inserir Pedido: ' + e.Message;
      result := false;
    end;
  end;
end;

function TPedido.InserirPedidoItem(out erro: string): boolean;
var
  qry: TFDQuery;
begin
  erro := EmptyStr;
  result := true;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;

    with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('  INSERT INTO PEDIDO_ITEM(ID_PEDIDO_ITEM, ID_PEDIDO, ID_PRODUTO, QUANTIDADE, VL_UNITARIO, VL_TOTAL) ');
        SQL.Add('  VALUES(:IdPedidoItem, :IdPedido, :IdProduto, :Quantidade, :ValorUnitario, :ValorTotal); ');

        ParamByName('IdPedidoItem').Value := FIdPedidoItem;
        ParamByName('IdPedido').Value := FIdPedido;
        ParamByName('IdProduto').Value := FIdProduto;
        ParamByName('Quantidade').Value := FQuantidade;
        ParamByName('ValorUnitario').Value := FValorUnitario;
        ParamByName('ValorTotal').Value := FValorTotal;
        ExecSQL;
        //Active := true;
      end;

    qry.Free;
  except on e: exception do
    begin
      erro := 'Erro ao inserir Pedido: ' + e.Message;
      result := false;
    end;
  end;
end;

function TPedido.EditarPedido(out erro: string): boolean;
var
  qry: TFDQuery;
begin
  erro := EmptyStr;
  result := true;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;

    with qry do
      begin
        //Active := false;
        SQL.Clear;
        SQL.Add('UPDATE PEDIDO SET ID_CLIENTE=:IdCliente, TOTAL=:ValorTotal, STATUS=:Status ');
        SQL.Add('WHERE ID_PEDIDO = :IdPedido');

        ParamByName('IdPedido').Value := FIdPedido;
        ParamByName('IdCliente').Value := FIdCliente;
        ParamByName('ValorTotal').Value := FValorTotal;
        ParamByName('Status').Value := FStatus;
        ExecSQL;
        //Active := true;
      end;

    qry.Free;

  except on e: exception do
    begin
      erro := 'Erro ao editar Pedido: ' + e.Message;
      result := false;
    end;
  end;
end;

procedure TPedido.DeletarPedido(out erro: string);
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;

    with qry do
      begin
        //Active := false;
        SQL.Clear;
        SQL.Add('DELETE FROM PEDIDO WHERE ID_PEDIDO = :IdPedido');
        ParamByName('IdPedido').Value := FIdPedido;
        ExecSQL;
        //Active := true;
      end;

    qry.Free;
    erro := EmptyStr;
  except on e: exception do
    begin
      erro := 'Erro ao excluir Pedido: ' + e.Message;
    end;
  end;
end;

procedure TPedido.DeletarPedidoItemPorIdPedido(out erro: string);
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;

    with qry do
      begin
        //Active := false;
        SQL.Clear;
        SQL.Add('DELETE FROM PEDIDO_ITEM WHERE ID_PEDIDO = :IdPedido');
        ParamByName('IdPedido').Value := FIdPedido;
        ExecSQL;
        //Active := true;
      end;

    qry.Free;
    erro := EmptyStr;
  except on e: exception do
    begin
      erro := 'Erro ao excluir Itens do Pedido: ' + e.Message;
    end;
  end;
end;

end.
