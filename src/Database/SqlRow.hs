module Database.SqlRow where

import Protolude hiding (Location, get)

import Database.PostgreSQL.LibPQ
import Foreign.C.Types

import Database.Types

import Data


class SqlRow a where
  fromSqlResultRow :: Result -> CInt -> IO a

  fromSqlResultRows :: Result -> IO [a]
  fromSqlResultRows sqlResult = do
    nbRows <- ntuples sqlResult
    fromSqlResultRows' sqlResult 0 nbRows
    where fromSqlResultRows' res nRow (Row nbRows) =
            if nbRows == 0
              then return []
              else
                if nRow >= (nbRows -1)
                  then do
                    -- last value to return
                    rowValue <- fromSqlResultRow res nRow
                    return $ [rowValue]
                  else do
                    rowValue <- fromSqlResultRow res nRow
                    rowValues <- fromSqlResultRows' res (nRow+1) (Row nbRows)
                    return $ rowValue:rowValues


instance SqlRow Text where
  fromSqlResultRow :: Result -> CInt -> IO Text
  fromSqlResultRow res nRow = do
    getPGTypeValue res nRow 0 :: IO Text

instance SqlRow Integer where
  fromSqlResultRow :: Result -> CInt -> IO Integer
  fromSqlResultRow res nRow = do
    getPGTypeValue res nRow 0 :: IO Integer

instance SqlRow Bool where
  fromSqlResultRow :: Result -> CInt -> IO Bool
  fromSqlResultRow res nRow = do
    getPGTypeValue res nRow 0 :: IO Bool

instance SqlRow User where
  fromSqlResultRow :: Result -> CInt -> IO User
  fromSqlResultRow res nRow = do
    User <$> (getPGTypeValue res nRow 0 :: IO Integer)
         <*> (getPGTypeValue res nRow 1 :: IO (Maybe Text))
         <*> (getPGTypeValue res nRow 2 :: IO Text)

instance SqlRow FlashCard where
  fromSqlResultRow :: Result -> CInt -> IO FlashCard
  fromSqlResultRow res nRow = do
    FlashCard <$> (getPGTypeValue res nRow 0 :: IO Integer)
              <*> (getPGTypeValue res nRow 1 :: IO Text)
              <*> (getPGTypeValue res nRow 2 :: IO [Text])
              <*> (getPGTypeValue res nRow 3 :: IO Text)
              <*> (getPGTypeValue res nRow 4 :: IO Int)
              <*> (getPGTypeValue res nRow 5 :: IO Text)
