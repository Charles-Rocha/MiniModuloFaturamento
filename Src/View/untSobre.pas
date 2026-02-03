unit untSobre;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

type
  TfrmSobre = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Button1: TButton;
    lblDataCriacao: TLabel;
    lblDesenvolvedor: TLabel;
    lblProcessoSelecao: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSobre: TfrmSobre;

implementation

{$R *.dfm}

procedure TfrmSobre.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
