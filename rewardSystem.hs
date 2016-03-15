import System.IO  
import Control.Monad
import Data.List
import Data.Function
import Data.Tuple

-- funcao que auxilia leitura do arquivo
f :: [String] -> [Int]
f = map read

-- lista com usuarios que convidaram 
inviting :: [Int] -> [Int]
inviting x = map ((!!) x) [0,2..(length x - 1)]

-- lista com usuarios convidados
invited :: [Int] -> [Int]
invited x = map ((!!) x) [1,3..(length x - 1)]

-- considera invalidos convites a usuarios que já estão no programa, já convidados ou auto convites
invalid :: (Eq a) => (a,a) -> (a,a) -> Bool
invalid (x,y) (u,v) = (x == v) || (y == v) || (u == v)

-- remome as tuplas invalidas (definidas na funcao "invalid")
removeInvalidTuples :: (Eq a) => [(a,a)] -> [(a,a)]
removeInvalidTuples = nubBy invalid

type Edge = (Int, Int)
type Graph = [Edge]

-- lista convidados de um usuario especifico
adjacents :: Graph -> Int -> [Int]
adjacents [] _ = []
adjacents ((a,b):c) v
		| (a == v) = b:(adjacents c v)
		| otherwise = adjacents c v

-- lista todos os "convidados" de um usuario em um determinado level (descendentes na arvore em determinado level)
adjacentsForLevel :: Graph -> [Int] -> [Int]
adjacentsForLevel _ [] = []
adjacentsForLevel [] _ = []
adjacentsForLevel g (x:xs) = (adjacents g x) ++ adjacentsForLevel g xs

-- lista quantidade total por level de convites descendentes de um usuario (indice corresponde a level)
pointsList :: Graph -> [Int] -> [Int]
pointsList [] _ = []
pointsList _ [] = []
pointsList g x = [length (adjacentsForLevel g x)] ++ (pointsList g (adjacentsForLevel g x))

-- calcula os pontos totais de usuario especifico
score :: [Int] -> Double
score [] = 0
score x =  sum (pointsFunc)
		where 
		pointsFunc = zipWith (*) func pointsDouble
		func = zipWith (^) [0.5, 0.5 ..] [0,1..]
		pointsDouble = map (fromIntegral) x

-- lista de pontos dos usuarios (e valida pontos. Zero caso nao sejam validos)
scoreList :: Graph -> [Int] -> [Int] -> [Double]
scoreList [] _ _ = []
scoreList _ [] _ = []
scoreList _ _ [] = []
scoreList g i (x:xs) 
		| validateScore g i x = [score (pointsList g [x])] ++ (scoreList g i xs)
		| otherwise = 0:(scoreList g i xs)

-- verifica se algum convidado do usuario convidou alguem (se o nodo tem algum neto)
validateScore :: Graph -> [Int] -> Int -> Bool
validateScore [] _ _ = False
validateScore _ [] _ = False
validateScore g i x = elemList (adjacents g x) i

-- verifica se pelo menos um elemento da primeira lista esta na segunda lista
elemList :: [Int] -> [Int] -> Bool
elemList [] _ = False
elemList _ [] = False
elemList (a:as) c = a `elem` c || elemList as c

-- ordena tuplas (ranking)
sortRanking :: [(Int, Double)] -> [(Int, Double)]
sortRanking x = sortBy (flip compare `on` snd) x

-- recebe tupla e retorna string no formato JSON
jsonFormat :: (Int, Double) -> String
jsonFormat (u, s) = "{ \n \t \"user\": " ++ show u ++ ",\n \t \"score\": " ++ show s ++ "\n }, \n"

stringRanking :: [(Int, Double)] -> String
stringRanking = (foldl' (++) "") . (map jsonFormat)


main = do  
	let list = []
        handle <- openFile "input.txt" ReadMode
        contents <- hGetContents handle
        let numb = words contents
            list = f numb
	
	let invitingList = inviting list     -- lista de usuarios que convidaram (antes de remover convites invalidos)
	let invitedList = invited list       -- lista de usuarios convidados
	
	let tuples = zip invitingList invitedList 
	let validTuples = removeInvalidTuples tuples     -- lista com as tuplas de convites validos

	let usersRanking = nub invitingList     -- remove repeticoes da lista de usuarios que convidaram
	let scoreRanking = scoreList validTuples usersRanking usersRanking     -- lista dos scores do ranking com indice equivalente ao de usersRanking

	let usersScore = zip usersRanking scoreRanking
	let ranking = sortRanking usersScore             -- cria o ranking
	
	writeFile "output.txt" $ stringRanking ranking   -- escreve output (no formato JSON)

        hClose handle  

	

