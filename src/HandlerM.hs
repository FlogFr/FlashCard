module HandlerM where

import Control.Monad.Trans.Reader (runReaderT, ReaderT)
import Control.Monad.Logger
import SharedEnv
import Servant


-- hoistServer :: HasServer api '[] => Proxy api -> (forall x. m x -> n x) -> ServerT api m -> ServerT api n 
--                                                  ^^^^^^^^^^^^^^^^^^^^^^
nt :: SharedEnv -> HandlerM a -> Handler a
-- runReaderT :: conf -> m a
nt c x = runStderrLoggingT (runReaderT x c)

-- newtype ReaderT conf m a
type HandlerM = ReaderT SharedEnv (LoggingT Handler)
