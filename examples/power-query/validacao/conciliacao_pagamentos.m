// Exemplo executável e fictício: prioriza agência + conta + valor e, em seguida, identificador + valor.
let
    Eventos = #table(type table [Evento=text,identificador=text,Agencia=text,Conta=text,Valor=number,Cliente=text], {
      {"EV-001","11111111111","010","001",120,"Cliente A"},
      {"EV-002","22222222222","020","002",250,"Cliente B"},
      {"EV-003","33333333333","030","003",75,"Cliente C"}}),
    Comprovantes = #table(type table [Arquivo=text,Pagina=Int64.Type,id_beneficiario=text,Agencia=text,Conta=text,Valor_Total=number], {
      {"demo_a.pdf",1,"11111111111","010","001",120},
      {"demo_b.pdf",2,"99999999999","020","002",250},
      {"demo_c.pdf",3,"33333333333","030","003",80}}),
    JoinId = Table.NestedJoin(Eventos,{"identificador","Valor"},Comprovantes,{"id_beneficiario","Valor_Total"},"PorId",JoinKind.LeftOuter),
    JoinAG = Table.NestedJoin(JoinId,{"Agencia","Conta","Valor"},Comprovantes,{"Agencia","Conta","Valor_Total"},"PorConta",JoinKind.LeftOuter),
    Origem = Table.AddColumn(JoinAG,"Origem", each if not Table.IsEmpty([PorConta]) then "conta" else if not Table.IsEmpty([PorId]) then "identificador" else "NAO_ENCONTRADO",type text),
    Arquivo = Table.AddColumn(Origem,"arquivo_destino",each if [Origem]="conta" then [PorConta]{0}[Arquivo] else if [Origem]="identificador" then [PorId]{0}[Arquivo] else "nao_localizado",type text),
    Pagina = Table.AddColumn(Arquivo,"Paginas",each if [Origem]="conta" then Text.Combine(List.Transform([PorConta][Pagina],Text.From),",") else if [Origem]="identificador" then Text.Combine(List.Transform([PorId][Pagina],Text.From),",") else "0",type text),
    Resultado = Table.RemoveColumns(Pagina,{"PorId","PorConta"})
in Resultado
