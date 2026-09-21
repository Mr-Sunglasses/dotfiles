PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS quicklinks(
  id TEXT PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  link TEXT NOT NULL,
  open_with TEXT,
  icon TEXT,
  in_root_search INTEGER NOT NULL DEFAULT 1,
  pinned_at REAL,
  created_at REAL NOT NULL,
  is_enabled INTEGER NOT NULL DEFAULT 1
);
INSERT OR IGNORE INTO quicklinks VALUES('1FDE924E-308D-4014-80FD-35C46373A27D','ggl','https://www.google.com/search?q={argument name="Argument"}',NULL,NULL,1,NULL,1790000080.552,1);
INSERT OR IGNORE INTO quicklinks VALUES('6CF57CEE-DDED-4320-A411-F6C95A945DF2','yt','https://www.youtube.com/results?search_query={argument name="Argument"}',NULL,NULL,1,NULL,1790000080.552,1);
INSERT OR IGNORE INTO quicklinks VALUES('ABCF586A-5887-41AC-87F9-568AAF92D789','Search Google','https://google.com/search?q={argument}',NULL,NULL,1,NULL,1790000080.552,1);
INSERT OR IGNORE INTO quicklinks VALUES('23BCE398-AAB1-4EBE-9026-1AD92274C372','Search DuckDuckGo','https://duckduckgo.com/?q={argument}',NULL,NULL,1,NULL,1790000080.552,1);
COMMIT;
