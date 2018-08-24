{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE TypeSynonymInstances       #-}

module Word
  ( Word(..)
  , WordId
  )
  where

import Prelude hiding (Word, id)
import Database.HDBC
import Database.YeshQL.HDBC.SqlRow.TH
import Data.ByteString.UTF8 as BUTF8 (toString, fromString)
import Data.ByteString
import Data.Convertible.Base
import Data.Aeson
import Data.Swagger
import Data.List
import User (User(..))
import GHC.Generics
import Prelude (Integer, Bool)
import Servant.Elm (ElmType)
import StringArray


type WordId = Int
type MaybeInt = Maybe Int

data Word = Word
  { id          :: WordId
  , language    :: String
  , word        :: String
  , definition  :: String
  , keywords    :: StringArray
  , difficulty  :: MaybeInt
  } deriving (Eq, Generic, Show)
makeSqlRow ''Word


instance ToSchema Word
instance ToJSON Word
instance FromJSON Word
instance ElmType Word
