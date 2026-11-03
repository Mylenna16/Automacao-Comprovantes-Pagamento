# Exemplos de Power Query (Linguagem M)

Todos os dados são fictícios e estão embutidos no código. Nenhum arquivo depende de fonte externa; cole cada um em uma consulta em branco no Editor Avançado.

## Extração (pipeline A)

| Arquivo | O que demonstra |
|---|---|
| `funcoes/buscar_valor.m` | Função que localiza um termo em uma tabela de texto e devolve o trecho após um delimitador |
| `extracao/modelo_bancario_a.m` | Layout fictício com rótulos "identificador:" e "Valor:" em linhas separadas; agrupa por página e extrai |
| `extracao/modelo_bancario_b.m` | Segundo layout fictício, com identificador e valor na mesma linha e moeda formatada |
| `extracao/consolidacao.m` | União dos dois modelos com `Table.Combine` e conversão de tipos (requer as duas consultas acima com esses nomes) |
| `extracao/demo_padronizacao.m` | Renomeação de colunas, normalização de datas e limpeza de moeda em dois layouts |

## Cruzamento e validação (pipeline B)

| Arquivo | O que demonstra |
|---|---|
| `validacao/conciliacao_pagamentos.m` | Dois left joins alternativos, escolha de origem, arquivo e páginas agrupadas (saída operacional) |
| `validacao/indicadores_validacao.m` | Quatro left joins e os indicadores de existência e de valor (saída de conferência) |
| `validacao/demo_cruzamento_ficticio.m` | Versão mínima da mesma ideia, para leitura rápida |

As saídas esperadas estão ilustradas em `../../assets/images/power-query/`.