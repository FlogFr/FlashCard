module Database.Types where

import Protolude hiding (empty, Location, get)

import Database.PostgreSQL.LibPQ
import Foreign.C.Types
import Control.Exception
import System.IO.Error

import Data.Binary
import Data.Binary.Get
import Data.Time
import Data.UUID
import qualified Data.ByteString.Lazy as BSL
import qualified Data.ByteString as BS

getPGBool :: Get Bool
getPGBool = do
  w <- getWord8
  return $ (fromIntegral w :: Integer) /= 0

getRemainingWord8 :: Get [Word8]
getRemainingWord8 = do
  empty <- isEmpty
  if empty
    then return []
    else do current <- getWord8
            remainingWords <- getRemainingWord8
            return (current:remainingWords)

data PGRange = PGRange
  { pgH              :: !Word8
  , pgLengthStart    :: !Word32
  , pgRangeStartData :: ![Word8]
  , pgLengthStop     :: !Word32
  , pgRangeStopData  :: ![Word8]
  } deriving (Show)

getPGRange :: Get PGRange
getPGRange = do
  pgH' <- getWord8 -- get the first byte
  pgLengthStart' <- getWord32be
  pgRangeStartData' <- getNbPGArrayData pgLengthStart'
  pgLengthStop' <- getWord32be
  pgRangeStopData' <- getNbPGArrayData pgLengthStop'

  return $! PGRange pgH' pgLengthStart' pgRangeStartData' pgLengthStop' pgRangeStopData'

--  Please refer to the documentation of array.h in postgresql repository
--  https://doxygen.postgresql.org/array_8h_source.html
-- *	  <vl_len_>		  - standard varlena header word
-- *	  <ndim>		    - number of dimensions of the array
-- *	  <dataoffset>	- offset to stored data, or 0 if no nulls bitmap
-- *	  <elemtype>	  - element type OID
-- *	  <dimensions>	- length of each array axis (C array of int)
-- *	  <lower bnds>	- lower boundary of each dimension (C array of int)
-- *	  <null bitmap> - bitmap showing locations of nulls (OPTIONAL)
-- *	  <actual data> - whatever is the stored data
data PGArray = PGArray
  { pgArrayVl_len_    :: !Word32
  , pgArrayNbDim      :: !(Maybe Word16)
  , pgArrayDataOffset :: !(Maybe Word32)
  , pgArrayElemType   :: !(Maybe Word16)
  , pgArrayDimensions :: !(Maybe Word32)
  , pgArrayLowerBound :: !(Maybe Word32)
  , pgArrayData       :: ![PGArrayData]
  } deriving (Show)

data PGArrayData = PGArrayData
  { pgArrayDataLength :: !Word32
  , pgArrayDataData   :: ![Word8]
  } deriving (Show)

getNb16PGArrayData :: Word16 -> Get [Word8]
getNb16PGArrayData 0 = return []
getNb16PGArrayData nbWords = do
  currentWord <- getWord8
  remainingWords <- getNb16PGArrayData (nbWords - 1)
  return (currentWord:remainingWords)

getNbPGArrayData :: Word32 -> Get [Word8]
getNbPGArrayData 0 = return []
getNbPGArrayData nbWords = do
  currentWord <- getWord8
  remainingWords <- getNbPGArrayData (nbWords - 1)
  return (currentWord:remainingWords)

getPGArrayData :: Get PGArrayData
getPGArrayData = do
  textLength <- getWord32be
  pgWord8' <- getNbPGArrayData textLength
  return $ PGArrayData textLength pgWord8'

getPGArrayDataList :: Get [PGArrayData]
getPGArrayDataList = do
  empty <- isEmpty
  if empty
    then return []
    else do pgArrayData' <- getPGArrayData
            pgArrayDatas' <- getPGArrayDataList
            return (pgArrayData':pgArrayDatas')

getPGArray :: Get PGArray
getPGArray = do
  vl_len_' <- getWord32be
  if vl_len_' == 0
    then do
      return $! PGArray vl_len_' Nothing Nothing Nothing Nothing Nothing []
    else do
      nbDim'   <- getWord16be
      dataOffset' <- getWord32be
      elemType' <- getWord16be
      dimensions' <- getWord32be
      lowerBound' <- getWord32be

      -- A text is represented by the length of the next words
      -- then appended the text
      pgArrayData' <- getPGArrayDataList

      return $! PGArray vl_len_' (Just nbDim') (Just dataOffset') (Just elemType') (Just dimensions') (Just lowerBound') pgArrayData'

class PGType a where
  decodePGType :: BSL.ByteString -> IO a

  getPGTypeValue :: Result -> CInt -> CInt -> IO a
  getPGTypeValue res nRow nCol = do
    mValueBS <- getvalue res (Row nRow) (Col nCol)
    case mValueBS of
      Just valueBS -> decodePGType . BSL.fromStrict $ valueBS
      Nothing -> throw $ userError "Impossible to get the value bytestring"


instance PGType [Text] where
  decodePGType bs = do
    return $ (decodeUtf8 . BS.pack) <$> words8
    where words8  = fmap pgArrayDataData $ pgArrayData pgArray
          pgArray = runGet getPGArray bs


instance PGType (Maybe Text) where
  decodePGType bs = return $ Just (decodeUtf8 . BSL.toStrict $ bs)
  getPGTypeValue res nRow nCol = do
    mValueBS <- getvalue res (Row nRow) (Col nCol)
    return $ decodeUtf8 <$> mValueBS

instance PGType Text where
  decodePGType bs = return $ decodeUtf8 . BSL.toStrict $ bs

instance PGType UUID where
  decodePGType bs = do
    let mValue = fromByteString bs
    case mValue of
      Just value' -> return value'
      Nothing -> throw $ userError "Impossible to decode expected UUID"

instance PGType ByteString where
  decodePGType bs = return $ BSL.toStrict bs

instance PGType BSL.ByteString where
  decodePGType bs = return $ bs

instance PGType Bool where
  decodePGType bs = return $ runGet getPGBool bs

instance PGType Double where
  decodePGType bs = return $ runGet getDoublebe bs

instance PGType Int where
  decodePGType bs = return $ fromIntegral $ runGet getInt32be bs

instance PGType Integer where
  decodePGType bs = return $ fromIntegral $ runGet getInt64be bs

getTupleWord64 :: Get (Word64, Word64)
getTupleWord64 = do
  firstWord64 <- getWord64be
  secondWord64 <- getWord64be
  _ <- getWord8 -- 1 byte unconsume for flag
  return (firstWord64,secondWord64)

getDate :: Get (Integer, Integer)
getDate = do
  totalSeconds <- get :: Get Int64
  let relDays    = (totalSeconds `div` 86400000000) + 51544
  let relSeconds = (totalSeconds `mod` 86400000000) `div` 1000000
  return (fromIntegral relDays, fromIntegral relSeconds)


instance PGType UTCTime where
  decodePGType bs = return $ UTCTime (ModifiedJulianDay relDays) (secondsToDiffTime relSeconds)
                    where (relDays, relSeconds)  = runGet getDate bs

instance PGType Float where
  decodePGType bs = return $ runGet getFloatbe bs
