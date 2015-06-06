{-# LANGUAGE OverloadedStrings,
             NoMonomorphismRestriction #-}

module Main where
import Snap.Http.Server
import Snap.Util.FileServe
import Snap.Core 
import Control.Applicative
import Control.Monad.IO.Class
import Data.Maybe
import qualified Network.HTTP as HTTP
import qualified Network.HTTP.Base as HTTP
import Network.HTTP.Headers
import Network.URI
import qualified Data.Text as T

app_id = "7740739530260546"
app_secret = "ycJgreLAX4Q0jTr6A1gcszO/7rWUxPU+UysAlwec+V6+VX5gZZLwHdrmF3vE0fWmLrBrCJJ9Wt7zdPj8Zh+Lyg=="

createURL:: String
createURL = "http://api.globalhack4.test.lockerdome.com/app_create_content?{\"app_id\":"++app_id++",\"app_secret\":\""++app_secret++"\",\"app_data\":{\"fun\":\"times\"},\"name\":\"rootastic\",\"text\":\"Short description of your content\"}\""

create' = HTTP.simpleHTTP (HTTP.getRequest createURL) >> return ()

create = HTTP.simpleHTTP (request) >>= fmap (take 100) . HTTP.getResponseBody
         where bod = "{\"app_id\":7740739530260546, \"app_secret\":\"ycJgreLAX4Q0jTr6A1gcszO/7rWUxPU+UysAlwec+V6+VX5gZZLwHdrmF3vE0fWmLrBrCJJ9Wt7zdPj8Zh+Lyg==\", \"app_data\":{ \"fun\":\"times\"}, \"name\":\"Some App Content\", \"text\":\"Short description of your content\"}"
               url = "http://api.globalhack4.test.lockerdome.com/app_create_content?"
               request:: HTTP.Request String
               request = HTTP.Request { HTTP.rqURI = (fromJust $ parseURI url),
                                  HTTP.rqMethod = HTTP.GET,
                                  HTTP.rqHeaders = [mkHeader HdrContentType "application/javascript"],
                                  HTTP.rqBody = bod}
apiHandle:: Snap ()
apiHandle = route [("1.0.0",serveFile "www/index.html"),
                   ("1.0.0/create", (liftIO create >>= writeText .  T.pack))]

fileHandle:: Snap ()
fileHandle = route [("",serveFile "www/index.html"),
                    ("",serveDirectory "www")]


main = quickHttpServe (apiHandle <|> fileHandle)
