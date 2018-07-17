{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE TemplateHaskell            #-}

module Word
  ( Word(..)
  , wordConstructor
  )
  where

import Prelude hiding (Word)
import Data.Aeson
import Data.Swagger
import GHC.Generics
import Servant.Elm (ElmType)

data Word = Word
  { wordId          :: Int
  , wordLanguage    :: String
  , wordWord        :: String
  , wordKeywords    :: [String]
  , wordDefinition  :: String
  , wordDifficulty  :: Maybe Int
  } deriving (Eq, Generic, Show)


instance ToSchema Word
instance ToJSON Word
instance FromJSON Word
instance ElmType Word

wordConstructor :: (Int, String, String, String, Maybe Int) -> Word
wordConstructor (wordId, wordLanguage, wordWord, wordDefinition, wordDifficulty) =
  Word wordId wordLanguage wordWord [] wordDefinition wordDifficulty
