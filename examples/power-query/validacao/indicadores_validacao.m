// Exemplo independente com quatro joins e indicadores de presença versus valor.
let
    Eventos = #table(type table [Evento=text,identificador=text,Agencia=text,Conta=text,Valor=number], {
      {"EV-001","11111111111","010","001",120},
      {"EV-002","22222222222","020","002",250},
      {"EV-003","33333333333","030","003",75}}),
    Comprovantes = #table(type table [Arquivo=text,Pagina=Int64.Type,id_beneficiario=text,Agencia=text,Conta=text,Valor_Total=number], {
      {"demo_a.pdf",1,"11111111111","010","001",120},
      {"demo_b.pdf",2,"99999999999","020","002",250},
      {"demo_c.pdf",3,"33333333333","030","003",80}}),
    J1 = Table.NestedJoin(Eventos,{"identificador"},Comprovantes,{"id_beneficiario"},"ID_JOIN",JoinKind.LeftOuter),
    J2 = Table.NestedJoin(J1,{"identificador","Valor"},Comprovantes,{"id_beneficiario","Valor_Total"},"ID_VAL_JOIN",JoinKind.LeftOuter),
    J3 = Table.NestedJoin(J2,{"Agencia","Conta"},Comprovantes,{"Agencia","Conta"},"AG_JOIN",JoinKind.LeftOuter),
    J4 = Table.NestedJoin(J3,{"Agencia","Conta","Valor"},Comprovantes,{"Agencia","Conta","Valor_Total"},"AG_VAL_JOIN",JoinKind.LeftOuter),
    IdExiste = Table.AddColumn(J4,"id_existe",each if Table.IsEmpty([ID_JOIN]) then "Não" else "Sim",type text),
    ContaExiste = Table.AddColumn(IdExiste,"conta_existe",each if Table.IsEmpty([AG_JOIN]) then "Não" else "Sim",type text),
    ValorId = Table.AddColumn(ContaExiste,"valor_confere_id",each if Table.IsEmpty([ID_VAL_JOIN]) then "Não" else "Sim",type text),
    ValorConta = Table.AddColumn(ValorId,"valor_confere_conta",each if Table.IsEmpty([AG_VAL_JOIN]) then "Não" else "Sim",type text),
    Tem = Table.AddColumn(ValorConta,"comprovante_localizado",each if [valor_confere_conta]="Sim" or [valor_confere_id]="Sim" then "Sim" else "Não",type text),
    Resultado = Table.RemoveColumns(Tem,{"ID_JOIN","ID_VAL_JOIN","AG_JOIN","AG_VAL_JOIN"})
in Resultado
