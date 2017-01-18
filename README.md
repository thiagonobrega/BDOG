Bancos de Dados Orientados a Grafos
==============

Material de apoio utilizado na disciplina de Bancos de Dados II do Curso de Ciência da Computação da UFCG.
## Instalando o Neo4j 
Baixe o Neo4J  do website (http://www.neo4j.org/download) e siga as instruções. Caso você ainda tenha alguma dúvida veja o vídeo abaixo

[![Youtube](https://raw.github.com/thiagonobrega/bdog/master/imagens/youtube.png)](https://www.youtube.com/watch?v=ANLZsH52kBA)

## Utilizando os dados do Exemplo da sala de aula
Em sala de aula nos adaptamos os dados de  [Mark Needham]( https://github.com/mneedham), com os dados das Copas do Mundo.

Os dados estão organizados de acordo com a Figura abaixo: 
![tirinha](https://github.com/thiagonobrega/bdog/blob/master/neo4j-worldcup/imagens/esquema.png)

### Carregando os dados na sua instancia Neo4J
Abra o navegador e acessa o [console web](http://localhost:7474) do Neo4J

#### Limpe a Base de Dados
````
MATCH (n)-[r]-() DELETE n,r;
````
#### Índices 
Para que os dados sejam carregados e consultados mais rapidamente é bom criar alguns índices primeiro.
````
CREATE INDEX ON :Partida(id);
````

````
CREATE INDEX ON :CopaDoMundo(nome);
````

````
CREATE INDEX ON :Estadio(nome);
````

````
CREATE INDEX ON :Pais(nome);
````

````
CREATE INDEX ON :Fase(nome);
````

````
CREATE INDEX ON :Jogador(id);
````

````
CREATE INDEX ON :Jogador(nome);
````
Cada linha deve ser executada individualmente
### Carregando os dados
Execute os comandos dos arquivos abaixo no Neo4J.

* [01 - Dados das Partidas](neo4j-worldcup/1-loadMatches.cyp)
* [02 - Dados das Seleções](neo4j-worldcup/2-oadSquads.cyp)
* [03 - Dados das Convocações](neo4j-worldcup/3-loadLineUps.cyp)
* [04 - Dados dos eventos](neo4j-worldcup/4-loadEvents.cyp)

*IMPORTANTE :* Para resolver os exercícios da Lista 02 é necessário executar a criação do relacionamento :VENCEU

````
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
````
## Exemplos de Sala de aula

As consultas utilizadas em sala de aula estão na pasta neo4j-worldcupr.

* [Creates](neo4j-worldcup/exemplos_create_sala.cyp)
* [Consultas simples](neo4j-worldcup/exemplos_consultas_sala.cyp)
* [Alteração e consultas Avançadas](neo4j-worldcup/exemplos_alteracao_e_consulta.cyp)


## Licença
Creative Commons. Reuse à vontade!
