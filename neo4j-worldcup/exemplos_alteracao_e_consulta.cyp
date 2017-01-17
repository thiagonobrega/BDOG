// INSERIR 
MATCH (visitante)<-[:TIME_VISITANTE]-(partida:Partida)-[:TIME_DA_CASA]->(tcasa)
MATCH (partida)<-[:COMPOSTA_POR]-(copa)
MATCH (copa)<-[:PARA_A_COPA]-(selecaoCasa)<-[:CONVOCOU]-(tcasa),
      (copa)<-[:PARA_A_COPA]-(selecaoVisitante)<-[:CONVOCOU]-(visitante)
 
FOREACH(n IN (CASE WHEN toInt(partida.placar_casa) > toInt(partida.placar_visitante) THEN [1] else [] END) |
	MERGE (selecaoCasa)-[:VENCEU {placar: partida.placar_casa + "-" + partida.placar_visitante}]->(selecaoVisitante)
)

FOREACH(n IN (CASE WHEN toInt(partida.placar_visitante) > toInt(partida.placar_casa) THEN [1] else [] END) |
	MERGE (selecaoVisitante)-[:VENCEU {placar: partida.placar_visitante + "-" + partida.placar_casa}]->(selecaoCasa)
);

// Find teams that beat each other in the same world cups
// Quais seleções se enfrentaram duas vezes em uma copa, onde na primeira partida a vitória foi de uma seleção, e na segunda partida vitória foi da outra seleção?

MATCH (s:Selecao) -[:VENCEU]-> (s2) -[:VENCEU]-> (s)
RETURN s
//consulta  para o tipo
MATCH (s:Selecao) -[:VENCEU]-> (s2) -[:VENCEU]-> (s)
MATCH (partida)-[r1:TIME_DA_CASA|TIME_VISITANTE]->(p1)-[:CONVOCOU]->(s),
	  (partida)-[r2:TIME_DA_CASA|TIME_VISITANTE]->(p2)-[:CONVOCOU]->(s2)
MATCH (copa)-[:COMPOSTA_POR]->(partida)
RETURN s,partida,s2,r1,r2,copa

//gabarito
//http://sports.stackexchange.com/questions/5465/have-two-teams-ever-played-each-other-twice-in-the-same-world-cup

