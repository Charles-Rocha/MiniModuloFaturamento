<h1 align="center">    
    <p>Decisões tomadas ao longo do desenvolvimento</p>
</h1>

- **Classe Sefaz**: Idealizada a criação de uma classe chamada Sefaz para simular o retorno do SEFAZ como solicitado no teste. Nessa classe eu valido todos os pontos possíveis com relação ao cadastro de clientes e produtos. Retornando para o chamador o status **REJEITADA** caso a validação falhe em algum ponto.

- **Criação do campo VL_TOTAL da tabela PEDIDO_ITEM**: Necessário para pode armazenar o cálculo dos campos **QUANTIDADE** x **VL_UNITARIO**, dispensando a necessidade de criar campo calculado. Servindo também para checagem do campo **TOTAL** da tabela **PEDIDO**.

- **Criação do campo CORRIGIR da tabela NFE**: Tomada a decisão de criar um campo a mais na tabela NFE para sinalizar com **S** caso o status de retorno da classe **Sefaz** seja **REJEITADA**. Essa flag ajuda a identificar um pedido que esteja com **Pendência de Correção** e ao realizar as devidas correções no que tange a cadastro de clientes e produtos, o documento XML da NFe é gerado novamente, antes de enviar a NFe novamente para a classe **Sefaz**.