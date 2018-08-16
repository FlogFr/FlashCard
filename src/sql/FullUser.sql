-- name:updateFullUser :: User
-- :user      :: User
-- :fullUser  :: FullUser
UPDATE
  users
SET
    email    = :fullUser.(FullUser.email)
  , lang     = :fullUser.(FullUser.lang)
WHERE
    users.id = :user.(User.userid)
RETURNING
    id
  , username
  , email
  , lang
;;;
