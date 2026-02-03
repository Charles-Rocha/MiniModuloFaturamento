unit Model.Cliente;

interface

uses
  System.SysUtils, Data.DB, FireDAC.Comp.Client, untDM, Model.Connection, FireDAC.Stan.Param;

type
  TCliente = class
    private
      FIdCliente: integer;
      FNome: string;
      FTipoPessoa: string;
      FCpfCnpj: string;
      FUF: string;
      FDataCadastro: string;

    public
      Constructor Create;
      Destructor Destroy; override;

      property IdCliente: Integer read FIdCliente write FIdCliente;
      property Nome: string read FNome write FNome;
      property TipoPessoa: string read FTipoPessoa write FTipoPessoa;
      property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
      property UF: string read FUF write FUF;
      property DataCadastro: string read FDataCadastro write FDataCadastro;

      function ListarClientes(out erro: string): TFDQuery;
      function ListarCodigoUltimoCliente(out erro: string): Integer;
      function InserirCliente(out erro: string): boolean;
      function EditarCliente(out erro: string): boolean;
      procedure DeletarCliente(out erro: string);
  end;

implementation

{ TAbastecimento }

uses untPrincipal;

constructor TCliente.Create;
begin
  Model.Connection.Conecta;
end;

destructor TCliente.Destroy;
begin
  Model.Connection.Desconecta;
end;

function TCliente.ListarClientes(out erro: string): TFDQuery;
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
        SQL.Add('ORDER BY C.ID_CLIENTE');

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

function TCliente.ListarCodigoUltimoCliente(out erro: string): Integer;
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
        SQL.Add('SELECT MAX(ID_CLIENTE) AS ULTIMO_ID_CLIENTE FROM CLIENTE ');

        Active := true;
        FetchAll;
      end;

    erro := EmptyStr;

    if qry.IsEmpty then
      result := 0
    else
      result := qry.FieldByName('ULTIMO_ID_CLIENTE').AsInteger;
  except on e: exception do
    begin
      erro := 'Erro na consulta: ' + e.Message;
      result := -1;
    end;
  end;
end;

function TCliente.InserirCliente(out erro: string): boolean;
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
        SQL.Add('INSERT INTO CLIENTE (ID_CLIENTE, NOME_RAZAO, TIPO_PESSOA, CPF_CNPJ, UF, DT_CADASTRO) ');
        SQL.Add('VALUES(:IdCliente, :Nome, :TipoPessoa, :CpfCnpj, :UF, :DataCadastro) ');

        ParamByName('IdCliente').Value := FIdCliente;
        ParamByName('Nome').Value := FNome;
        ParamByName('TipoPessoa').Value := FTipoPessoa;
        ParamByName('CpfCnpj').Value := FCpfCnpj;
        ParamByName('UF').Value := FUF;
        ParamByName('DataCadastro').Value := FDataCadastro;
        ExecSQL;
        //Active := true;
      end;

    qry.Free;
  except on e: exception do
    begin
      erro := 'Erro ao inserir Abastecimento: ' + e.Message;
      result := false;
    end;
  end;
end;

function TCliente.EditarCliente(out erro: string): boolean;
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
        SQL.Add('UPDATE CLIENTE SET NOME_RAZAO=:Nome, TIPO_PESSOA=:TipoPessoa, ');
        SQL.Add('CPF_CNPJ=:CpfCnpj, UF=:UF, DT_CADASTRO=:DataCadastro');
        SQL.Add('WHERE ID_CLIENTE = :IdCliente');

        ParamByName('IdCliente').Value := FIdCliente;
        ParamByName('Nome').Value := FNome;
        ParamByName('TipoPessoa').Value := FTipoPessoa;
        ParamByName('CpfCnpj').Value := FCpfCnpj;
        ParamByName('UF').Value := FUF;
        ParamByName('DataCadastro').Value := FDataCadastro;

        ExecSQL;
        //Active := true;
      end;

    qry.Free;

  except on e: exception do
    begin
      erro := 'Erro ao editar Abastecimento: ' + e.Message;
      result := false;
    end;
  end;
end;

procedure TCliente.DeletarCliente(out erro: string);
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
        SQL.Add('DELETE FROM CLIENTE WHERE ID_CLIENTE = :IdCliente');
        ParamByName('IdCliente').Value := FIdCliente;
        ExecSQL;
        //Active := true;
      end;

    qry.Free;
    erro := EmptyStr;
  except on e: exception do
    begin
      erro := 'Erro ao excluir Abastecimento: ' + e.Message;
    end;
  end;
end;

end.
