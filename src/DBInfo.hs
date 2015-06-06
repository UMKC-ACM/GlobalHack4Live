{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE NoMonomorphismRestriction  #-}
module DBInfo where
import           Control.Monad.IO.Class  (liftIO)
import           Database.Persist
import           Database.Persist.Postgresql
import           Database.Persist.TH
import Types
import qualified Data.Text as T
import Data.Functor
import Control.Monad.Logger
conf = "host=ec2-54-83-57-86.compute-1.amazonaws.com port=5432 user=bmfwimcvljiyil dbname=d2fhi8h00c05m7 password=f4oDRsvVF5d4VFgm2vvEZ-fzd0"
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

test = undefined

contentToDB (ContentID id picture pairs) = DBContentID id picture (map pairToDB pairs)

pairToDB (Pair x y info) = DBPair x y info

dBToContent (DBContentID id picture pairs) = ContentID id picture (map dBToPair pairs)

dBToPair (DBPair x y info) = Pair x y info

mkMigration = runStdoutLoggingT $ withPostgresqlPool conf 1 $ \pool ->
     liftIO $ flip runSqlPersistMPool pool $ do
        printMigration migrateAll

runInDb  f = runStdoutLoggingT $ withPostgresqlPool conf 1 $ \pool -> liftIO $ flip runSqlPersistMPool pool f

lookupContent:: T.Text -> IO (Maybe ContentID)
lookupContent id = do
  content <-getContent 
  return (dBToContent <$> (entityVal <$> content))
    where getContent:: IO (Maybe (Entity DBContentID))
          getContent =  runInDb (selectFirst [DBContentIDDbid ==. id][LimitTo 1])

createContent:: ContentID -> IO (Key DBContentID)
createContent content =   runStdoutLoggingT $ withPostgresqlPool conf 1 $ \pool -> liftIO $ flip runSqlPersistMPool pool ((insert (contentToDB content)))

