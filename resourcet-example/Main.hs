module Main where



type Username = Text

type Highscore = Integer

selectUsers :: Connection -> IO [(Username,Highscore)]
selectUsers connection =
    query_ connection "SELECT * FROM users"

insertUser :: Connection -> (Username,Highscore) -> IO ()
insertUser connection =
    execute_ connection "INSERT INTO users (?,?)"

main :: IO ()
main = runResourceT (do
    mydb <- allocateSQLite "my.db"
    memorydb <- allocateSQLite ":memory:"
    return ())

