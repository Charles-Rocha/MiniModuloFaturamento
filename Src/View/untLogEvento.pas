unit untLogEvento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls;

type
  TfrmLogEvento = class(TForm)
    pnlDBGrid: TPanel;
    dbgLogEventoNFe: TDBGrid;
    StatusBar1: TStatusBar;
    dtsLogEvento: TDataSource;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogEvento: TfrmLogEvento;

implementation

{$R *.dfm}

uses untDM;

procedure TfrmLogEvento.FormShow(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := 'Total de registros: ' + IntToStr(DM.mtLogEvento.RecordCount);
end;

end.
