// Requer que as consultas modelo_bancario_a e modelo_bancario_b existam com esses nomes.
// No projeto corporativo, a Query_Final combinava 12 consultas; aqui, duas consultas fictícias.
let
    Fonte = Table.Combine({modelo_bancario_a, modelo_bancario_b}),
    Resultado = Table.TransformColumnTypes(Fonte,{{"Arquivo",type text},{"Pagina",Int64.Type},{"id_beneficiario",type text},{"Valor_Total",type number},{"Banco",type text}})
in Resultado
