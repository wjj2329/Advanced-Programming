import Data.Array
iSquare :: Int ->Int
iSquare n =floor(sqrt(fromIntegral n))
isPrime :: Int -> Bool
isPrime k = null [ x | x <- [2..(iSquare k)], k `mod`x  == 0]
primes :: [Int]
primes =filter(isPrime) [2..]
isPrimeFast :: Int -> Bool
isPrimeFast n= null [c |c <-takeWhile (<= m) primesFast , n `mod` c==0] where m = iSquare n
primesFast :: [Int]
primesFast = 2:filter (isPrimeFast) [3..]
lcsLength::String->String->Int
lcsLength string1 string2 = a!(length1,length2)
  where length1 = length string1
        length2 = length string2
        a=array ((0,0),(length1,length2))
         ([((0,j),0)| j<-[0..length2]]++
          [((i,0),0)| i<-[1..length1]]++
          [((i,j),if string1!!(i-1)==string2!!(j-1)
           then a!(i-1, j-1)+1 else max (a!(i-1, j))(a!(i, j-1)))
             | i <- [1..length1], j<-[1..length2]])
