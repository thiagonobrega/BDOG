USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/thiagonobrega/bdog/master/neo4j-worldcup/data/import/matches.csv" AS csvLine

WITH csvLine, toInt(csvLine.match_number) AS matchNumber 

MERGE (match:Partida {id: csvLine.id})
SET match.placar_casa = csvLine.h_score,
    match.placar_visitante = csvLine.a_score,
    match.publico = csvLine.attendance,
    match.data = csvLine.date,
    match.descricao = csvLine.home + " vs. " + csvLine.away,
    match.numero = toInt(matchNumber)


MERGE (home:Pais {nome: csvLine.home})
MERGE (match)-[:TIME_DA_CASA]->(home)
MERGE (match)<-[:JOGOU_EM]-(home)

MERGE (away:Pais {nome: csvLine.away})
MERGE (match)-[:TIME_VISITANTE]->(away)
MERGE (match)<-[:JOGOU_EM]-(away)

MERGE (year:Ano {year: toInt(csvLine.year)})

MERGE (worldCup:CopaDoMundo {nome: csvLine.world_cup})
ON CREATE SET worldCup.ano = toInt(csvLine.year)

MERGE (match)<-[:COMPOSTA_POR]-(worldCup)

FOREACH(i IN CASE WHEN csvLine.host = "Korea/Japan" THEN [1] ELSE [] END |
	MERGE (host1:Pais {nome: "Korea Republic"})
	MERGE (host2:Pais {nome: "Japan"})
	MERGE (host1)<-[:ORGANIZADA_POR]-(worldCup)
	MERGE (host2)<-[:ORGANIZADA_POR]-(worldCup))

FOREACH(i IN CASE WHEN csvLine.host <> "Korea/Japan" THEN [1] ELSE [] END |
	MERGE (host:Pais {nome: csvLine.host})
	MERGE (host)<-[:ORGANIZADA_POR]-(worldCup))

MERGE (year)<-[:REALIZADA_EM]-(worldCup)

MERGE (stadium:Estadio {nome: csvLine.stadium})
MERGE (match)-[:DISPUTADA_NO]->(stadium)

MERGE (p:Fase {nome: csvLine.phase})
MERGE (match)-[:NA_FASE]->(p)

// nao e necessario para o exemplo
//MERGE (time:Time {time: csvLine.time})
//MERGE (match)-[:PLAYED_AT_TIME]->(time);