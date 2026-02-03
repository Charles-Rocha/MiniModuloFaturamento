unit Model.Connection;

interface

uses
  System.Classes, FireDAC.DApt, FireDAC.Stan.Option, FireDAC.Stan.Intf, FireDAC.UI.Intf, FireDAC.Stan.Error, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB, FireDac.Comp.Client, FireDAC.Phys.FB, FireDAC.Phys.FBDef, System.IniFiles,
  System.SysUtils, untDM;

var
  FConnection: TFDConnection;

function ConfiguraConexao(FConn: TFDConnection): string;
function Conecta: TFDConnection;
procedure Desconecta;

implementation

function ConfiguraConexao(FConn: TFDConnection): string;
var
  arqIni: string;
  Ini: TIniFile;
begin
  arqIni := 'Config\modulo_faturamento.ini';
  Ini := TIniFile.Create(arqIni);
  try
    try
      if not FileExists(arqIni) then
      begin
        result := 'Arquivo modulo_faturamento.ini não encontrado';
        exit;
      end;

      FConn.Params.Clear;
      FConn.Params.Values['DriverID'] := Ini.ReadString('Dados', 'DriverID', 'Erro ao ler valor');
      FConn.Params.Values['Database'] := Ini.ReadString('Dados', 'DatabaseName', 'Erro ao ler valor');
      FConn.Params.Values['User_Name'] := Ini.ReadString('Dados', 'Username', 'Erro ao ler valor');
      FConn.Params.Values['Password'] := Ini.ReadString('Dados', 'Password', 'Erro ao ler valor');
      FConn.Params.Values['Port'] := Ini.ReadString('Dados', 'Port', 'Erro ao ler valor');
      FConn.Params.Values['Server'] := Ini.ReadString('Dados', 'Server', 'Erro ao ler valor');
      result := 'Ok';
    except on e:exception do
      result := 'Erro ao configurar o banco de dados: ' + e.Message;
    end;
  finally
    Ini.Free;
  end;
end;

function Conecta: TFDConnection;
begin
  FConnection := TFDConnection.Create(nil);
  ConfiguraConexao(FConnection);
  FConnection.Connected := true;

  result := FConnection;
end;

procedure Desconecta;
begin
  if Assigned(FConnection) then
  begin
    if FConnection.Connected then
      FConnection.Connected := false;
  end;
end;

end.
