unit Model.LogEvento;

interface

uses
  System.SysUtils, Data.DB, FireDAC.Comp.Client, untDM, Model.Connection, FireDAC.Stan.Param;

type
  TLogEvento = class
    private
      FIdLog: integer;
      FDataLog: string;
      FEntidade: string;
      FAcao: string;
      FMensagem: string;
      FNumeroNFe: integer;

    public
      Constructor Create;
      Destructor Destroy; override;

      property IdLog: Integer read FIdLog write FIdLog;
      property DataLog: string read FDataLog write FDataLog;
      property Entidade: string read FEntidade write FEntidade;
      property Acao: string read FAcao write FAcao;
      property Mensagem: string read FMensagem write FMensagem;
      property NumeroNFe: Integer read FNumeroNFe write FNumeroNFe;

      function ListarCodigoUltimoLogEvento(out erro: string): Integer;
      function ListarLogEventoPorIdNFe(out erro: string): TFDQuery;
      function InserirLogEvento(out erro: string): boolean;
  end;

implementation

{ TAbastecimento }

uses untPrincipal;

constructor TLogEvento.Create;
begin
  Model.Connection.Conecta;
end;

destructor TLogEvento.Destroy;
begin
  Model.Connection.Desconecta;
end;

function TLogEvento.ListarCodigoUltimoLogEvento(out erro: string): Integer;
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
        SQL.Add('SELECT MAX(ID_LOG) AS ULTIMO_ID_LOG FROM LOG_EVENTO ');

        Active := true;
        FetchAll;
      end;

    erro := EmptyStr;

    if qry.IsEmpty then
      result := 0
    else
      result := qry.FieldByName('ULTIMO_ID_LOG').AsInteger;
  except on e: exception do
    begin
      erro := 'Erro na consulta: ' + e.Message;
      result := -1;
    end;
  end;
end;

function TLogEvento.ListarLogEventoPorIdNFe(out erro: string): TFDQuery;
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
        SQL.Add('SELECT LE.DT_LOG, LE.ENTIDADE, LE.ACAO, LE.MENSAGEM ');
        SQL.Add('FROM LOG_EVENTO LE ');
        SQL.Add('WHERE 1=1');
        SQL.Add('AND LE.MENSAGEM LIKE :Mensagem');

        ParamByName('Mensagem').Value := '%' + IntToStr(FNumeroNFe) + '%';

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

function TLogEvento.InserirLogEvento(out erro: string): boolean;
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
        SQL.Add('INSERT INTO LOG_EVENTO (ID_LOG, DT_LOG, ENTIDADE, ACAO, MENSAGEM) ');
        SQL.Add('VALUES(:IdLog, CURRENT_TIMESTAMP, :Entidade, :Acao, :Mensagem) ');

        ParamByName('IdLog').Value := FIdLog;
        ParamByName('Entidade').Value := FEntidade;
        ParamByName('Acao').Value := FAcao;
        ParamByName('Mensagem').Value := FMensagem;
        ExecSQL;
        //Active := true;
      end;

    qry.Free;
  except on e: exception do
    begin
      erro := 'Erro ao inserir Log Evento: ' + e.Message;
      result := false;
    end;
  end;
end;

end.
