unit untLogEventoNFe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls;

type
  TfrmLogEventoNFe = class(TForm)
    pnlDBGrid: TPanel;
    dbgLogEventoNFe: TDBGrid;
    StatusBar1: TStatusBar;
    dtsLogEventoNFe: TDataSource;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogEventoNFe: TfrmLogEventoNFe;

implementation

{$R *.dfm}

uses untDM;

procedure TfrmLogEventoNFe.FormShow(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := 'Total de registros: ' + IntToStr(DM.mtEventoNFe.RecordCount);
end;

end.
