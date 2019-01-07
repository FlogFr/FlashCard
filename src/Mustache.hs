module Mustache where

import Protolude

import Text.Mustache
import Text.Mustache.Types
import qualified Data.Vector as V
import Data



newtype MessageMustache = MessageMustache Text
instance ToMustache MessageMustache where
  toMustache (MessageMustache messageText) = object
    [ "message" ~> (String $ messageText)
    ]

newtype FlashCardTagMustache = FlashCardTagMustache Text
instance ToMustache FlashCardTagMustache where
  toMustache (FlashCardTagMustache tag) = object
    [ "tag" ~> (String tag) ]

newtype FlashCardMustache = FlashCardMustache FlashCard
instance ToMustache FlashCardMustache where
  toMustache (FlashCardMustache flashCard@FlashCard{}) = object
    [ "id" ~> (Number . fromInteger $ flashCardId flashCard)
    , "recto" ~> (String $ flashCardRecto flashCard)
    , "recto-value" ~> (String $ (if (flashCardSide flashCard) == "recto" then (flashCardRecto flashCard) else ""))
    , "recto-disabled" ~> (String $ (if (flashCardSide flashCard) == "recto" then "disabled" else ""))
    , "verso" ~> (String $ flashCardVerso flashCard)
    , "verso-value" ~> (String $ (if (flashCardSide flashCard) == "verso" then (flashCardVerso flashCard) else ""))
    , "verso-disabled" ~> (String $ (if (flashCardSide flashCard) == "verso" then "disabled" else ""))
    , "tags" ~> (V.fromList (toMustache . FlashCardTagMustache <$> flashCardTags flashCard))
    ]

newtype UserMustache = UserMustache User
instance ToMustache UserMustache where
  toMustache (UserMustache user@User{}) = object
    [ "username" ~> (String $ fromMaybe "" (userUsername user))
    , "email" ~> (String $ userEmail user)
    ]
