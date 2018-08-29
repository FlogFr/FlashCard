-- Revert words:0001-words from pg

BEGIN;

  DROP TABLE "words";

COMMIT;
