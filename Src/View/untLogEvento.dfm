object frmLogEvento: TfrmLogEvento
  Left = 0
  Top = 0
  Caption = 'Log Evento da NFe'
  ClientHeight = 561
  ClientWidth = 984
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnShow = FormShow
  TextHeight = 15
  object pnlDBGrid: TPanel
    Left = 0
    Top = 0
    Width = 984
    Height = 542
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 834
    object dbgLogEventoNFe: TDBGrid
      Left = 1
      Top = 1
      Width = 982
      Height = 540
      Align = alClient
      DataSource = dtsLogEvento
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'DT_LOG'
          Title.Alignment = taCenter
          Title.Caption = 'Data do Log'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -12
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = [fsBold]
          Width = 110
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'ENTIDADE'
          Title.Alignment = taCenter
          Title.Caption = 'Entidade'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -12
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = [fsBold]
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACAO'
          Title.Caption = 'A'#231#227'o'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -12
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = [fsBold]
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MENSAGEM'
          Title.Caption = 'Mensagem'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -12
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = [fsBold]
          Width = 714
          Visible = True
        end>
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 542
    Width = 984
    Height = 19
    Panels = <
      item
        Text = 'Total de registros:'
        Width = 50
      end>
    ExplicitWidth = 834
  end
  object dtsLogEvento: TDataSource
    DataSet = DM.mtLogEvento
    Left = 744
    Top = 472
  end
end
