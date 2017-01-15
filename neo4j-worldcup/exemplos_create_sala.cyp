CREATE (:Ano {ano: 2014} )
CREATE (:CopaDoMundo { nome: 'Brasil 2014'} )
CREATE (:Pais { nome: 'Brasil'} 

//SLIDE
MATCH (ano:Ano),(copa:CopaDoMundo)
WHERE ano.ano=2014 and copa.nome='Brasil 2014'
MERGE (copa)-[:REALIZADA_EM]->(ano)

//SLIDE
MATCH (pais:Pais),(copa:CopaDoMundo)
WHERE  pais.nome ='Brasil' and copa.nome='Brasil 2014'
MERGE (copa)-[:ORGANIZADA_POR]->(pais)

//SLIDE
MATCH (br:Pais),(copa:CopaDoMundo)
WHERE  br.nome ='Brasil' and copa.nome='Brasil 2014'
CREATE (partida:Patida { placar_time_casa: 1 ,
						 placar_visitante: 7 } )
						 
MERGE (copa)-[:COMPOSTA_POR]->(partida)

CREATE (estadio:Estadio { nome: 'Maracanã'} )
MERGE (partida)-[:DISPUTADA_NO]->(estadio)

CREATE (final:Fase { nome: 'Final'} )
MERGE (partida)-[:NA_FASE]->(final)

CREATE (de:Pais { nome: 'Alemanha'} )
MERGE (br)-[:TIME_DA_CASA]->(partida)<-[:TIME_VISITANTE]-(de)





CREATE (:Partida)
