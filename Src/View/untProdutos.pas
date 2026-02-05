unit untProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, untTelaBaseCRUD, Rest.Types, System.JSON, Vcl.Mask, Vcl.DBCtrls, Datasnap.DBClient;

type
  TTipoAcaoProduto = (eAdicionar, eExcluir);

type
  TfrmProdutos = class(TForm)
    pnlBotoes: TPanel;
    btnCancelar: TBitBtn;
    btnAceitar: TBitBtn;
    pnlProdutosAdicionados: TPanel;
    dbgProdutosAdicionados: TDBGrid;
    dtsProdutosAdicionados: TDataSource;
    dtsProdutos: TDataSource;
    pnlProdutos: TPanel;
    dbgProdutos: TDBGrid;
    pnlProdutosAdicionadosParaVenda: TPanel;
    lblProdutosAdicionadosParaPedido: TLabel;
    StatusBar1: TStatusBar;
    StatusBar2: TStatusBar;
    btnLimpar: TBitBtn;
    btnExcluir: TBitBtn;
    btnInserir: TBitBtn;
    cdsProdutosAdicionados: TClientDataSet;
    cdsProdutosAdicionadosCodigo: TIntegerField;
    cdsProdutosAdicionadosDescricao: TStringField;
    cdsProdutosAdicionadosValorUnitario: TCurrencyField;
    cdsProdutosAdicionadosQuantidade: TIntegerField;
    cdsProdutosAdicionadosValorTotal: TCurrencyField;
    cdsProdutosAdicionadosCodigoProduto: TIntegerField;
    Panel1: TPanel;
    lblProdutos: TLabel;
    Splitter1: TSplitter;
    procedure btnInserirClick(Sender: TObject);
    procedure btnAceitarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure CarregaProdutosAdicionadosJaGravados;
    procedure btnExcluirClick(Sender: TObject);
    procedure cdsProdutosAdicionadosValorUnitarioGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure cdsProdutosAdicionadosValorTotalGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure dbgProdutosDblClick(Sender: TObject);

  private
    { Private declarations }
    FCodigoClienteAtual: Integer;
    FValorTotalGeral: Currency;
    FProdutosExistentesAlterados: boolean;

    procedure AdicionaProdutosOuExcluiAdicionados(TipoAcaoProduto: TTipoAcaoProduto);
    procedure CarregarProdutos;
    procedure OnPrecoVendaPedidoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  public
    { Public declarations }
    property ValorTotalGeral: Currency read FValorTotalGeral write FValorTotalGeral;
    property ProdutosExistentesAlterados: boolean read FProdutosExistentesAlterados write FProdutosExistentesAlterados;
  end;

var
  frmProdutos: TfrmProdutos;

implementation

{$R *.dfm}

uses untDM, untCadastroPedido, Controller.Produto;

procedure TfrmProdutos.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmProdutos.btnExcluirClick(Sender: TObject);
begin
  if cdsProdutosAdicionadosQuantidade.AsInteger = 1 then
  begin
    cdsProdutosAdicionados.Delete;
  end;

  if cdsProdutosAdicionadosQuantidade.AsInteger > 1 then
  begin
    AdicionaProdutosOuExcluiAdicionados(eExcluir);
  end;

  if cdsProdutosAdicionados.IsEmpty then
    btnAceitar.Enabled := false;
end;

procedure TfrmProdutos.btnAceitarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmProdutos.btnInserirClick(Sender: TObject);
var
  CurrentRecord: TBookMark;
begin
  CurrentRecord := dbgProdutosAdicionados.DataSource.DataSet.GetBookmark;
  AdicionaProdutosOuExcluiAdicionados(eAdicionar);
  dbgProdutosAdicionados.DataSource.DataSet.GotoBookmark(CurrentRecord);
  dbgProdutosAdicionados.DataSource.DataSet.FreeBookmark(CurrentRecord);
end;

procedure TfrmProdutos.btnLimparClick(Sender: TObject);
begin
  cdsProdutosAdicionados.EmptyDataSet;
  btnAceitar.Enabled := false;
end;

procedure TfrmProdutos.CarregarProdutos;
var
  sErro: string;
begin
  if DM.mtProduto.Active then
    DM.mtProduto.EmptyDataSet;

  DM.mtProduto.Close;
  ListarProdutos(DM.mtProduto, sErro);
  dtsProdutos.DataSet := DM.mtProduto;
  DM.mtProduto.FieldByName('PRECO_VENDA').OnGetText := OnPrecoVendaPedidoGetText;
end;

procedure TfrmProdutos.FormShow(Sender: TObject);
begin
  CarregarProdutos;
  cdsProdutosAdicionados.LogChanges := false;
  CarregaProdutosAdicionadosJaGravados;
  cdsProdutosAdicionados.LogChanges := true;
  if not cdsProdutosAdicionados.IsEmpty then
    btnAceitar.Enabled := true;
end;

procedure TfrmProdutos.OnPrecoVendaPedidoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if not DM.mtProduto.IsEmpty then
    Text := FormatFloat('###,###,###,###,###,##0.00', Sender.AsFloat);
end;

procedure TfrmProdutos.CarregaProdutosAdicionadosJaGravados;
begin
  if cdsProdutosAdicionados.IsEmpty then
    FCodigoClienteAtual := 0;

  if frmCadastroPedido.TipoCadastro = eInserir then
  begin
    if (FCodigoClienteAtual <> DM.mtPedido.FieldByName('ID_CLIENTE').AsInteger) then //dm.cdsVendacodigocliente.AsInteger) then
    begin
      cdsProdutosAdicionados.EmptyDataSet;
      FValorTotalGeral := 0;
    end;
  end;

  if frmCadastroPedido.TipoCadastro = eEditar then
  begin
    if (FCodigoClienteAtual <> DM.mtPedido.FieldByName('ID_CLIENTE').AsInteger) then
    begin
      cdsProdutosAdicionados.EmptyDataSet;
      DM.mtPedidoItem.First;
      while not DM.mtPedidoItem.Eof do
      begin
        cdsProdutosAdicionados.Append;
        cdsProdutosAdicionadosCodigo.AsInteger := DM.mtPedidoItem.FieldByName('ID_PRODUTO').AsInteger;
        cdsProdutosAdicionadosDescricao.AsString := DM.mtPedidoItem.FieldByName('DESCRICAO').AsString;
        cdsProdutosAdicionadosValorUnitario.AsFloat := DM.mtPedidoItem.FieldByName('VL_UNITARIO').AsFloat;
        cdsProdutosAdicionadosQuantidade.AsInteger := DM.mtPedidoItem.FieldByName('QUANTIDADE').AsInteger;
        cdsProdutosAdicionadosValorTotal.AsCurrency := DM.mtPedidoItem.FieldByName('VL_TOTAL').AsFloat;
        cdsProdutosAdicionadosCodigoProduto.AsInteger := DM.mtPedidoItem.FieldByName('ID_PRODUTO').AsInteger;
        cdsProdutosAdicionados.Post;

        DM.mtPedidoItem.Next;
      end;

      cdsProdutosAdicionados.First;
    end;
  end;
  StatusBar1.Panels[0].Text := 'Total de registros: ' + IntToStr(dbgProdutos.DataSource.DataSet.RecordCount);
  StatusBar2.Panels[0].Text := 'Total de registros: ' + IntToStr(dbgProdutosAdicionados.DataSource.DataSet.RecordCount);
end;

procedure TfrmProdutos.cdsProdutosAdicionadosValorUnitarioGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if not cdsProdutosAdicionados.IsEmpty then
  begin
    if cdsProdutosAdicionadosValorUnitario.AsString <> '' then
      Text := FormatFloat('###,###,###,###,###,##0.00', cdsProdutosAdicionadosValorUnitario.AsFloat);
  end;
end;

procedure TfrmProdutos.cdsProdutosAdicionadosValorTotalGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if not cdsProdutosAdicionados.IsEmpty then
  begin
    if cdsProdutosAdicionadosValorTotal.AsString <> '' then
      Text := FormatFloat('###,###,###,###,###,##0.00', cdsProdutosAdicionadosValorTotal.AsFloat);
  end;
end;

procedure TfrmProdutos.dbgProdutosDblClick(Sender: TObject);
var
  pt: TPoint;
  gc: TGridCoord;
begin
  GetCursorPos(pt);
  with Sender as TDBGrid do
  begin
    pt := ScreenToClient(pt);
    gc := MouseCoord(pt.x, pt.y);
    if (gc.X < 0) and (gc.Y < 0) then
      exit
    else
      begin
        AdicionaProdutosOuExcluiAdicionados(eAdicionar);
      end;
  end;
end;

procedure TfrmProdutos.AdicionaProdutosOuExcluiAdicionados(TipoAcaoProduto: TTipoAcaoProduto);
var
  iQuantidade: integer;
  cValorTotal: Currency;
  bRepetido: boolean;
begin
  iQuantidade := 0;
  cValorTotal := 0;
  bRepetido := false;

  if TipoAcaoProduto = eAdicionar then
  begin
    cdsProdutosAdicionados.First;
    while not cdsProdutosAdicionados.Eof do
    begin
      if cdsProdutosAdicionadosCodigoProduto.AsInteger = DM.mtProduto.FieldByName('ID_PRODUTO').AsInteger then
      begin
        iQuantidade := iQuantidade + 1 + cdsProdutosAdicionadosQuantidade.AsInteger;
        cValorTotal := cValorTotal + cdsProdutosAdicionadosValorTotal.AsCurrency + DM.mtProduto.FieldByName('PRECO_VENDA').AsCurrency;
        FValorTotalGeral := FValorTotalGeral + DM.mtProduto.FieldByName('PRECO_VENDA').AsCurrency;

        cdsProdutosAdicionados.Edit;
        cdsProdutosAdicionadosQuantidade.AsInteger := iQuantidade;
        cdsProdutosAdicionadosValorTotal.AsCurrency := cValorTotal;
        cdsProdutosAdicionados.Post;
        btnAceitar.Enabled := true;
        bRepetido := true;
      end;

      cdsProdutosAdicionados.Next;
    end;

    if not bRepetido then
    begin
      cdsProdutosAdicionados.Append;
      cdsProdutosAdicionadosCodigo.AsInteger := DM.mtProduto.FieldByName('ID_PRODUTO').AsInteger;
      cdsProdutosAdicionadosDescricao.AsString := DM.mtProduto.FieldByName('DESCRICAO').AsString;
      cdsProdutosAdicionadosValorUnitario.AsFloat := DM.mtProduto.FieldByName('PRECO_VENDA').AsCurrency;
      cdsProdutosAdicionadosQuantidade.AsInteger := 1;
      cdsProdutosAdicionadosValorTotal.AsCurrency := DM.mtProduto.FieldByName('PRECO_VENDA').AsCurrency;
      cdsProdutosAdicionadosCodigoProduto.AsInteger := DM.mtProduto.FieldByName('ID_PRODUTO').AsInteger;
      FValorTotalGeral := FValorTotalGeral + DM.mtProduto.FieldByName('PRECO_VENDA').AsCurrency;
      cdsProdutosAdicionados.Post;
      btnAceitar.Enabled := true;
      StatusBar2.Panels[0].Text := 'Total de registros: ' + IntToStr(dbgProdutosAdicionados.DataSource.DataSet.RecordCount);
    end;
  end;

  if TipoAcaoProduto = eExcluir then
  begin
    cValorTotal := cdsProdutosAdicionadosValorTotal.AsFloat - cdsProdutosAdicionadosValorUnitario.AsFloat;
    cdsProdutosAdicionados.Edit;
    cdsProdutosAdicionadosQuantidade.AsInteger := cdsProdutosAdicionadosQuantidade.AsInteger - 1;
    cdsProdutosAdicionadosValorTotal.AsCurrency := cValorTotal;
    cdsProdutosAdicionados.Post;
    if cdsProdutosAdicionados.IsEmpty then
      btnAceitar.Enabled := false;
  end;
end;

end.
