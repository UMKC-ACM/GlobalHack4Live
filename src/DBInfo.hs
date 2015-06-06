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
import           Database.Persist.Sqlite
import           Database.Persist.TH
import Types
import qualified Data.Text as T
import Data.Functor

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
mkMigration = runInSqlLite (runMigration migrateAll)

runInSqlLite f = runSqlite "test.db" f

lookupContent:: T.Text -> IO (Maybe ContentID)
lookupContent id = do
  content <- runInSqlLite $ (selectFirst [DBContentIDDbid ==. id][LimitTo 1])
  return (dBToContent <$> (entityVal <$> content))

createContent:: ContentID -> IO (Key DBContentID)
createContent content =  runInSqlLite  (insert (contentToDB content))
