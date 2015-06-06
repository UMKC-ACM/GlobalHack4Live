{-# LANGUAGE OverloadedStrings #-}

module Main where
import Snap.Http.Server
import Snap.Util.FileServe
import Snap.Core 

fileHandle = route [("",serveFile "www/index.html"),
                    ("",serveDirectory "www")]

handle = fileHandle

main = quickHttpServe handle
