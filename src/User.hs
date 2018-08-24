{-# LANGUAGE QuasiQuotes, DataKinds, DeriveGeneric, DeriveDataTypeable, FlexibleInstances, TypeOperators, TemplateHaskell, MultiParamTypeClasses, NoImplicitPrelude #-}

module User
  ( User(..)
  , userId
  , userUsername
  )
  where

import           Data.Swagger                   ( ToSchema )
import           Data.Aeson
import           Data.Typeable
import           Data.Convertible
import           Data.Int
import           Data.Eq
import           Data.String
import           Text.Show
import           Data.ByteString.UTF8          as BUTF8
                                                ( toString
                                                , fromString
                                                )
import           Data.ByteString
import           Database.HDBC
import           Database.YeshQL.HDBC.SqlRow.Class
import           Database.YeshQL.HDBC.SqlRow.TH
import           GHC.Generics
import           Prelude                        ( Integer
                                                , Bool
                                                )
import           Servant.Elm                    ( ElmType )
import           StringArray
import           MaybeString


data User = User
  { id :: Int
  , username  :: String
  , email     :: MaybeString
  , languages :: StringArray
  } deriving (Eq, Generic, Show)
makeSqlRow ''User


userId :: User -> Int
userId = id

userUsername :: User -> String
userUsername = username

instance ToSchema User
instance ToJSON User
instance FromJSON User
instance ElmType User
