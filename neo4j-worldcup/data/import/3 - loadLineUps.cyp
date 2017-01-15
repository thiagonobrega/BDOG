USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/thiagonobrega/BDOG/master/data/import/lineups.csv" AS csvLine

MATCH (home)<-[:TIME_DA_CASA]-(match:Partida {id: csvLine.match_id})-[:TIME_VISITANTE]->(away)
MATCH (player:Jogador {id: csvLine.player_id})
MATCH (wc:CopaDoMundo {nome: csvLine.world_cup})
MATCH (wc)<-[:PARA_A_COPA]-()<-[:JOGOU_POR]-(player)

// home players
FOREACH(n IN (CASE csvLine.team WHEN "home" THEN [1] else [] END) |
	FOREACH(o IN (CASE csvLine.type WHEN "starting" THEN [1] else [] END) |
		MERGE (match)-[:TIME_DA_CASA]->(home)
		MERGE (player)-[:TITULAR]->(Estatisticas)-[:NA_PARTIDA]->(match)
	)

	FOREACH(o IN (CASE csvLine.type WHEN "sub" THEN [1] else [] END) |
		MERGE (match)-[:TIME_DA_CASA]->(home)
		MERGE (player)-[:RESERVA]->(Estatisticas)-[:NA_PARTIDA]->(match)
	)	
)

// away players
FOREACH(n IN (CASE csvLine.team WHEN "away" THEN [1] else [] END) |
	FOREACH(o IN (CASE csvLine.type WHEN "starting" THEN [1] else [] END) |
		MERGE (match)-[:TIME_VISITANTE]->(away)
		MERGE (player)-[:TITULAR]->(Estatisticas)-[:NA_PARTIDA]->(match)
	)

	FOREACH(o IN (CASE csvLine.type WHEN "sub" THEN [1] else [] END) |
		MERGE (match)-[:TIME_VISITANTE]->(away)
		MERGE (player)-[:RESERVA]->(Estatisticas)-[:NA_PARTIDA]->(match)
	)	
)
;