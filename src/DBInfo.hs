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
  dtitle  T.Text
  dlink  T.Text
  dbannotation  [DBAnnotation]
  dbid T.Text
  deriving Show
DBAnnotation
  dbsrc T.Text
  dbtext T.Text
  dbshapes [DBShapes]
  dbcontext T.Text
  dbeditable Bool
  deriving Show
DBShapes
  dbtype T.Text
  dbgeometry DBGeometry
  deriving Show
DBGeometry
  dbx Double
  dby Double
  dbwidth Double
  dbheight Double
  deriving Show
|]



contentToDB (ContentID link title annotation id) = DBContentID link title (map annotationToDB annotation) id

annotationToDB (Annotation src text shapes context editable) = DBAnnotation src text (map shapeToDB shapes) context editable

shapeToDB (Shapes typ geom) = DBShapes typ (geometryToDB geom)

geometryToDB (Geometry x y w h) = DBGeometry x y w h

dBToContent (DBContentID title link annotation id) = ContentID title link (map dBToAnnotation annotation) id

dBToAnnotation (DBAnnotation src text shapes context editable) = Annotation src text (map dBToShape shapes) context editable

dBToShape (DBShapes typ geom) = Shapes typ (dBToGeometry geom)

dBToGeometry (DBGeometry x y w h ) = Geometry x y w h

mkMigration = runStdoutLoggingT $ withPostgresqlPool conf 1 $ \pool ->
     liftIO $ flip runSqlPersistMPool pool $  runMigration migrateAll

runInDb  f = runStdoutLoggingT $ withPostgresqlPool conf 1 $ \pool -> liftIO $ flip runSqlPersistMPool pool f

lookupContent:: T.Text -> IO (Maybe ContentID)
lookupContent id = do
  content <-getContent 
  return (dBToContent <$> (entityVal <$> content))
    where getContent:: IO (Maybe (Entity DBContentID))
          getContent =  runInDb (selectFirst [DBContentIDDbid ==. id][LimitTo 1])

createContent:: ContentID -> IO (Key DBContentID)
createContent content =   runStdoutLoggingT $ withPostgresqlPool conf 10 $ \pool -> liftIO $ flip runSqlPersistMPool pool ((insert (contentToDB content)))

