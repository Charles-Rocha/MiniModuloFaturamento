unit untCadastroCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, untTelaBaseCRUD, Data.DB, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.WinXCalendars, Vcl.Mask, Vcl.Menus;

type
  TTipoCadastro = (eInserir, eEditar, eBuscar, eNenhum);

type
  TfrmCadastroClientes = class(TfrmTelaBaseCRUD)
    pnlCampos: TPanel;
    lblIdCliente: TLabel;
    lblUF: TLabel;
    lblNome: TLabel;
    lblTipoPessoa: TLabel;
    lblDataCadastro: TLabel;
    lblCpfCnpj: TLabel;
    cdpDataCadastro: TCalendarPicker;
    edtIdCliente: TEdit;
    edtNome: TEdit;
    edtCpfCnpj: TMaskEdit;
    cmbUF: TComboBox;
    popDataCadastro: TPopupMenu;
    Limpar1: TMenuItem;
    N3: TMenuItem;
    SelecionarDataAtual1: TMenuItem;
    cmbTipoPessoa: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure cdpDataCadastroCloseUp(Sender: TObject);
    procedure Limpar1Click(Sender: TObject);
    procedure SelecionarDataAtual1Click(Sender: TObject);
    procedure cmbTipoPessoaCloseUp(Sender: TObject);
    procedure cmbTipoPessoaExit(Sender: TObject);
  private
    { Private declarations }
    FCancelar: boolean;
    FTipoCadastro: TTipoCadastro;
    FTipoPessoaAnterior: string;

    procedure CarregarClientes;
    procedure ConfigurarEHabilitarControle;
    procedure HabilitarControles;
    procedure DesabilitarControles;
    procedure FormatarFonteCalendario(Calendario: TCalendarPicker);
    procedure LimparControles;
    procedure OnAfterScrollClientes(DataSet: TDataSet);
    procedure OnCpfCnpjGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure PreencherCamposCliente;
    procedure PreencherCamposDeValores;
    function ValidarCamposObrigatorios: boolean;
  public
    { Public declarations }
  end;

var
  frmCadastroClientes: TfrmCadastroClientes;

implementation

{$R *.dfm}

uses untDM, Controller.Cliente;

{ TfrmCadastroClientes }

procedure TfrmCadastroClientes.btnApagarClick(Sender: TObject);
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
          bResultado := DeletarCliente(DM.mtCliente.FieldByName('ID_CLIENTE').AsInteger, sErro);
          if not bResultado then
            begin
              Application.MessageBox(PChar(sErro), 'Aviso', mb_Ok + mb_IconExclamation)
            end
          else
            begin
              CarregarClientes;

              if DM.mtCliente.IsEmpty then
                LimparControles
              else
                PreencherCamposCliente;
            end;
        except
          on E : Exception do
            Application.MessageBox(PChar('Erro encontrado! ' + E.Message),'Aviso',mb_Ok+mb_IconExclamation);
        end;
      finally
        begin
          FTipoCadastro := eNenhum;
          StatusBar1.Panels[0].Text := 'Total de registros: ' + IntToStr(DM.mtCliente.RecordCount);
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

procedure TfrmCadastroClientes.btnCancelarClick(Sender: TObject);
begin
  inherited;
  FCancelar := true;
  DesabilitarControles;
  LimparControles;
  PreencherCamposCliente;
  FCancelar := false;
  FTipoCadastro := eNenhum;
end;

procedure TfrmCadastroClientes.btnEditarClick(Sender: TObject);
var
  CurrentRecord: TBookMark;
begin
  inherited;
  FTipoCadastro := eEditar;
  CurrentRecord := dbgBaseCadastro.DataSource.DataSet.GetBookmark;
  FormatarFonteCalendario(cdpDataCadastro);
  HabilitarControles;
  dbgBaseCadastro.DataSource.DataSet.GotoBookmark(CurrentRecord);
  dbgBaseCadastro.DataSource.DataSet.FreeBookmark(CurrentRecord);
end;

procedure TfrmCadastroClientes.btnGravarClick(Sender: TObject);
var
  iIdCliente: integer;
  sNome, sTipoPessoa, sCpfCnpj, sUF, sDataCadastro, sErro: string;
  bResultado: boolean;
begin
  if not ValidarCamposObrigatorios then
    exit;

  iIdCliente := StrToInt(edtIdCliente.Text);
  sNome := edtNome.Text;

  if cmbTipoPessoa.Text = 'Física' then
    sTipoPessoa := 'F';
  if cmbTipoPessoa.Text = 'Jurídica' then
    sTipoPessoa := 'J';

  sCpfCnpj := Trim(edtCpfCnpj.Text);
  sUF := cmbUF.Text;
  sDataCadastro := DateToStr(cdpDataCadastro.Date);
  sDataCadastro := copy(sDataCadastro, 7, 4) + '-' +
                   copy(sDataCadastro, 4, 2) + '-' +
                   copy(sDataCadastro, 1, 2);
  bResultado := false;

  try
    if FTipoCadastro = eInserir then
      bResultado := InserirCliente(iIdCliente, sNome, sTipoPessoa, sCpfCnpj, sUF, sDataCadastro, sErro);

    if FTipoCadastro = eEditar then
      bResultado := EditarCliente(iIdCliente, sNome, sTipoPessoa, sCpfCnpj, sUF, sDataCadastro, sErro);

    try
      if not bResultado then
        begin
          Application.MessageBox(PChar(sErro), 'Aviso', mb_Ok + mb_IconExclamation)
        end
      else
        begin
          CarregarClientes;

          if DM.mtCliente.IsEmpty then
            LimparControles
          else
            PreencherCamposCliente;
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
      StatusBar1.Panels[0].Text := 'Total de registros: ' + IntToStr(DM.mtCliente.RecordCount);
    end;
  if bResultado then
    inherited;
end;

procedure TfrmCadastroClientes.btnInserirClick(Sender: TObject);
begin
  inherited;
  FTipoCadastro := eInserir;
  FormatarFonteCalendario(cdpDataCadastro);
  HabilitarControles;
  LimparControles;
  FTipoPessoaAnterior := EmptyStr;
  PreencherCamposDeValores;
end;

procedure TfrmCadastroClientes.btnLimparClick(Sender: TObject);
begin
  inherited;
  LimparControles;
end;

procedure TfrmCadastroClientes.CarregarClientes;
var
  sErro: string;
  CurrentRecord: TBookMark;
begin
  if DM.mtCliente.Active then
    DM.mtCliente.EmptyDataSet;

  DM.mtCliente.Close;
  ListarClientes(DM.mtCliente, sErro);
  dtsDBGrid.DataSet := DM.mtCliente;

  CurrentRecord := dbgBaseCadastro.DataSource.DataSet.GetBookmark;

  DM.mtCliente.AfterScroll := OnAfterScrollClientes;
  DM.mtCliente.FieldByName('CPF_CNPJ').OnGetText := OnCpfCnpjGetText;

  dbgBaseCadastro.DataSource.DataSet.GotoBookmark(CurrentRecord);
  dbgBaseCadastro.DataSource.DataSet.FreeBookmark(CurrentRecord);
end;

procedure TfrmCadastroClientes.cdpDataCadastroCloseUp(Sender: TObject);
begin
  FormatarFonteCalendario(cdpDataCadastro);
end;

procedure TfrmCadastroClientes.cmbTipoPessoaCloseUp(Sender: TObject);
begin
  ConfigurarEHabilitarControle;
end;

procedure TfrmCadastroClientes.cmbTipoPessoaExit(Sender: TObject);
begin
  ConfigurarEHabilitarControle;
end;

procedure TfrmCadastroClientes.ConfigurarEHabilitarControle;
begin
  if cmbTipoPessoa.Text <> EmptyStr then
    begin
      if FTipoPessoaAnterior <> cmbTipoPessoa.Text then
        begin
          edtCpfCnpj.Clear;
          if cmbTipoPessoa.Text = 'Física' then
            begin
              lblCpfCnpj.Caption := 'CPF';
              edtCpfCnpj.EditMask := '!999.999.999-99;0;';
            end;

          if cmbTipoPessoa.Text = 'Jurídica' then
            begin
              lblCpfCnpj.Caption := 'CNPJ';
              edtCpfCnpj.EditMask := '!99.999.999/9999-99;0;';
            end;
        end;

      edtCpfCnpj.Enabled := true;
      FTipoPessoaAnterior := cmbTipoPessoa.Text;
      edtCpfCnpj.SetFocus;
    end;
end;

procedure TfrmCadastroClientes.DesabilitarControles;
begin
  edtNome.Enabled := false;
  cmbTipoPessoa.Enabled := false;
  edtCpfCnpj.Enabled := false;
  cmbUF.Enabled := false;
  cdpDataCadastro.Enabled := false;
end;

procedure TfrmCadastroClientes.FormatarFonteCalendario(Calendario: TCalendarPicker);
begin
  if Calendario.IsEmpty then
    Calendario.Font.Color := clGray
  else
    Calendario.Font.Color := clBlack;
end;

procedure TfrmCadastroClientes.FormShow(Sender: TObject);
begin
  FTipoCadastro := eNenhum;
  FCancelar := false;

  CarregarClientes;

  if DM.mtCliente.IsEmpty then
    LimparControles
  else
    PreencherCamposCliente;

  DesabilitarControles;
  inherited;
end;

procedure TfrmCadastroClientes.HabilitarControles;
begin
  edtNome.Enabled := true;
  cmbTipoPessoa.Enabled := true;
  edtCpfCnpj.Enabled := true;
  cmbUF.Enabled := true;
  cdpDataCadastro.Enabled := true;
  edtNome.SetFocus;
end;

procedure TfrmCadastroClientes.Limpar1Click(Sender: TObject);
begin
  cdpDataCadastro.IsEmpty := true;
  FormatarFonteCalendario(cdpDataCadastro);
end;

procedure TfrmCadastroClientes.LimparControles;
begin
  edtNome.Clear;
  cmbTipoPessoa.ItemIndex := -1;
  edtCpfCnpj.Clear;
  edtCpfCnpj.EditMask := EmptyStr;
  cmbUF.ItemIndex := -1;
  cdpDataCadastro.IsEmpty := true;
end;

procedure TfrmCadastroClientes.OnAfterScrollClientes(DataSet: TDataSet);
begin
  if (FTipoCadastro = eEditar) or (FTipoCadastro = eNenhum) then
    begin
      PreencherCamposCliente;
      FTipoPessoaAnterior := cmbTipoPessoa.Text;
    end;
end;

procedure TfrmCadastroClientes.OnCpfCnpjGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if not DM.mtCliente.IsEmpty then
    begin
      if DM.mtCliente.FieldByName('TIPO_PESSOA').AsString = 'F' then
        begin
          Text := FormatFloat( '0##"."###"."###"-"##', StrToFloatDef(Sender.AsString, 0));
        end;

      if DM.mtCliente.FieldByName('TIPO_PESSOA').AsString = 'J' then
        begin
          Text := copy(Sender.AsString, 1, 2) + '.' +
                  copy(Sender.AsString, 3, 3) + '.' +
                  copy(Sender.AsString, 6, 3) + '/' +
                  copy(Sender.AsString, 9, 4) + '.' +
                  copy(Sender.AsString, 12, 2);
        end;
    end;
end;

procedure TfrmCadastroClientes.PreencherCamposCliente;
var
  sData, sTipoPessoa, sCpfCnpj: string;
begin
  edtIdCliente.Text := DM.mtCliente.FieldByName('ID_CLIENTE').AsString;
  edtNome.Text := DM.mtCliente.FieldByName('NOME_RAZAO').AsString;

  sTipoPessoa := DM.mtCliente.FieldByName('TIPO_PESSOA').AsString;
  if sTipoPessoa = 'F' then
    cmbTipoPessoa.ItemIndex := cmbTipoPessoa.Items.IndexOf('Física');
  if sTipoPessoa = 'J' then
    cmbTipoPessoa.ItemIndex := cmbTipoPessoa.Items.IndexOf('Jurídica');

  sCpfCnpj := DM.mtCliente.FieldByName('CPF_CNPJ').AsString;
  if length(sCpfCnpj) = 11 then
    begin
      edtCpfCnpj.EditMask := '!999.999.999-99;0;';
      edtCpfCnpj.Text := sCpfCnpj;
    end
  else
  if length(sCpfCnpj) = 14 then
    begin
      edtCpfCnpj.EditMask := '!99.999.999/9999-99;0;';
      edtCpfCnpj.Text := sCpfCnpj;
    end
  else
    edtCpfCnpj.Text := sCpfCnpj;

  cmbUF.ItemIndex := cmbUF.Items.IndexOf(DM.mtCliente.FieldByName('UF').AsString);

  if DM.mtCliente.FieldByName('DT_CADASTRO').AsString <> EmptyStr then
    begin
      sData := DM.mtCliente.FieldByName('DT_CADASTRO').AsString;
      cdpDataCadastro.Date := StrToDate(sData);
    end;
  StatusBar1.Panels[0].Text := 'Total de registros: ' + IntToStr(DM.mtCliente.RecordCount);
end;

procedure TfrmCadastroClientes.PreencherCamposDeValores;
var
  sErro: string;
begin
  edtIdCliente.Text := IntToStr(ListarCodigoUltimoCliente(sErro) + 1);
end;

procedure TfrmCadastroClientes.SelecionarDataAtual1Click(Sender: TObject);
begin
  cdpDataCadastro.Date := Date;
  FormatarFonteCalendario(cdpDataCadastro);
end;

function TfrmCadastroClientes.ValidarCamposObrigatorios: boolean;
begin
  result := true;
  if cdpDataCadastro.Date > Date then
    begin
      Application.MessageBox('O campo Data do Cadastro não pode ser maior que a data atual', 'Aviso', mb_Ok + mb_IconExclamation);
      result := false;
      cdpDataCadastro.SetFocus;
      exit;
    end;
end;

end.
