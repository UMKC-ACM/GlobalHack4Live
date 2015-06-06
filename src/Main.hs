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
--import qualified Rest.Gen as Gen

contentIDResource = mkResourceReader {
 R.name = "content_id",
 R.schema = withListing () $ named [("id", singleBy id)],
 R.get = Just get,
 R.create = Just create
}


testContentId = ContentID{ _id = "test",_picture = "https://imgur.com/GKFT6bm",_pairs = [Pair {_x =10,_y=10,_info="test"}, Pair{_x=20,_y=20,_info="testy"}]}

get = mkIdHandler jsonO $ \_ id -> readPostFromDb id

readPostFromDb id = return testContentId 

create = undefined

apiRoutes = root -/ (route contentIDResource)
api = [(mkVersion 1 0 0, Some1 apiRoutes)]

apiHandle = apiToHandler' liftIO api



main = do
--	config <- Gen.configFromArgs "gh4"
--	Gen.generate config "gh4" api [] [] []
 	quickHttpServe (apiHandle )
