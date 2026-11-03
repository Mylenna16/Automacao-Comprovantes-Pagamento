// Exemplo independente com texto e valores inventados; consulta pode ser colada no Editor Avançado.
let
    Linhas = #table(type table [Arquivo=text, Pagina=Int64.Type, Descricao=text], {
        {"demo_a.pdf", 1, "identificador: 11111111111"},
        {"demo_a.pdf", 1, "Valor: 120,00"},
        {"demo_a.pdf", 2, "identificador: 33333333333"},
        {"demo_a.pdf", 2, "Valor: 80,00"}}),
    PorPagina = Table.Group(Linhas, {"Arquivo","Pagina"}, {{"Conteudo", each [Descricao], type list}}),
    Extrair = (lista as list, rotulo as text) as nullable text => let x = List.Select(lista, each Text.StartsWith(_,rotulo)) in if List.IsEmpty(x) then null else Text.Trim(Text.AfterDelimiter(x{0}, ":")),
    identificador = Table.AddColumn(PorPagina,"id_beneficiario",each Extrair([Conteudo],"identificador:"), type nullable text),
    Valor = Table.AddColumn(identificador,"Valor_Total",each try Number.FromText(Extrair([Conteudo],"Valor:"),"pt-BR") otherwise null, type nullable number),
    Banco = Table.AddColumn(Valor,"Banco",each "Modelo A (fictício)", type text),
    Resultado = Table.SelectColumns(Banco,{"Arquivo","Pagina","id_beneficiario","Valor_Total","Banco"})
in Resultado
