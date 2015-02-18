addLnat x y =  addLnatt 0 x y

addLnatt c (x:xs) (y:ys) = [((x + y) + c) `mod` 10] ++ addLnatt (calcC (x + y)) xs ys
addLnatt c (x:xs) [] = [(x + c) `mod` 10] ++ addLnatt (calcC (x + c)) xs []
addLnatt c [] (x:xs) = [(x + c) `mod` 10] ++ addLnatt (calcC (x + c)) xs []
addLnatt 1 [] [] = [1]
addLnatt 0 [] [] = []

mulLnat :: [Int] -> [Int] -> [Int]
mulLnat (x:xs) y = addLnat (addOnL 0 x y) (0 : (mulLnat xs y))
mulLnat [] mulist = []

addOnL :: Int -> Int -> [Int] -> [Int]
addOnL c x (y:ys) = (((x * y) + c) `mod` 10) : addOnL (calcC ((x * y) + c)) x ys
addOnL c x [] = [c]

calcC x = (x - (x `mod` 10)) `div` 10