USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/thiagonobrega/bdog/master/neo4j-worldcup/data/import/squads.csv" AS csvLine

MATCH (y:Ano {year: toInt(csvLine.year)})<-[:REALIZADA_EM]-(worldCup),
      (c:Pais {nome: csvLine.country})

MERGE (squad:Selecao {nome: c.nome + " selecao para a " + worldCup.nome })
MERGE (c)-[:CONVOCOU]->(squad)-[:PARA_A_COPA]->(worldCup)

MERGE (p:Jogador {id: csvLine.player_id})
ON CREATE SET p.nome = csvLine.player_name

MERGE (p)-[:JOGOU_POR]->(squad);