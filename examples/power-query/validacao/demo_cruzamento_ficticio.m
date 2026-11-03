// Demonstração DIDÁTICA: dados integralmente inventados e sem dependências corporativas.
// Cole em uma Consulta Nula do Power Query para visualizar a tabela resultante.
let
    Eventos = #table(
        type table [Evento = text, identificador = text, Agencia = text, Conta = text, Valor = number],
        {{"EV-A", "11111111111", "010", "001", 120.00},
         {"EV-B", "22222222222", "020", "002", 250.00},
         {"EV-C", "33333333333", "030", "003", 75.00}}
    ),
    Comprovantes = #table(
        type table [Arquivo = text, Pagina = Int64.Type, id_beneficiario = text, Agencia = text, Conta = text, Valor_Total = number],
        {{"exemplo_a.pdf", 1, "11111111111", "010", "001", 120.00},
         {"exemplo_b.pdf", 2, "00000000000", "020", "002", 250.00},
         {"exemplo_c.pdf", 3, "33333333333", "030", "003", 80.00}}
    ),
    JoinId = Table.NestedJoin(Eventos, {"identificador", "Valor"}, Comprovantes, {"id_beneficiario", "Valor_Total"}, "Id_Valor", JoinKind.LeftOuter),
    JoinConta = Table.NestedJoin(JoinId, {"Agencia", "Conta", "Valor"}, Comprovantes, {"Agencia", "Conta", "Valor_Total"}, "Conta_Valor", JoinKind.LeftOuter),
    ComStatus = Table.AddColumn(JoinConta, "comprovante_localizado", each if not Table.IsEmpty([Conta_Valor]) or not Table.IsEmpty([Id_Valor]) then "Sim" else "Não", type text),
    ComOrigem = Table.AddColumn(ComStatus, "Origem", each if not Table.IsEmpty([Conta_Valor]) then "conta" else if not Table.IsEmpty([Id_Valor]) then "identificador" else "NAO_ENCONTRADO", type text),
    ComArquivo = Table.AddColumn(ComOrigem, "Arquivo_Exemplo", each if [Origem] = "conta" then [Conta_Valor]{0}[Arquivo] else if [Origem] = "identificador" then [Id_Valor]{0}[Arquivo] else null, type nullable text),
    Resultado = Table.RemoveColumns(ComArquivo, {"Id_Valor", "Conta_Valor"})
in
    Resultado
