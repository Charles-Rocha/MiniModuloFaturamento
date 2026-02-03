unit untConfigurarBancoDados;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IniFiles, System.ImageList, Vcl.ImgList;

type
  TfrmConfigurarBancoDados = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnSalvar: TButton;
    lblBaseDados: TLabel;
    lblUsuario: TLabel;
    edtUsuario: TEdit;
    lblSenha: TLabel;
    edtSenha: TEdit;
    edtDriverId: TEdit;
    lblDriverId: TLabel;
    edtPorta: TEdit;
    lblPorta: TLabel;
    edtServidor: TEdit;
    lblServidor: TLabel;
    edtBaseDados: TButtonedEdit;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure edtBaseDadosRightButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfigurarBancoDados: TfrmConfigurarBancoDados;

implementation

{$R *.dfm}

procedure TfrmConfigurarBancoDados.edtBaseDadosRightButtonClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      edtBaseDados.Text := OpenDialog1.FileName;
    end
  else
    begin
      exit;
    end;
end;

procedure TfrmConfigurarBancoDados.FormShow(Sender: TObject);
var
  ArqIni : TIniFile;
begin
  ArqIni := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Config\modulo_faturamento.ini');
  if not FileExists(ExtractFilePath(Application.ExeName)+'Config\modulo_faturamento.ini') then
    begin
      try
        ArqIni.WriteString('Dados', 'DriverID', '');
        ArqIni.WriteString('Dados', 'DatabaseName', '');
        ArqIni.WriteString('Dados', 'Username', '');
        ArqIni.WriteString('Dados', 'Password', '');
        ArqIni.WriteString('Dados', 'Port', '');
        ArqIni.WriteString('Dados', 'Server', '');
      finally
        ArqIni.Free;
      end;
    end
  else
    begin
      try
        edtDriverId.Text := ArqIni.ReadString('Dados', 'DriverID', 'Erro ao ler valor');
        edtBaseDados.Text := ArqIni.ReadString('Dados', 'DatabaseName', 'Erro ao ler valor');
        edtUsuario.Text := ArqIni.ReadString('Dados', 'Username', 'Erro ao ler valor');
        edtSenha.Text := ArqIni.ReadString('Dados', 'Password', 'Erro ao ler valor');
        edtPorta.Text := ArqIni.ReadString('Dados', 'Port', 'Erro ao ler valor');
        edtServidor.Text := ArqIni.ReadString('Dados', 'Server', 'Erro ao ler valor');
      finally
        ArqIni.Free;
      end;
    end;
  OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName);
end;

procedure TfrmConfigurarBancoDados.btnSalvarClick(Sender: TObject);
var
  ArqIni : TIniFile;
begin
  ArqIni := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Config\modulo_faturamento.ini');
  try
    try
      ArqIni.WriteString('Dados', 'DriverID', edtDriverId .Text);
      ArqIni.WriteString('Dados', 'DatabaseName', edtBaseDados.Text);
      ArqIni.WriteString('Dados', 'Username', edtUsuario.Text);
      ArqIni.WriteString('Dados', 'Password', edtSenha.Text);
      ArqIni.WriteString('Dados', 'Port', edtPorta.Text);
      ArqIni.WriteString('Dados', 'Server', edtServidor.Text);
      Close;
    except
      on E : Exception do
        begin
          Application.MessageBox(PChar('Erro encontrado. Verifique os dados fornecidos.' + #13#13 + E.Message),'Aviso',mb_Ok+mb_IconExclamation);
          exit;
        end;
    end;
  finally
    begin
      ArqIni.Free;
    end;
  end;
end;

end.
