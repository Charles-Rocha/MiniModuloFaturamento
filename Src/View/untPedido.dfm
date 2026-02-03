inherited frmPedidos: TfrmPedidos
  Caption = 'Pedidos'
  StyleElements = [seFont, seClient, seBorder]
  TextHeight = 13
  inherited pnlBotoes: TPanel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited pnlDBGrid: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited dbgBaseCadastro: TDBGrid
      DataSource = dtsDBGrid
    end
  end
end
