module TestMain where

import

instance Arbirary ContentID where
 arbitrary = do id <- arbitary
                pic <- arbitary
                pairs <- arbitrary
                return $ ContentID id pic pairs
