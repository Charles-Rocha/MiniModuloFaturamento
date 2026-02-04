unit untCadastroPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, untTelaBaseCRUD, Rest.Types, System.JSON, Vcl.Mask, Vcl.DBCtrls, FireDAC.Comp.Client, ACBrBase, ACBrDFe,
  ACBrNFe;

type
  TTipoCadastro = (eInserir, eEditar, eBuscar, eNenhum);

type
  TfrmCadastroPedido = class(TfrmTelaBaseCRUD)
    pnlCampos: TPanel;
    edtTotal: TEdit;
    lblTotal: TLabel;
    lblDataHoraEmissao: TLabel;
    lblCliente: TLabel;
    edtNumeroPedido: TEdit;
    lblNumeroPedido: TLabel;
    pnlItensPedido: TPanel;
    dbgPedidoItem: TDBGrid;
    lblStatus: TLabel;
    dbLookupComboBoxClientes: TDBLookupComboBox;
    dtsClientes: TDataSource;
    btnAdicionarProdutos: TBitBtn;
    dtsPedidoItem: TDataSource;
    stbItensPedido: TStatusBar;
    stbPedidos: TStatusBar;
    pnlItensPedidoTitulo: TPanel;
    lblItensPedido: TLabel;
    edtDataHoraEmissao: TEdit;
    Timer1: TTimer;
    ACBrNFe1: TACBrNFe;
    edtStatus: TEdit;
    pnlPedidosTitulo: TPanel;
    lblPedidos: TLabel;
    Splitter1: TSplitter;
    btnGerarNfe: TBitBtn;
    btnCancelarPedido: TBitBtn;
    btnEnviarNFe: TBitBtn;
    btnLogNFe: TBitBtn;
    lblPendenteCorrecao: TLabel;
    btnVisualizarLog: TBitBtn;

    procedure btnAdicionarProdutosClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnGerarNfeClick(Sender: TObject);
    procedure btnLogNFeClick(Sender: TObject);
    procedure btnEnviarNFeClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure btnVisualizarLogClick(Sender: TObject);
  private
    { Private declarations }
    FCancelar: boolean;
    FContador: integer;
    FProdutosAdicionados: boolean;
    FTipoCadastro: TTipoCadastro;

    procedure AlimentarComponente(NumDFe: String);
    procedure AlimentarNFe(NumDFe: String);
    procedure CarregarClientes;
    procedure CarregarEventosNFe;
    procedure CarregarLogEvento;
    procedure CarregarNFe;
    procedure CarregarPedidos;
    procedure CarregarPedidoItens;
    procedure CarregarUltimoEventoNFePorIdNFe;
    procedure ConfigurarBotoes;
    procedure CriarEntradaNfe;
    procedure CriarEventoNfe(pStatusAntes, pStatusDepois, pMotivo: string);
    procedure GerarXML;
    procedure HabilitarControles;
    procedure DesabilitarControles;
    procedure LimparControles;
    procedure OnAfterScrollPedidos(DataSet: TDataSet);
    procedure OnValorTotalPedidoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure OnValorUnitarioGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure OnValorTotalPedidoItemGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure PreencherCamposPedido;
    procedure PreencherCamposDeValores;
    function ValidarCamposObrigatorios: boolean;
  public
    { Public declarations }
    property TipoCadastro: TTipoCadastro read FTipoCadastro write FTipoCadastro;
  end;

var
  frmCadastroPedido: TfrmCadastroPedido;

implementation

{$R *.dfm}

uses untDM, untCadastroProduto, untProdutos, Controller.Pedido,
  Controller.Cliente, Controller.NFe, Controller.EventoNFe,
  ACBrUtil.Base, ACBrUtil.FilesIO, ACBrUtil.DateTime, ACBrUtil.Strings,
  ACBrUtil.XMLHTML, ACBrNFe.Classes, ACBrNFe.EnvEvento, ACBrNFe.EventoClass,
  ACBrDFe.Conversao, pcnConversao, pcnConversaoNFe, pcnNFeRTXT,
  ACBrDFeConfiguracoes, ACBrDFeSSL, ACBrDFeOpenSSL, ACBrDFeUtil,
  ACBrNFeNotasFiscais, ACBrNFeConfiguracoes, untLogEventoNFe, Controller.Sefaz, untPrincipal, Controller.LogEvento,
  untLogEvento;

procedure TfrmCadastroPedido.CarregarClientes;
var
  sErro: string;
begin
  if DM.mtCliente.Active then
    DM.mtCliente.EmptyDataSet;

  DM.mtCliente.Close;
  ListarClientes(DM.mtCliente, sErro);
  dtsClientes.DataSet := DM.mtCliente;
end;

procedure TfrmCadastroPedido.CarregarEventosNFe;
var
  sErro: string;
  iIdNFe: integer;
begin
  iIdNFe := DM.mtNFe.FieldByName('ID_NFE').AsInteger;

  if DM.mtEventoNFe.Active then
    DM.mtEventoNFe.EmptyDataSet;

  DM.mtEventoNFe.Close;
  ListarEventosNFePorIdNFe(DM.mtEventoNFe, iIdNFe, sErro);
end;

procedure TfrmCadastroPedido.CarregarLogEvento;
var
  sErro: string;
  iNumeroNFe: integer;
begin
  iNumeroNFe := DM.mtNFe.FieldByName('NUMERO').AsInteger;

  if DM.mtLogEvento.Active then
    DM.mtLogEvento.EmptyDataSet;

  DM.mtLogEvento.Close;
  ListarLogEventoPorIdNFe(DM.mtLogEvento, iNumeroNFe, sErro);
end;

procedure TfrmCadastroPedido.CarregarUltimoEventoNFePorIdNFe;
var
  sErro: string;
  iIdNFe: integer;
begin
  iIdNFe := DM.mtNFe.FieldByName('ID_NFE').AsInteger;

  if DM.mtEventoNFe.Active then
    DM.mtEventoNFe.EmptyDataSet;

  DM.mtEventoNFe.Close;
  ListarUltimoEventoNFePorIdNFe(DM.mtEventoNFe, iIdNFe, sErro);
end;

procedure TfrmCadastroPedido.ConfigurarBotoes;
begin
  if (FTipoCadastro = eEditar) or (FTipoCadastro = eNenhum) then
    begin
      if edtStatus.Text = 'Pendente' then
        btnGerarNfe.Enabled := true
      else
        btnGerarNfe.Enabled := false;

      if (edtStatus.Text = 'Confirmado') and
         ((DM.mtNFe.FieldByName('STATUS_ATUAL').AsString = 'PRONTA PARA ENVIO') or
         (DM.mtNFe.FieldByName('STATUS_ATUAL').AsString = 'REJEITADA') or
         (DM.mtNFe.FieldByName('STATUS_ATUAL').AsString = 'CONTINGENCIA')) then
        begin
          btnEnviarNFe.Enabled := true;
          btnEditar.Enabled := true;
        end
      else
        begin
          btnEnviarNFe.Enabled := false;
          btnEditar.Enabled := false;
        end;

      if DM.mtPedido.IsEmpty then
        btnLogNFe.Enabled := false
      else
        btnLogNFe.Enabled := true;

      if (edtStatus.Text = 'Faturado') and
         (DM.mtNFe.FieldByName('STATUS_ATUAL').AsString = 'AUTORIZADA') then
        btnCancelarPedido.Enabled := true
      else
        btnCancelarPedido.Enabled := false;

      if DM.mtNFe.FieldByName('CORRIGIR').AsString = 'S' then
        begin
          lblPendenteCorrecao.Visible := true;
          btnVisualizarLog.Visible := true;
          CarregarLogEvento;
        end
      else
        begin
          lblPendenteCorrecao.Visible := false;
          btnVisualizarLog.Visible := false;
        end;
    end;
end;

procedure TfrmCadastroPedido.CarregarNFe;
var
  sErro: string;
  iIdPedido: integer;
begin
  iIdPedido := StrToInt(edtNumeroPedido.Text);

  if DM.mtNFe.Active then
    DM.mtNFe.EmptyDataSet;

  DM.mtNFe.Close;
  ListarNFePorIdPedido(DM.mtNFe, iIdPedido, sErro);
end;

procedure TfrmCadastroPedido.HabilitarControles;
begin
  dbLookupComboBoxClientes.Enabled := true;
  btnAdicionarProdutos.Enabled := true;

  if FTipoCadastro = eInserir then
    begin
      btnAdicionarProdutos.Caption := 'Adicionar produtos';
      lblPendenteCorrecao.Visible := false;
      btnVisualizarLog.Visible := false;
    end;

  if FTipoCadastro = eEditar then
    begin
      btnAdicionarProdutos.Caption := 'Editar produtos';
    end;

  dbLookupComboBoxClientes.SetFocus;
end;

procedure TfrmCadastroPedido.DesabilitarControles;
begin
  dbLookupComboBoxClientes.Enabled := false;
  btnAdicionarProdutos.Enabled := false;
end;

procedure TfrmCadastroPedido.LimparControles;
begin
  dbLookupComboBoxClientes.KeyValue := -1;

  if FTipoCadastro = eInserir then
    begin
      edtDataHoraEmissao.Clear;
      btnAdicionarProdutos.Caption := 'Adicionar produtos';
    end;

  if FTipoCadastro = eEditar then
    btnAdicionarProdutos.Caption := 'Editar produtos';

  if FTipoCadastro = eNenhum then
    begin
      edtNumeroPedido.Clear;
      edtDataHoraEmissao.Clear;
      edtTotal.Clear;
      edtStatus.Clear;
    end;
end;

procedure TfrmCadastroPedido.btnCancelarClick(Sender: TObject);
begin
  inherited;
  FCancelar := true;
  FTipoCadastro := eNenhum;
  DesabilitarControles;
  LimparControles;
  PreencherCamposPedido;
  FCancelar := false;
  ConfigurarBotoes;
end;

procedure TfrmCadastroPedido.btnCancelarPedidoClick(Sender: TObject);
var
  sErro, sValorTotalPedido, sChaveAcesso, sStatusAntes, sCNPJ, sResultado, sMensagemRetorno: string;
  iIdNFe, iSerie, iNumero, iIdPedido, iIdCliente, iIdLog: integer;
  dValorTotalPedido: double;
begin
  iIdPedido := StrToInt(edtNumeroPedido.Text);
  iIdCliente := dbLookupComboBoxClientes.KeyValue;
  sValorTotalPedido := StringReplace(edtTotal.Text, '.', EmptyStr, [rfReplaceAll]);
  dValorTotalPedido := StrToFloat(sValorTotalPedido);
  sCNPJ := '36729378000178';

  CarregarUltimoEventoNFePorIdNFe;
  sStatusAntes := DM.mtEventoNFe.FieldByName('STATUS_DEPOIS').AsString;
  iIdNFe := DM.mtNFe.FieldByName('ID_NFE').AsInteger;
  iSerie := DM.mtNFe.FieldByName('SERIE').AsInteger;
  iNumero := DM.mtNFe.FieldByName('NUMERO').AsInteger;
  sChaveAcesso := DM.mtNFe.FieldByName('CHAVE_ACESSO').AsString;

  try
    with frmMiniModuloFaturamento do
      begin
        sResultado := Sefaz.CancelarNFe(333,
          ExtractFilePath(Application.ExeName)+'Docs\' + sChaveAcesso + '-nfe.xml',
          sChaveAcesso, 'Pedido de Cancelamento por parte do Cliente', sCNPJ);
      end;

    sMensagemRetorno := copy(sResultado, pos(';', sResultado)+1, length(sResultado));
    sResultado := copy(sResultado, 1, pos(';', sResultado)-1);

    if sResultado = 'HOMOLOGADO' then
      begin
        EditarPedido(iIdPedido, iIdCliente, dValorTotalPedido, 'Cancelado', sErro);
        EditarNFe(iIdNFe, iIdPedido, iSerie, iNumero, 'CANCELADA', sChaveAcesso, 'N', sErro);
        CriarEventoNfe(sStatusAntes, 'CANCELADA', 'CANCELAMENTO DE NFE');
        CarregarPedidos;
        CarregarPedidoItens;
        DM.mtPedido.Locate('ID_PEDIDO', iIdPedido, []);
        DM.mtPedidoItem.Locate('ID_PEDIDO', iIdPedido, []);
      end;

    Application.MessageBox(PChar('Pedido de cancelamento da NFe Nro ' + IntToStr(iIdNFe) +
                           ' enviada com sucesso para o SEFAZ.' +#13+#13+
                           'Status de retorno da NFe: ' + sResultado + #13+#13+
                           sMensagemRetorno),'Aviso', mb_Ok+mb_IconExclamation);
  except
  on E : Exception do
    begin
      Application.MessageBox(PChar('Erro encontrado! ' + E.Message),'Aviso',mb_Ok+mb_IconExclamation);
      iIdLog := ListarCodigoUltimoLogEvento(sErro) + 1;
      InserirLogEvento(iIdLog, 'TfrmCadastroPedido', 'CANCELAMENTO DE NFE', E.Message, sErro);
    end;
  end;
end;

procedure TfrmCadastroPedido.btnGerarNfeClick(Sender: TObject);
var
  sAux, sValorTotalPedido, sChaveAcesso, sErro: string;
  iIdPedido, iIdCliente, iIdNFe, iSerie, iNumero, iIdLog: integer;
  dValorTotalPedido: double;
begin
  sAux := EmptyStr;
  iIdPedido := StrToInt(edtNumeroPedido.Text);
  iIdCliente := dbLookupComboBoxClientes.KeyValue;
  sValorTotalPedido := StringReplace(edtTotal.Text, '.', EmptyStr, [rfReplaceAll]);
  dValorTotalPedido := StrToFloat(sValorTotalPedido);
  iIdNFe := ListarIdNFePorIdPedido(iIdPedido, sErro);

  if not(InputQuery('WebServices Enviar', 'Numero da Nota', sAux)) then
    exit;

  try
    ACBrNFe1.NotasFiscais.Clear;
    AlimentarComponente(sAux);
    //ACBrNFe1.NotasFiscais.Assinar;
    ACBrNFe1.NotasFiscais.GerarNFe;
    ACBrNFe1.NotasFiscais.Items[0].GravarXML();

    sChaveAcesso := ACBrNFe1.NotasFiscais.Items[0].NumID;
    iSerie := ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.serie;
    iNumero := ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.nNF;
    EditarPedido(iIdPedido, iIdCliente, dValorTotalPedido, 'Confirmado', sErro);
    EditarNFe(iIdNFe, iIdPedido, iSerie, iNumero, 'PRONTA PARA ENVIO', sChaveAcesso, 'N', sErro);
    CriarEventoNfe('RASCUNHO', 'PRONTA PARA ENVIO', 'GERAÇÃO DE NFE');
    CarregarPedidos;
    CarregarPedidoItens;

    DM.mtPedido.Locate('ID_PEDIDO', iIdPedido, []);
    DM.mtPedidoItem.Locate('ID_PEDIDO', iIdPedido, []);
    Application.MessageBox(PChar('NFe gerada com sucesso no caminho abaixo:' +#13+#13+
                           ACBrNFe1.NotasFiscais.Items[0].NomeArq),'Aviso', mb_Ok+mb_IconExclamation);
  except
  on E : Exception do
    begin
      Application.MessageBox(PChar('Erro encontrado! ' + E.Message),'Aviso',mb_Ok+mb_IconExclamation);
      iIdLog := ListarCodigoUltimoLogEvento(sErro) + 1;
      InserirLogEvento(iIdLog, 'TfrmCadastroPedido', 'GERAÇÃO DE NFE', E.Message, sErro);
    end;
  end;
end;

procedure TfrmCadastroPedido.AlimentarComponente(NumDFe: String);
begin
  ACBrNFe1.NotasFiscais.Clear;

  if ACBrNFe1.Configuracoes.Geral.ModeloDF = moNFe then
    AlimentarNFe(NumDFe);
  //else
    //AlimentarNFCe(NumDFe);
end;

procedure TfrmCadastroPedido.btnGravarClick(Sender: TObject);
var
  bResultado: boolean;
  sValorTotalItem, sValorTotalPedido, sStatus, sErro: string;
  dValorTotalItem, dValorTotalPedido, dValorUnitario: double;
  iIdPedido, iIdCliente, iIdPedidoItem, iIdProduto, iQuantidade: integer;
  lstNFe: TStringList;
begin
  if not ValidarCamposObrigatorios then
    exit;

  iIdPedido := StrToInt(edtNumeroPedido.Text);
  iIdCliente := dbLookupComboBoxClientes.KeyValue;
  sValorTotalPedido := StringReplace(edtTotal.Text, '.', EmptyStr, [rfReplaceAll]);
  dValorTotalPedido := StrToFloat(sValorTotalPedido);
  sStatus := edtStatus.Text;
  lstNFe := TStringList.Create;
  bResultado := false;

  try
    if FTipoCadastro = eEditar then
      begin
        if FProdutosAdicionados then
          begin
            iIdPedido := StrToInt(edtNumeroPedido.Text);
            bResultado := DeletarPedidoItemPorIdPedido(iIdPedido, sErro);
          end;
      end;

    if FProdutosAdicionados then
      begin
        with frmProdutos do
          begin
            dValorTotalPedido := 0;
            dbgProdutosAdicionados.DataSource.DataSet.DisableControls;
            cdsProdutosAdicionados.First;
            while not cdsProdutosAdicionados.Eof do
              begin
                iIdPedidoItem := ListarCodigoUltimoPedidoItem(sErro) + 1;
                iIdProduto := frmProdutos.cdsProdutosAdicionadosCodigo.AsInteger;
                iQuantidade := frmProdutos.cdsProdutosAdicionadosQuantidade.AsInteger;
                dValorUnitario := frmProdutos.cdsProdutosAdicionadosValorUnitario.AsFloat;
                sValorTotalItem := StringReplace(frmProdutos.cdsProdutosAdicionadosValorTotal.AsString, '.', EmptyStr, [rfReplaceAll]);
                dValorTotalItem := StrToFloat(sValorTotalItem);
                dValorTotalPedido := dValorTotalPedido + dValorTotalItem;

                bResultado := InserirPedidoItem(iIdPedidoItem, iIdPedido, iIdProduto, iQuantidade,
                                                dValorUnitario, dValorTotalItem, sErro);
                cdsProdutosAdicionados.Next;
              end;
          end;
      end;

    if FTipoCadastro = eInserir then
      begin
        bResultado := InserirPedido(iIdPedido, iIdCliente, dValorTotalPedido, 'Pendente', sErro);
        if bResultado then
          begin
            CriarEntradaNfe;
            CriarEventoNfe('INEXISTENTE', 'RASCUNHO', 'REGISTRO DE NFE');
          end;
      end;

    if FTipoCadastro = eEditar then
      begin
        iIdPedido := StrToInt(edtNumeroPedido.Text);
        bResultado := EditarPedido(iIdPedido, iIdCliente, dValorTotalPedido, sStatus, sErro);
      end;

    try
      if not bResultado then
        begin
          Application.MessageBox(PChar(sErro), 'Aviso', mb_Ok + mb_IconExclamation)
        end
      else
        begin
          CarregarPedidos;
          DM.mtPedido.Locate('ID_PEDIDO', iIdPedido, []);
          CarregarPedidoItens;
          DM.mtPedidoItem.Locate('ID_PEDIDO', iIdPedido, []);

          if DM.mtPedido.IsEmpty then
            LimparControles
          else
            PreencherCamposPedido;

          FProdutosAdicionados := false;
        end;
    except
      on E : Exception do
        Application.MessageBox(PChar('Erro encontrado! ' + E.Message),'Aviso',mb_Ok+mb_IconExclamation);
      end;
    finally
      if bResultado then
        begin
          DesabilitarControles;

          if FTipoCadastro = eEditar then
            begin
              if not DM.mtPedidoItem.IsEmpty then
                GerarXML;
            end;
          FTipoCadastro := eNenhum;
          frmProdutos.dbgProdutosAdicionados.DataSource.DataSet.EnableControls;
        end;
      lstNFe.Free;
      StatusBar1.Panels[0].Text := 'Total de registros: ' + IntToStr(DM.mtPedido.RecordCount);
    end;
  if bResultado then
    inherited;
end;

procedure TfrmCadastroPedido.btnApagarClick(Sender: TObject);
var
  sErro: string;
  bResultado: boolean;
  iIdPedido, IdNFe: integer;
begin
  Case Application.MessageBox(PChar('Tem certeza que deseja apagar o registro selecionado?'),
                                    'Aviso', MB_YesNo + MB_IconExclamation) of
  IdYes:
    begin
      try
        try
          iIdPedido := DM.mtPedido.FieldByName('ID_PEDIDO').AsInteger;
          IdNFe := ListarIdNFePorIdPedido(iIdPedido, sErro);

          bResultado := DeletarPedido(iIdPedido, sErro);
          if not bResultado then
            begin
              Application.MessageBox(PChar(sErro), 'Aviso', mb_Ok + mb_IconExclamation)
            end;

          bResultado := DeletarPedidoItemPorIdPedido(iIdPedido, sErro);
          if not bResultado then
            begin
              Application.MessageBox(PChar(sErro), 'Aviso', mb_Ok + mb_IconExclamation)
            end;

          bResultado := DeletarNFe(IdNFe, sErro);
          if not bResultado then
            begin
              Application.MessageBox(PChar(sErro), 'Aviso', mb_Ok + mb_IconExclamation)
            end;

          CarregarPedidos;
          CarregarPedidoItens;

          if DM.mtPedido.IsEmpty then
            LimparControles
          else
            PreencherCamposPedido;
        except
          on E : Exception do
            Application.MessageBox(PChar('Erro encontrado! ' + E.Message),'Aviso',mb_Ok+mb_IconExclamation);
        end;
      finally
        begin
          FTipoCadastro := eNenhum;
          stbPedidos.Panels[0].Text := 'Total de registros: ' + IntToStr(dbgBaseCadastro.DataSource.DataSet.RecordCount);
          stbItensPedido.Panels[0].Text := 'Total de registros: ' + IntToStr(dbgPedidoItem.DataSource.DataSet.RecordCount);
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

procedure TfrmCadastroPedido.btnInserirClick(Sender: TObject);
begin
  if DM.mtCliente.IsEmpty then
  begin
    Application.MessageBox('Ainda não há clientes cadastrados ' + #13 +
                           'Cadastre clientes para realizar um pedido', 'Aviso', mb_Ok + mb_IconExclamation);
    exit;
  end;

  inherited;
  FTipoCadastro := eInserir;
  HabilitarControles;
  LimparControles;
  PreencherCamposDeValores;
end;

procedure TfrmCadastroPedido.btnLimparClick(Sender: TObject);
begin
  inherited;
  LimparControles;
end;

procedure TfrmCadastroPedido.btnLogNFeClick(Sender: TObject);
begin
  CarregarEventosNFe;
  frmLogEventoNFe.ShowModal;
end;

procedure TfrmCadastroPedido.btnVisualizarLogClick(Sender: TObject);
begin
  frmLogEvento.ShowModal;
end;

procedure TfrmCadastroPedido.btnEditarClick(Sender: TObject);
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

procedure TfrmCadastroPedido.btnEnviarNFeClick(Sender: TObject);
var
  sChaveAcesso, sResultado, sCpfCnpj, sTipoPessoa, sNomeCliente, sErro: string;
  sNcm, sCfop, sDescricaoProduto, sValorTotalPedido, sStatusAntes, sMensagemRetorno: string;
  iIdNFe, iSerie, iNumero, iIdPedido, iIdCliente, iIdLog: integer;
  dValorTotalPedido: double;
  CurrentRecord: TBookMark;
begin
  if DM.mtNFe.FieldByName('CORRIGIR').AsString = 'S' then
    begin
      GerarXML;
    end;

  CarregarNFe;
  sCpfCnpj := DM.mtCliente.FieldByName('CPF_CNPJ').AsString;
  sTipoPessoa := DM.mtCliente.FieldByName('TIPO_PESSOA').AsString;
  sNomeCliente := DM.mtCliente.FieldByName('NOME_RAZAO').AsString;
  CurrentRecord := dbgPedidoItem.DataSource.DataSet.GetBookmark;

  iIdPedido := StrToInt(edtNumeroPedido.Text);
  iIdCliente := dbLookupComboBoxClientes.KeyValue;
  sValorTotalPedido := StringReplace(edtTotal.Text, '.', EmptyStr, [rfReplaceAll]);
  dValorTotalPedido := StrToFloat(sValorTotalPedido);
  iIdNFe := ListarIdNFePorIdPedido(iIdPedido, sErro);
  iSerie := DM.mtNFe.FieldByName('SERIE').AsInteger;
  iNumero := DM.mtNFe.FieldByName('NUMERO').AsInteger;
  sChaveAcesso := DM.mtNFe.FieldByName('CHAVE_ACESSO').AsString;

  if sCpfCnpj = EmptyStr then
    begin
      if sTipoPessoa = 'F' then
        begin
          Application.MessageBox(PChar('Não é permitido enviar uma NFe sem CPF.' +#13+#13+
                                       'Preencha o CPF para o cliente ' + sNomeCliente + ' na tela de Cadastro de Cliente'),'Aviso',mb_Ok+mb_IconExclamation);
          exit;
        end;

      if sTipoPessoa = 'J' then
        begin
          Application.MessageBox(PChar('Não é permitido enviar uma NFe sem CNPJ.' +#13+#13+
                                       'Preencha o CNPJ para o cliente ' + sNomeCliente + ' na tela de Cadastro de Cliente'),'Aviso',mb_Ok+mb_IconExclamation);
          exit;
        end;
    end;

  try
    try
      dbgPedidoItem.DataSource.DataSet.DisableControls;
      DM.mtPedidoItem.First;
      while not DM.mtPedidoItem.Eof do
        begin
          sDescricaoProduto := DM.mtPedidoItem.FieldByName('DESCRICAO').AsString;
          sNcm := DM.mtPedidoItem.FieldByName('NCM').AsString;
          sCfop := DM.mtPedidoItem.FieldByName('CFOP_PADRAO').AsString;

          if sNcm = EmptyStr then
            begin
              Application.MessageBox(PChar('Não é permitido enviar uma NFe sem o código NCM do Produto. ' +
                                           'Preencha na tela de Cadastro de Produto o código NCM do item:' +#13+#13+
                                           sDescricaoProduto), 'Aviso',mb_Ok+mb_IconExclamation);
              exit;
            end;

          if sCfop = EmptyStr then
            begin
              Application.MessageBox(PChar('Não é permitido enviar uma NFe sem o código CFOP do Produto. ' +
                                           'Preencha na tela de Cadastro de Produto o código CFOP do item:' +#13+#13+
                                           sDescricaoProduto), 'Aviso',mb_Ok+mb_IconExclamation);
              exit;
            end;
          DM.mtPedidoItem.Next;
        end;

      CarregarUltimoEventoNFePorIdNFe;
      sStatusAntes := DM.mtEventoNFe.FieldByName('STATUS_DEPOIS').AsString;
      EditarNFe(iIdNFe, iIdPedido, iSerie, iNumero, 'ENVIADA', sChaveAcesso, 'N', sErro);
      CriarEventoNfe(sStatusAntes, 'ENVIADA', 'ENVIO DA NFE PARA O SEFAZ');
      CarregarUltimoEventoNFePorIdNFe;
      sStatusAntes := DM.mtEventoNFe.FieldByName('STATUS_DEPOIS').AsString;

      with frmMiniModuloFaturamento do
        begin
          Sefaz.TipoPessoa := sTipoPessoa;
          Sefaz.Externo := False;
          sResultado := Sefaz.SefazRecebeEValidaXML(ExtractFilePath(Application.ExeName)+'Docs\' + sChaveAcesso + '-nfe.xml');
          sMensagemRetorno := copy(sResultado, pos(';', sResultado)+1, length(sResultado));
          sResultado := copy(sResultado, 1, pos(';', sResultado)-1);

          if sResultado = 'AUTORIZADA' then
            begin
              EditarPedido(iIdPedido, iIdCliente, dValorTotalPedido, 'Faturado', sErro);
              EditarNFe(iIdNFe, iIdPedido, iSerie, iNumero, sResultado, sChaveAcesso, 'N', sErro);
              CriarEventoNfe(sStatusAntes, sResultado, 'AUTORIZAÇÃO DE NFE');
            end;

          if sResultado = 'REJEITADA' then
            begin
              //Marcar que precisa de correção ('S')
              EditarNFe(iIdNFe, iIdPedido, iSerie, iNumero, sResultado, sChaveAcesso, 'S', sErro);
              CriarEventoNfe(sStatusAntes, sResultado, 'REJEIÇÃO DE NFE');
            end;

          if sResultado = 'CONTINGENCIA' then
            begin
              EditarNFe(iIdNFe, iIdPedido, iSerie, iNumero, sResultado, sChaveAcesso, 'N', sErro);
              CriarEventoNfe(sStatusAntes, sResultado, 'NFE EM CONTINGÊNCIA');
            end;

          CarregarPedidos;
          CarregarPedidoItens;
          DM.mtPedido.Locate('ID_PEDIDO', iIdPedido, []);
          DM.mtPedidoItem.Locate('ID_PEDIDO', iIdPedido, []);
        end;

      Application.MessageBox(PChar('NFe Nro ' + IntToStr(iIdNFe) + ' enviada com sucesso para o SEFAZ.' +#13+
                             'Status de retorno da NFe: ' + sResultado +#13+#13+
                             sMensagemRetorno),'Aviso', mb_Ok+mb_IconExclamation);
    except
    on E : Exception do
      begin
        Application.MessageBox(PChar('Erro encontrado! ' + E.Message),'Aviso',mb_Ok+mb_IconExclamation);
        iIdLog := ListarCodigoUltimoLogEvento(sErro) + 1;
        InserirLogEvento(iIdLog, 'TfrmCadastroPedido', 'ENVIO DE NFE PARA O SEFAZ', E.Message, sErro);
      end;
    end;
  finally
    dbgPedidoItem.DataSource.DataSet.GotoBookmark(CurrentRecord);
    dbgPedidoItem.DataSource.DataSet.FreeBookmark(CurrentRecord);
    dbgPedidoItem.DataSource.DataSet.EnableControls;
  end;
end;

procedure TfrmCadastroPedido.CarregarPedidoItens;
var
  sErro: string;
  iIdPedido: integer;
begin
  if DM.mtPedidoItem.Active then
    DM.mtPedidoItem.EmptyDataSet;

  DM.mtPedidoItem.Close;
  iIdPedido := DM.mtPedido.FieldByName('ID_PEDIDO').AsInteger;
  ListarPedidoItemPorIdPedido(DM.mtPedidoItem, iIdPedido, sErro);
  dtsPedidoItem.DataSet := DM.mtPedidoItem;
  DM.mtPedidoItem.FieldByName('VL_UNITARIO').OnGetText := OnValorUnitarioGetText;
  DM.mtPedidoItem.FieldByName('VL_TOTAL').OnGetText := OnValorTotalPedidoItemGetText;
  stbItensPedido.Panels[0].Text := 'Total de registros: ' + IntToStr(dbgPedidoItem.DataSource.DataSet.RecordCount);
end;

procedure TfrmCadastroPedido.CarregarPedidos;
var
  sErro: string;
  CurrentRecord: TBookMark;
begin
  if DM.mtPedido.Active then
    DM.mtPedido.EmptyDataSet;

  DM.mtPedido.Close;
  ListarPedidos(DM.mtPedido, sErro);
  dtsDBGrid.DataSet := DM.mtPedido;

  CurrentRecord := dbgBaseCadastro.DataSource.DataSet.GetBookmark;

  DM.mtPedido.AfterScroll := OnAfterScrollPedidos;
  DM.mtPedido.FieldByName('TOTAL').OnGetText := OnValorTotalPedidoGetText;

  if DM.mtPedido.IsEmpty then
    begin
      btnGerarNfe.Enabled := false;
      btnEnviarNFe.Enabled := false;
      btnLogNFe.Enabled := false;
    end;

  dbgBaseCadastro.DataSource.DataSet.GotoBookmark(CurrentRecord);
  dbgBaseCadastro.DataSource.DataSet.FreeBookmark(CurrentRecord);
end;

procedure TfrmCadastroPedido.CriarEntradaNfe;
var
  sErro: string;
  iIdPedido, iIdNFe: integer;
begin
  iIdPedido := StrToInt(edtNumeroPedido.Text);
  iIdNFe := ListarCodigoUltimaNFe(sErro) + 1;
  InserirNFe(iIdNFe, iIdPedido, 0, 0, 'RASCUNHO', EmptyStr, 'N', sErro);
end;

procedure TfrmCadastroPedido.CriarEventoNfe(pStatusAntes, pStatusDepois, pMotivo: string);
var
  sErro: string;
  iIdNFeEvento, iIdNFe, iIdPedido: integer;
begin
  iIdNFeEvento := ListarCodigoUltimoEventoNFe(sErro) + 1;
  iIdPedido := StrToInt(edtNumeroPedido.Text);
  iIdNFe := ListarIdNFePorIdPedido(iIdPedido, sErro);
  InserirEventoNfe(iIdNFeEvento, iIdNFe, pStatusAntes, pStatusDepois, pMotivo, sErro);
end;

procedure TfrmCadastroPedido.FormShow(Sender: TObject);
begin
  FTipoCadastro := eNenhum;
  FContador := 0;
  FCancelar := false;
  FProdutosAdicionados := false;

  CarregarPedidos;
  CarregarPedidoItens;
  CarregarClientes;

  if DM.mtPedido.IsEmpty then
    LimparControles
  else
    PreencherCamposPedido;

  DesabilitarControles;
  stbPedidos.Panels[0].Text := 'Total de registros: ' + IntToStr(DM.mtPedido.RecordCount);
  inherited;
  ConfigurarBotoes;
end;

procedure TfrmCadastroPedido.GerarXML;
var
  sChaveAcesso, sNumDFe, sStatusAtual, sNovaChaveAcesso, sArquivoXmlAntigo, sErro: string;
  iIdNFe, iSerie, iNumero, iIdPedido: integer;
  lstNFe: TStringList;
begin
  lstNFe := TStringList.Create;
  try
    try
      iIdPedido := StrToInt(edtNumeroPedido.Text);
      sChaveAcesso := DM.mtNFe.FieldByName('CHAVE_ACESSO').AsString;
      sNumDFe := DM.mtNFe.FieldByName('NUMERO').AsString;
      if sChaveAcesso <> EmptyStr then
        begin
          iIdNFe := DM.mtNFe.FieldByName('ID_NFE').AsInteger;
          iSerie := DM.mtNFe.FieldByName('SERIE').AsInteger;
          iNumero := DM.mtNFe.FieldByName('NUMERO').AsInteger;
          sStatusAtual := DM.mtNFe.FieldByName('STATUS_ATUAL').AsString;

          ACBrNFe1.NotasFiscais.Clear;
          AlimentarComponente(sNumDFe);
          lstNFe.Text := ACBrNFe1.NotasFiscais.Items[0].GerarXML;
          sNovaChaveAcesso := ACBrNFe1.NotasFiscais.Items[0].NFe.infNFe.ID;
          sNovaChaveAcesso := copy(sNovaChaveAcesso, 4, 44);
          EditarNFe(iIdNFe, iIdPedido, iSerie, iNumero, sStatusAtual, sNovaChaveAcesso, 'N', sErro);
          sArquivoXmlAntigo := ExtractFilePath(Application.ExeName)+'Docs\' + sChaveAcesso + '-nfe.xml';
          if FileExists(sArquivoXmlAntigo) then
          begin
            if not DeleteFile(sArquivoXmlAntigo) then
              Application.MessageBox(PChar('Erro ao deletar o arquivo abaixo, pode estar em uso:' +#13+#13+
              sArquivoXmlAntigo),'Aviso',mb_Ok+mb_IconExclamation);
          end;
          lstNFe.SaveToFile(ExtractFilePath(Application.ExeName)+'Docs\' + sNovaChaveAcesso + '-nfe.xml');
        end;
    except
    on E : Exception do
      begin
        Application.MessageBox(PChar('Erro encontrado! ' + E.Message),'Aviso',mb_Ok+mb_IconExclamation);
      end;
    end;
  finally
    lstNFe.Free;
  end;
end;

procedure TfrmCadastroPedido.OnAfterScrollPedidos(DataSet: TDataSet);
begin
  if (FTipoCadastro = eEditar) or (FTipoCadastro = eNenhum) then
    begin
      PreencherCamposPedido;
      CarregarPedidoItens;
      CarregarNFe;
      ConfigurarBotoes;
    end;
end;

procedure TfrmCadastroPedido.OnValorTotalPedidoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if not DM.mtPedido.IsEmpty then
    Text := FormatFloat('###,###,###,###,###,##0.00', Sender.AsFloat);
end;

procedure TfrmCadastroPedido.OnValorTotalPedidoItemGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if not DM.mtPedidoItem.IsEmpty then
    Text := FormatFloat('###,###,###,###,###,##0.00', Sender.AsFloat);
end;

procedure TfrmCadastroPedido.OnValorUnitarioGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if not DM.mtPedidoItem.IsEmpty then
    Text := FormatFloat('###,###,###,###,###,##0.00', Sender.AsFloat);
end;

procedure TfrmCadastroPedido.PreencherCamposPedido;
begin
  if not DM.mtPedido.IsEmpty then
    begin
      edtNumeroPedido.Text := DM.mtPedido.FieldByName('ID_PEDIDO').AsString;
      dbLookupComboBoxClientes.KeyValue := DM.mtPedido.FieldByName('ID_CLIENTE').AsInteger;
      edtDataHoraEmissao.Text := DM.mtPedido.FieldByName('DT_EMISSAO').AsString;
      edtTotal.Text := FormatFloat('#,##0.00', DM.mtPedido.FieldByName('TOTAL').AsFloat);;
      edtStatus.Text := DM.mtPedido.FieldByName('STATUS').AsString;
      stbPedidos.Panels[0].Text := 'Total de registros: ' + IntToStr(dbgBaseCadastro.DataSource.DataSet.RecordCount);
    end;
end;

procedure TfrmCadastroPedido.PreencherCamposDeValores;
var
  sErro: string;
begin
  edtNumeroPedido.Text := IntToStr(ListarCodigoUltimoPedido(sErro) + 1);
  edtTotal.Text := '0,0000';
end;

procedure TfrmCadastroPedido.Timer1Timer(Sender: TObject);
begin
  if FContador = 5 then
    begin
      Timer1.Enabled := false;
      btnAdicionarProdutos.Visible := true;
      FContador := 0;
      exit;
    end;

  btnAdicionarProdutos.Visible := not btnAdicionarProdutos.Visible;
  FContador := FContador + 1;
end;

procedure TfrmCadastroPedido.btnAdicionarProdutosClick(Sender: TObject);
begin
  FProdutosAdicionados := true;
  frmProdutos.ShowModal;
end;

function TfrmCadastroPedido.ValidarCamposObrigatorios: boolean;
begin
  result := true;
  if dbLookupComboBoxClientes.KeyValue = -1 then
    begin
      Application.MessageBox('É necessário selecionar um cliente para concluir essa operação', 'Aviso', mb_Ok + mb_IconExclamation);
      result := false;
      dbLookupComboBoxClientes.SetFocus;
      exit;
    end;

  if (FTipoCadastro = eInserir) and (frmProdutos.cdsProdutosAdicionados.IsEmpty) then
    begin
      Application.MessageBox('É necessário adicionar produtos para concluir essa operação', 'Aviso', mb_Ok + mb_IconExclamation);
      result := false;
      btnAdicionarProdutos.Visible := false;
      Timer1.Enabled := true;
      exit;
    end;
end;

procedure TfrmCadastroPedido.AlimentarNFe(NumDFe: String);
var
  Ok: Boolean;
  NotaF: NotaFiscal;
  Produto: TDetCollectionItem;
//    Servico: TDetCollectionItem;
  Volume: TVolCollectionItem;
  Duplicata: TDupCollectionItem;
  ObsComplementar: TobsContCollectionItem;
  ObsFisco: TobsFiscoCollectionItem;
//    Referenciada: TNFrefCollectionItem;
//    DI: TDICollectionItem;
//    Adicao: TAdiCollectionItem;
//    Rastro: TrastroCollectionItem;
//    Medicamento: TMedCollectionItem;
//    Arma: TArmaCollectionItem;
//    Reboque: TreboqueCollectionItem;
//    Lacre: TLacresCollectionItem;
//    ProcReferenciado: TprocRefCollectionItem;
//  Agropecuario: Tagropecuario;
//  Defensivo: TdefensivoCollectionItem;
  InfoPgto: TpagCollectionItem;
  iContador: integer;
begin
  iContador := 0;
  NotaF := ACBrNFe1.NotasFiscais.Add;
  NotaF.NFe.Ide.natOp     := 'VENDA PRODUCAO DO ESTAB.';
  NotaF.NFe.Ide.indPag    := ipVista;
  NotaF.NFe.Ide.modelo    := 55;
  NotaF.NFe.Ide.serie     := 1;
  NotaF.NFe.Ide.nNF       := StrToInt(NumDFe);
  NotaF.NFe.Ide.cNF       := GerarCodigoDFe(NotaF.NFe.Ide.nNF);
  NotaF.NFe.Ide.dEmi      := Date;
  NotaF.NFe.Ide.dSaiEnt   := Date;
  NotaF.NFe.Ide.hSaiEnt   := Now;

  // Reforma Tributária
  //if rgReformaTributaria.ItemIndex = 0 then
    //NotaF.NFe.Ide.dPrevEntrega := Date + 10;

  NotaF.NFe.Ide.tpNF      := tnSaida;
  NotaF.NFe.Ide.tpEmis    := TpcnTipoEmissao(teNormal); //cbFormaEmissao.ItemIndex Exemplos: teContingencia

  NotaF.NFe.Ide.tpAmb     := ACBrNFe1.Configuracoes.WebServices.Ambiente;
  NotaF.NFe.Ide.verProc   := '1.0.0.0'; //Versão do seu sistema
  NotaF.NFe.Ide.cUF       := UFtoCUF(DM.mtCliente.FieldByName('UF').AsString); //edtEmitUF.Text
  NotaF.NFe.Ide.cMunFG    := StrToInt('33'); //edtEmitCodCidade.Text
  NotaF.NFe.Ide.finNFe    := fnNormal;
  if  Assigned( ACBrNFe1.DANFE ) then
    NotaF.NFe.Ide.tpImp     := ACBrNFe1.DANFE.TipoDANFE;

//  NotaF.NFe.Ide.dhCont := date;
//  NotaF.NFe.Ide.xJust  := 'Justificativa Contingencia';

  {
    valores aceitos pelo campo:
    iiSemOperacao, iiOperacaoSemIntermediador, iiOperacaoComIntermediador
  }
  // Indicador de intermediador/marketplace
  NotaF.NFe.Ide.indIntermed := iiSemOperacao;

  // Reforma Tributária
  {if rgReformaTributaria.ItemIndex = 0 then
  begin
    NotaF.NFe.Ide.cMunFGIBS := StrToInt(edtEmitCodCidade.Text);

    NotaF.NFe.Ide.tpNFDebito := tdNenhum;
    NotaF.NFe.Ide.tpNFCredito := tcNenhum;

    NotaF.NFe.Ide.gCompraGov.tpEnteGov := tcgEstados;
    NotaF.NFe.Ide.gCompraGov.pRedutor := 5;
    NotaF.NFe.Ide.gCompraGov.tpOperGov := togFornecimento;

//    Informado para abater as parcelas de antecipação de pagamento, conforme Art. 10. § 4º
//    refNFe: Referência uma NF-e (modelo 55) emitida anteriormente, referente a pagamento antecipado

    with NotaF.NFe.Ide.gPagAntecipado.New do
      refNFe := '12345678901234567890123456789012345678901234';

    with NotaF.NFe.Ide.gPagAntecipado.New do
      refNFe := '12345678901234567890123456789012345678904567';
  end;}

  //Para NFe referenciada use os campos abaixo
  (*
  Referenciada := NotaF.NFe.Ide.NFref.Add;
  Referenciada.refNFe       := ''; //NFe Eletronica

  Referenciada.RefNF.cUF    := 0;  // |
  Referenciada.RefNF.AAMM   := ''; // |
  Referenciada.RefNF.CNPJ   := ''; // |
  Referenciada.RefNF.modelo := 1;  // |- NFe Modelo 1/1A
  Referenciada.RefNF.serie  := 1;  // |
  Referenciada.RefNF.nNF    := 0;  // |

  Referenciada.RefNFP.cUF     := 0;  // |
  Referenciada.RefNFP.AAMM    := ''; // |
  Referenciada.RefNFP.CNPJCPF := ''; // |
  Referenciada.RefNFP.IE      := ''; // |- NF produtor Rural
  Referenciada.RefNFP.modelo  := ''; // |
  Referenciada.RefNFP.serie   := 1;  // |
  Referenciada.RefNFP.nNF     := 0;  // |

  Referenciada.RefECF.modelo  := ECFModRef2B; // |
  Referenciada.RefECF.nECF    := '';          // |- Cupom Fiscal
  Referenciada.RefECF.nCOO    := '';          // |
  *)
  NotaF.NFe.Emit.CNPJCPF           := '36729378000178'; //edtEmitCNPJ.Text
  NotaF.NFe.Emit.IE                := '35575049';//edtEmitIE.Text - Inscrição Estadual
  NotaF.NFe.Emit.xNome             := 'Casa do PC LTDA'; //edtEmitRazao.Text - Razão Social
  NotaF.NFe.Emit.xFant             := 'Casa do PC'; //edtEmitFantasia.Text

  NotaF.NFe.Emit.EnderEmit.fone    := '21993406645'; //edtEmitFone.Text;
  NotaF.NFe.Emit.EnderEmit.CEP     := StrToInt('22790669'); //edtEmitCEP.Text
  NotaF.NFe.Emit.EnderEmit.xLgr    := 'Avenida Tim Maia'; //edtEmitLogradouro.Text
  NotaF.NFe.Emit.EnderEmit.nro     := '7285'; //edtEmitNumero.Text;
  NotaF.NFe.Emit.EnderEmit.xCpl    := 'Bloco 04 apto 203'; //edtEmitComp.Text;
  NotaF.NFe.Emit.EnderEmit.xBairro := 'Recreio dos Bandeirantes'; //edtEmitBairro.Text;
  NotaF.NFe.Emit.EnderEmit.cMun    := StrToInt('33'); //edtEmitCodCidade.Text
  NotaF.NFe.Emit.EnderEmit.xMun    := 'Rio de Janeiro'; //edtEmitCidade.Text;
  NotaF.NFe.Emit.EnderEmit.UF      := 'RJ'; //edtEmitUF.Text;
  NotaF.NFe.Emit.enderEmit.cPais   := 1058;
  NotaF.NFe.Emit.enderEmit.xPais   := 'BRASIL';

  NotaF.NFe.Emit.IEST              := '';
  NotaF.NFe.Emit.IM                := '2648800'; // Preencher no caso de existir serviços na nota
  NotaF.NFe.Emit.CNAE              := '6201500'; // Verifique na cidade do emissor da NFe se é permitido
                                                 // a inclusão de serviços na NFe

    // esta sendo somando 1 uma vez que o ItemIndex inicia do zero e devemos
    // passar os valores 1, 2 ou 3
    // (1-crtSimplesNacional, 2-crtSimplesExcessoReceita, 3-crtRegimeNormal)
  NotaF.NFe.Emit.CRT  := StrToCRT(Ok, IntToStr(2 + 1)); //cbTipoEmpresa.ItemIndex

//Para NFe Avulsa preencha os campos abaixo

  NotaF.NFe.Avulsa.CNPJ    := '';
  NotaF.NFe.Avulsa.xOrgao  := '';
  NotaF.NFe.Avulsa.matr    := '';
  NotaF.NFe.Avulsa.xAgente := '';
  NotaF.NFe.Avulsa.fone    := '';
  NotaF.NFe.Avulsa.UF      := '';
  NotaF.NFe.Avulsa.nDAR    := '';
  NotaF.NFe.Avulsa.dEmi    := now;
  NotaF.NFe.Avulsa.vDAR    := 0;
  NotaF.NFe.Avulsa.repEmi  := '';
  NotaF.NFe.Avulsa.dPag    := now;

  NotaF.NFe.Dest.CNPJCPF           := DM.mtCliente.FieldByName('CPF_CNPJ').AsString; //'05481336000137';
  NotaF.NFe.Dest.IE                := EmptyStr;//'687138770110'; //Inscrição Estadual
  NotaF.NFe.Dest.ISUF              := EmptyStr; //'';
  NotaF.NFe.Dest.xNome             := DM.mtCliente.FieldByName('NOME_RAZAO').AsString; //'D.J. COM. E LOCAÇÃO DE SOFTWARES LTDA - ME';

  NotaF.NFe.Dest.EnderDest.Fone    := EmptyStr; //'1532599600';
  NotaF.NFe.Dest.EnderDest.CEP     := 0; //18270170;
  NotaF.NFe.Dest.EnderDest.xLgr    := EmptyStr; //'Rua Coronel Aureliano de Camargo';
  NotaF.NFe.Dest.EnderDest.nro     := EmptyStr; //'973';
  NotaF.NFe.Dest.EnderDest.xCpl    := '';
  NotaF.NFe.Dest.EnderDest.xBairro := EmptyStr; //'Centro';
  NotaF.NFe.Dest.EnderDest.cMun    := 0; //3554003;
  NotaF.NFe.Dest.EnderDest.xMun    := EmptyStr; //'Tatui';
  NotaF.NFe.Dest.EnderDest.UF      := DM.mtCliente.FieldByName('UF').AsString;//'SP';
  NotaF.NFe.Dest.EnderDest.cPais   := 1058;
  NotaF.NFe.Dest.EnderDest.xPais   := 'BRASIL';

//Use os campos abaixo para informar o endereço de retirada quando for diferente do Remetente/Destinatário

  NotaF.NFe.Retirada.CNPJCPF := '';
  NotaF.NFe.Retirada.xLgr    := '';
  NotaF.NFe.Retirada.nro     := '';
  NotaF.NFe.Retirada.xCpl    := '';
  NotaF.NFe.Retirada.xBairro := '';
  NotaF.NFe.Retirada.cMun    := 0;
  NotaF.NFe.Retirada.xMun    := '';
  NotaF.NFe.Retirada.UF      := '';

//Use os campos abaixo para informar o endereço de entrega quando for diferente do Remetente/Destinatário

  NotaF.NFe.Entrega.CNPJCPF := '';
  NotaF.NFe.Entrega.xLgr    := '';
  NotaF.NFe.Entrega.nro     := '';
  NotaF.NFe.Entrega.xCpl    := '';
  NotaF.NFe.Entrega.xBairro := '';
  NotaF.NFe.Entrega.cMun    := 0;
  NotaF.NFe.Entrega.xMun    := '';
  NotaF.NFe.Entrega.UF      := '';

//Adicionando Produtos
  DM.mtPedidoItem.First;
  while not DM.mtPedidoItem.Eof do
    begin
      iContador := iContador + 1;

      Produto := NotaF.NFe.Det.New;
      Produto.Prod.nItem    := iContador; // Número sequencial, para cada item deve ser incrementado
      Produto.Prod.cProd    := DM.mtPedidoItem.FieldByName('ID_PRODUTO').AsString; //'123456'; Representa o Código do Produto ou Serviço interno da sua empresa
      Produto.Prod.cEAN     := '7896523206646'; //Representa o código de barras GTIN (anteriormente conhecido como EAN/Código de Barras Europeu)
      Produto.Prod.xProd    := DM.mtPedidoItem.FieldByName('DESCRICAO').AsString; //'Camisa Polo ACBr';
      Produto.Prod.NCM      := DM.mtPedidoItem.FieldByName('NCM').AsString; //'61051000';

      // Reforma Tributária
      {if rgReformaTributaria.ItemIndex = 0 then
        Produto.Prod.tpCredPresIBSZFM := tcpSemCredito;}

      Produto.Prod.EXTIPI   := '';
      Produto.Prod.CFOP     := DM.mtPedidoItem.FieldByName('CFOP_PADRAO').AsString; //'5101';
      Produto.Prod.uCom     := 'UN';
      Produto.Prod.qCom     := DM.mtPedidoItem.FieldByName('QUANTIDADE').AsFloat; //1; //Quantidade Comercial Vendida
      Produto.Prod.vUnCom   := DM.mtPedidoItem.FieldByName('VL_UNITARIO').AsFloat; //100; //Valor unitário de comercialização
      Produto.Prod.vProd    := DM.mtPedidoItem.FieldByName('VL_TOTAL').AsFloat; //100; //Valor Total: vProd = qCom * vUnCom

      Produto.Prod.cEANTrib  := '7896523206646';
      Produto.Prod.uTrib     := 'UN';
      Produto.Prod.qTrib     := DM.mtPedidoItem.FieldByName('QUANTIDADE').AsFloat; //1;
      Produto.Prod.vUnTrib   := DM.mtPedidoItem.FieldByName('VL_UNITARIO').AsFloat; //100;

      Produto.Prod.vOutro    := 0;
      Produto.Prod.vFrete    := 0;
      Produto.Prod.vSeg      := 0;
      Produto.Prod.vDesc     := 0;

      //Produto.Prod.CEST := '1111111';

      Produto.infAdProd := 'Informacao Adicional do Produto';

      {
        abaixo os campos incluidos no layout a partir da NT 2020/005
      }
      // Opcional - Preencher com o Código de Barras próprio ou de terceiros que seja diferente do padrão GTIN
      // por exemplo: código de barras de catálogo, partnumber, etc
      Produto.Prod.cBarra := 'ABC123456';
      // Opcional - Preencher com o Código de Barras próprio ou de terceiros que seja diferente do padrão GTIN
      //  correspondente àquele da menor unidade comercializável identificado por Código de Barras
      // por exemplo: código de barras de catálogo, partnumber, etc
      Produto.Prod.cBarraTrib := 'ABC123456';

      // Declaração de Importação. Pode ser adicionada várias através do comando Prod.DI.Add
      (*
      DI := Produto.Prod.DI.Add;
      DI.nDi         := '';
      DI.dDi         := now;
      DI.xLocDesemb  := '';
      DI.UFDesemb    := '';
      DI.dDesemb     := now;
      {
        tvMaritima, tvFluvial, tvLacustre, tvAerea, tvPostal, tvFerroviaria, tvRodoviaria,

        abaixo os novos valores incluidos a partir da NT 2020/005

        tvConduto, tvMeiosProprios, tvEntradaSaidaFicta, tvCourier, tvEmMaos, tvPorReboque
      }
      DI.tpViaTransp := tvRodoviaria;
      DI.vAFRMM := 0;
      {
        tiContaPropria, tiContaOrdem, tiEncomenda
      }
      DI.tpIntermedio := tiContaPropria;
      DI.CNPJ := '';
      DI.UFTerceiro := '';
      DI.cExportador := '';

      Adicao := DI.adi.Add;
      Adicao.nAdicao     := 1;
      Adicao.nSeqAdi     := 1;
      Adicao.cFabricante := '';
      Adicao.vDescDI     := 0;
      Adicao.nDraw       := '';
      *)

    //Campos para venda de veículos novos

      Produto.Prod.veicProd.tpOP    := toVendaConcessionaria;
      Produto.Prod.veicProd.chassi  := '';
      Produto.Prod.veicProd.cCor    := '';
      Produto.Prod.veicProd.xCor    := '';
      Produto.Prod.veicProd.pot     := '';
      Produto.Prod.veicProd.Cilin   := '';
      Produto.Prod.veicProd.pesoL   := '';
      Produto.Prod.veicProd.pesoB   := '';
      Produto.Prod.veicProd.nSerie  := '';
      Produto.Prod.veicProd.tpComb  := '';
      Produto.Prod.veicProd.nMotor  := '';
      Produto.Prod.veicProd.CMT     := '';
      Produto.Prod.veicProd.dist    := '';
      Produto.Prod.veicProd.anoMod  := 0;
      Produto.Prod.veicProd.anoFab  := 0;
      Produto.Prod.veicProd.tpPint  := '';
      Produto.Prod.veicProd.tpVeic  := 0;
      Produto.Prod.veicProd.espVeic := 0;
      Produto.Prod.veicProd.VIN     := '';
      Produto.Prod.veicProd.condVeic := cvAcabado;
      Produto.Prod.veicProd.cMod    := '';

    // Campos de Rastreabilidade do produto
      {
      O grupo <rastro> permiti a rastreabilidade de qualquer produto sujeito a
      regulações sanitárias, casos de recolhimento/recall, além de defensivos agrícolas,
      produtos veterinários, odontológicos, medicamentos, bebidas, águas envasadas,
      embalagens, etc., a partir da indicação de informações de número de lote,
      data de fabricação/produção, data de validade, etc.
      Obrigatório o preenchimento deste grupo no caso de medicamentos e
      produtos farmacêuticos.
      }

      // Ocorrências: 0 - 500
      (*
      Rastro := Produto.Prod.rastro.Add;

      Rastro.nLote  := '17H8F5';
      Rastro.qLote  := 1;
      Rastro.dFab   := StrToDate('01/08/2017');
      Rastro.dVal   := StrToDate('01/08/2019');
      Rastro.cAgreg := ''; // Código de Agregação (opcional) de 1 até 20 dígitos
      *)

    //Campos específicos para venda de medicamentos

      // Ocorrências: 1 - 500 ==> 1 - 1 (4.00)
      (*
      Medicamento := Produto.Prod.med.Add;

      Medicamento.cProdANVISA := '1256802470029';
      Medicamento.vPMC        := 100.00; // Preço máximo consumidor
      *)

    //Campos específicos para venda de armamento
      (*
      Arma := Produto.Prod.arma.Add;
      Arma.nSerie := 0;
      Arma.tpArma := taUsoPermitido;
      Arma.nCano  := 0;
      Arma.descr  := '';
      *)

    //Campos específicos para agropecuario / defensivo
    // Devemos gerar somente o grupo defensivo ou o grupo guiaTransito
    (*
      Defensivo := Agropecuario.defensivo.Add;
      Defensivo.nReceituario := '123';
      Defensivo.CPFRespTec := '12345678901';
    *)

    //Campos específicos para agropecuario / guiaTransito
    (*
      Agropecuario.guiaTransito.tpGuia := tpgGuiaFlorestal;
      Agropecuario.guiaTransito.UFGuia := 'SP';
      Agropecuario.guiaTransito.serieGuia := '1';
      Agropecuario.guiaTransito.nGuia := '1';
    *)

    //Campos específicos para venda de combustível(distribuidoras)

      Produto.Prod.comb.cProdANP := 0;
      Produto.Prod.comb.CODIF    := '';
      Produto.Prod.comb.qTemp    := 0;
      Produto.Prod.comb.UFcons   := '';

      Produto.Prod.comb.CIDE.qBCprod   := 0;
      Produto.Prod.comb.CIDE.vAliqProd := 0;
      Produto.Prod.comb.CIDE.vCIDE     := 0;

      Produto.Prod.comb.ICMS.vBCICMS   := 0;
      Produto.Prod.comb.ICMS.vICMS     := 0;
      Produto.Prod.comb.ICMS.vBCICMSST := 0;
      Produto.Prod.comb.ICMS.vICMSST   := 0;

      Produto.Prod.comb.ICMSInter.vBCICMSSTDest := 0;
      Produto.Prod.comb.ICMSInter.vICMSSTDest   := 0;

      Produto.Prod.comb.ICMSCons.vBCICMSSTCons := 0;
      Produto.Prod.comb.ICMSCons.vICMSSTCons   := 0;
      Produto.Prod.comb.ICMSCons.UFcons        := '';

      // Reforma Tributária
      {if rgReformaTributaria.ItemIndex = 0 then
      begin
        // Indicador de fornecimento de bem móvel usado
        Produto.Prod.indBemMovelUsado := tieNenhum;

        // Valor total do Item, correspondente à sua participação no total da nota.
        // A soma dos itens deverá corresponder ao total da nota.
        Produto.vItem := 100;
        // Referenciamento de item de outro Documento Fiscal Eletrônico - DF-e
        Produto.DFeReferenciado.chaveAcesso := '';
        Produto.DFeReferenciado.nItem := 1;
      end;}
      DM.mtPedidoItem.Next;
    end;

  with Produto.Imposto do
  begin
    // lei da transparencia nos impostos
    vTotTrib := 0;

    with ICMS do
    begin
      // caso o CRT seja:
      // 1=Simples Nacional
      // Os valores aceitos para CSOSN são:
      // csosn101, csosn102, csosn103, csosn201, csosn202, csosn203,
      // csosn300, csosn400, csosn500,csosn900

      // 2=Simples Nacional, excesso sublimite de receita bruta;
      // ou 3=Regime Normal.
      // Os valores aceitos para CST são:
      // cst00, cst10, cst20, cst30, cst40, cst41, cst45, cst50, cst51,
      // cst60, cst70, cst80, cst81, cst90, cstPart10, cstPart90,
      // cstRep41, cstVazio, cstICMSOutraUF, cstICMSSN, cstRep60

      // (consulte o contador do seu cliente para saber qual deve ser utilizado)
      // Pode variar de um produto para outro.

      orig := oeNacional;

      //Grupo de Tributação do ICMS Monofásico sobre combustíveis.
      (*
      CST       := cst02;
      qBCMono   := 100;
      adRemICMS := 10;
      vICMSMono := 10;
      *)
      //Grupo de Tributação do ICMS Monofásico sobre combustíveis.
      (*
      CST          := cst15;
      qBCMono      := 100;
      adRemICMS    := 10;
      vICMSMono    := 10;
      qBCMonoReten := 100;
      adRemICMSReten := 10;
      vICMSMonoReten := 10;
      pRedAdRem      := 10;
      motRedAdRem    := TmotRedAdRem.motTranspColetivo;
      *)
      //Grupo de Tributação do ICMS Monofásico sobre combustíveis.
      (*
      CST           := cst53;
      qBCMono       := 100;
      adRemICMS     := 10;
      vICMSMonoOp   := 10;
      pDif          := 10;
      vICMSMonoDif  := 1;
      vICMSMono     := 10;
      *)
      //Grupo de Tributação do ICMS Monofásico sobre combustíveis.
      (*
      CST           := cst61;
      qBCMonoRet    := 100;
      adRemICMSRet  := 10;
      vICMSMonoRet  := 10;
      *)

      if NotaF.NFe.Emit.CRT in [crtSimplesExcessoReceita, crtRegimeNormal] then
      begin
      {
        CST     := cst00;
        modBC   := dbiPrecoTabelado;
        vBC     := 100;
        pICMS   := 18;
        vICMS   := 18;
        modBCST := dbisMargemValorAgregado;
        pMVAST  := 0;
        pRedBCST:= 0;
        vBCST   := 0;
        pICMSST := 0;
        vICMSST := 0;
        pRedBC  := 0;
      }
        CST := cst20;
        modBC := dbiMargemValorAgregado;
        pRedBC := 0;
        vBC := 100;
        pICMS := 18;
        vICMS := 18;
        vICMSDeson := 8;
        motDesICMS := mdiOutros;
        indDeduzDeson := tieSim;
      end
      else
      begin
        CSOSN   := csosn101;
        modBC   := dbiValorOperacao;
        pCredSN := 5;
        vCredICMSSN := 100 * pCredSN / 100;
        vBC     := 0;
        pICMS   := 0;
        vICMS   := 0;
        modBCST := dbisListaNeutra;
        pMVAST  := 0;
        pRedBCST:= 0;
        vBCST   := 0;
        pICMSST := 0;
        vICMSST := 0;
      end;

      vBCFCPST := 100;
      pFCPST := 2;
      vFCPST := 2;
      vBCSTRet := 0;
      pST := 0;
      vICMSSubstituto := 0;
      vICMSSTRet := 0;
      vBCFCPSTRet := 0;
      pFCPSTRet := 0;
      vFCPSTRet := 0;
      pRedBCEfet := 0;
      vBCEfet := 0;
      pICMSEfet := 0;
      vICMSEfet := 0;

      {
        abaixo os campos incluidos no layout a partir da NT 2020/005
      }
      // Informar apenas nos motivos de desoneração documentados abaixo
      vICMSSTDeson := 0;
      {
        o campo abaixo só aceita os valores:
        mdiProdutorAgropecuario, mdiOutros, mdiOrgaoFomento
        Campo será preenchido quando o campo anterior estiver preenchido.
      }
      motDesICMSST := mdiOutros;

      // Percentual do diferimento do ICMS relativo ao Fundo de Combate à Pobreza (FCP).
      // No caso de diferimento total, informar o percentual de diferimento "100"
      pFCPDif := 0;
      // Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) diferido
      vFCPDif := 0;
      // Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) realmente devido.
      vFCPEfet := 0;
    end;

    with ICMSUFDest do
    begin
      // partilha do ICMS e fundo de probreza
      vBCUFDest      := 0.00;
      pFCPUFDest     := 0.00;
      pICMSUFDest    := 0.00;
      pICMSInter     := 0.00;
      pICMSInterPart := 0.00;
      vFCPUFDest     := 0.00;
      vICMSUFDest    := 0.00;
      vICMSUFRemet   := 0.00;
    end;

    (*
    // IPI, se hpouver...
    with IPI do
    begin
      CST      := ipi99;
      clEnq    := '999';
      CNPJProd := '';
      cSelo    := '';
      qSelo    := 0;
      cEnq     := '';

      vBC    := 100;
      qUnid  := 0;
      vUnid  := 0;
      pIPI   := 5;
      vIPI   := 5;
    end;
    *)

    with II do
    begin
      II.vBc      := 0;
      II.vDespAdu := 0;
      II.vII      := 0;
      II.vIOF     := 0;
    end;

    with PIS do
    begin
      CST  := pis99;
      vBC  := 0;
      pPIS := 0;
      vPIS := 0;

      qBCProd   := 0;
      vAliqProd := 0;
      vPIS      := 0;
    end;

    with PISST do
    begin
      vBc       := 0;
      pPis      := 0;
      qBCProd   := 0;
      vAliqProd := 0;
      vPIS      := 0;
      {
        abaixo o campo incluido no layout a partir da NT 2020/005
      }
      {
        valores aceitos pelo campo:
        ispNenhum, ispPISSTNaoCompoe, ispPISSTCompoe
      }
      // Indica se o valor do PISST compõe o valor total da NF-e
      IndSomaPISST :=  ispNenhum;
    end;

    with COFINS do
    begin
      CST     := cof99;
      vBC     := 0;
      pCOFINS := 0;
      vCOFINS := 0;
      qBCProd   := 0;
      vAliqProd := 0;
    end;

    with COFINSST do
    begin
      vBC       := 0;
      pCOFINS   := 0;
      qBCProd   := 0;
      vAliqProd := 0;
      vCOFINS   := 0;
      {
        abaixo o campo incluido no layout a partir da NT 2020/005
      }
      {
        valores aceitos pelo campo:
        iscNenhum, iscCOFINSSTNaoCompoe, iscCOFINSSTCompoe
      }
      // Indica se o valor da COFINS ST compõe o valor total da NF-e
      indSomaCOFINSST :=  iscNenhum;
    end;

    // Reforma Tributária
    {if rgReformaTributaria.ItemIndex = 0 then
    begin
      //  Informações do tributo: Imposto Seletivo só para 2027 e para os
      //  os produtos nocivos ao meio ambiente e a saúde.

      //ISel.CSTIS := cstis000;
      //ISel.cClassTribIS := '000001';

      //ISel.vBCIS := 100;
      //ISel.pIS := 5;
      //ISel.pISEspec := 5;
      //ISel.uTrib := 'UNIDAD';
      //ISel.qTrib := 10;
      //ISel.vIS := 100;



      //  Utilize os CST (cst000, cst200, cst220, cst510 e cst550) e os cClassTrib
      //  correspondentes para gerar o grupo IBSCBS
      //  Utilize o CST cst620 e os cClassTrib correspondentes para gerar o grupo
      //  IBSCBSMono
      //  Utilize o CST cst800 e os cClassTrib correspondentes para gerar o grupo
      //  gTransfCred
      //  Utilize o CST cst810 e os cClassTrib correspondentes para gerar o grupo
      //  gCredPresIBSZFM


      //  Informações do tributo: IBS / CBS
      IBSCBS.CST := cst811;
      IBSCBS.cClassTrib := '000001';
      IBSCBS.indDoacao := tieSim;

      IBSCBS.gIBSCBS.vBC := 100;

      IBSCBS.gIBSCBS.gIBSUF.pIBSUF := 5;
      IBSCBS.gIBSCBS.gIBSUF.vIBSUF := 100;

      IBSCBS.gIBSCBS.gIBSUF.gDif.pDif := 5;
      IBSCBS.gIBSCBS.gIBSUF.gDif.vDif := 100;

      IBSCBS.gIBSCBS.gIBSUF.gDevTrib.vDevTrib := 100;

      IBSCBS.gIBSCBS.gIBSUF.gRed.pRedAliq := 5;
      IBSCBS.gIBSCBS.gIBSUF.gRed.pAliqEfet := 5;

      IBSCBS.gIBSCBS.gIBSMun.pIBSMun := 5;
      IBSCBS.gIBSCBS.gIBSMun.vIBSMun := 100;

      IBSCBS.gIBSCBS.gIBSMun.gDif.pDif := 5;
      IBSCBS.gIBSCBS.gIBSMun.gDif.vDif := 100;

      IBSCBS.gIBSCBS.gIBSMun.gDevTrib.vDevTrib := 100;

      IBSCBS.gIBSCBS.gIBSMun.gRed.pRedAliq := 5;
      IBSCBS.gIBSCBS.gIBSMun.gRed.pAliqEfet := 5;

      // vIBS = vIBSUF + vIBSMun
      IBSCBS.gIBSCBS.vIBS := 100;

      IBSCBS.gIBSCBS.gCBS.pCBS := 5;
      IBSCBS.gIBSCBS.gCBS.vCBS := 100;

      IBSCBS.gIBSCBS.gCBS.gDif.pDif := 5;
      IBSCBS.gIBSCBS.gCBS.gDif.vDif := 100;

      IBSCBS.gIBSCBS.gCBS.gDevTrib.vDevTrib := 100;

      IBSCBS.gIBSCBS.gCBS.gRed.pRedAliq := 5;
      IBSCBS.gIBSCBS.gCBS.gRed.pAliqEfet := 5;

      IBSCBS.gIBSCBS.gTribRegular.CSTReg := cst000;
      IBSCBS.gIBSCBS.gTribRegular.cClassTribReg := '000001';
      IBSCBS.gIBSCBS.gTribRegular.pAliqEfetRegIBSUF := 5;
      IBSCBS.gIBSCBS.gTribRegular.vTribRegIBSUF := 50;
      IBSCBS.gIBSCBS.gTribRegular.pAliqEfetRegIBSMun := 5;
      IBSCBS.gIBSCBS.gTribRegular.vTribRegIBSMun := 50;
      IBSCBS.gIBSCBS.gTribRegular.pAliqEfetRegCBS := 5;
      IBSCBS.gIBSCBS.gTribRegular.vTribRegCBS := 50;

      // Tipo Tributação Compra Governamental
      IBSCBS.gIBSCBS.gTribCompraGov.pAliqIBSUF := 5;
      IBSCBS.gIBSCBS.gTribCompraGov.vTribIBSUF := 50;
      IBSCBS.gIBSCBS.gTribCompraGov.pAliqIBSMun := 5;
      IBSCBS.gIBSCBS.gTribCompraGov.vTribIBSMun := 50;
      IBSCBS.gIBSCBS.gTribCompraGov.pAliqCBS := 5;
      IBSCBS.gIBSCBS.gTribCompraGov.vTribCBS := 50;

      //  Informações do tributo: IBS / CBS em operações com imposto monofásico
      IBSCBS.gIBSCBSMono.gMonoPadrao.qBCMono := 1;
      IBSCBS.gIBSCBSMono.gMonoPadrao.adRemIBS := 5;
      IBSCBS.gIBSCBSMono.gMonoPadrao.adRemCBS := 5;
      IBSCBS.gIBSCBSMono.gMonoPadrao.vIBSMono := 100;
      IBSCBS.gIBSCBSMono.gMonoPadrao.vCBSMono := 100;

      IBSCBS.gIBSCBSMono.gMonoReten.qBCMonoReten := 1;
      IBSCBS.gIBSCBSMono.gMonoReten.adRemIBSReten := 5;
      IBSCBS.gIBSCBSMono.gMonoReten.vIBSMonoReten := 100;
      IBSCBS.gIBSCBSMono.gMonoReten.vCBSMonoReten := 100;

      IBSCBS.gIBSCBSMono.gMonoRet.qBCMonoRet := 1;
      IBSCBS.gIBSCBSMono.gMonoRet.adRemIBSRet := 5;
      IBSCBS.gIBSCBSMono.gMonoRet.vIBSMonoRet := 100;
      IBSCBS.gIBSCBSMono.gMonoRet.vCBSMonoRet := 100;

      IBSCBS.gIBSCBSMono.gMonoDif.pDifIBS := 5;
      IBSCBS.gIBSCBSMono.gMonoDif.vIBSMonoDif := 100;
      IBSCBS.gIBSCBSMono.gMonoDif.pDifCBS := 5;
      IBSCBS.gIBSCBSMono.gMonoDif.vCBSMonoDif := 100;

      IBSCBS.gIBSCBSMono.vTotIBSMonoItem := 100;
      IBSCBS.gIBSCBSMono.vTotCBSMonoItem := 100;

      //  Informações da Transferencia de Crédito
      IBSCBS.gTransfCred.vIBS := 100;
      IBSCBS.gTransfCred.vCBS := 100;

      //  Informações Ajuste de Competência
      IBSCBS.gAjusteCompet.competApur := Date;
      IBSCBS.gAjusteCompet.vIBS := 100;
      IBSCBS.gAjusteCompet.vCBS := 100;

      //  Informações Estorno de Crédito
      IBSCBS.gEstornoCred.vIBSEstCred := 100;
      IBSCBS.gEstornoCred.vCBSEstCred := 100;

      //  Informações do Crédito Presumido Operacional
      IBSCBS.gCredPresOper.cCredPres := cpNenhum;
      IBSCBS.gCredPresOper.vBCCredPres := 100;
      IBSCBS.gCredPresOper.gIBSCredPres.pCredPres := 5;
      IBSCBS.gCredPresOper.gIBSCredPres.vCredPres := 100;
      IBSCBS.gCredPresOper.gIBSCredPres.vCredPresCondSus := 0;
      IBSCBS.gCredPresOper.gCBSCredPres.pCredPres := 5;
      IBSCBS.gCredPresOper.gCBSCredPres.vCredPres := 100;
      IBSCBS.gCredPresOper.gCBSCredPres.vCredPresCondSus := 0;

      //  Informações do Crédito Presumido IBS ZFM
      // tcpNenhum, tcpSemCredito, tcpBensConsumoFinal, tcpBensCapital,
      // tcpBensIntermediarios, tcpBensInformaticaOutros
      IBSCBS.gCredPresIBSZFM.competApur := Date;
      IBSCBS.gCredPresIBSZFM.tpCredPresIBSZFM := tcpBensInformaticaOutros;
      IBSCBS.gCredPresIBSZFM.vCredPresIBSZFM := 100;
    end;}
  end;

  //Adicionando Serviços
  (*
  Servico := NotaF.Nfe.Det.Add;
  Servico.Prod.nItem    := 1; // Número sequencial, para cada item deve ser incrementado
  Servico.Prod.cProd    := '123457';
  Servico.Prod.cEAN     := '';
  Servico.Prod.xProd    := 'Descrição do Serviço';
  Servico.Prod.NCM      := '99';
  Servico.Prod.EXTIPI   := '';
  Servico.Prod.CFOP     := '5933';
  Servico.Prod.uCom     := 'UN';
  Servico.Prod.qCom     := 1;
  Servico.Prod.vUnCom   := 100;
  Servico.Prod.vProd    := 100;

  Servico.Prod.cEANTrib  := '';
  Servico.Prod.uTrib     := 'UN';
  Servico.Prod.qTrib     := 1;
  Servico.Prod.vUnTrib   := 100;

  Servico.Prod.vFrete    := 0;
  Servico.Prod.vSeg      := 0;
  Servico.Prod.vDesc     := 0;

  Servico.infAdProd      := 'Informação Adicional do Serviço';

  //Grupo para serviços
  Servico.Imposto.ISSQN
  Servico.Imposto.cSitTrib  := ISSQNcSitTribNORMAL;
  Servico.Imposto.vBC       := 100;
  Servico.Imposto.vAliq     := 2;
  Servico.Imposto.vISSQN    := 2;
  Servico.Imposto.cMunFG    := 3554003;
  // Preencha este campo usando a tabela disponível
  // em http://www.planalto.gov.br/Ccivil_03/LEIS/LCP/Lcp116.htm
  Servico.Imposto.cListServ := '1402';

  NotaF.NFe.Total.ISSQNtot.vServ   := 100;
  NotaF.NFe.Total.ISSQNTot.vBC     := 100;
  NotaF.NFe.Total.ISSQNTot.vISS    := 2;
  NotaF.NFe.Total.ISSQNTot.vPIS    := 0;
  NotaF.NFe.Total.ISSQNTot.vCOFINS := 0;

*)

  if NotaF.NFe.Emit.CRT in [crtSimplesExcessoReceita, crtRegimeNormal] then
  begin
    NotaF.NFe.Total.ICMSTot.vBC := 100;
    NotaF.NFe.Total.ICMSTot.vICMS := 18;
  end
  else
  begin
    NotaF.NFe.Total.ICMSTot.vBC := 0;
    NotaF.NFe.Total.ICMSTot.vICMS := 0;
  end;

  NotaF.NFe.Total.ICMSTot.vBCST   := 0;
  NotaF.NFe.Total.ICMSTot.vST     := 0;
  NotaF.NFe.Total.ICMSTot.vProd   := 100;
  NotaF.NFe.Total.ICMSTot.vFrete  := 0;
  NotaF.NFe.Total.ICMSTot.vSeg    := 0;
  NotaF.NFe.Total.ICMSTot.vDesc   := 0;
  NotaF.NFe.Total.ICMSTot.vII     := 0;
  NotaF.NFe.Total.ICMSTot.vIPI    := 0;
  NotaF.NFe.Total.ICMSTot.vPIS    := 0;
  NotaF.NFe.Total.ICMSTot.vCOFINS := 0;
  NotaF.NFe.Total.ICMSTot.vOutro  := 0;
  NotaF.NFe.Total.ICMSTot.vNF     := 100;

  // lei da transparencia de impostos
  NotaF.NFe.Total.ICMSTot.vTotTrib := 0;

  // partilha do icms e fundo de probreza
  NotaF.NFe.Total.ICMSTot.vFCPUFDest   := 0.00;
  NotaF.NFe.Total.ICMSTot.vICMSUFDest  := 0.00;
  NotaF.NFe.Total.ICMSTot.vICMSUFRemet := 0.00;

  NotaF.NFe.Total.ICMSTot.vFCPST     := 0;
  NotaF.NFe.Total.ICMSTot.vFCPSTRet  := 0;

  NotaF.NFe.Total.retTrib.vRetPIS    := 0;
  NotaF.NFe.Total.retTrib.vRetCOFINS := 0;
  NotaF.NFe.Total.retTrib.vRetCSLL   := 0;
  NotaF.NFe.Total.retTrib.vBCIRRF    := 0;
  NotaF.NFe.Total.retTrib.vIRRF      := 0;
  NotaF.NFe.Total.retTrib.vBCRetPrev := 0;
  NotaF.NFe.Total.retTrib.vRetPrev   := 0;

  // Reforma Tributária
  {if rgReformaTributaria.ItemIndex = 0 then
  begin
    NotaF.NFe.Total.ISTot.vIS := 100;

    NotaF.NFe.Total.IBSCBSTot.vBCIBSCBS := 100;

    NotaF.NFe.Total.IBSCBSTot.gIBS.vIBS := 100;
    NotaF.NFe.Total.IBSCBSTot.gIBS.vCredPres := 100;
    NotaF.NFe.Total.IBSCBSTot.gIBS.vCredPresCondSus := 100;

    NotaF.NFe.Total.IBSCBSTot.gIBS.gIBSUFTot.vDif := 100;
    NotaF.NFe.Total.IBSCBSTot.gIBS.gIBSUFTot.vDevTrib := 100;
    NotaF.NFe.Total.IBSCBSTot.gIBS.gIBSUFTot.vIBSUF := 100;

    NotaF.NFe.Total.IBSCBSTot.gIBS.gIBSMunTot.vDif := 100;
    NotaF.NFe.Total.IBSCBSTot.gIBS.gIBSMunTot.vDevTrib := 100;
    NotaF.NFe.Total.IBSCBSTot.gIBS.gIBSMunTot.vIBSMun := 100;

    NotaF.NFe.Total.IBSCBSTot.gCBS.vDif := 100;
    NotaF.NFe.Total.IBSCBSTot.gCBS.vDevTrib := 100;
    NotaF.NFe.Total.IBSCBSTot.gCBS.vCBS := 100;
    NotaF.NFe.Total.IBSCBSTot.gCBS.vCredPres := 100;
    NotaF.NFe.Total.IBSCBSTot.gCBS.vCredPresCondSus := 100;

    NotaF.NFe.Total.IBSCBSTot.gMono.vIBSMono := 100;
    NotaF.NFe.Total.IBSCBSTot.gMono.vCBSMono := 100;
    NotaF.NFe.Total.IBSCBSTot.gMono.vIBSMonoReten := 100;
    NotaF.NFe.Total.IBSCBSTot.gMono.vCBSMonoReten := 100;
    NotaF.NFe.Total.IBSCBSTot.gMono.vIBSMonoRet := 100;
    NotaF.NFe.Total.IBSCBSTot.gMono.vCBSMonoRet := 100;

    NotaF.NFe.Total.IBSCBSTot.gEstornoCred.vIBSEstCred := 100;
    NotaF.NFe.Total.IBSCBSTot.gEstornoCred.vCBSEstCred := 100;

    // Valor total da NF-e com IBS / CBS / IS
    NotaF.NFe.Total.vNFTot := 100;
  end;}

  NotaF.NFe.Transp.modFrete := mfContaEmitente;
  NotaF.NFe.Transp.Transporta.CNPJCPF  := '';
  NotaF.NFe.Transp.Transporta.xNome    := '';
  NotaF.NFe.Transp.Transporta.IE       := '';
  NotaF.NFe.Transp.Transporta.xEnder   := '';
  NotaF.NFe.Transp.Transporta.xMun     := '';
  NotaF.NFe.Transp.Transporta.UF       := '';

  NotaF.NFe.Transp.retTransp.vServ    := 0;
  NotaF.NFe.Transp.retTransp.vBCRet   := 0;
  NotaF.NFe.Transp.retTransp.pICMSRet := 0;
  NotaF.NFe.Transp.retTransp.vICMSRet := 0;
  NotaF.NFe.Transp.retTransp.CFOP     := '';
  NotaF.NFe.Transp.retTransp.cMunFG   := 0;

  Volume := NotaF.NFe.Transp.Vol.New;
  Volume.qVol  := 1;
  Volume.esp   := 'Especie';
  Volume.marca := 'Marca';
  Volume.nVol  := 'Numero';
  Volume.pesoL := 100;
  Volume.pesoB := 110;

  //Lacres do volume. Pode ser adicionado vários
  (*
  Lacre := Volume.Lacres.Add;
  Lacre.nLacre := '';
  *)

  NotaF.NFe.Cobr.Fat.nFat  := '1001'; // 'Numero da Fatura'
  NotaF.NFe.Cobr.Fat.vOrig := 100;
  NotaF.NFe.Cobr.Fat.vDesc := 0;
  NotaF.NFe.Cobr.Fat.vLiq  := 100;

  Duplicata := NotaF.NFe.Cobr.Dup.New;
  Duplicata.nDup  := '001';
  Duplicata.dVenc := now+10;
  Duplicata.vDup  := 50;

  Duplicata := NotaF.NFe.Cobr.Dup.New;
  Duplicata.nDup  := '002';
  Duplicata.dVenc := now+20;
  Duplicata.vDup  := 50;

    // O grupo infIntermed só deve ser gerado nos casos de operação não presencial
    // pela internet em site de terceiros (Intermediadores).
//  NotaF.NFe.infIntermed.CNPJ := '';
//  NotaF.NFe.infIntermed.idCadIntTran := '';

  NotaF.NFe.InfAdic.infCpl     :=  '';
  NotaF.NFe.InfAdic.infAdFisco :=  '';

  ObsComplementar := NotaF.NFe.InfAdic.obsCont.New;
  ObsComplementar.xCampo := 'ObsCont';
  ObsComplementar.xTexto := 'Texto';

  ObsFisco := NotaF.NFe.InfAdic.obsFisco.New;
  ObsFisco.xCampo := 'ObsFisco';
  ObsFisco.xTexto := 'Texto';

//Processo referenciado
  (*
  ProcReferenciado := NotaF.Nfe.InfAdic.procRef.Add;
  ProcReferenciado.nProc := '';
  ProcReferenciado.indProc := ipSEFAZ;
  *)

  NotaF.NFe.exporta.UFembarq   := '';
  NotaF.NFe.exporta.xLocEmbarq := '';

  NotaF.NFe.compra.xNEmp := '';
  NotaF.NFe.compra.xPed  := '';
  NotaF.NFe.compra.xCont := '';

// YA. Informações de pagamento

  InfoPgto := NotaF.NFe.pag.New;
  InfoPgto.indPag := ipVista;
  InfoPgto.tPag   := fpDinheiro;
  InfoPgto.vPag   := 100;

// Exemplo de pagamento integrado.

  InfoPgto := NotaF.NFe.pag.New;
  InfoPgto.indPag := ipVista;
  InfoPgto.tPag   := fpCartaoCredito;

  {
    abaixo o campo incluido no layout a partir da NT 2020/006
  }
  {
    se tPag for fpOutro devemos incluir o campo xPag
  InfoPgto.xPag := 'Caderneta';
  }
  InfoPgto.vPag   := 75;
  InfoPgto.tpIntegra := tiPagIntegrado;
  InfoPgto.CNPJ      := '05481336000137';
  InfoPgto.tBand     := bcVisa;
  InfoPgto.cAut      := '1234567890123456';

// YA09 Troco
// Regra opcional: Informar se valor dos pagamentos maior que valor da nota.
// Regra obrigatória: Se informado, Não pode diferir de "(+) vPag (id:YA03) (-) vNF (id:W16)"
//  NotaF.NFe.pag.vTroco := 75;

  {
    abaixo o campo incluido no layout a partir da NT 2020/006
  }
  // CNPJ do Intermediador da Transação (agenciador, plataforma de delivery,
  // marketplace e similar) de serviços e de negócios.
  NotaF.NFe.infIntermed.CNPJ := '';
  // Nome do usuário ou identificação do perfil do vendedor no site do intermediador
  // (agenciador, plataforma de delivery, marketplace e similar) de serviços e de
  // negócios.
  NotaF.NFe.infIntermed.idCadIntTran := '';
end;

end.
