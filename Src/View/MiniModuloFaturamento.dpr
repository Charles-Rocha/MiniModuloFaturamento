program MiniModuloFaturamento;

uses
  Vcl.Forms,
  untPrincipal in 'untPrincipal.pas' {frmMiniModuloFaturamento},
  untTelaBaseCRUD in 'untTelaBaseCRUD.pas' {frmTelaBaseCRUD},
  untCadastroCliente in 'untCadastroCliente.pas' {frmCadastroClientes},
  untCadastroProduto in 'untCadastroProduto.pas' {frmCadastroProdutos},
  Controller.Cliente in '..\Controller\Controller.Cliente.pas',
  Controller.Produto in '..\Controller\Controller.Produto.pas',
  Model.Cliente in '..\Model\Model.Cliente.pas',
  Model.Produto in '..\Model\Model.Produto.pas',
  untDM in '..\DM\untDM.pas' {DM: TDataModule},
  Model.Connection in '..\Model\Model.Connection.pas',
  Controller.Pedido in '..\Controller\Controller.Pedido.pas',
  Model.Pedido in '..\Model\Model.Pedido.pas',
  untUniversal in 'untUniversal.pas',
  untConfigurarBancoDados in 'untConfigurarBancoDados.pas' {frmConfigurarBancoDados},
  untCadastroPedido in 'untCadastroPedido.pas' {frmCadastroPedido},
  untProdutos in 'untProdutos.pas' {frmProdutos},
  Controller.NFe in '..\Controller\Controller.NFe.pas',
  Model.NFe in '..\Model\Model.NFe.pas',
  untSobre in 'untSobre.pas' {frmSobre},
  Controller.Sefaz in '..\Controller\Controller.Sefaz.pas',
  Controller.EventoNFe in '..\Controller\Controller.EventoNFe.pas',
  Model.EventoNFe in '..\Model\Model.EventoNFe.pas',
  untLogEventoNFe in 'untLogEventoNFe.pas' {frmLogEventoNFe},
  Controller.LogEvento in '..\Controller\Controller.LogEvento.pas',
  Model.LogEvento in '..\Model\Model.LogEvento.pas',
  untLogEvento in 'untLogEvento.pas' {frmLogEvento};

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
