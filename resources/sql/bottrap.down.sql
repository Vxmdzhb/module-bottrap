-- Teardown for the Bot-trap module (tools/module.php purge bottrap).
-- Destructive: removes the module's pages and drops its table. Re-enabling
-- afterwards requires reinstalling the schema (tools/install.php).

DELETE FROM `page` WHERE `module` = 'bottrap';

DROP TABLE IF EXISTS `bot_trap_log`;

-- A nav entry whose page is gone is dangling: delete its id-allocator row,
-- which cascades to the entry (navbar_entry.id references navbar_entry_ids).
-- Allocator rows with no entry at all are removed too.
DELETE nid FROM `navbar_entry_ids` nid
  JOIN `navbar_entry` ne ON ne.id = nid.id
  LEFT JOIN `navbar_internal` ni ON ni.id = ne.id
  LEFT JOIN `navbar_external` nx ON nx.id = ne.id
 WHERE ni.id IS NULL AND nx.id IS NULL;
DELETE nid FROM `navbar_entry_ids` nid
  LEFT JOIN `navbar_entry` ne ON ne.id = nid.id
 WHERE ne.id IS NULL;
