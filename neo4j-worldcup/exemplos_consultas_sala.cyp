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





// show the phases
MATCH (p:Phase)
RETURN p