// LISTAR AS COPAS DO MUNDO
MATCH (n:CopaDoMundo) RETURN n

// COPAS DO MUNDO QUE A RUSSIA JOGOU
MATCH (n:CopaDoMundo)-[:COMPOSTA_POR]->()<-[:JOGOU_EM]->(p:Pais) 
WHERE p.nome="Russia"
RETURN n,p

// COPAS DO MUNDO QUE O BRASIL DISPUTOU A FINAL?
MATCH (c:CopaDoMundo)-[:COMPOSTA_POR]->(jogo)-[:TIME_DA_CASA|:TIME_VISITANTE]->(pais:Pais) 
MATCH (jogo)-[:NA_FASE]->(f:Fase {nome: "Final"})
WHERE pais.nome="Brazil"
RETURN c,pais

// QUE PAISES HOSPEDARAM MAIS DE UMA COPA
MATCH (copa)-[:ORGANIZADA_POR]->(host:Pais)
WITH host,count(copa) as rel, collect(copa)as copas
WHERE  rel > 1
return copas,host

// EXISTE ALGUMA COPA QUE FOI ORGANIZADA POR 2 PAISES?
MATCH (copa)-[:ORGANIZADA_POR]->(host:Pais)
WITH copa,count(host) as rel, collect(host)as hosts
WHERE  rel > 1
return copa,hosts


//
// CONSULTAS COMPLEXAS
// Convocados da seleção Brasileira em 1994

MATCH (p:Pais {nome: "Brazil"})-[:CONVOCOU]->(selecao),
      (selecao)-[:PARA_A_COPA]->(copa)-[:REALIZADA_EM]->(ano {year: 1994}),
      (selecao)<-[:JOGOU_POR]-(jogador)
RETURN p, selecao, ano, copa, jogador

//
// Jogadores que não foram utilizados nas copas
//MATCH (a)-[:JOGOU_POR]->(b) 
//WHERE not ( (a)-[:TITULAR|:RESERVA]->()) 
//RETURN b,count(a) 
//order by count(a) desc


//TIMES QUE ESTIVERAM QUE HOSPEDARAM E FORAM PARA A FINAL
MATCH (fase:Fase {nome: "Final"})<-[:NA_FASE]-(partida),
	   (copa:CopaDoMundo)-[:COMPOSTA_POR]->(partida),
       (partida)<-[:JOGOU_EM]-(pais:Pais),
	   (copa)-[:ORGANIZADA_POR]->(pais)
RETURN pais.nome,partida.descricao,copa.nome
//RETURN pais,partida,copa


//PAISES QUE HOSPEDARAM A COPA E GANHARAM
MATCH (fase:Fase {nome: "Final"})<-[:NA_FASE]-(partida),
		(partida)-[rel:TIME_DA_CASA|TIME_VISITANTE]->(pais:Pais),
		(copa:CopaDoMundo)-[:COMPOSTA_POR]->(partida),
		(copa)-[:ORGANIZADA_POR]->(pais)
WITH partida,copa,pais,rel,
CASE WHEN TYPE(rel) = "TIME_DA_CASA"
	THEN TOINT(partida.placar_casa) - TOINT(partida.placar_visitante)
	ELSE TOINT(partida.placar_visitante) - TOINT(partida.placar_casa)
    END AS resultado_partida
WHERE resultado_partida > 0
RETURN pais.nome,partida.descricao,copa.nome

//
// 


