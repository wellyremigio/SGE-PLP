dobro :: Int-> Int
dobro x = x * 2

triplo:: Int -> Int
triplo x = 3 * x

par:: Int -> Bool
par x
    | mod x 2 == 0 = True
    | otherwise = False