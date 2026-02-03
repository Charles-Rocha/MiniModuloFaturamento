unit Model.NFe;

interface

uses
  System.SysUtils, Data.DB, FireDAC.Comp.Client, untDM, Model.Connection, FireDAC.Stan.Param;

type
  TNFe = class
    private
      FIdNFe: integer;
      FIdPedido: integer;
      FSerie: integer;
      FNumero: integer;
      FStatusAtual: string;
      FChaveAcesso: string;
      FCorrigir: string;

    public
      Constructor Create;
      Destructor Destroy; override;

      property IdNFe: Integer read FIdNFe write FIdNFe;
      property IdPedido: Integer read FIdPedido write FIdPedido;
      property Serie: Integer read FSerie write FSerie;
      property Numero: Integer read FNumero write FNumero;
      property StatusAtual: string read FStatusAtual write FStatusAtual;
      property ChaveAcesso: string read FChaveAcesso write FChaveAcesso;
      property Corrigir: string read FCorrigir write FCorrigir;

      function ListarCodigoUltimaNFe(out erro: string): Integer;
      function ListarNFes(out erro: string): TFDQuery;
      function ListarNFePorIdPedido(out erro: string): TFDQuery;
      function ListarIdNFePorIdPedido(out erro: string): Integer;
      function InserirNFe(out erro: string): boolean;
      function EditarNFe(out erro: string): boolean;
      procedure DeletarNFe(out erro: string);
  end;

implementation

{ TNFe }

uses untPrincipal;

constructor TNFe.Create;
begin
  Model.Connection.Conecta;
end;

destructor TNFe.Destroy;
begin
  Model.Connection.Desconecta;
end;

function TNFe.ListarNFes(out erro: string): TFDQuery;
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

        SQL.Add('SELECT C.ID_CLIENTE, C.NOME_RAZAO, ');
        SQL.Add('C.TIPO_PESSOA, C.CPF_CNPJ, C.UF, C.DT_CADASTRO ');
        SQL.Add('FROM CLIENTE C ');
        SQL.Add('WHERE 1=1');

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

function TNFe.ListarNFePorIdPedido(out erro: string): TFDQuery;
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
        SQL.Add('SELECT ID_NFE, ID_PEDIDO, SERIE, NUMERO, ');
        SQL.Add('STATUS_ATUAL, CHAVE_ACESSO, DT_EMISSAO, CORRIGIR ');
        SQL.Add('FROM NFE ');
        SQL.Add('WHERE ID_PEDIDO = :IdPedido');

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

function TNFe.ListarCodigoUltimaNFe(out erro: string): Integer;
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
        SQL.Add('SELECT MAX(ID_NFE) AS ULTIMO_ID_NFE FROM NFE ');

        Active := true;
        FetchAll;
      end;

    erro := EmptyStr;

    if qry.IsEmpty then
      result := 0
    else
      result := qry.FieldByName('ULTIMO_ID_NFE').AsInteger;
  except on e: exception do
    begin
      erro := 'Erro na consulta: ' + e.Message;
      result := -1;
    end;
  end;
end;

function TNFe.ListarIdNFePorIdPedido(out erro: string): Integer;
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
        SQL.Add('SELECT ID_NFE FROM NFE ');
        SQL.Add('WHERE ID_PEDIDO = :IdPedido');

        ParamByName('IdPedido').Value := FIdPedido;

        Active := true;
        FetchAll;
      end;

    erro := EmptyStr;

    if qry.IsEmpty then
      result := 0
    else
      result := qry.FieldByName('ID_NFE').AsInteger;
  except on e: exception do
    begin
      erro := 'Erro na consulta: ' + e.Message;
      result := -1;
    end;
  end;
end;

function TNFe.InserirNFe(out erro: string): boolean;
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
        SQL.Add('INSERT INTO NFE (ID_NFE, ID_PEDIDO, SERIE, NUMERO, STATUS_ATUAL, CHAVE_ACESSO, DT_EMISSAO) ');
        SQL.Add('VALUES(:IdNFe, :IdPedido, :Serie, :Numero, :StatusAtual, :ChaveAcesso, CURRENT_TIMESTAMP) ');

        ParamByName('IdNFe').Value := FIdNFe;
        ParamByName('IdPedido').Value := FIdPedido;
        ParamByName('Serie').Value := FSerie;
        ParamByName('Numero').Value := FNumero;
        ParamByName('StatusAtual').Value := FStatusAtual;
        ParamByName('ChaveAcesso').Value := FChaveAcesso;
        ExecSQL;
        //Active := true;
      end;

    qry.Free;
  except on e: exception do
    begin
      erro := 'Erro ao inserir NFe: ' + e.Message;
      result := false;
    end;
  end;
end;

function TNFe.EditarNFe(out erro: string): boolean;
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
        SQL.Add('UPDATE NFE SET ID_PEDIDO=:IdPedido, SERIE=:Serie, NUMERO=:Numero, ');
        SQL.Add('STATUS_ATUAL=:StatusAtual, CHAVE_ACESSO=:ChaveAcesso, CORRIGIR=:Corrigir');
        SQL.Add('WHERE ID_NFE = :IdNFe');

        ParamByName('IdNFe').Value := FIdNFe;
        ParamByName('IdPedido').Value := FIdPedido;
        ParamByName('Serie').Value := FSerie;
        ParamByName('Numero').Value := FNumero;
        ParamByName('StatusAtual').Value := FStatusAtual;
        ParamByName('ChaveAcesso').Value := FChaveAcesso;
        ParamByName('Corrigir').Value := FCorrigir;

        ExecSQL;
        //Active := true;
      end;

    qry.Free;

  except on e: exception do
    begin
      erro := 'Erro ao editar NFe: ' + e.Message;
      result := false;
    end;
  end;
end;

procedure TNFe.DeletarNFe(out erro: string);
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
        SQL.Add('DELETE FROM NFE WHERE ID_NFE = :IdNFe');
        ParamByName('IdNFe').Value := FIdNFe;
        ExecSQL;
        //Active := true;
      end;

    qry.Free;
    erro := EmptyStr;
  except on e: exception do
    begin
      erro := 'Erro ao excluir NFe: ' + e.Message;
    end;
  end;
end;

end.
