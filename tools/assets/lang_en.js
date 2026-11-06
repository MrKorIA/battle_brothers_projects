registerLang("en", {
  app_title: "BB Sprite Editor — tune sprites without restarting the game",
  btn_open: "Open PNG…",
  tt_open: "pick one PNG: the editor finds the brush it belongs to",
  chk_doll: "doll",
  tt_doll: "base doll (body+head) beneath all layers",
  chk_dead: "corpse",
  tt_dead: "dead doll (_dead sprites) beneath all layers",
  chk_tile: "tile",
  tt_tile: "tactical map tile beneath objects (doll for static objects)",
  not_loaded: "not loaded",
  btn_save: "Save",
  btn_download: "Download XML",
  hdr_sprites: "Sprites",
  filter_ph: "filter… (click — add to stage)",
  empty_list: "Open a sprite via «Open PNG…» or drag PNG + metadata.xml here.",
  hdr_scene: "Stage (doll)",
  hdr_props: "Properties",
  no_selection: "No sprite selected",
  hint: "Click — select · Drag — move · Wheel — zoom · Middle button — pan · Arrows — 1px (Shift — 10px)",
  drop_hint: "Drop to load",
  err_no_chrome: "Opening by PNG requires Chrome/Edge.",
  err_no_sprite_in_xml: "ERROR: {file} has no sprite «{id}» — wrong brush.",
  err_sprite_not_found: "ERROR: sprite «{id}» not found in {name}",
  err_write: "ERROR writing {name}: {msg}",
  drop_brushes: "brushes",
  drop_sprites_with_imgs: "Drop-brush {name}: sprites with images — {n}. Save via download.",
  drop_wait_xml: "Received PNG: {n}. Now drop this brush's metadata.xml.",
  st_dirty_refresh: "Brush «{name}» changed on disk, but there are unsaved edits —\nfresh data NOT pulled (save or reset your edits first).",
  vis: "visibility",
  tt_up: "up",
  tt_down: "down",
  tt_del: "remove from stage",
  prop_opacity: "opacity",
  prop_layer: "layer",
  tt_layer: "VISUAL layer: draw order only (as in game). Does NOT move the sprite, not written to XML.",
  layer_hint: "layer = z-order, NOT position",
  prop_offset_tip: "registration point shift; final rect = coords + offset",
  part_none: "none",
  part_helmet: "helmet",
  part_armor: "armor",
  part_up: "upgrade",
  part_weapon: "weapon",
  btn_snap: "Snap to doll",
  tt_snap: "move ONLY this sprite onto the doll part (preview only, not written to XML)",
  btn_reset: "Reset",
  tt_reset: "restore original coordinates and snap",
  btn_copy: "Copy coords",
  tt_copy: "copy sprite coordinates (for _damaged/_dead variants)",
  btn_paste: "Paste coords",
  tt_paste: "apply copied coordinates to this sprite",
  snap_no_target: "No doll target for this part (pick a type: helmet/armor/upgrade).",
  snap_already: "Sprite is already in place (within a couple of pixels) — snap skipped.",
  st_coords_copied: "Coordinates copied: {v}",
  st_no_clipboard: "Copy coordinates first («Copy coords» button).",
  st_brushes_line: "Brushes: {list}",
  st_changed_line: "Changed sprites: {n}",
  st_save_xml_disk: "Saving — directly into xml files on disk.",
  st_save_xml_dl: "Saving — via download (drag&drop brush).",
  st_saved_disk: "Saved: {names}. Pack with:\nbbrusher.exe pack <path>.brush <folder> --gfxPath <where to put gfx>",
  st_saved_download: "Downloaded files: {names} — replace metadata.xml in brush folders.",
  st_none_loaded: "—",
  help: "Workflow:\n" +
    "1) Unpack brushes:  bbrusher.exe unpack entity_0.brush entity_0\n" +
    "2) «Open PNG…» (Chrome/Edge required): 1st dialog — PNG. The 2nd dialog (its xml) appears\n" +
    "   only if the sprite is unknown to every loaded brush; otherwise the PNG binds to the\n" +
    "   known brush right away (xml is re-read from disk). Every open uses fresh data.\n" +
    "   Brushes live independently and save into their own xml files.\n" +
    "3) Checkboxes: «doll»/«corpse» — base body+head; «tile» — doll for static objects.\n" +
    "   z-order as in game: doll body → armor → upgrade _back → doll head → helmet →\n" +
    "   upgrade _front/other.\n" +
    "4) Layer (helmet/armor/upgrade/weapon): VISUAL switch — sets draw order only (as in\n" +
    "   game), does NOT move the sprite and is not written to XML. The «Snap to doll» button\n" +
    "   is a separate preview jump of ONLY this sprite onto a doll part (for foreign brushes;\n" +
    "   not written to XML). «Copy coords»/«Paste» — transfer coordinates between variants\n" +
    "   (clean ↔ _damaged ↔ _dead).\n" +
    "5) Edit coordinates: drag, arrows, fields. Missing rect edges are derived from the PNG\n" +
    "   size and materialize in XML once edited.\n" +
    "6) «Save» — writes each brush into its own xml (drag&drop brushes via download).\n" +
    "   Pack:  bbrusher.exe pack entity_0.brush entity_0 --gfxPath <where to put gfx>\n\n" +
    "Coordinates: left/right/top/bottom — sprite rect relative to the pivot; offsetX/offsetY —\n" +
    "registration point shift (sum). Y axis points up — as in the game."
});
