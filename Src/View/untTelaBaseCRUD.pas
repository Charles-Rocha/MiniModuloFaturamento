unit untTelaBaseCRUD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls, Data.DB,
  Datasnap.DBClient;

type
  TfrmTelaBaseCRUD = class(TForm)
    pnlBotoes: TPanel;
    pnlDBGrid: TPanel;
    StatusBar1: TStatusBar;
    dbgBaseCadastro: TDBGrid;
    btnInserir: TBitBtn;
    btnEditar: TBitBtn;
    btnApagar: TBitBtn;
    btnCancelar: TBitBtn;
    btnGravar: TBitBtn;
    dtsDBGrid: TDataSource;
    btnLimpar: TBitBtn;
    procedure btnInserirClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure HabilitarBotoes;
    procedure DesabilitarBotoes;
  public
    { Public declarations }
  end;

var
  frmTelaBaseCRUD: TfrmTelaBaseCRUD;

implementation

{$R *.dfm}

procedure TfrmTelaBaseCRUD.btnCancelarClick(Sender: TObject);
begin
  HabilitarBotoes;
end;

procedure TfrmTelaBaseCRUD.btnEditarClick(Sender: TObject);
begin
  DesabilitarBotoes;
end;

procedure TfrmTelaBaseCRUD.btnApagarClick(Sender: TObject);
begin
  if not dbgBaseCadastro.DataSource.DataSet.IsEmpty then
    begin
      btnEditar.Enabled := true;
      btnApagar.Enabled := true;
    end
  else
    begin
      btnEditar.Enabled := false;
      btnApagar.Enabled := false;
    end;
end;

procedure TfrmTelaBaseCRUD.btnGravarClick(Sender: TObject);
begin
  HabilitarBotoes;
end;

procedure TfrmTelaBaseCRUD.btnInserirClick(Sender: TObject);
begin
  DesabilitarBotoes;
end;

procedure TfrmTelaBaseCRUD.DesabilitarBotoes;
begin
  btnInserir.Enabled := false;
  btnEditar.Enabled := false;
  btnApagar.Enabled := false;
  btnCancelar.Enabled := true;
  btnGravar.Enabled := true;
  btnLimpar.Enabled := true;
end;

procedure TfrmTelaBaseCRUD.FormShow(Sender: TObject);
begin
  HabilitarBotoes;
end;

procedure TfrmTelaBaseCRUD.HabilitarBotoes;
begin
  btnInserir.Enabled := true;

  if dbgBaseCadastro.DataSource.DataSet.IsEmpty then
    begin
      btnEditar.Enabled := false;
      btnApagar.Enabled := false;
    end
  else
    begin
      btnEditar.Enabled := true;
      btnApagar.Enabled := true;
    end;

  btnCancelar.Enabled := false;
  btnGravar.Enabled := false;
  btnLimpar.Enabled := false;
end;

end.
