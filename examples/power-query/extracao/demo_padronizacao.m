// DEMONSTRACAO INDEPENDENTE: todos os dados sao ficticios.
// Cole no Editor Avancado do Power Query (consulta em branco).
let
    BancoA = #table(
        type table [Instituicao = text, DataPagamento = text, ValorPago = text, Beneficiario = text],
        {{"Banco Exemplo A", "10/10/2026", "1.250,50", "Empresa Exemplo A"}}
    ),
    BancoB = #table(
        type table [Banco = text, DataOperacao = text, Total = text, Favorecido = text],
        {{"Banco Exemplo B", "11-10-2026", "R$ 900,30", "Empresa Exemplo B"}}
    ),
    PadronizarA = Table.RenameColumns(BancoA, {
        {"Instituicao", "banco"}, {"DataPagamento", "data_texto"},
        {"ValorPago", "valor_texto"}, {"Beneficiario", "recebedor"}
    }),
    PadronizarB = Table.RenameColumns(BancoB, {
        {"Banco", "banco"}, {"DataOperacao", "data_texto"},
        {"Total", "valor_texto"}, {"Favorecido", "recebedor"}
    }),
    Consolidar = Table.Combine({PadronizarA, PadronizarB}),
    NormalizarDatas = Table.TransformColumns(Consolidar, {
        {"data_texto", each Text.Replace(_, "-", "/"), type text}
    }),
    LimparMoeda = Table.TransformColumns(NormalizarDatas, {
        {"valor_texto", each Text.Trim(Text.Replace(_, "R$", "")), type text}
    }),
    Tipos = Table.TransformColumns(LimparMoeda, {
        {"data_texto", each Date.FromText(_, [Culture = "pt-BR"]), type date},
        {"valor_texto", each Number.FromText(_, "pt-BR"), type number}
    }),
    Renomear = Table.RenameColumns(Tipos, {
        {"data_texto", "data_transacao"}, {"valor_texto", "valor"}
    }),
    Final = Table.ReorderColumns(Renomear, {"banco", "data_transacao", "valor", "recebedor"})
in
    Final
