// Exemplo didático independente. Não reproduz a função corporativa.
(tabela as table, termo as text, coluna as text, optional delimitador as nullable text) as nullable text =>
let
    VerificarColuna = Table.HasColumns(tabela, {coluna}),
    Correspondencias = if VerificarColuna then Table.FindText(tabela, termo) else #table({coluna}, {}),
    PrimeiroValor = if Table.IsEmpty(Correspondencias) then null else try Text.From(Record.Field(Correspondencias{0}, coluna)) otherwise null,
    TextoExtraido = if PrimeiroValor = null then null else if delimitador <> null and delimitador <> "" and Text.Contains(PrimeiroValor, delimitador) then Text.AfterDelimiter(PrimeiroValor, delimitador) else PrimeiroValor,
    Resultado = if TextoExtraido = null then null else Text.Trim(TextoExtraido)
in
    Resultado
