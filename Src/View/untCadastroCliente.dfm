inherited frmCadastroClientes: TfrmCadastroClientes
  Caption = 'Cadastro de Clientes'
  ClientHeight = 563
  ClientWidth = 684
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 700
  ExplicitHeight = 602
  TextHeight = 13
  inherited pnlBotoes: TPanel
    Width = 684
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 684
    inherited btnCancelar: TBitBtn
      Left = 504
      ExplicitLeft = 504
    end
    inherited btnGravar: TBitBtn
      Left = 592
      ExplicitLeft = 592
    end
    inherited btnLimpar: TBitBtn
      OnClick = btnLimparClick
    end
  end
  inherited pnlDBGrid: TPanel
    Top = 162
    Width = 684
    Height = 382
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 162
    ExplicitWidth = 684
    ExplicitHeight = 382
    inherited dbgBaseCadastro: TDBGrid
      Width = 680
      Height = 378
      DataSource = dtsDBGrid
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'ID_CLIENTE'
          Title.Alignment = taCenter
          Title.Caption = 'C'#243'digo Cliente'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME_RAZAO'
          Title.Caption = 'Nome'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Width = 210
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'TIPO_PESSOA'
          Title.Alignment = taCenter
          Title.Caption = 'Tipo Pessoa'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Width = 86
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'CPF_CNPJ'
          Title.Alignment = taCenter
          Title.Caption = 'CPF/CNPJ'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Width = 124
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'UF'
          Title.Alignment = taCenter
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Width = 40
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'DT_CADASTRO'
          Title.Alignment = taCenter
          Title.Caption = 'Dt. Cadastro'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Width = 84
          Visible = True
        end>
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 544
    Width = 684
    Panels = <
      item
        Width = 50
      end>
    ExplicitTop = 544
    ExplicitWidth = 684
  end
  object pnlCampos: TPanel [3]
    Left = 0
    Top = 58
    Width = 684
    Height = 104
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 3
    object lblIdCliente: TLabel
      Left = 8
      Top = 8
      Width = 100
      Height = 13
      Caption = 'C'#243'digo do Cliente:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblUF: TLabel
      Left = 416
      Top = 56
      Width = 17
      Height = 13
      Caption = 'UF:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblNome: TLabel
      Left = 168
      Top = 8
      Width = 35
      Height = 13
      Caption = 'Nome:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTipoPessoa: TLabel
      Left = 8
      Top = 56
      Width = 70
      Height = 13
      Caption = 'Tipo Pessoa:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblDataCadastro: TLabel
      Left = 512
      Top = 56
      Width = 101
      Height = 13
      Caption = 'Data do Cadastro:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCpfCnpj: TLabel
      Left = 168
      Top = 56
      Width = 56
      Height = 13
      Caption = 'CPF/CNPJ:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cdpDataCadastro: TCalendarPicker
      Left = 512
      Top = 71
      Width = 164
      Height = 23
      BorderColor = clSilver
      CalendarHeaderInfo.DaysOfWeekFont.Charset = DEFAULT_CHARSET
      CalendarHeaderInfo.DaysOfWeekFont.Color = clWindowText
      CalendarHeaderInfo.DaysOfWeekFont.Height = -13
      CalendarHeaderInfo.DaysOfWeekFont.Name = 'Segoe UI'
      CalendarHeaderInfo.DaysOfWeekFont.Style = []
      CalendarHeaderInfo.Font.Charset = DEFAULT_CHARSET
      CalendarHeaderInfo.Font.Color = clWindowText
      CalendarHeaderInfo.Font.Height = -20
      CalendarHeaderInfo.Font.Name = 'Segoe UI'
      CalendarHeaderInfo.Font.Style = []
      CalendarHeaderInfo.FontColor = 10774084
      Color = clWhite
      DisabledColor = 13146425
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      OnCloseUp = cdpDataCadastroCloseUp
      ParentFont = False
      PopupMenu = popDataCadastro
      SelectionColor = clRed
      TabOrder = 5
      TextHint = 'Selecionar'
      TodayColor = 10774084
    end
    object edtIdCliente: TEdit
      Left = 8
      Top = 24
      Width = 154
      Height = 21
      Enabled = False
      NumbersOnly = True
      TabOrder = 0
    end
    object edtNome: TEdit
      Left = 168
      Top = 24
      Width = 508
      Height = 21
      TabOrder = 1
    end
    object edtCpfCnpj: TMaskEdit
      Left = 168
      Top = 72
      Width = 242
      Height = 21
      TabOrder = 3
      Text = ''
    end
    object cmbUF: TComboBox
      Left = 416
      Top = 72
      Width = 89
      Height = 21
      Style = csDropDownList
      TabOrder = 4
      Items.Strings = (
        'AC'
        'AL'
        'AP'
        'AM'
        'BA'
        'CE'
        'DF'
        'ES'
        'GO'
        'MA'
        'MT'
        'MS'
        'MG'
        'PA'
        'PB'
        'PR'
        'PE'
        'PI'
        'RJ'
        'RN'
        'RS'
        'RO'
        'RR'
        'SC'
        'SP'
        'SE'
        'TO')
    end
    object cmbTipoPessoa: TComboBox
      Left = 8
      Top = 72
      Width = 154
      Height = 21
      Style = csDropDownList
      TabOrder = 2
      OnCloseUp = cmbTipoPessoaCloseUp
      OnExit = cmbTipoPessoaExit
      Items.Strings = (
        'F'#237'sica'
        'Jur'#237'dica')
    end
  end
  inherited dtsDBGrid: TDataSource
    Top = 480
  end
  object popDataCadastro: TPopupMenu
    Left = 110
    Top = 480
    object Limpar1: TMenuItem
      Caption = 'Limpar'
      ImageIndex = 27
      OnClick = Limpar1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object SelecionarDataAtual1: TMenuItem
      Caption = 'Selecionar Data Atual'
      ImageIndex = 28
      OnClick = SelecionarDataAtual1Click
    end
  end
end
