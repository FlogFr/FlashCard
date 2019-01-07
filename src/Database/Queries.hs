module Database.Queries where

import           Protolude hiding (FatalError)

import           Data.Pool

import           Database.PostgreSQL.LibPQ
import qualified Data.ByteString.Internal      as B
                                                ( ByteString(..) )

import           Control.Exception
import           SharedEnv
import           Database.SqlRow
import           Data.Exception
import Cache
import           HandlerM

-- PG_TYPE_BOOL			16
-- PG_TYPE_BYTEA			17
-- PG_TYPE_CHAR			18
-- PG_TYPE_NAME			19
-- PG_TYPE_INT8			20
-- PG_TYPE_INT2			21
-- PG_TYPE_INT2VECTOR		22
-- PG_TYPE_INT4			23
-- PG_TYPE_REGPROC			24
-- PG_TYPE_TEXT			25
-- PG_TYPE_OID				26
-- PG_TYPE_TID				27
-- PG_TYPE_XID				28
-- PG_TYPE_CID				29
-- PG_TYPE_OIDVECTOR		30
-- PG_TYPE_SET				32
-- PG_TYPE_XML			142
-- PG_TYPE_XMLARRAY		143
-- PG_TYPE_CHAR2			409
-- PG_TYPE_CHAR4			410
-- PG_TYPE_CHAR8			411
-- PG_TYPE_POINT			600
-- PG_TYPE_LSEG			601
-- PG_TYPE_PATH			602
-- PG_TYPE_BOX				603
-- PG_TYPE_POLYGON			604
-- PG_TYPE_FILENAME		605
-- PG_TYPE_CIDR			650
-- PG_TYPE_FLOAT4			700
-- PG_TYPE_FLOAT8			701
-- PG_TYPE_ABSTIME			702
-- PG_TYPE_RELTIME			703
-- PG_TYPE_TINTERVAL		704
-- PG_TYPE_UNKNOWN			705
-- PG_TYPE_MONEY			790
-- PG_TYPE_OIDINT2			810
-- PG_TYPE_MACADDR			829
-- PG_TYPE_INET			869
-- PG_TYPE_OIDINT4			910
-- PG_TYPE_OIDNAME			911
-- PG_TYPE_TEXTARRAY		1009
-- PG_TYPE_BPCHARARRAY		1014
-- PG_TYPE_VARCHARARRAY		1015
-- PG_TYPE_BPCHAR			1042
-- PG_TYPE_VARCHAR			1043
-- PG_TYPE_DATE			1082
-- PG_TYPE_TIME			1083
-- PG_TYPE_TIMESTAMP_NO_TMZONE	1114		/* since 7.2 */
-- PG_TYPE_DATETIME		1184
-- PG_TYPE_TIME_WITH_TMZONE	1266		/* since 7.1 */
-- PG_TYPE_TIMESTAMP		1296	/* deprecated since 7.0 */
-- PG_TYPE_NUMERIC			1700
-- PG_TYPE_RECORD			2249
-- PG_TYPE_VOID			2278

queryFromText :: (SqlRow a) => Connection -> Text -> [Maybe (Oid, B.ByteString, Format)] -> IO [a]
queryFromText conn sqlQuery params = do
  mresult <- execParams conn (encodeUtf8 sqlQuery) params Binary 
  case mresult of
    Just result -> do
      rStatus <- resultStatus result
      case rStatus of
        TuplesOk -> fromSqlResultRows result
        FatalError -> do
          diagSqlstate <- resultErrorField result DiagSqlstate

          diagSeverity <- resultErrorField result DiagSeverity
          putStrLn $ ("DiagSeverity : " <> (show diagSeverity) :: Text)
          diagMessagePrimary <- resultErrorField result DiagMessagePrimary
          putStrLn $ ("DiagMessagePrimary : " <> (show diagMessagePrimary) :: Text)
          diagMessageDetail <- resultErrorField result DiagMessageDetail
          putStrLn $ ("DiagMessageDetail : " <> (show diagMessageDetail) :: Text)
          diagMessageHint <- resultErrorField result DiagMessageHint
          putStrLn $ ("DiagMessageHint : " <> (show diagMessageHint) :: Text)
          diagStatementPosition <- resultErrorField result DiagStatementPosition
          putStrLn $ ("DiagStatementPosition : " <> (show diagStatementPosition) :: Text)
          diagInternalPosition <- resultErrorField result DiagInternalPosition
          putStrLn $ ("DiagInternalPosition : " <> (show diagInternalPosition) :: Text)
          diagInternalQuery <- resultErrorField result DiagInternalQuery
          putStrLn $ ("DiagInternalQuery : " <> (show diagInternalQuery) :: Text)
          diagContext <- resultErrorField result DiagContext
          putStrLn $ ("DiagContext : " <> (show diagContext) :: Text)
          diagSourceFile <- resultErrorField result DiagSourceFile
          putStrLn $ ("DiagSourceFile : " <> (show diagSourceFile) :: Text)
          diagSourceLine <- resultErrorField result DiagSourceLine
          putStrLn $ ("DiagSourceLine : " <> (show diagSourceLine) :: Text)
          diagSourceFunction <- resultErrorField result DiagSourceFunction
          putStrLn $ ("DiagSourceFunction : " <> (show diagSourceFunction) :: Text)
          putStrLn $ ("DiagSqlstate : " <> (show diagSqlstate) :: Text)

          case diagSqlstate of
            Just sqlStateBS -> do
              let sqlState = show sqlStateBS :: [Char]
              case sqlState of
                -- https://www.postgresql.org/docs/current/errcodes-appendix.html
                "\"23505\"" -> throw ExceptionPGUniqueViolation
                "\"P1002\"" -> throw ExceptionPGJWTMalformed
                "\"P1003\"" -> throw ExceptionPGJWTInvalid
                _ -> throw $ ExceptionText "Dont know this PG exception"
            Nothing -> throw $ ExceptionText "Cant retrieve the PostgreSQL error field SqlState"
        otherStatus -> do
          putStrLn $ ("PG Status : " <> (show otherStatus) :: Text)
          throw $ ExceptionText "Wrong PostgreSQL result status, please check"
    Nothing -> throw $ ExceptionText "Didnt receive a PostgreSQL result"

runSqlFile :: (SqlRow a) => FilePath -> [Maybe (Oid, B.ByteString, Format)] -> HandlerM (Either ExceptionPostgreSQL [a])
runSqlFile sqlFilePath params = do
  -- fetch the events
  sharedEnv <- ask
  let dbPool = dbConnectionPool sharedEnv
  sqlQuery <- readCacheOrFile sqlFilePath
  withResource dbPool $ \conn -> liftIO $ try $ do
    queryFromText conn sqlQuery params

runSqlFile' :: (SqlRow a) => FilePath -> [Maybe (Oid, B.ByteString, Format)] -> HandlerM [a]
runSqlFile' sqlFilePath params = do
  -- Unsafe function that can throw exception
  eitherResult <- runSqlFile sqlFilePath params :: (SqlRow a) => HandlerM (Either ExceptionPostgreSQL [a])
  case eitherResult of
    Right result -> return result
    Left err -> throw $ toException err
