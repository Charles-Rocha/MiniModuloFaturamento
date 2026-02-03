inherited frmCadastroProdutos: TfrmCadastroProdutos
  Caption = 'Cadastro de Produtos'
  ClientHeight = 563
  ClientWidth = 786
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 802
  ExplicitHeight = 602
  TextHeight = 13
  inherited pnlBotoes: TPanel
    Width = 786
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 786
    inherited btnCancelar: TBitBtn
      Left = 608
      ExplicitLeft = 608
    end
    inherited btnGravar: TBitBtn
      Left = 696
      ExplicitLeft = 696
    end
    inherited btnLimpar: TBitBtn
      OnClick = btnLimparClick
    end
  end
  inherited pnlDBGrid: TPanel
    Top = 162
    Width = 786
    Height = 382
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 162
    ExplicitWidth = 786
    ExplicitHeight = 382
    inherited dbgBaseCadastro: TDBGrid
      Width = 782
      Height = 378
      DataSource = dtsDBGrid
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'ID_PRODUTO'
          Title.Alignment = taCenter
          Title.Caption = 'C'#243'digo Produto'
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
          FieldName = 'DESCRICAO'
          Title.Caption = 'Descri'#231#227'o'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Width = 350
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'NCM'
          Title.Alignment = taCenter
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Width = 80
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'CFOP_PADRAO'
          Title.Alignment = taCenter
          Title.Caption = 'CFOP'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PRECO_VENDA'
          Title.Alignment = taRightJustify
          Title.Caption = 'Pre'#231'o Venda'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Width = 138
          Visible = True
        end>
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 544
    Width = 786
    Panels = <
      item
        Width = 50
      end>
    ExplicitTop = 544
    ExplicitWidth = 786
  end
  object pnlCampos: TPanel [3]
    Left = 0
    Top = 58
    Width = 786
    Height = 104
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 3
    object lblIdProduto: TLabel
      Left = 8
      Top = 8
      Width = 106
      Height = 13
      Caption = 'C'#243'digo do Produto:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCfopPadrao: TLabel
      Left = 184
      Top = 56
      Width = 74
      Height = 13
      Caption = 'CFOP Padr'#227'o:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblDescricao: TLabel
      Left = 184
      Top = 8
      Width = 58
      Height = 13
      Caption = 'Descri'#231#227'o:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPrecoVenda: TLabel
      Left = 484
      Top = 56
      Width = 73
      Height = 13
      Caption = 'Pre'#231'o Venda:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblNcm: TLabel
      Left = 8
      Top = 56
      Width = 27
      Height = 13
      Caption = 'NCM:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtIdProduto: TEdit
      Left = 8
      Top = 24
      Width = 170
      Height = 21
      Enabled = False
      NumbersOnly = True
      TabOrder = 0
    end
    object edtDescricao: TEdit
      Left = 184
      Top = 24
      Width = 594
      Height = 21
      TabOrder = 1
    end
    object edtCfopPadrao: TEdit
      Left = 184
      Top = 72
      Width = 294
      Height = 21
      NumbersOnly = True
      TabOrder = 3
    end
    object edtPrecoVenda: TEdit
      Left = 484
      Top = 72
      Width = 294
      Height = 21
      Alignment = taRightJustify
      TabOrder = 4
      OnChange = edtPrecoVendaChange
      OnClick = edtPrecoVendaClick
    end
    object edtNcm: TMaskEdit
      Left = 8
      Top = 72
      Width = 170
      Height = 21
      EditMask = '9999.99.99;0;_'
      MaxLength = 10
      TabOrder = 2
      Text = ''
    end
  end
  inherited dtsDBGrid: TDataSource
    Top = 480
  end
end
