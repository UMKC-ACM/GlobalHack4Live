{-# LANGUAGE OverloadedStrings #-}

module Main where
import Snap.Http.Server
import Snap.Util.FileServe
import qualified Snap.Core as Core

fileHandle = Core.route [("",serveFile "www/index.html"),
                        ("",serveDirectory "www")]

handle = fileHandle

main = do
  quickHttpServe handle
