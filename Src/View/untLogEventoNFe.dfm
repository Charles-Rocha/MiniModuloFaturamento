object frmLogEventoNFe: TfrmLogEventoNFe
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Log Evento da NFe'
  ClientHeight = 561
  ClientWidth = 834
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
    Width = 834
    Height = 542
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 714
    ExplicitHeight = 442
    object dbgLogEventoNFe: TDBGrid
      Left = 1
      Top = 1
      Width = 832
      Height = 540
      Align = alClient
      DataSource = dtsLogEventoNFe
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
          FieldName = 'ID_NFE_EVENTO'
          Title.Alignment = taCenter
          Title.Caption = 'Id NFe Evento'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -12
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = [fsBold]
          Width = 90
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'ID_NFE'
          Title.Alignment = taCenter
          Title.Caption = 'Id NFe'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -12
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = [fsBold]
          Width = 74
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'DT_EVENTO'
          Title.Alignment = taCenter
          Title.Caption = 'Data Evento'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -12
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = [fsBold]
          Width = 118
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'STATUS_ANTES'
          Title.Alignment = taCenter
          Title.Caption = 'Status Antes'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -12
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = [fsBold]
          Width = 150
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'STATUS_DEPOIS'
          Title.Alignment = taCenter
          Title.Caption = 'Status Depois'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -12
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = [fsBold]
          Width = 150
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'MOTIVO'
          Title.Alignment = taCenter
          Title.Caption = 'Motivo'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -12
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = [fsBold]
          Width = 210
          Visible = True
        end>
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 542
    Width = 834
    Height = 19
    Panels = <
      item
        Text = 'Total de registros:'
        Width = 50
      end>
    ExplicitTop = 442
    ExplicitWidth = 714
  end
  object dtsLogEventoNFe: TDataSource
    DataSet = DM.mtEventoNFe
    Left = 744
    Top = 472
  end
end
