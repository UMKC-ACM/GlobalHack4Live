{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
module DBInfo where
import           Control.Monad.IO.Class  (liftIO)
import           Database.Persist
import           Database.Persist.Postgresql
import           Database.Persist.Postgres
import           Database.Persist.TH
import Types
import qualified Data.Text as T
import Data.Functor

conf = "host=ec2-54-83-57-86.compute-1.amazonaws.comport=5432 user=bmfwimcvljiyil dbname=d2fhi8h00c05m7 password=f4oDRsvVF5d4VFgm2vvEZ-fzd0"
share [mkPersist sqlSettings, mkMigrate "migrateAll"][persistLowerCase|
DBContentID 
  dbid  T.Text
  dbpicture  T.Text
  dbpairs  [DBPair]
  deriving Show
DBPair
  dbx Int
  dby Int
  dbinfo T.Text
  deriving Show
|]

contentToDB (ContentID id picture pairs) = DBContentID id picture (map pairToDB pairs)

pairToDB (Pair x y info) = DBPair x y info

dBToContent (DBContentID id picture pairs) = ContentID id picture (map dBToPair pairs)

dBToPair (DBPair x y info) = Pair x y info

mkMigration:: IO ()
mkMigration = runInDB (runMigration migrateAll)

runInDB f = withPostgresqlConn conf f

lookupContent:: T.Text -> IO (Maybe ContentID)
lookupContent id = do
  content <- runInDB $ (selectFirst [DBContentIDDbid ==. id][LimitTo 1])
  return (dBToContent <$> (entityVal <$> content))

createContent:: ContentID -> IO (Key DBContentID)
createContent content =  runInDB  (insert (contentToDB content))
