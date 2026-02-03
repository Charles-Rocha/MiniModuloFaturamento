unit untCadastroProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, untTelaBaseCRUD, Data.DB, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.WinXCalendars;

type
  TTipoCadastro = (eInserir, eEditar, eBuscar, eNenhum);

type
  TfrmCadastroProdutos = class(TfrmTelaBaseCRUD)
    pnlCampos: TPanel;
    lblIdProduto: TLabel;
    lblCfopPadrao: TLabel;
    lblDescricao: TLabel;
    lblPrecoVenda: TLabel;
    lblNcm: TLabel;
    edtIdProduto: TEdit;
    edtDescricao: TEdit;
    edtCfopPadrao: TEdit;
    edtPrecoVenda: TEdit;
    edtNcm: TMaskEdit;
    procedure btnApagarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtPrecoVendaChange(Sender: TObject);
    procedure edtPrecoVendaClick(Sender: TObject);
  private
    { Private declarations }
    FCancelar: boolean;
    FTipoCadastro: TTipoCadastro;
    FTipoPessoaAnterior: string;

    procedure CarregarProdutos;
    procedure HabilitarControles;
    procedure DesabilitarControles;
    procedure LimparControles;
    procedure OnAfterScrollProdutos(DataSet: TDataSet);
    procedure OnNcmGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure OnPrecoVendaGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure PreencherCamposProduto;
    procedure PreencherCamposDeValores;
  public
    { Public declarations }
  end;

var
  frmCadastroProdutos: TfrmCadastroProdutos;

implementation

{$R *.dfm}

uses untDM, untUniversal, Controller.Produto;

{ TfrmCadastroProdutos }

procedure TfrmCadastroProdutos.btnApagarClick(Sender: TObject);
var
  sErro: string;
  bResultado: boolean;
begin
  Case Application.MessageBox(PChar('Tem certeza que deseja apagar o registro selecionado?'),
                                    'Aviso', MB_YesNo + MB_IconExclamation) of
  IdYes:
    begin
      try
        try
          bResultado := DeletarProduto(DM.mtProduto.FieldByName('ID_PRODUTO').AsInteger, sErro);
          if not bResultado then
            begin
              Application.MessageBox(PChar(sErro), 'Aviso', mb_Ok + mb_IconExclamation)
            end
          else
            begin
              CarregarProdutos;

              if DM.mtProduto.IsEmpty then
                LimparControles
              else
                PreencherCamposProduto;
            end;
        except
          on E : Exception do
            Application.MessageBox(PChar('Erro encontrado! ' + E.Message),'Aviso',mb_Ok+mb_IconExclamation);
        end;
      finally
        begin
          FTipoCadastro := eNenhum;
          StatusBar1.Panels[0].Text := 'Total de registros: ' + IntToStr(DM.mtProduto.RecordCount);
        end;
      end;
    end;
  IdNo:
    begin
      DesabilitarControles;
    end;
  end;
  inherited;
end;

procedure TfrmCadastroProdutos.btnCancelarClick(Sender: TObject);
begin
  inherited;
  FCancelar := true;
  DesabilitarControles;
  LimparControles;
  PreencherCamposProduto;
  FCancelar := false;
  FTipoCadastro := eNenhum;
end;

procedure TfrmCadastroProdutos.btnEditarClick(Sender: TObject);
var
  CurrentRecord: TBookMark;
begin
  inherited;
  FTipoCadastro := eEditar;
  CurrentRecord := dbgBaseCadastro.DataSource.DataSet.GetBookmark;
  HabilitarControles;
  dbgBaseCadastro.DataSource.DataSet.GotoBookmark(CurrentRecord);
  dbgBaseCadastro.DataSource.DataSet.FreeBookmark(CurrentRecord);
end;

procedure TfrmCadastroProdutos.btnGravarClick(Sender: TObject);
var
  iIdProduto: integer;
  sDescricao, sNcm, sCfopPadrao, sPrecoVenda, sErro: string;
  dPrecoVenda: double;
  bResultado: boolean;
begin
  iIdProduto := StrToInt(edtIdProduto.Text);
  sDescricao := edtDescricao.Text;
  sNcm := edtNcm.Text;
  sCfopPadrao := edtCfopPadrao.Text;
  sPrecoVenda := StringReplace(edtPrecoVenda.Text, '.', EmptyStr, [rfReplaceAll]);
  dPrecoVenda := StrToFloat(sPrecoVenda);
  bResultado := false;

  try
    if FTipoCadastro = eInserir then
      bResultado := InserirProduto(iIdProduto, sDescricao, sNcm, sCfopPadrao, dPrecoVenda, sErro);

    if FTipoCadastro = eEditar then
      bResultado := EditarProduto(iIdProduto, sDescricao, sNcm, sCfopPadrao, dPrecoVenda, sErro);

    try
      if not bResultado then
        begin
          Application.MessageBox(PChar(sErro), 'Aviso', mb_Ok + mb_IconExclamation)
        end
      else
        begin
          CarregarProdutos;

          if DM.mtProduto.IsEmpty then
            LimparControles
          else
            PreencherCamposProduto;

          DM.mtProduto.Locate('ID_PRODUTO', iIdProduto, []);
        end;
    except
      on E : Exception do
        Application.MessageBox(PChar('Erro encontrado! ' + E.Message),'Aviso',mb_Ok+mb_IconExclamation);
      end;
    finally
      if bResultado then
        begin
          DesabilitarControles;
          FTipoCadastro := eNenhum;
        end;
    end;
  if bResultado then
    inherited;
end;

procedure TfrmCadastroProdutos.btnInserirClick(Sender: TObject);
begin
  inherited;
  FTipoCadastro := eInserir;
  HabilitarControles;
  LimparControles;
  FTipoPessoaAnterior := EmptyStr;
  PreencherCamposDeValores;
end;

procedure TfrmCadastroProdutos.btnLimparClick(Sender: TObject);
begin
  inherited;
  LimparControles;
end;

procedure TfrmCadastroProdutos.CarregarProdutos;
var
  sErro: string;
begin
  if DM.mtProduto.Active then
    DM.mtProduto.EmptyDataSet;

  DM.mtProduto.Close;
  ListarProdutos(DM.mtProduto, sErro);
  dtsDBGrid.DataSet := DM.mtProduto;
  DM.mtProduto.AfterScroll := OnAfterScrollProdutos;
  DM.mtProduto.FieldByName('NCM').OnGetText := OnNcmGetText;
  DM.mtProduto.FieldByName('PRECO_VENDA').OnGetText := OnPrecoVendaGetText;
end;

procedure TfrmCadastroProdutos.DesabilitarControles;
begin
  edtDescricao.Enabled := false;
  edtNcm.Enabled := false;
  edtCfopPadrao.Enabled := false;
  edtPrecoVenda.Enabled := false;
end;

procedure TfrmCadastroProdutos.edtPrecoVendaChange(Sender: TObject);
begin
  if not FCancelar then
    begin
      edtPrecoVenda.Text := FormatarMoeda(edtPrecoVenda.Text);
      edtPrecoVenda.SelStart := Length(edtPrecoVenda.Text);
    end;
end;

procedure TfrmCadastroProdutos.edtPrecoVendaClick(Sender: TObject);
begin
  edtPrecoVenda.SelStart := Length(edtPrecoVenda.Text);
end;

procedure TfrmCadastroProdutos.FormShow(Sender: TObject);
begin
  FTipoCadastro := eNenhum;
  FCancelar := false;

  CarregarProdutos;

  if DM.mtProduto.IsEmpty then
    LimparControles
  else
    PreencherCamposProduto;

  DesabilitarControles;
  StatusBar1.Panels[0].Text := 'Total de registros: ' + IntToStr(DM.mtProduto.RecordCount);
  inherited;
end;

procedure TfrmCadastroProdutos.HabilitarControles;
begin
  edtDescricao.Enabled := true;
  edtNcm.Enabled := true;
  edtCfopPadrao.Enabled := true;
  edtPrecoVenda.Enabled := true;
  edtDescricao.SetFocus;
end;

procedure TfrmCadastroProdutos.LimparControles;
begin
  edtDescricao.Clear;
  edtNcm.Clear;
  edtCfopPadrao.Clear;
  edtPrecoVenda.Clear;
end;

procedure TfrmCadastroProdutos.OnAfterScrollProdutos(DataSet: TDataSet);
begin
  if (FTipoCadastro = eEditar) or (FTipoCadastro = eNenhum) then
    begin
      PreencherCamposProduto;
    end;
end;

procedure TfrmCadastroProdutos.OnNcmGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if not DM.mtProduto.IsEmpty then
    Text := copy(Sender.AsString, 1, 4) + '.' +
            copy(Sender.AsString, 5, 2) + '.' +
            copy(Sender.AsString, 7, 2);
end;

procedure TfrmCadastroProdutos.OnPrecoVendaGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if not DM.mtProduto.IsEmpty then
    Text := FormatFloat('###,###,###,###,###,##0.00', Sender.AsFloat);
end;

procedure TfrmCadastroProdutos.PreencherCamposDeValores;
var
  sErro: string;
begin
  edtIdProduto.Text := IntToStr(ListarCodigoUltimoProduto(sErro) + 1);
  edtPrecoVenda.Text := '0,00';
end;

procedure TfrmCadastroProdutos.PreencherCamposProduto;
begin
  if not DM.mtProduto.IsEmpty then
    begin
      edtIdProduto.Text := DM.mtProduto.FieldByName('ID_PRODUTO').AsString;
      edtDescricao.Text := DM.mtProduto.FieldByName('DESCRICAO').AsString;
      edtNcm.Text := DM.mtProduto.FieldByName('NCM').AsString;
      edtCfopPadrao.Text := DM.mtProduto.FieldByName('CFOP_PADRAO').AsString;
      edtPrecoVenda.Text := FormatFloat('#,##0.00', DM.mtProduto.FieldByName('PRECO_VENDA').AsFloat);
      StatusBar1.Panels[0].Text := 'Total de registros: ' + IntToStr(DM.mtProduto.RecordCount);
    end;
end;

end.
