program MiniModuloFaturamento;

uses
  Vcl.Forms,
  untPrincipal in 'Src\View\untPrincipal.pas' {frmMiniModuloFaturamento},
  untTelaBaseCRUD in 'Src\View\untTelaBaseCRUD.pas' {frmTelaBaseCRUD},
  untCadastroCliente in 'Src\View\untCadastroCliente.pas' {frmCadastroClientes},
  untCadastroProduto in 'Src\View\untCadastroProduto.pas' {frmCadastroProdutos},
  Controller.Cliente in 'Src\Controller\Controller.Cliente.pas',
  Controller.Produto in 'Src\Controller\Controller.Produto.pas',
  Model.Cliente in 'Src\Model\Model.Cliente.pas',
  Model.Produto in 'Src\Model\Model.Produto.pas',
  untDM in 'Src\DM\untDM.pas' {DM: TDataModule},
  Model.Connection in 'Src\Model\Model.Connection.pas',
  Controller.Pedido in 'Src\Controller\Controller.Pedido.pas',
  Model.Pedido in 'Src\Model\Model.Pedido.pas',
  untUniversal in 'Src\View\untUniversal.pas',
  untConfigurarBancoDados in 'Src\View\untConfigurarBancoDados.pas' {frmConfigurarBancoDados},
  untCadastroPedido in 'Src\View\untCadastroPedido.pas' {frmCadastroPedido},
  untProdutos in 'Src\View\untProdutos.pas' {frmProdutos},
  Controller.NFe in 'Src\Controller\Controller.NFe.pas',
  Model.NFe in 'Src\Model\Model.NFe.pas',
  untSobre in 'Src\View\untSobre.pas' {frmSobre},
  Controller.Sefaz in 'Src\Controller\Controller.Sefaz.pas',
  Controller.EventoNFe in 'Src\Controller\Controller.EventoNFe.pas',
  Model.EventoNFe in 'Src\Model\Model.EventoNFe.pas',
  untLogEventoNFe in 'Src\View\untLogEventoNFe.pas' {frmLogEventoNFe},
  Controller.LogEvento in 'Src\Controller\Controller.LogEvento.pas',
  Model.LogEvento in 'Src\Model\Model.LogEvento.pas',
  untLogEvento in 'Src\View\untLogEvento.pas' {frmLogEvento};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMiniModuloFaturamento, frmMiniModuloFaturamento);
  Application.CreateForm(TfrmTelaBaseCRUD, frmTelaBaseCRUD);
  Application.CreateForm(TfrmCadastroClientes, frmCadastroClientes);
  Application.CreateForm(TfrmCadastroProdutos, frmCadastroProdutos);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmConfigurarBancoDados, frmConfigurarBancoDados);
  Application.CreateForm(TfrmCadastroPedido, frmCadastroPedido);
  Application.CreateForm(TfrmProdutos, frmProdutos);
  Application.CreateForm(TfrmSobre, frmSobre);
  Application.CreateForm(TfrmLogEventoNFe, frmLogEventoNFe);
  Application.CreateForm(TfrmLogEvento, frmLogEvento);
  Application.Run;
end.
