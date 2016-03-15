- O codigo foi escrito na linguagem Haskell.
Para rodar, baixar o GHC (https://www.haskell.org/downloads)
Colocar o arquivo "input.txt" com as entradas na mesma pasta do código;
No prompt digitar "ghc --make rewardSystem.hs" em seguida "rewardSystem";
Será criado um arquivo "output.txt" com o resultado.

- A solução do problema foi elaborada da seguinte maneira (maiores detalhes, comentarios no codigo):
A entrada foi recebida e cada valor colocado em uma lista. 
A lista foi dividida em duas (usuarios que convidaram e usuarios que foram convidados).
	a lista de usuarios que convidaram é util mais a frente, para validar pontos.
Essas listas foram unidas em uma unica lista de tuplas.
	foram retirados os convites invalidos (usuarios já convidados, usuarios já no sistema e auto convite)
Foram calculados (através de busca de nós adjacentes) os pontos por level e colocados em uma lista.
Em seguida aplicada a fórmula e assim calculado o score.
	foi feita a validação: no caso de usuários que não tiveram convidados que convidaram alguem (nós netos), o score foi 0
Feito isso para cada usuário, o ranking foi criado (tuplas ordenadas).
A saida foi formatada para o formato JSON e escrita em um arquivo.