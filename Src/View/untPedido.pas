unit untPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, untTelaBaseCRUD, Data.DB, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrmPedidos = class(TfrmTelaBaseCRUD)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPedidos: TfrmPedidos;

implementation

{$R *.dfm}

uses untDM, Controller.Cliente, Controller.Pedido;

procedure TfrmPedidos.FormShow(Sender: TObject);
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

  //DM.mtCliente.AfterScroll := OnAfterScrollClientes;
  //DM.mtCliente.FieldByName('CPF_CNPJ').OnGetText := OnCpfCnpjGetText;

  dbgBaseCadastro.DataSource.DataSet.GotoBookmark(CurrentRecord);
  dbgBaseCadastro.DataSource.DataSet.FreeBookmark(CurrentRecord);
  inherited;
end;

end.
