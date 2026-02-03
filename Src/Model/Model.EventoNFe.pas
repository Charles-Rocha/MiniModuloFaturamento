unit Model.EventoNFe;

interface

uses
  System.SysUtils, Data.DB, FireDAC.Comp.Client, untDM, Model.Connection, FireDAC.Stan.Param;

type
  TEventoNFe = class
    private
      FIdNFeEvento: integer;
      FIdNFe: integer;
      FDataEvento: string;
      FStatusAntes: string;
      FStatusDepois: string;
      FMotivo: string;

    public
      Constructor Create;
      Destructor Destroy; override;

      property IdNFeEvento: Integer read FIdNFeEvento write FIdNFeEvento;
      property IdNFe: Integer read FIdNFe write FIdNFe;
      property DataEvento: string read FDataEvento write FDataEvento;
      property StatusAntes: string read FStatusAntes write FStatusAntes;
      property StatusDepois: string read FStatusDepois write FStatusDepois;
      property Motivo: string read FMotivo write FMotivo;

      function ListarCodigoUltimoEventoNFe(out erro: string): Integer;
      function ListarEventosNFe(out erro: string): TFDQuery;
      function ListarEventosNFePorIdNFe(out erro: string): TFDQuery;
      function ListarUltimoEventoNFePorIdNFe(out erro: string): TFDQuery;
      function InserirEventoNFe(out erro: string): boolean;
  end;

implementation

{ TAbastecimento }

uses untPrincipal;

constructor TEventoNFe.Create;
begin
  Model.Connection.Conecta;
end;

destructor TEventoNFe.Destroy;
begin
  Model.Connection.Desconecta;
end;

function TEventoNFe.ListarCodigoUltimoEventoNFe(out erro: string): Integer;
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
        SQL.Add('SELECT MAX(ID_NFE_EVENTO) AS ULTIMO_ID_NFE_EVENTO FROM NFE_EVENTO ');

        Active := true;
        FetchAll;
      end;

    erro := EmptyStr;

    if qry.IsEmpty then
      result := 0
    else
      result := qry.FieldByName('ULTIMO_ID_NFE_EVENTO').AsInteger;
  except on e: exception do
    begin
      erro := 'Erro na consulta: ' + e.Message;
      result := -1;
    end;
  end;
end;

function TEventoNFe.ListarEventosNFe(out erro: string): TFDQuery;
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

function TEventoNFe.ListarEventosNFePorIdNFe(out erro: string): TFDQuery;
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
        SQL.Add('SELECT ID_NFE_EVENTO, ID_NFE, DT_EVENTO, ');
        SQL.Add('STATUS_ANTES, STATUS_DEPOIS, MOTIVO ');
        SQL.Add('FROM NFE_EVENTO ');
        SQL.Add('WHERE ID_NFE = :IdNFe');

        ParamByName('IdNFe').Value := FIdNFe;

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

function TEventoNFe.ListarUltimoEventoNFePorIdNFe(out erro: string): TFDQuery;
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

        SQL.Add('SELECT ID_NFE_EVENTO, ID_NFE, DT_EVENTO, ');
        SQL.Add('STATUS_ANTES, STATUS_DEPOIS, MOTIVO ');
        SQL.Add('FROM NFE_EVENTO ');
        SQL.Add('WHERE ID_NFE_EVENTO = ');
        SQL.Add('(SELECT MAX(ID_NFE_EVENTO) ');
        SQL.Add(' FROM NFE_EVENTO WHERE ID_NFE =:IdNFe) ');

        ParamByName('IdNFe').Value := FIdNFe;

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

function TEventoNFe.InserirEventoNFe(out erro: string): boolean;
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
        SQL.Add('INSERT INTO NFE_EVENTO (ID_NFE_EVENTO, ID_NFE, DT_EVENTO, STATUS_ANTES, STATUS_DEPOIS, MOTIVO) ');
        SQL.Add('VALUES(:IdNFeEvento, :IdNFe, CURRENT_TIMESTAMP, :StatusAntes, :StatusDepois, :Motivo) ');

        ParamByName('IdNFeEvento').Value := FIdNFeEvento;
        ParamByName('IdNFe').Value := FIdNFe;
        ParamByName('StatusAntes').Value := FStatusAntes;
        ParamByName('StatusDepois').Value := FStatusDepois;
        ParamByName('Motivo').Value := FMotivo;
        ExecSQL;
        //Active := true;
      end;

    qry.Free;
  except on e: exception do
    begin
      erro := 'Erro ao inserir Evento NFe: ' + e.Message;
      result := false;
    end;
  end;
end;

end.
