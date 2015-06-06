{-# LANGUAGE OverloadedStrings #-}

module Main where
import Snap.Http.Server
import Snap.Util.FileServe
import Rest
import Rest.Api
import qualified Rest.Resource as R
import Rest.Driver.Snap
import qualified Data.Text as T
import Data.Aeson
import Types
import Control.Monad.IO.Class
import Control.Applicative
import qualified Snap.Core as Core
--import qualified Rest.Gen as Gen
import DBInfo
import Control.Monad.Error.Class

contentIDResource = mkResourceReader {
 R.name = "content_id",
 R.schema = noListing $ named [("id", singleBy id)],
 R.get = Just get,
 R.create = Just create
}


testContentId = ContentID{ _id = "test",_picture = "",_pairs = [Pair {_x =10,_y=10,_info="test"}, Pair{_x=20,_y=20,_info="testy"}]}

badContentID = ContentID { _id = "ERROR NOT FOUND"}

get = mkIdHandler (jsonO) $ handle 
     where handle _ id = do
             content <- liftIO $ lookupContent (T.pack id)
             case content of
              Nothing -> return badContentID
              Just a -> return a


readPostFromDb id = return testContentId 

create = mkInputHandler (jsonI . jsonO) $ handle 
          where handle c = do
                            key <- liftIO $ createContent c
                            return (_id c)
              
apiRoutes = root -/ (route contentIDResource)
api = [(mkVersion 1 0 0, Some1 apiRoutes)]

apiHandle = apiToHandler' liftIO api

fileHandler = serveDirectory "www"


main = do
--	config <- Gen.configFromArgs "gh4"
--	Gen.generate config "gh4" api [] [] []
 	quickHttpServe (fileHandler <|> apiHandle)
