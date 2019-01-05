module Data.Exception where

import Protolude


newtype ExceptionText = ExceptionText Text
  deriving (Show, Eq)
instance Exception ExceptionText

data ExceptionPostgreSQL = ExceptionPGUniqueViolation
                         | ExceptionPGJWTMalformed
                         | ExceptionPGJWTInvalid
  deriving (Show, Eq)
instance Exception ExceptionPostgreSQL
