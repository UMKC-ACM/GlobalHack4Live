{-# LANGUAGE OverloadedStrings,
             DeriveGeneric,
             DeriveDataTypeable #-}

module Types where
import qualified Data.Text as T
import Data.Aeson
import Data.Functor
import Control.Applicative
import qualified Data.JSON.Schema.Types as Schema
import Data.Typeable
import Data.Data

data ContentID = ContentID {
  _id :: T.Text,
  _picture :: T.Text,
  _pairs :: [Pair]
} deriving (Data,Typeable)

instance FromJSON ContentID where
 parseJSON (Object v) = ContentID <$>
                        v .: "id" <*>
                        v .: "picture" <*>
                        v .: "pairs"

instance ToJSON ContentID where
  toJSON (ContentID id picture pairs) = object ["id" .= id, "picture" .= picture, "pairs" .= pairs]

instance Schema.JSONSchema ContentID where
  schema _ = Schema.Any

data Pair = Pair{
  _x :: Integer,
  _y :: Integer,
  _info :: T.Text
} deriving (Data,Typeable)

instance FromJSON Pair where
  parseJSON (Object v) = Pair <$>
                         v .: "x" <*>
                         v .: "y" <*>
                         v .: "info"
instance ToJSON Pair where
  toJSON (Pair x y info) = object ["x" .= x, "y" .= y, "info" .= info]

instance Schema.JSONSchema Pair where
  schema _ = Schema.Any
