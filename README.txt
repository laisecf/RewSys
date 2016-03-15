- O codigo foi escrito na linguagem Haskell.
Para rodar, baixar o GHC (https://www.haskell.org/downloads)
Colocar o arquivo "input.txt" com as entradas na mesma pasta do c�digo;
No prompt digitar "ghc --make rewardSystem.hs" em seguida "rewardSystem";
Ser� criado um arquivo "output.txt" com o resultado.

- A solu��o do problema foi elaborada da seguinte maneira (maiores detalhes, comentarios no codigo):
A entrada foi recebida e cada valor colocado em uma lista. 
A lista foi dividida em duas (usuarios que convidaram e usuarios que foram convidados).
	a lista de usuarios que convidaram � util mais a frente, para validar pontos.
Essas listas foram unidas em uma unica lista de tuplas.
	foram retirados os convites invalidos (usuarios j� convidados, usuarios j� no sistema e auto convite)
Foram calculados (atrav�s de busca de n�s adjacentes) os pontos por level e colocados em uma lista.
Em seguida aplicada a f�rmula e assim calculado o score.
	foi feita a valida��o: no caso de usu�rios que n�o tiveram convidados que convidaram alguem (n�s netos), o score foi 0
Feito isso para cada usu�rio, o ranking foi criado (tuplas ordenadas).
A saida foi formatada para o formato JSON e escrita em um arquivo.