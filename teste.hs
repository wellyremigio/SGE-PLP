import Text.XHtml (input)
dobro :: Int-> Int
dobro x = x * 2

triplo:: Int -> Int
triplo x = 3 * x

quadruplo:: Int -> Int
quadruplo x = 4 * x

par:: Int -> Bool
par x
    | mod x 2 == 0 = True
    | otherwise = False

main:: IO()
main = do
    input <- readLn::IO Int
    print(quadruplo input)