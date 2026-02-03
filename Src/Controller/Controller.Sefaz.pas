unit Controller.Sefaz;

interface

uses
  System.SysUtils, Data.DB, FireDAC.Comp.Client, untDM, Model.Connection, FireDAC.Stan.Param,
  Controller.EventoNFe, Controller.LogEvento, ACBrNFe;

type
  TSefaz = class
    private
      FTipoPessoa: string;
      FExterno: boolean;
      FContingiencia: integer;
    public
      Constructor Create;
      Destructor Destroy; override;

      property TipoPessoa: string read FTipoPessoa write FTipoPessoa;
      property Externo: boolean read FExterno write FExterno;
      property Contingiencia: Integer read FContingiencia write FContingiencia;

      function CancelarNFe(pIdLote: integer; pArquivoXML, pChaveNFe, pJustificativa, pCNPJ: string): string;
      function SefazRecebeEValidaXML(pArquivoXML: string): string;

      //Cliente
      function ValidarCPF(pCPF: string): boolean;
      function ValidarCNPJ(pCNPJ: string): boolean;
      function ValidarNomeCliente(pNomeCliente: string): boolean;
      function ValidarUFCliente(pUFCliente: string): boolean;

      //Produto
      function ValidarNomeProduto(pNomeProduto: string): boolean;
      function ValidarNCM(pNCM: string): boolean;
      function ValidarCFOP(pCFOP: string): boolean;
      function ValidarQuantidade(pQuantidade: double): boolean;
      function ValidarPrecoVenda(pPrecoVenda: double): boolean;
      function ValidarValorTotal(pValorTotal: double): boolean;
  end;

implementation

{ TSefaz }

uses untPrincipal;

function TSefaz.CancelarNFe(pIdLote: integer; pArquivoXML, pChaveNFe, pJustificativa, pCNPJ: string): string;
var
  iNFe, iIdLog: integer;
  sResultado, sChaveNFe, sCNPJ, sMensagem, sErro: string;
  ACBrNFe1: TACBrNFe;
begin
  sResultado := EmptyStr;
  ACBrNFe1 := TACBrNFe.Create(nil);
  ACBrNFe1.NotasFiscais.Add;
  ACBrNFe1.NotasFiscais.Clear;
  try
    try
      ACBrNFe1.NotasFiscais.LoadFromFile(pArquivoXML);
      iNFe := ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.nNF;

      //Validar Chave
      sChaveNFe := ACBrNFe1.NotasFiscais.Items[0].NFe.infNFe.ID;
      sChaveNFe := copy(sChaveNFe, 4, 44);
      if sChaveNFe <> pChaveNFe then
        begin
          sMensagem := sMensagem + '604 - Rejeição: Chave de acesso informada inválida da NFe Nro: ' + IntToStr(iNFe);
          sResultado := 'REJEITADO';
        end;

      //Validar CNPJ do Emitente
      sCNPJ := ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.CNPJCPF;
      if sCNPJ <> pCNPJ then
        begin
          sMensagem := sMensagem + '207 - Rejeição 207: CNPJ do emitente inválido da NFe Nro: ' + IntToStr(iNFe);
          sResultado := 'REJEITADO';
        end;

      if sResultado = EmptyStr then
        begin
          iIdLog := ListarCodigoUltimoLogEvento(sErro) + 1;
          sMensagem := sMensagem + '101 - Cancelamento: Cancelamento homologado da NFe Nro: ' + IntToStr(iNFe);
          InserirLogEvento(iIdLog, 'TSefaz', 'CANCELAMENTO DE NFE', sMensagem, sErro);
          sResultado := 'HOMOLOGADO;' + sMensagem;
        end
      else
        begin
          iIdLog := ListarCodigoUltimoLogEvento(sErro) + 1;
          InserirLogEvento(iIdLog, 'TSefaz', 'CANCELAMENTO DE NFE', sMensagem, sErro);
          sResultado := 'REJEITADO;' + sMensagem;
        end;

    except
      result := 'Arquivo NFe Inválido';
      exit;
    end;
  finally
    result := sResultado;
    ACBrNFe1.Free;
  end;
end;

constructor TSefaz.Create;
begin
  Model.Connection.Conecta;
end;

destructor TSefaz.Destroy;
begin
  Model.Connection.Desconecta;
end;

function TSefaz.SefazRecebeEValidaXML(pArquivoXML: string): string;
var
  sNomeCliente, sCPFCNPJ, sUF: string;
  sNCM, sCfop, sNomeProduto, sMensagem: string;
  sErro, sResultado: string;
  bResultado: boolean;
  iNFe, i, iIdLog: integer;
  dQuantidade, dPrecoVenda, dValorTotal: double;
  ACBrNFe1: TACBrNFe;
begin
  sResultado := EmptyStr;

  if FContingiencia = 1 then
    begin
      iIdLog := ListarCodigoUltimoLogEvento(sErro) + 1;
      sMensagem := 'Sistema indisponível';
      InserirLogEvento(iIdLog, 'TSefaz',
        'SIMULAÇÃO RETORNO SEFAZ', sMensagem, sErro);
      sResultado := 'CONTINGENCIA;' + sMensagem;
      result := sResultado;
      exit;
    end;

  ACBrNFe1 := TACBrNFe.Create(nil);
  ACBrNFe1.NotasFiscais.Add;
  ACBrNFe1.NotasFiscais.Clear;
  try
    try
      ACBrNFe1.NotasFiscais.LoadFromFile(pArquivoXML);
      iNFe := ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.nNF;

      //Cliente
      sNomeCliente := ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.xNome;
      bResultado := ValidarNomeCliente(sNomeCliente);
      if not bResultado then
        begin
          sMensagem := sMensagem + 'Nome de cliente em branco na NFe Nro: ' + IntToStr(iNFe) +#13+#13;
          sResultado := 'REJEITADA';
        end;

      sUF := ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.UF;
      bResultado := ValidarUFCliente(sUF);
      if not bResultado then
        begin
          sMensagem := sMensagem + 'UF do cliente em branco na NFe Nro: ' + IntToStr(iNFe) +#13+#13;
          sResultado := 'REJEITADA';
        end;

      if FTipoPessoa = EmptyStr then
        begin
          sMensagem := sMensagem + 'CPF/CNPJ Inválido na NFe Nro: ' + IntToStr(iNFe) +#13+#13;
          sResultado := 'REJEITADA';
        end;

      sCPFCNPJ := ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.CNPJCPF;
      if FTipoPessoa = 'F' then
        begin
          bResultado := ValidarCPF(sCPFCNPJ);
          if not bResultado then
            begin
              sMensagem := sMensagem + 'CPF Inválido na NFe Nro: ' + IntToStr(iNFe) +#13+#13;
              sResultado := 'REJEITADA';
            end;
        end;

      if FTipoPessoa = 'J' then
        begin
          bResultado := ValidarCNPJ(sCPFCNPJ);
          if not bResultado then
            begin
              sMensagem := sMensagem + 'CNPJ Inválido na NFe Nro: ' + IntToStr(iNFe) +#13+#13;
              sResultado := 'REJEITADA';
            end;
        end;

      //Produtos
      for i := 0 to ACBrNFe1.NotasFiscais.Items[0].NFe.Det.Count-1 do
        begin
          //Validar Nome do Produto
          sNomeProduto := ACBrNFe1.NotasFiscais.Items[0].NFe.Det.Items[i].Prod.xProd;
          bResultado := ValidarNomeProduto(sNomeProduto);
          if not bResultado then
            begin
              sMensagem := sMensagem + 'Nome do Produto em branco da NFe Nro: ' + IntToStr(iNFe) +#13+#13;
              sResultado := 'REJEITADA';
            end;

          //Validar NCM
          sNCM := ACBrNFe1.NotasFiscais.Items[0].NFe.Det.Items[i].Prod.NCM;
          bResultado := ValidarNCM(sNCM);
          if not bResultado then
            begin
              sMensagem := sMensagem + 'NCM Inválido do Produto ' + sNomeProduto + ' da NFe Nro: ' + IntToStr(iNFe) +#13+#13;
              sResultado := 'REJEITADA';
            end;

          //Validar CFOP
          sCfop := ACBrNFe1.NotasFiscais.Items[0].NFe.Det.Items[i].Prod.CFOP;
          bResultado := ValidarCFOP(sCfop);
          if not bResultado then
            begin
              sMensagem := sMensagem + 'CFOP Inválido do Produto ' + sNomeProduto + ' da NFe Nro: ' + IntToStr(iNFe) +#13+#13;
              sResultado := 'REJEITADA';
            end;

          //Validar Quantidade
          dQuantidade := ACBrNFe1.NotasFiscais.Items[0].NFe.Det.Items[i].Prod.qCom;
          bResultado := ValidarQuantidade(dQuantidade);
          if not bResultado then
            begin
              sMensagem := sMensagem + 'Quantidade vazia do Produto ' + sNomeProduto + ' da NFe Nro: ' + IntToStr(iNFe) +#13+#13;
              sResultado := 'REJEITADA';
            end;

          //Validar Preço Venda
          dPrecoVenda := ACBrNFe1.NotasFiscais.Items[0].NFe.Det.Items[i].Prod.vUnCom;
          bResultado := ValidarPrecoVenda(dPrecoVenda);
          if not bResultado then
            begin
              sMensagem := sMensagem + 'Preço de Venda vazio do Produto ' + sNomeProduto + ' da NFe Nro: ' + IntToStr(iNFe) +#13+#13;
              sResultado := 'REJEITADA';
            end;

          //Validar Valor Total
          dValorTotal := ACBrNFe1.NotasFiscais.Items[0].NFe.Det.Items[i].Prod.vProd;
          bResultado := ValidarPrecoVenda(dValorTotal);
          if not bResultado then
            begin
              sMensagem := sMensagem + 'Valor Total vazio do Produto ' + sNomeProduto + ' da NFe Nro: ' + IntToStr(iNFe) +#13+#13;
              sResultado := 'REJEITADA';
            end;
        end;

      if sResultado = EmptyStr then
        begin
          if not FExterno then
            begin
              iIdLog := ListarCodigoUltimoLogEvento(sErro) + 1;
              InserirLogEvento(iIdLog, 'TSefaz', 'SIMULAÇÃO RETORNO SEFAZ', sMensagem, sErro);
            end;
          sMensagem := 'Autorizado o uso da NF-e ' + IntToStr(iNFe);
          sResultado := 'AUTORIZADA;' + sMensagem;
        end
      else
        begin
          if not FExterno then
            begin
              iIdLog := ListarCodigoUltimoLogEvento(sErro) + 1;
              InserirLogEvento(iIdLog, 'TSefaz', 'SIMULAÇÃO RETORNO SEFAZ', sMensagem, sErro);
            end;
          sResultado := 'REJEITADA;' + sMensagem;
        end;
    except
      result := 'Arquivo NFe Inválido';
      exit;
    end;
  finally
    result := sResultado;
    ACBrNFe1.Free;
  end;
end;

function TSefaz.ValidarCNPJ(pCNPJ: string): boolean;
begin
  result := true;
  if Length(pCNPJ) <> 14 then
    result := false;
end;

function TSefaz.ValidarCPF(pCPF: string): boolean;
begin
  result := true;
  if Length(pCPF) <> 11 then
    result := false;
end;

function TSefaz.ValidarNomeProduto(pNomeProduto: string): boolean;
begin
  result := true;
  if pNomeProduto = EmptyStr then
    result := false;
end;

function TSefaz.ValidarNCM(pNCM: string): boolean;
begin
  result := true;
  if Length(pNCM) <> 8 then
    result := false;
end;

function TSefaz.ValidarCFOP(pCFOP: string): boolean;
begin
  result := true;
  if Length(pCFOP) <> 4 then
    result := false;
end;

function TSefaz.ValidarNomeCliente(pNomeCliente: string): boolean;
begin
  result := true;
  if pNomeCliente = EmptyStr then
    result := false;
end;

function TSefaz.ValidarQuantidade(pQuantidade: double): boolean;
begin
  result := true;
  if pQuantidade = 0 then
    result := false;
end;

function TSefaz.ValidarPrecoVenda(pPrecoVenda: double): boolean;
begin
  result := true;
  if pPrecoVenda = 0 then
    result := false;
end;

function TSefaz.ValidarValorTotal(pValorTotal: double): boolean;
begin
  result := true;
  if pValorTotal = 0 then
    result := false;
end;

function TSefaz.ValidarUFCliente(pUFCliente: string): boolean;
begin
  result := true;
  if pUFCliente = EmptyStr then
    result := false;
end;

end.
