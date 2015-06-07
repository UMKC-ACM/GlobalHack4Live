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
--import qualified Rest.Gen.Config as Gen
import DBInfo
import Control.Monad.Error.Class

contentIDResource = mkResourceReader {
 R.name = "content_id",
 R.schema = noListing $ named [("id", singleBy id)],
 R.get = Just get,
 R.create = Just create
}

testContentId = ContentID{ _id = "test",_picture = "",_pairs = [Pair {_x =10,_y=10,_info="test"}, Pair{_x=20,_y=20,_info="testy"}]}

badContentID::ContentID
badContentID = ContentID { _id = "ERROR NOT FOUND", _picture ="", _pairs=[]}

get = mkIdHandler (jsonO) $ handle 
     where handle _ id = do
             content <- liftIO $ lookupContent (T.pack id)
             case content of
              Nothing -> return badContentID
              Just a -> return a

create = mkInputHandler (jsonI . jsonO) $ handle 
          where 	handle c@(ContentID id picture pairs) =  (liftIO $ createContent c) >> return (id)
              
apiRoutes = root -/ (route contentIDResource)

api = [(mkVersion 1 0 0, Some1 apiRoutes)]

apiHandle = apiToHandler' liftIO api

fileHandler::Core.Snap ()
fileHandler = serveDirectory "www"


main = do
--	config <- Gen.configFromArgs "rest-example-gen"
--	Gen.generate config "gh4" api [] [] []
 	quickHttpServe (fileHandler <|> apiHandle)
