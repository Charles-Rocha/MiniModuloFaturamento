unit untPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  System.ImageList, Vcl.ImgList, Controller.Sefaz, ACBrBase, ACBrDFe, ACBrNFe, ACBrDFeUtil;

type
  TfrmMiniModuloFaturamento = class(TForm)
    MainMenu1: TMainMenu;
    BancodeDados1: TMenuItem;
    Configurar1: TMenuItem;
    Abastecimentos1: TMenuItem;
    Configurar2: TMenuItem;
    ValorCombustveis1: TMenuItem;
    Ajuda1: TMenuItem;
    Sobre1: TMenuItem;
    Clientes1: TMenuItem;
    Produtos1: TMenuItem;
    N1: TMenuItem;
    Pedidos1: TMenuItem;
    pnlPrincipal: TPanel;
    Image1: TImage;
    N2: TMenuItem;
    Contingencia1: TMenuItem;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    ACBrNFe1: TACBrNFe;
    procedure Clientes1Click(Sender: TObject);
    procedure Produtos1Click(Sender: TObject);
    procedure Configurar1Click(Sender: TObject);
    procedure Pedidos1Click(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
    procedure Contingencia1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ValorCombustveis1Click(Sender: TObject);
  private
    { Private declarations }
    FSefaz: TSefaz;
  public
    { Public declarations }
    property Sefaz: TSefaz read FSefaz write FSefaz;
  end;

var
  frmMiniModuloFaturamento: TfrmMiniModuloFaturamento;

implementation

{$R *.dfm}

uses untCadastroCliente, untCadastroProduto, untPedido, untConfigurarBancoDados, untCadastroPedido, untDM,
  Controller.Cliente, untSobre, pcnNFeRTXT;

procedure TfrmMiniModuloFaturamento.Clientes1Click(Sender: TObject);
begin
  frmCadastroClientes.ShowModal;
end;

procedure TfrmMiniModuloFaturamento.Configurar1Click(Sender: TObject);
begin
  frmConfigurarBancoDados.ShowModal;
end;

procedure TfrmMiniModuloFaturamento.Contingencia1Click(Sender: TObject);
begin
  if Contingencia1.Checked then
    begin
      Contingencia1.ImageIndex := 1;
      FSefaz.Contingiencia := 1;
    end
  else
    begin
      Contingencia1.ImageIndex := 0;
      FSefaz.Contingiencia := 0;
    end;
end;

procedure TfrmMiniModuloFaturamento.FormCreate(Sender: TObject);
begin
  FSefaz := TSefaz.Create;
end;

procedure TfrmMiniModuloFaturamento.FormDestroy(Sender: TObject);
begin
  FSefaz.Free;
end;

procedure TfrmMiniModuloFaturamento.Pedidos1Click(Sender: TObject);
begin
  frmCadastroPedido.ShowModal;
end;

procedure TfrmMiniModuloFaturamento.Produtos1Click(Sender: TObject);
begin
  frmCadastroProdutos.ShowModal;
end;

procedure TfrmMiniModuloFaturamento.Sobre1Click(Sender: TObject);
begin
  frmSobre.ShowModal;
end;

procedure TfrmMiniModuloFaturamento.ValorCombustveis1Click(Sender: TObject);
var
  sCpfCnpj, sResultado, sMensagemRetorno: string;
begin
  OpenDialog1.FileName  :=  '';
  OpenDialog1.Title := 'Selecione a NFe';
  OpenDialog1.DefaultExt := '*-nfe.XML';
  OpenDialog1.Filter := 'Arquivos NFe (*-nfe.XML)|*-nfe.XML|Arquivos XML (*.XML)|*.XML|Arquivos TXT (*.TXT)|*.TXT|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;

  if OpenDialog1.Execute then
  begin
    ACBrNFe1.NotasFiscais.Clear;
    try
      ACBrNFe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
    except
      ShowMessage('Arquivo NFe Inválido');
      exit;
    end;

    sCpfCnpj := ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.CNPJCPF;
    if length(sCpfCnpj) = 11 then
      Sefaz.TipoPessoa := 'F'
    else
    if length(sCpfCnpj) = 14 then
      Sefaz.TipoPessoa := 'J'
    else
      Sefaz.TipoPessoa := EmptyStr;

    Sefaz.Externo := true;
    sResultado := Sefaz.SefazRecebeEValidaXML(OpenDialog1.FileName);
    sMensagemRetorno := copy(sResultado, pos(';', sResultado)+1, length(sResultado));
    sResultado := copy(sResultado, 1, pos(';', sResultado)-1);

    Application.MessageBox(PChar('NFe enviada com sucesso para o SEFAZ.' +#13+
                             'Status de retorno da NFe: ' + sResultado +#13+#13+
                             sMensagemRetorno),'Aviso', mb_Ok+mb_IconExclamation);
  end;
end;

end.
