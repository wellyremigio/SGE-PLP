{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
#if __GLASGOW_HASKELL__ >= 810
{-# OPTIONS_GHC -Wno-prepositive-qualified-module #-}
#endif
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_haskell (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath




bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "C:\\Users\\pedro\\AppData\\Roaming\\cabal\\bin"
libdir     = "C:\\Users\\pedro\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-9.6.2\\haskell-0.1.0.0-inplace-haskell"
dynlibdir  = "C:\\Users\\pedro\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-9.6.2"
datadir    = "C:\\Users\\pedro\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-9.6.2\\haskell-0.1.0.0"
libexecdir = "C:\\Users\\pedro\\AppData\\Roaming\\cabal\\haskell-0.1.0.0-inplace-haskell\\x86_64-windows-ghc-9.6.2\\haskell-0.1.0.0"
sysconfdir = "C:\\Users\\pedro\\AppData\\Roaming\\cabal\\etc"

getBinDir     = catchIO (getEnv "haskell_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "haskell_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "haskell_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "haskell_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "haskell_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "haskell_sysconfdir") (\_ -> return sysconfdir)



joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '\\'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/' || c == '\\'
