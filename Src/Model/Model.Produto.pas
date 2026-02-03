unit Model.Produto;

interface

uses
  System.SysUtils, Data.DB, FireDAC.Comp.Client, untDM, Model.Connection, FireDAC.Stan.Param;

type
  TProduto = class
    private
      FIdProduto: Integer;
      FDescricao: string;
      FNcm: string;
      FCfopPadrao: string;
      FPrecoVenda: double;

    public
      Constructor Create;
      Destructor Destroy; override;

      property IdProduto: Integer read FIdProduto write FIdProduto;
      property Descricao: string read FDescricao write FDescricao;
      property Ncm: string read FNcm write FNcm;
      property CfopPadrao: string read FCfopPadrao write FCfopPadrao;
      property PrecoVenda: double read FPrecoVenda write FPrecoVenda;

      function ListarProdutos(out erro: string): TFDQuery;
      function ListarCodigoUltimoProduto(out erro: string): Integer;
      function InserirProduto(out erro: string): boolean;
      function EditarProduto(out erro: string): boolean;
      procedure DeletarProduto(out erro: string);
  end;

implementation

{ TAbastecimento }

uses untPrincipal;

constructor TProduto.Create;
begin
  Model.Connection.Conecta;
end;

destructor TProduto.Destroy;
begin
  Model.Connection.Desconecta;
end;

function TProduto.ListarProdutos(out erro: string): TFDQuery;
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
        SQL.Add('SELECT P.ID_PRODUTO, P.DESCRICAO, P.NCM, P.CFOP_PADRAO, P.PRECO_VENDA ');
        SQL.Add('FROM PRODUTO P ');
        SQL.Add('WHERE 1=1');
        SQL.Add('ORDER BY P.ID_PRODUTO');

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

function TProduto.ListarCodigoUltimoProduto(out erro: string): Integer;
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
        SQL.Add('SELECT MAX(ID_PRODUTO) AS ULTIMO_ID_PRODUTO FROM PRODUTO ');

        Active := true;
        FetchAll;
      end;

    erro := EmptyStr;

    if qry.IsEmpty then
      result := 0
    else
      result := qry.FieldByName('ULTIMO_ID_PRODUTO').AsInteger;
  except on e: exception do
    begin
      erro := 'Erro na consulta: ' + e.Message;
      result := -1;
    end;
  end;
end;

function TProduto.InserirProduto(out erro: string): boolean;
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

        SQL.Add('INSERT INTO PRODUTO (ID_PRODUTO, DESCRICAO, NCM, CFOP_PADRAO, PRECO_VENDA) ');
        SQL.Add('VALUES(:IdProduto, :Descricao, :Ncm, :CfopPadrao, :PrecoVenda) ');

        ParamByName('IdProduto').Value := FIdProduto;
        ParamByName('Descricao').Value := FDescricao;
        ParamByName('Ncm').Value := FNcm;
        ParamByName('CfopPadrao').Value := FCfopPadrao;
        ParamByName('PrecoVenda').Value := FPrecoVenda;
        ExecSQL;
        //Active := true;
      end;

    qry.Free;
  except on e: exception do
    begin
      erro := 'Erro ao inserir Produto: ' + e.Message;
      result := false;
    end;
  end;
end;

function TProduto.EditarProduto(out erro: string): boolean;
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
        SQL.Add('UPDATE PRODUTO SET DESCRICAO=:Descricao, NCM=:Ncm, ');
        SQL.Add('CFOP_PADRAO=:CfopPadrao, PRECO_VENDA=:PrecoVenda');
        SQL.Add('WHERE ID_PRODUTO = :IdProduto');

        ParamByName('IdProduto').Value := FIdProduto;
        ParamByName('Descricao').Value := FDescricao;
        ParamByName('Ncm').Value := FNcm;
        ParamByName('CfopPadrao').Value := FCfopPadrao;
        ParamByName('PrecoVenda').Value := FPrecoVenda;
        ExecSQL;
        //Active := true;
      end;

    qry.Free;

  except on e: exception do
    begin
      erro := 'Erro ao editar Produto: ' + e.Message;
      result := false;
    end;
  end;
end;

procedure TProduto.DeletarProduto(out erro: string);
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
        SQL.Add('DELETE FROM PRODUTO WHERE ID_PRODUTO = :IdProduto');
        ParamByName('IdProduto').Value := FIdProduto;
        ExecSQL;
        //Active := true;
      end;

    qry.Free;
    erro := EmptyStr;
  except on e: exception do
    begin
      erro := 'Erro ao excluir Produto: ' + e.Message;
    end;
  end;
end;

end.
