USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/thiagonobrega/bdog/master/neo4j-worldcup/data/import/events.csv" AS csvLine

MATCH (home)<-[:TIME_DA_CASA]-(match:Partida {id: csvLine.match_id})-[:TIME_VISITANTE]->(away)

MATCH (player:Jogador {id: csvLine.player_id})-[:JOGOU_POR]->(squad)<-[:CONVOCOU]-(team)
MATCH (player)-[:TITULA|:RESERVA]->(Estatisticas)-[:NA_PARTIDA]->(match)

// goals
FOREACH(n IN (CASE WHEN csvLine.type IN ["penalty", "goal", "owngoal"] THEN [1] else [] END) |
	FOREACH(t IN CASE WHEN team = home THEN [home] ELSE [away] END |
		MERGE (Estatisticas)-[:MARCOU_UM_GOL]->(penalty:Gol {tempo: csvLine.time, tipo: csvLine.type})
	)		
)

// cards
FOREACH(n IN (CASE WHEN csvLine.type IN ["yellow", "red", "yellowred"] THEN [1] else [] END) |
	FOREACH(t IN CASE WHEN team = home THEN [home] ELSE [away] END |
		MERGE (Estatisticas)-[:RECEBEU_CARTAO]->(Cartao {tempo: csvLine.time, tipo: csvLine.type})
	)		
)
;