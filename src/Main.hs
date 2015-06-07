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

testContentId = ContentID{_title="yest",
                          _link="eh",
                          _annotation = [testAnnotation],
                          _id = "test"
}

testAnnotation = Annotation {_src = "http://127.0.0.1:8080/image/640px-Hallstatt.jpg",
                             _text = "test",
                             _shapes = [testShape]
}

testShape = Shapes {
  _type = "rect",
  _geometry = testGeometry,
  _context = "http://127.0.0.1:8080/",
  _editable = False
}

testGeometry = Geometry{
  _x = 1,
  _y = 1,
  _width = 1,
  _height = 1
}

badContentID::ContentID
badContentID = ContentID { _title = errString, _link =errString, _annotation=[], _id = errString}
        where errString = "ERROR: NOT FOUND"

get = mkIdHandler (jsonO) $ handle 
     where handle _ id = do
             content <- liftIO $ lookupContent (T.pack id)
             case content of
              Nothing -> return badContentID
              Just a -> return a

create = mkInputHandler (jsonI) $ handle 
          where handle c =  (liftIO $ createContent c) >> return ()
              
apiRoutes = root -/ (route contentIDResource)

api = [(mkVersion 1 0 0, Some1 apiRoutes)]

apiHandle = apiToHandler' liftIO api

fileHandler::Core.Snap ()
fileHandler = serveDirectory "www"


main = do
--	config <- Gen.configFromArgs "rest-example-gen"
--	Gen.generate config "gh4" api [] [] []
 	quickHttpServe (fileHandler <|> apiHandle)
