// Exemplo independente: segundo layout fictício, com dados ilustrativos.
let
    Origem = #table(type table [Arquivo=text, Pagina=Int64.Type, Documento=text, Total=text], {
        {"demo_b.pdf",3,"Documento 22222222222","R$ 250,00"},
        {"demo_b.pdf",4,"Documento 44444444444","R$ 90,00"}}),
    identificador = Table.AddColumn(Origem,"id_beneficiario",each Text.AfterDelimiter([Documento],"Documento "),type text),
    Valor = Table.AddColumn(identificador,"Valor_Total",each try Number.FromText(Text.Replace([Total],"R$ ",""),"pt-BR") otherwise null,type nullable number),
    Banco = Table.AddColumn(Valor,"Banco",each "Modelo B (fictício)", type text),
    Resultado = Table.SelectColumns(Banco,{"Arquivo","Pagina","id_beneficiario","Valor_Total","Banco"})
in Resultado
