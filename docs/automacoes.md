# Automações

## Fluxos Cloud

Todos são disparados pelo Power Apps (gatilho V2) e seguem o mesmo esqueleto: validar entrada, executar, registrar status, notificar.

| Fluxo | Entrada | O que faz | Saída |
|---|---|---|---|
| Importar comprovantes | Arquivos selecionados no app | Grava os PDFs na biblioteca de comprovantes e registra a importação | Confirmação no app |
| Importar bases | Arquivos de referência | Limpa a versão anterior, grava as novas bases, valida colunas obrigatórias | Confirmação no app e status "bases atualizadas" |
| Executar separação | Competência e confirmação do usuário | Aciona o fluxo Desktop de separação, aguarda, lê o log e consolida o resultado | Cartão no Teams com status, bases usadas e link para a saída |
| Extrair por identificador | Lista de CPFs/CNPJs | Aciona o fluxo Desktop de extração, separa encontrados de não encontrados | Cartão no Teams com as duas listas |

Padrões adotados:

- As variáveis são inicializadas no início do fluxo e preenchidas a partir do `Parse JSON` da entrada, para que erros de formato apareçam cedo.
- Loops e condições ficam dentro de um `Scope` para capturar falhas em um único ponto.
- O fluxo Cloud nunca manipula PDF; só move arquivos e coordena.

## Fluxos Desktop

Dois fluxos independentes, cada um com um `Main` curto e subfluxos por responsabilidade.

### Separação de comprovantes

`Main` faz apenas: definir nome do fluxo e identificador de sessão, registrar início, chamar os subfluxos dentro de um bloco de erro, registrar fim e devolver status.

Subfluxos:

1. Limpar pastas de trabalho da competência anterior.
2. Baixar os PDFs e as bases do SharePoint para a pasta de trabalho.
3. Atualizar as consultas e ler a saída operacional.
4. Para cada linha da saída, extrair as páginas indicadas do PDF de origem e salvar no destino (ano/mês, cliente, contrato).
5. Gerar o log da execução (linhas processadas, arquivos gerados, erros).
6. Enviar os arquivos e o log de volta ao SharePoint.

### Extração por identificador

Mesma estrutura, com um único subfluxo de trabalho: para cada identificador recebido, localizar as páginas correspondentes na saída do pipeline A, extrair e salvar em uma pasta da solicitação; devolver as listas de encontrados e não encontrados.

## Tratamento de erro

- Cada execução tem um `session_id` gerado no início; ele aparece no log, nos nomes de pasta temporária e no cartão do Teams.
- Os subfluxos rodam dentro de um bloco "em caso de erro". Se algo falha, o `Main` captura a mensagem, o subfluxo e a ação, grava no log e devolve status de erro.
- O usuário recebe sempre uma notificação, de sucesso ou de falha, sem precisar abrir o Power Automate.

## Como mostrar isso no portfólio

Este repositório descreve os fluxos por responsabilidade e padrões, em vez de expor exportações ou capturas de um ambiente real. Para quem quiser reproduzir, a estrutura acima é suficiente para montar os fluxos em um ambiente do Power Apps Developer Plan.