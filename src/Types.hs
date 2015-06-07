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
  _title :: T.Text,
  _link :: T.Text,
  _annotation :: [Annotation],
  _id :: T.Text
} deriving (Data,Typeable, Show, Eq, Read)

data Annotation = Annotation{
  _src :: T.Text,
  _text :: T.Text,
  _shapes :: [Shapes]
} deriving (Data,Typeable, Show, Eq, Read)


data Shapes = Shapes {
  _type  :: T.Text,
  _geometry :: Geometry,
  _context :: T.Text,
  _editable :: Bool

} deriving (Data,Typeable, Show, Eq, Read)

data Geometry = Geometry {
  _x :: Double,
  _y :: Double,
  _width :: Double,
  _height :: Double
} deriving (Data,Typeable, Show, Eq, Read)



instance FromJSON ContentID where
 parseJSON (Object v) = ContentID <$>
                        v .: "title" <*>
                        v .: "link" <*>
                        v .: "annotation" <*>
                        v .: "id"

instance ToJSON ContentID where
  toJSON (ContentID title link annotation id) = object ["title" .= title, "link" .= link, "annotation" .= annotation, "id" .= id]

instance Schema.JSONSchema ContentID where
  schema _ = Schema.Any

instance FromJSON Annotation where
  parseJSON (Object v) = Annotation <$>
                         v .: "src" <*>
                         v .: "text" <*>
                         v .: "shapes"
instance ToJSON Annotation where
  toJSON (Annotation src text shapes) = object ["src" .= src, "text" .= text, "shapes" .= shapes]

instance Schema.JSONSchema Annotation where
  schema _ = Schema.Any

instance FromJSON Shapes where
  parseJSON (Object v) = Shapes <$>
                         v .: "type" <*>
                         v .: "geometry" <*>
                         v .: "context" <*>
                         v .: "editable" 
instance ToJSON Shapes where
  toJSON (Shapes typ geom context editable) = object ["type" .= typ, "geometry" .= geom, "context" .= context, "editable" .= editable]
instance Schema.JSONSchema Shapes where
  schema _ = Schema.Any

instance FromJSON Geometry where
  parseJSON (Object v) = Geometry <$>
                         v .: "x" <*>
                         v .: "y" <*>
                         v .: "width" <*>
                         v .: "height"
instance ToJSON Geometry where
  toJSON (Geometry x y w h) = object ["x" .= x, "y" .= y, "width" .= w, "height" .= h]

instance Schema.JSONSchema Geometry where
  schema _ = Schema.Any
