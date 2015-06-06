module Paths_test_backend (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/octopuscabbage/.cabal/bin"
libdir     = "/home/octopuscabbage/.cabal/lib/x86_64-linux-ghc-7.6.3/test-backend-0.1.0.0"
datadir    = "/home/octopuscabbage/.cabal/share/x86_64-linux-ghc-7.6.3/test-backend-0.1.0.0"
libexecdir = "/home/octopuscabbage/.cabal/libexec"
sysconfdir = "/home/octopuscabbage/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "test_backend_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "test_backend_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "test_backend_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "test_backend_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "test_backend_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
