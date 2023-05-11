import System.Environment
import System.Exit
import Text.ParserCombinators.Parsec
import Data.List

---- parser part

csvFile :: GenParser Char st [[String]]
csvFile = 
    do result <- many line
       eof
       return result

line :: GenParser Char st [String]
line = 
    do result <- cells
       eol                       
       return result
       
cells :: GenParser Char st [String]
cells = 
    do first <- cellContent
       next <- remainingCells
       return (first : next)

remainingCells :: GenParser Char st [String]
remainingCells =
    (char ',' >> cells) 
    <|> (return []) 


cellContent :: GenParser Char st String
cellContent = 
    many (noneOf ",\n")
       

eol :: GenParser Char st Char
eol = char '\n'

parseCSV :: String -> Either ParseError [[String]]
parseCSV input = parse csvFile "(unknown)" input

--- search part

find_algos "all" (Right tab) = [y | [x,y] <- tab]
find_algos term (Right tab) = [y | [x,y] <- tab, isInfixOf term x]

format_element element 
            | res == [] = "_empty_"
            | otherwise = tail res
            where
                res = foldl (\acc x -> concat [acc, " ", x]) "" element

get_algo :: [Char] -> IO()
get_algo term = do
    -- open_database
    csv_content <- readFile "/home/fabrice/sh/workflow_module/algos.csv"
    let table = parseCSV csv_content
    let element = find_algos term table
    let res = format_element element
    putStrLn (res)

--- command line interface part

main = getArgs >>= my_parse >>= putStr . tac

tac  = unlines . reverse . lines

my_parse []     = getContents
my_parse [val]  = get_algo val >> exit

exit      = exitWith ExitSuccess
die       = exitWith (ExitFailure 1)
