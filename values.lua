RELEASE_BUILD = false

DEFAULT_WIDTH = 800
DEFAULT_HEIGHT = 600

ANIM_TIMER = 180
MAX_MOVE_TIMER = 80
MAX_UNDO_DELAY = 150
MIN_UNDO_DELAY = 50
UNDO_SPEED = 5
UNDO_DELAY = MAX_UNDO_DELAY
repeat_keys = {"wasd","udlr","numpad","ijkl","space","undo","tfgh"}

--is_mobile = love.system.getOS() == "Android" or love.system.getOS() == "iOS"
emulating_mobile = false

PACK_UNIT_V1 = "hhhb" -- TILE, X, Y, DIR
PACK_UNIT_V2 = "hhhhbs" -- ID, TILE, X, Y, DIR, SPECIALS
PACK_UNIT_V3 = "llhhbs" -- ID, TILE, X, Y, DIR, SPECIALS

PACK_SPECIAL_V2 = "ss" -- KEY, VALUE

profile = {
  name = "bab"
}

defaultsettings = {
  is_mobile = false,
  master_vol = 1,
  music_on = true,
  music_vol = 1,
  sfx_on = true,
  sfx_vol = 1,
  focus_sound = true,
  rhythm_interval = 1,
  particles_on = true,
  shake_on = true,
  scribble_anim = true,
  debugg = false,
  light_on = true,
  lessflashing = false,
  int_scaling = true,
  input_delay = 150,
  grid_lines = false,
  mouse_lines = false,
  stopwatch_effect = true,
  fullscreen = false,
  focus_pause = false,
  level_compression = "zlib",
  draw_editor_lins = true,
  infomode = false,
  scroll_on = true,
  menu_anim = true,
  themes = true,
  autoupdate = true,
  print_to_screen = false,
  unfinished_words = false,
  max_wobble = false,
  true_wobble = false,
  editor_music = false,
  day = true,
  night = false,
  baba = true,
  randomize = false,
  contrast = false,
  canspooku = false,
}

if love.filesystem.read("Settings.bab") ~= nil then
  settings = json.decode(love.filesystem.read("Settings.bab"))
  for i in pairs(defaultsettings) do
    if settings[i] == nil then
      settings[i] = defaultsettings[i]
    end
  end
else
  settings = defaultsettings
end

debug_view= false
superduperdebugmode = false
debug_values = {

}

rainbowmode = false

displayids = false

if love.filesystem.getInfo("build_number") ~= nil then
  build_number = love.filesystem.read("build_number")
else
  build_number = "HEY, READ THE README!"
end

ruleparts = {"subject", "verb", "object"}

dirs = {{1,0},{0,1},{-1,0},{0,-1}}
dirs_by_name = {
  right = 1,
  down = 2,
  left = 3,
  up = 4
}
dirs_by_offset = {}
dirs_by_offset[-1],dirs_by_offset[0],dirs_by_offset[1] = {},{},{}
dirs_by_offset[1][0] = 1
dirs_by_offset[0][1] = 2
dirs_by_offset[-1][0] = 3
dirs_by_offset[0][-1] = 4
dirs8 = {{1,0},{1,1},{0,1},{-1,1},{-1,0},{-1,-1},{0,-1},{1,-1}}
dirs8_by_name = {
  "right",
  "downright",
  "down",
  "downleft",
  "left",
  "upleft",
  "up",
  "upright",
}

cilindr_names = {
  cilindr_right,
  cilindr_downright,
  cilindr_down,
  cilindr_downleft,
  cilindr_left,
  cilindr_upleft,
  cilindr_up,
  cilindr_upright,
}
mobyus_names = {
  mobyus_right,
  mobyus_downright,
  mobyus_down,
  mobyus_downleft,
  mobyus_left,
  mobyus_upleft,
  mobyus_up,
  mobyus_upright,
}

dirs8_by_name_set = {};
for _,dir in ipairs(dirs8_by_name) do
  dirs8_by_name_set[dir] = true
end

dirs8_by_offset = {}
dirs8_by_offset[-1],dirs8_by_offset[0],dirs8_by_offset[1] = {},{},{}
dirs8_by_offset[1][0] = 1
dirs8_by_offset[1][1] = 2
dirs8_by_offset[0][1] = 3
dirs8_by_offset[-1][1] = 4
dirs8_by_offset[-1][0] = 5
dirs8_by_offset[-1][-1] = 6
dirs8_by_offset[0][-1] = 7
dirs8_by_offset[1][-1] = 8
TILE_SIZE = 32

mapwidth = 21
mapheight = 15

map_music = "map"
map_ver = 1

default_map = '{"width":21,"version":5,"extra":false,"author":"","compression":"zlib","background_sprite":"","height":15,"next_level":"","puffs_to_clear":0,"parent_level":"","is_overworld":false,"palette":"default","music":"map","name":"new level","map":"eJyNkUEKgzAQRa8i7gpZdGKrtpKziJqxBIJKjKCId2+SFu2mJotk9d7nM5/3keybSkYlW1ctJLJYz7qsqzomMwMiuPkW88YBG1FJtm6EC8VgI784Wppamp7T32CHJgbNzoMnCycWvvlbDArH0QoPK9yNkJ4LLd3p1N+FIhd6FzIj5IF9wN0xDygEB/4IaDRIXA4Drv5OrexfzsicEbwt5I73rLunf+iAgZ8Xx7uTwp+Nt0KhnlQXlQV2/A10B+gd"}'

main_palette_for_colour = {
blacc = {0, 4},
reed = {2, 2}, 
orang = {2, 3},
yello = {2, 4},
grun = {5, 2},
limeme = {5, 3},
cyeann = {1, 4},
bleu = {1, 3},
purp = {3, 1},
whit = {0, 3},
pinc = {4, 1},
corl = {4, 2},
graey = {0, 1},
brwn = {6, 0},
golld = {6, 2},
viloet = {3, 3},
extra = {0, 0},
pushy = {6, 1},
darkreed = {2, 1},
darkgrun = {5, 1},
darkpinc = {4, 0},
}
color_names = {"reed", "orang", "yello", "grun", "cyeann", "bleu", "purp", "pinc", "whit", "blacc", "graey", "brwn", "corl", "limeme", "golld", "viloet", "extra", "pushy", "darkreed", "darkgrun", "darkpinc"}

colour_for_palette = {}
colour_for_palette[0] = {}
colour_for_palette[0][0] = "blacc"
colour_for_palette[0][1] = "graey"
colour_for_palette[0][2] = "graey"
colour_for_palette[0][3] = "whit"
colour_for_palette[0][4] = "blacc"
colour_for_palette[1] = {}
colour_for_palette[1][0] = "blacc"
colour_for_palette[1][1] = "bleu"
colour_for_palette[1][2] = "bleu"
colour_for_palette[1][3] = "bleu"
colour_for_palette[1][4] = "cyeann"
colour_for_palette[2] = {}
colour_for_palette[2][0] = "reed"
colour_for_palette[2][1] = "reed"
colour_for_palette[2][2] = "reed"
colour_for_palette[2][3] = "orang"
colour_for_palette[2][4] = "yello"
colour_for_palette[3] = {}
colour_for_palette[3][0] = "pinc"
colour_for_palette[3][1] = "purp"
colour_for_palette[3][2] = "purp"
colour_for_palette[3][3] = "viloet"
colour_for_palette[3][4] = nil
colour_for_palette[4] = {}
colour_for_palette[4][0] = "pinc"
colour_for_palette[4][1] = "pinc"
colour_for_palette[4][2] = "corl"
colour_for_palette[4][3] = nil
colour_for_palette[4][4] = nil
colour_for_palette[5] = {}
colour_for_palette[5][0] = "grun"
colour_for_palette[5][1] = "grun"
colour_for_palette[5][2] = "grun"
colour_for_palette[5][3] = "limeme"
colour_for_palette[5][4] = nil
colour_for_palette[6] = {}
colour_for_palette[6][0] = "brwn"
colour_for_palette[6][1] = "brwn"
colour_for_palette[6][2] = "golld"
colour_for_palette[6][3] = "brwn"
colour_for_palette[6][4] = "blacc"

--anti replacements for easy words
anti_word_replacements = {
  stubbn = "shy...",
  ["shy..."] = "stubbn",
  nogo = "icyyyy",
  stukc = "vibe",
  vibe = "stukc",
  goawaypls = "comepls",
  push = "comepls",
  comepls = "goawaypls",
  haetskye = "haetflor",
  haetflor = "haetskye",
  diag = "ortho",
  ortho = "diag",
  turncornr = "folowal",
  folowal = "turncornr",
  rotatbl = "noturn",
  noturn = "rotatbl",
  right = "left",
  downright = "upleft",
  down = "up",
  downleft = "upright",
  left = "right",
  upleft = "downright",
  up = "down",
  upright = "downleft",
  thicc = "babby",
  [":)"] = "un:)",
  win2 = "defeat",
  defeat = "win2",
  ["un:)"] = ":)",
  nedkee = "fordor",
  fordor = "nedkee",
  shut = "open",
  open = "shut",
  hotte = "fridgd",
  fridgd = "hotte",
  cool = "hotte",
  thingify = "txtify",
  txtify = "thingify",
  ["n'tify"] = "ify",
  ["ify"] = "n'tify",
  ["n'tifyyy"] = "ify",
  notranform = "tranz",
  noundo = "undo",
  undo = "noundo",
  brite = "tranparnt",
  tranparnt = "brite",
  gone = "zomb",
  zomb = "gone",
  reed = "cyeann",
  orang = "bleu",
  yello = "purp",
  grun = "pinc",
  limeme = "corl",
  corl = "limeme",
  cyeann = "reed",
  bleu = "orang",
  purp = "yello",
  pinc = "grun",
  whit = "blacc",
  graey = "graey",
  blacc = "whit",
  brwn = "cyeann",
  creat = "snacc",
  snacc = "creat",
  liek = "haet",
  haet = "liek",
  lookat = "lookaway",
  lookaway = "lookat",
  corekt = "rong",
  rong = "corekt",
  seenby = "behind",
  behind = "seenby",
  halfstep = "hopovr",
  clip = "board",
}

--anti replacements for easy words
omega_word_replacements = {
  stubbn = "shy...",
  ["shy..."] = "stubbn",
  nogo = "yesgo",
  yesgo = "nogo",
  stukc = "vibe",
  vibe = "stukc",
  goawaypls = "comepls",
  push = "comepls",
  comepls = "goawaypls",
  haetskye = "haetflor",
  haetflor = "haetskye",
  diag = "ortho",
  ortho = "diag",
  turncornr = "folowal",
  folowal = "turncornr",
  rotatbl = "noturn",
  noturn = "rotatbl",
  right = "left",
  downright = "upleft",
  down = "up",
  downleft = "upright",
  left = "right",
  upleft = "downright",
  up = "down",
  upright = "downleft",
  thicc = "babby",
  [":)"] = "un:)",
  ["un:)"] = ":)",
  nedkee = "fordor",
  fordor = "nedkee",
  hotte = "fridgd",
  fridgd = "hotte",
  cool = "hotte",
  thingify = "txtify",
  txtify = "thingify",
  ["n'tify"] = "ify",
  ["ify"] = "ifyyy",
  ["n'tifyyy"] = "ify",
  notranform = "tranz",
  noundo = "undo",
  undo = "noundo",
  brite = "tranparnt",
  tranparnt = "brite",
  gone = "zomb",
  zomb = "gone",
  reed = "cyeann",
  orang = "bleu",
  yello = "purp",
  grun = "pinc",
  limeme = "corl",
  corl = "limeme",
  cyeann = "reed",
  bleu = "orang",
  purp = "yello",
  pinc = "grun",
  whit = "blacc",
  graey = "graey",
  blacc = "whit",
  brwn = "cyeann",
  creat = "snacc",
  snacc = "creat",
  liek = "haet",
  haet = "liek",
  lookat = "lookaway",
  lookaway = "lookat",
  corekt = "rong",
  rong = "corekt",
  seenby = "behind",
  behind = "seenby",
  halfstep = "hopovr",
  clip = "board",
}

anti_word_reverses = {
  wont = true,
  oob = true,
  frenles = true,
  timles = true,
  lit = true,
  alt = true,
  past = true,
  wun = true,
  an = true,
  mayb = true,
  ["wait..."] = true,
  ["w/fren"] = true,
  arond = true,
  sans = true,
  meow = true,
}

anti_verb_mirrors = {
  be = true,
  got = true,
  paint = true,
  rp = true,
}

--in palettes: (3,4) is main title buttons, (4,4) is level buttons, (5,4) is extras
menu_palettes = {
  "autumn",
  "cauliflower",
  "default",
  "edge",
  "factory",
  "garden",
  "greenfault",
  "future",
  "abstract",
  "mountain",
  "ocean",
  "redfault",
  "ruins",
  --"inverted",
  "space",
  "variant",
  "volcano",
  --"scribble",
  "mono",
  --"babatiles",
  "baba",
  --"mspaint mod",
  --"r",
  "corruption",
  --"granddad",
  --"gramfild",
  "babadefault",
}


custom_letter_quads = {
  {}, -- single letters will always use actual letter units, not custom letter units
  {
    {love.graphics.newQuad(0, 0, 16, 32, 64, 64), 0, 0},
    {love.graphics.newQuad(16, 0, 16, 32, 64, 64), 16, 0},
  },
  {
    {love.graphics.newQuad(32, 0, 16, 16, 64, 64), 0, 0},
    {love.graphics.newQuad(48, 0, 16, 16, 64, 64), 16, 0},
    {love.graphics.newQuad(0, 48, 32, 16, 64, 64), 0, 16},
  },
  {
    {love.graphics.newQuad(32, 0, 16, 16, 64, 64), 0, 0},
    {love.graphics.newQuad(48, 0, 16, 16, 64, 64), 16, 0},
    {love.graphics.newQuad(32, 16, 16, 16, 64, 64), 0, 16},
    {love.graphics.newQuad(48, 16, 16, 16, 64, 64), 16, 16},
  },
  {
    {love.graphics.newQuad(0, 32, 16, 16, 64, 64), 0, 0},
    {love.graphics.newQuad(16, 32, 16, 16, 64, 64), 16, 0},
    {love.graphics.newQuad(32, 48, 11, 16, 64, 64), 0, 16},
    {love.graphics.newQuad(43, 48, 10, 16, 64, 64), 11, 16},
    {love.graphics.newQuad(53, 48, 11, 16, 64, 64), 21, 16},
  },
  {
    {love.graphics.newQuad(32, 32, 11, 16, 64, 64), 0, 0},
    {love.graphics.newQuad(43, 32, 10, 16, 64, 64), 11, 0},
    {love.graphics.newQuad(53, 32, 11, 16, 64, 64), 21, 0},
    {love.graphics.newQuad(32, 48, 11, 16, 64, 64), 0, 16},
    {love.graphics.newQuad(43, 48, 10, 16, 64, 64), 11, 16},
    {love.graphics.newQuad(53, 48, 11, 16, 64, 64), 21, 16},
  },
}

selector_grid_contents = {
  -- page 1: default
  {
    0, "txt_be", "txt_&", "txt_got", "txt_nt", "txt_every1", "txt_no1", "txt_txt", "txt_wurd", "txt_txtify", 0, "txt_wait...", "txt_mous", "txt_clikt", "txt_nxt", "txt_stayther", "lvl", "txt_lvl",0,0,0,0,0,0,
    "bab", "txt_bab", "txt_u", "kee", "txt_kee", "txt_fordor", "txt_goooo", "txt_icy", "txt_icyyyy", "txt_behinu", "txt_moar", "txt_sans", "txt_liek", "txt_infloop", "lin", "txt_lin", "selctr", "txt_selctr",0,0,0,0,0,0,
    "keek", "txt_keek", "txt_walk", "dor", "txt_dor", "txt_nedkee", "txt_frens", "txt_gang", "txt_utoo", "txt_utres", "txt_delet", "txt_an", "txt_haet", "txt_mayb", "txt_that", "txt_ignor", "txt_curse", "txt_...",0,0,0,0,0,0,
    "flog", "txt_flog", "txt_:)", "colld", "txt_colld", "txt_fridgd", "txt_direction", "txt_ouch", "txt_slep", "txt_protecc", "txt_sidekik", "txt_brite", "txt_lit", "txt_tranparnt", "txt_torc", "txt_vs", "txt_nuek", "txt_''",0,0,0,0,0,0,
    "roc", "txt_roc", "txt_goawaypls", "laav", "txt_laav", "txt_hotte","txt_visitfren", "txt_w/fren", "txt_arond", "txt_frenles", "txt_copkat", "txt_zawarudo", "txt_timles", "txt_behind", "txt_beside", "txt_lookaway", "txt_notranform", "this",0,0,0,0,0,0,
    "wal", "txt_wal", "txt_nogo", "l..uv", "txt_l..uv", "gras", "txt_gras", "txt_creat", "txt_lookat", "txt_spoop", "txt_yeet", "txt_turncornr", "txt_corekt", "txt_goarnd", "txt_mirrarnd", "txt_past", 0, "txt_sing",0,0,0,0,0,0,
    "watr", "txt_watr", "txt_noswim", "meem", "txt_meem", "dayzy", "txt_dayzy", "txt_snacc", "txt_seenby" , "txt_stalk", "txt_moov", "txt_folowal", "txt_rong", "txt_her", "txt_thr", "txt_rithere", "txt_the", 0,0,0,0,0,0,0,
    "skul", "txt_skul", "txt_:(", "til", "txt_til", "hurcane", "txt_hurcane", "gunne", "txt_gunne", "woug", "txt_woug", 0, "txt_shy...", "txt_munwalk", "txt_sidestep", "txt_diagstep", "txt_hopovr", "txt_knightstep",0,0,0,0,0,0,
    "boux", "txt_boux", "txt_comepls", "os", "txt_os", "bup", "txt_bup", "han", "txt_han", "fenss", "txt_fenss", 0, 0, "hol", "txt_hol", "txt_poortoll", "txt_blacc", "txt_reed",0,0,0,0,0,0,
    "bellt", "txt_bellt", "txt_go", "tre", "txt_tre", "piler", "txt_piler", "hatt", "txt_hatt", "hedg", "txt_hedg", 0, 0, "rif", "txt_rif", "txt_glued", "txt_whit", "txt_orang",0,0,0,0,0,0,
    "boll", "txt_boll", "txt_:o", "frut", "txt_frut", "kirb", "txt_kirb", "katany", "txt_katany", "metl", "txt_metl", 0, 0, 0, 0, "txt_enby", "txt_colrful", "txt_yello",0,0,0,0,0,0,
    "clok", "txt_clok", "txt_tryagain", "txt_noundo", "txt_undo", "slippers", "txt_slippers", "firbolt", "txt_firbolt", "jail", "txt_jail", "itt", "txt_itt", "zez", "txt_zez", "txt_tranz", "txt_rave", "txt_grun",0,0,0,0,0,0,
    "splittr", "txt_splittr", "txt_split", "steev", "txt_steev", "boy", "txt_boy", "icbolt", "txt_icbolt", "platfor", "txt_platfor", "chain", "txt_chain", 0, 0, "txt_gay", "txt_stelth", "txt_cyeann",0,0,0,0,0,0,
    "chekr", "txt_chekr", "txt_diag", "txt_ortho", "txt_haetflor", "arro", "txt_arro", "txt_gomyway", "txt_spin", "txt_noturn", "txt_stubbn", "txt_rotatbl", 0, 0, "txt_pinc", "txt_qt", "txt_paint", "txt_bleu",0,0,0,0,0,0,
    "clowd", "txt_clowd", "txt_flye", "txt_tall", "txt_haetskye", "ghostfren", "txt_ghostfren", "robobot", "txt_robobot", "sparkl", "txt_sparkl", "spik", "txt_spik", "spiky", "txt_spiky", "bordr", "txt_bordr", "txt_purp",0,0,0,0,0,0,
    nil
  },
  -- page 2: letters
  {
    "letter_a","letter_b","letter_c","letter_d","letter_e","letter_f","letter_g","letter_h","letter_i","letter_j","letter_k","letter_l","letter_m","letter_n","letter_o","letter_p","letter_q","letter_r",0,0,0,0,0,0,
    "letter_s","letter_t","letter_u","letter_v","letter_w","letter_x","letter_y","letter_z","letter_.","letter_colon","letter_parenthesis","letter_'","letter_/","letter_1","letter_2","letter_3","letter_4","letter_5",0,0,0,0,0,0,
    0,0,0,0,0,0,"letter_-","letter_π","letter_$","letter_;","letter_>",0,0,"letter_6","letter_7","letter_8","letter_9","letter_0",0,0,0,0,0,0,
	"letter_go","letter_come","letter_pls","letter_away","letter_my","letter_no","letter_way","letter_ee","letter_fren","letter_ll","letter_bolt","letter_ol",0,0,0,"letter_*","txt_numa","txt_lethers",0,0,0,0,0,0,
	"txt_c_sharp","txt_d_sharp","txt_f_sharp","txt_g_sharp","txt_a_sharp","txt_sharp","txt_flat","letter_ae","letter_¢","letter_!","letter_ß","letter_+",0,0,0,0,0,0,0,0,0,0,0,0,
	"letter_ba","letter_ab","letter_ke","letter_ek","letter_me","letter_em","letter_ga","letter_al","letter_ut","letter_lk","letter_wa","letter_gr",0,0,0,0,0,0,0,0,0,0,0,0,
	"letter_oe","letter_sh","letter_bi","letter_ib","letter_up","letter_le","letter_ft","letter_do","letter_wn","letter_ag","letter_an","letter_wi",0,0,0,0,0,0,0,0,0,0,0,0,
   	 "letter_ar","letter_at","letter_ca","letter_ji","letter_fo","letter_be","letter_ea","letter_aa","letter_bo","letter_lt","letter_as","letter_fr",0,0,0,0,0,0,0,0,0,0,0,0,
    "letter_en",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 3: ui / instructions
  {
    "ui_esc",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "ui_tab","ui_q","ui_w","ui_e","ui_r","ui_t","ui_y","ui_u","ui_i","ui_o","ui_p","ui_[","ui_-","ui_=","ui_`","ui_7","ui_8","ui_9",0,0,0,0,0,0,
    "ui_cap","ui_a","ui_s","ui_d","ui_f","ui_g","ui_h","ui_j","ui_k","ui_l","ui_;","ui_'","ui_return",0,0,"ui_4","ui_5","ui_6",0,0,0,0,0,0,
    "ui_shift",0,"ui_z","ui_x","ui_c","ui_v","ui_b","ui_n","ui_m","ui_,","ui_.","ui_/",0,0,0,"ui_1","ui_2","ui_3",0,0,0,0,0,0,
    "ui_ctrl","ui_gui","ui_alt",0,"ui_space",0,0,0,0,0,0,0,0,0,0,"ui_arrow","ui_0","ui_del",0,0,0,0,0,0,
    "txt_press","txt_f1","txt_2pley","txt_f2","txt_2edit","ui_leftclick","ui_rightclick",0,0,0,0,0,0,0,0,0,"txt_yuiy","ui_box",0,0,0,0,0,0,
    0,"ui_walk",0,0,"ui_reset",0,0,"ui_undo",0,0,"ui_wait",0,0,"ui_activat",0,0,"ui_clik",0,0,"ui_walk2",0,0,"ui_walk3",0,
    0,"ui_walk4",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 4: characters and special objects
  {
    "bab","txt_bab","kat","txt_kat","flof","txt_flof","babby","txt_babby","bad","txt_bad","fof","txt_fof","one","txt_one","baba","txt_baba","jiji","txt_jiji",0,0,"lila","txt_lila","vite","txt_vite",
    "keek","txt_keek","creb","txt_creb","shrim","txt_shrim","moo","txt_moo","toby","txt_toby","jij","txt_jij","sehseh","txt_sehseh","keke","txt_keke","fofo","txt_fofo",0,0,"pata","txt_pata","jill","txt_jill",
    "meem","txt_meem","statoo","txt_statoo","flamgo","txt_flamgo","migri","txt_migri","temmi","txt_temmi","ballt","txt_ballt","ehceec","txt_ehceec","me","txt_me","it2","txt_it2",0,0,"slab","txt_slab","zsoob","txt_zsoob",
    "skul","txt_skul","beeee","txt_beeee","gul","txt_gul","kva","txt_kva","bunmy","txt_bunmy","cic","txt_cic","beeb","txt_beeb","badbad","txt_badbad","ditto","txt_ditto",0,0,"notnat","txt_notnat","she","txt_she",
    "ghostfren","txt_ghostfren","fishe","txt_fishe","starrfishe","txt_starrfishe","pidgin","txt_pidgin","slogkat","txt_slogkat","evil","txt_evil","bobua","txt_bobua","ghost","txt_ghost","jams","txt_jams",0,0,"ally","txt_ally","butcher","txt_butcher",
    "robobot","txt_robobot","snek","txt_snek","sneel","txt_sneel","swan","txt_swan","b..er","txt_b..er","itte!","txt_itte!","kiik","txt_kiik","ßaßa","txt_ßaßa","meeeep","txt_meeeep",0,0,0,0,"pitta","txt_pitta",
    "woug","txt_woug","bog","txt_bog","enbybog","txt_enbybog","spoder","txt_spoder","niko","txt_niko","tu","txt_tu","smoll","txt_smoll","tesho","txt_tesho",0,0,0,0,0,0,0,0,
    "kirb","txt_kirb","ripof","txt_ripof","trob","txt_trob","cavebab","txt_cavebab","detox","txt_detox","nyowo","txt_nyowo","amoung","txt_amoung","bibi","txt_bibi",0,0,0,0,0,0,"tot","txt_tot",
    "bup","txt_bup","butflye","txt_butflye","boooo","txt_boooo","prime","txt_prime","grimkid","txt_grimkid","dad","txt_dad","bellby","txt_bellby","balt","txt_balt",0,0,0,0,0,0,"fax","txt_fax",
    "boy","txt_boy","wurm","txt_wurm","madi","txt_madi","angle","txt_angle","boogie","txt_boogie","aka","txt_aka","nyaka","txt_nyaka","foomf","txt_foomf",0,0,0,0,0,0,"hempuli","txt_hempuli",
    "steev","txt_steev","ratt","txt_ratt","badi","txt_badi","dvl","txt_dvl","assh","txt_assh","obby","txt_obby","chad.","txt_chad.","floomf","txt_floomf",0,0,0,0,0,0,0,0,
    "han","txt_han","iy","txt_iy","lisp","txt_lisp","paw","txt_paw","humuhumunukunukuapua'a","txt_humuhumunukunukuapua'a","day","txt_day","rru","txt_rru","overdose","txt_overdose",0,0,0,0,0,0,0,0,
    "snoman","txt_snoman","pingu","txt_pingu","der","txt_der","ginn","txt_ginn","snom","txt_snom","ses","txt_ses","hey","txt_hey","sneelectric","txt_sneelectric",0,0,0,0,0,0,"square","txt_square",
    "kapa","txt_kapa","urei","txt_urei","ryugon","txt_ryugon","viruse","txt_viruse","slog","txt_slog","pati","txt_pati","then","txt_then","furlof","txt_furlof",0,0,0,0,0,0,"triangle","txt_triangle",
    "os","txt_os","hors","txt_hors","mimi","txt_mimi","err","txt_err","scorpino","txt_scorpino","gargle","txt_gargle","foof","txt_foof","great","txt_great","rriotu","txt_rriotu",0,0,0,0,"oat","txt_oat",
    "pyuku","txt_pyuku","lokkeek","txt_lokkeek","dorrkeek","txt_dorrkeek","babi","txt_babi","babber","txt_babber","skulnbon","txt_skulnbon","joj","txt_joj","good","txt_good","joofj","txt_joofj",0,0,0,0,0,0,
    "memem","txt_memem","memeemem","txt_memeemem","snoboy","txt_snoboy","wogotch","txt_wogotch","sham","txt_sham","duf","txt_duf","itd","txt_itd","bitte!","txt_bitte!","branium","txt_branium",0,0,0,0,0,0,
  },
  -- page 5: inanimate objects
  {
    "wal","txt_wal","bellt","txt_bellt","hurcane","txt_hurcane","buble","txt_buble","katany","txt_katany","petnygrame","txt_petnygrame","firbolt","txt_firbolt","hol","txt_hol","golf","txt_golf","voom","txt_voom","wan","txt_wan","mug","txt_mug",
    "til","txt_til",0,0,"clowd","txt_clowd","snoflak","txt_snoflak","gunne","txt_gunne","scarr","txt_scarr","litbolt","txt_litbolt","rif","txt_rif","paint","txt_paint","die","txt_die","sno","txt_sno","bel","txt_bel",
    "watr","txt_watr","colld","txt_colld","rein","txt_rein","icecub","txt_icecub","slippers","txt_slippers","pudll","txt_pudll","icbolt","txt_icbolt","win","txt_win","press","txt_press","wres","txt_wres","bowie","txt_bowie","sant","txt_sant",
    "laav","txt_laav","dor","txt_dor","kee","txt_kee","roc","txt_roc","hatt","txt_hatt","extre","txt_extre","poisbolt","txt_poisbolt","smol","txt_smol","pumkin","txt_pumkin","canedy","txt_canedy","bolble","txt_bolble","now","txt_now",
    "gras","txt_gras","algay","txt_algay","flog","txt_flog","boux","txt_boux","knif","txt_knif","heg","txt_heg","timbolt","txt_timbolt","tor","txt_tor","grav","txt_grav","cooky","txt_cooky","pot","txt_pot","sweep","txt_sweep",
    "hedg","txt_hedg","banboo","txt_banboo","boll","txt_boll",0,0,"wips","txt_wips","pepis","txt_pepis","pixbolt","txt_pixbolt","dling","txt_dling","pen","txt_pen","candl","txt_candl","which","txt_which","corndy","txt_corndy",
    "metl","txt_metl","vien","txt_vien","leef","txt_leef","karot","txt_karot","fir","txt_fir","eeg","txt_eeg","foreeg","txt_foreeg","forbeeee","txt_forbeeee","cil","txt_cil","maglit","txt_maglit","cracc","txt_cracc","tobm","txt_tobm",
    "jail","txt_jail","ladr","txt_ladr","pallm","txt_pallm","coco","txt_coco","rouz","txt_rouz","noet","txt_noet","lili","txt_lili","weeb","txt_weeb","3den","txt_3den","whee","txt_whee","joycon","txt_joycon","steam","txt_steam",
    "fenss","txt_fenss","platfor","txt_platfor","tre","txt_tre","stum","txt_stum","dayzy","txt_dayzy","lie","txt_lie","reffil","txt_reffil","ofin","txt_ofin","ches","txt_ches","pois","txt_pois","tres","txt_tres","extres","txt_extres",
    "cobll","txt_cobll","spik","txt_spik","frut","txt_frut","fungye","txt_fungye","red","txt_red","lie/8","txt_lie/8","vlc","txt_vlc","foru","txt_foru","rod","txt_rod","decaey","txt_decaey","predayzy","txt_predayzy","couhc","txt_couhc",
    "wuud","txt_wuud","spiky","txt_spiky","parsol","txt_parsol","clok","txt_clok","ufu","txt_ufu","rockit","txt_rockit","swim","txt_swim","yanying","txt_yanying","casete","txt_casete","clif","txt_clif","stik","txt_stik","rubbe","txt_rubbe",
    "brik","txt_brik","sparkl","txt_sparkl","sanglas","txt_sanglas","bullb","txt_bullb","son","txt_son","muun","txt_muun","bac","txt_bac","warn","txt_warn","piep","txt_piep","mhatt","txt_mhatt","noe","txt_noe","yea","txt_yea",
    "san","txt_san","piler","txt_piler","sancastl","txt_sancastl","shel","txt_shel","starr","txt_starr","cor","txt_cor","byc","txt_byc","gorder","txt_gorder","tuba","txt_tuba","sooda","txt_sooda","furt","txt_furt","hous","txt_hous",
    "glas","txt_glas","bom","txt_bom","sine","txt_sine","kar","txt_kar","can","txt_can","ger","txt_ger","sirn","txt_sirn","chain","txt_chain","rood","txt_rood","¢ont","txt_¢ont","bok","txt_bok","banananana","txt_banananana",
    "trol","txt_trol","wut","txt_wut","wat","txt_wat","splittr","txt_splittr","toggl","txt_toggl","bon","txt_bon","battry","txt_battry","chekr","txt_chekr","do$h","txt_do$h","stomp","txt_stomp","biechboll","txt_biechboll","bulon","txt_bulon",
    "fube","txt_fube","tronk","txt_tronk","cart","txt_cart","drop","txt_drop","woosh","txt_woosh","tanc","txt_tanc","gato","txt_gato","painbuct","txt_painbuct","sinyroc","txt_sinyroc","cryespik","txt_cryespik",0,0,"cair","txt_cair",
    "colect","txt_colect",0,0,0,0,0,0,"b-ir","txt_b-ir","panlie","txt_panlie","cheez","txt_cheez","nuzt","txt_nuzt","xplod","txt_xplod","seewead","txt_seewead","forutoo","txt_forutoo","wulgaye","txt_wulgaye",
  },
  -- page 6: more inanimate objects
  {
    "squar","txt_squar","tri","txt_tri","0sid","txt_0sid","2sid","txt_2sid","hex","txt_hex","lucki","txt_lucki","qb","txt_qb",0,0,0,0,0,0,0,0,0,0,
    "sloop","txt_sloop","arro","txt_arro","arro2","txt_arro2","l..uv","txt_l..uv","zig","txt_zig","pixl","txt_pixl","prop","txt_prop",0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 
  },
  -- page 7: properties, verbs and conditions
  {
    "txt_be","txt_&","txt_got","txt_creat","txt_snacc","txt_spoop","txt_png","txt_moov","txt_yeet","txt_liek","txt_haet","txt_stalk","txt_ignor","txt_paint","txt_vs","txt_sing","txt_soko","txt_lookat","txt_ware","txt_idk","txt_knobout","txt_jojmen","txt_stoop","txt_attacc",
    "txt_u","txt_utoo","txt_utres","txt_ufor","txt_y'all","txt_w","txt_:)","txt_noswim","txt_ouch","txt_protecc","txt_nxt","txt_stayther","txt_wont","txt_giv","txt_alow","txt_rp","txt_offgrid","txt_lookaway","txt_thirds","txt_toad","txt_letr","txt_xwx","txt_paybac","txt_foeddee",
    "txt_go","txt_goooo","txt_icy","txt_icyyyy","txt_stubbn","txt_:(","txt_nedkee","txt_fordor","txt_wurd","txt_stare","txt_infloop","txt_plsdont","txt_oob","txt_frenles","txt_timles","txt_lit","txt_corekt","txt_rong","txt_lonk",0,0,0,0,0,
    "txt_nogo","txt_goawaypls","txt_comepls","txt_sidekik","txt_diagkik","txt_delet","txt_hotte","txt_fridgd","txt_thingify","txt_yfi","txt_rythm","txt_curse","txt_alt","txt_clikt","txt_past","txt_wun","txt_an","txt_mayb",0,"txt_gay","txt_lesbab","txt_tranz","txt_ace","txt_aro",
    "txt_visitfren","txt_slep","txt_shy...","txt_behinu","txt_walk","txt_:o","txt_moar","txt_split","txt_txtify","txt_yyyfi","txt_dragbl","txt_nodrag","txt_looped","txt_wait...","txt_samefloat","txt_samepaint","txt_sameface","txt_samepng",0,"txt_pan","txt_bi","txt_enby","txt_fluid","txt_πoly",
    "txt_flye","txt_tall","txt_haetskye","txt_haetflor","txt_zomb","txt_un:)","txt_gone","txt_nuek","txt_n'tify","txt_n'tifyyy",0,0,0,0,"txt_bunosd","txt_undun","txt_samex","txt_samey",0,"txt_rave","txt_colrful","txt_bigender","txt_gaymen","txt_lesbad",
    "txt_diag","txt_ortho","txt_gomyway","txt_halfstep","txt_rond","txt_boring","txt_bce","txt_notranform","txt_ify","txt_ifyyy",0,0,0,"txt_w/fren","txt_arond","txt_sans","txt_seenby","txt_behind",0,0,0,0,0,0,
    "txt_turncornr","txt_folowal","txt_hopovr","txt_reflecc",0,0,0,0,0,0,0,0,0,"txt_that","txt_thatbe","txt_thatgot","txt_meow","txt_beside",0,"txt_qt","txt_thonk","txt_happi","txt_crye","txt_scream",
    "txt_munwalk","txt_sidestep","txt_diagstep","txt_knightstep",0,"txt_tryagain","txt_noundo","txt_undo","txt_zawarudo","txt_brite","txt_torc","txt_tranparnt",0,"txt_reed","txt_orang","txt_yello","txt_grun","txt_cyeann",0,"txt_stelth","txt_huh","txt_unhuh","txt_/:o","txt_cool",
    "txt_spin","txt_rotatbl","txt_noturn","txt_stukc",0,"txt_poortoll","txt_goarnd","txt_mirrarnd","txt_glued",0,0,0,0,"txt_bleu","txt_purp","txt_pinc","txt_whit","txt_graey",0,"txt_scary","txt_altsprite","txt_altsprite2","txt_nope","txt_nooope",
    "txt_upleft","txt_up","txt_upright","txt_thicc",0,"txt_her","txt_thr","txt_rithere","txt_the","txt_deez","txt_dat",0,0,0,"txt_golld","txt_viloet","txt_blacc","txt_brwn",0,"txt_angy",0,0,0,0,
    "txt_left","txt_direction","txt_right","txt_yesgo","txt_upgrade",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"txt_copkat","txt_copdog","txt_copbab","txt_copzez",
    "txt_downleft","txt_down","txt_downright","txt_poof",0,"selctr","txt_selctr","txt_frens","txt_groop","txt_gang","txt_themself","this",0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,"lvl","txt_lvl","txt","txt_txt","txt_no1","txt_every1","txt_every2","txt_every3","txt_every4",0,0,0,0,0,0,"txt_:p","txt_loep","txt_living","txt_vsel",
    "txt_...","txt_''","txt_nt","txt_anti",0,"bordr","txt_bordr","lin","txt_lin","txt_lethers","txt_numa","txt_toen","txt_yuiy","txt_gaem","txt_mous",0,"camra","txt_camra",0,0,"txt_dirgo","txt_energy","txt_energy2","txt_energy3",
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"txt_goawayplsdir","txt_on","txt_on2","txt_on3",
    "txt_snacced",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"txt_noswims","txt_yays","txt_whuhd","txt_vibe",
  },
  -- page 8: complex
  {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 9: Platfory's modds
  {
	"platfory","txt_platfory","wiki","txt_wiki","whenthe","txt_whenthe","him","txt_him","bruhbruh","txt_bruhbruh","monokeek","txt_monokeek",0,0,"gunguy","txt_gunguy","bologna","txt_bologna",0,0,0,0,0,0,
	"whiz","txt_whiz","monsert","txt_monsert",0,0,0,0,0,0,0,0,"it","txt_it","lol","txt_lol",0,0,0,0,0,0,0,0,
	"ubu","txt_ubu",0,0,0,0,"waly","txt_waly",0,0,"wowbrutal","txt_wowbrutal",0,0,"heeh2","txt_heeh2",0,0,0,0,0,0,0,0,
	"sammah","txt_sammah","sallt","txt_sallt","huro","txt_huro","chonke","txt_chonke","quiq","txt_quiq","follt","txt_follt",0,0,0,0,0,0,0,0,0,0,0,0,
	"txt_gud","txt_awdul","txt_nft","txt_corl","txt_limeme","txt_matic",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	"muuv","pooosh","redbloodcell","tholl","stne",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	"be","goawaypls","nedkee","fordor","every1","every2","every3","txtify",":)",0,0,0,0,"direction",0,0,0,0,0,0,0,0,0,0,
	"snacc","ouch","lookat","nogo","walk","flye","go",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	"beb","txt_beb","dad","txt_dad","day","txt_day","getboux","txt_getboux","obby","txt_obby","tu","txt_tu","then","txt_then","hey","txt_hey",0,0,0,0,0,0,0,0,
	"zekiel2","txt_zekiel2","menstr2","txt_menstr2","jely2","txt_jely2","babtoo","txt_babtoo",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,"txt_mtalmaje","txt_tinbolt",0,0,0,0,0,0,0,0,0,"txt_xx__xx",0,0,0,0,0,0,
	0,0,0,0,0,0,"mtalmaje","tinbolt",0,0,0,0,0,0,0,0,0,"xx__xx",0,0,0,0,0,0,
	"canyon","txt_canyon","lokc","txt_lokc","pikc","txt_pikc","sog","txt_sog","eexe","txt_eexe","bandana","txt_bandana","bead","txt_bead","bloop","txt_bloop","boug","txt_boug","oiter","txt_oiter",0,0,0,0,
	"drincc","txt_drincc","read","txt_read","cbush","txt_cbush","cap","txt_cap","lopikckc","txt_lopikckc",0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 10: parsers and "parsers"
  {
    "obejt","txt_obejt","txt_beobj","txt_deobe","obejt_bab","obejt_be","obejt_keek","obejt_watr","obejt_fenss","obejt_algay","obejt_buble",0,0,0,0,0,0,0,0,0,0,0,0,0,
    "obejt_meem","obejt_dor","obejt_til","obejt_flog","obejt_boux","obejt_bellt","obejt_kee","obejt_boll","obejt_wal","obejt_obejt_bab","obejt_tre",0,0,0,0,0,0,0,0,0,0,0,0,0,
    "obejt_obejt_flog","obejt_huro","obejt_platfory","obejt_txt_u","obejt_obejt_keek","obejt_obejt_obejt_bab","obejt_txt_bab","obejt_txt_be","obejt_lesbab","obejt_txt_a","obejt_letter_a",0,0,0,0,0,0,0,0,0,0,0,0,0,
    "obejt_starr","obejt_obejt_watr","obejt_obejt","obejt_meemto","obejt_skul","obejt_gras","obejt_hedg","obejt_arro","obejt_u","obejt_fof",0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"txt_camra","camra",0,0,0,0,0,0,
    "txt_offgrid","txt_rond",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "txt_halfstep",0,0,0,0,0,0,0,0,0,0,0,0,0,"ouch","aaaaaa","therealqt","zawarudo",0,0,0,0,0,0,
    "txt_every3","txt_n'tifyyy",0,0,0,0,0,0,0,0,0,0,"lookat","snacc","&","sans","copkat","ditto",0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"bab0",0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,"jams","txt_jams","meeeep","txt_meeeep",0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"blossom","blossom2","blossom3",0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,"ui_s","ui_p","ui_o","ui_i","ui_l","ui_e","ui_r","ui_s",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,"txt_is","txt_and","txt_not","txt_eat",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "baba","txt_baba","txt_you","txt_red2","txt_blue",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,"txt_push",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,no1ghost,
  },
  {
    "txt_iscome","txt_befit",0,0,"txt_snaccish","txt_noswims",0,"txt_daed","txt_blj",0,0,"txt_nuhuh","txt_were",0,0,0,0,0,0,0,0,0,0,0,
    "txt_halfu","txt_yays","txt_when","txt_:(ish","txt_noswimish","txt_;)","txt_crystal","txt_no:)",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "txt_lookwithme","txt_shiftaway","txt_march",0,0,"txt_:u",0,0,0,0,"txt_zup",0,0,0,0,0,0,0,0,0,0,0,0,0,
    "txt_halfnogo",0,0,0,0,0,0,0,0,0,"txt_zown",0,0,0,"txt_bunosd","txt_whuhd","txt_png",0,0,0,0,0,0,0,
    "txt_dirgo","txt_nogoish","txt_goawayplsdir",0,"txt_step","txt_:p",0,0,0,"txt_boem",0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "txt_living","txt_vsel","txt_stalkskye","txt_stalkflor","txt_clip","txt_board","txt_cliverb","letter_clip",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,"txt_stalkledge","txt_stalkredge",0,0,0,0,"txt_B)","txt_in","txt_out",0,0,0,0,0,0,0,0,0,0,0,0,0,
    "treesh","txt_beok","txt_uok","txt_nogook","txt_:)ok",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "txt_no2",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "txt_omega",0,"txt_east2","txt_vibe",0,"txt_abov","txt_sid>",0,0,0,0,0,"txt_golden_be",0,0,0,0,0,0,0,0,0,0,0,
    "txt_loep","txt_toss",0,0,0,"txt_sid<","txt_below",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "txt_uhhh",0,0,0,0,0,"txt_groop2","txt_groop3","txt_groop4","txt_groop5","txt_groop6",0,0,0,0,0,0,0,0,0,0,0,0,0,
    "txt_^o^","txt_east","txt_west",0,0,0,0,0,0,0,0,0,0,0,0,0,0,"txt_cube",0,0,0,0,0,0,
    "txt_template","txt_template2","txt_template3",0,"txt_seventyfive","txt_energy","txt_energy2","txt_energy3","txt_on","txt_on2","txt_on3",0,0,"txt_un:O","txt_pathz",0,"txt_ad","txt_subt",0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "txt_flogus","txt_flogjp","txt_flogsg","txt_floggs","txt_floggb-eng",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 1.5: default
  {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 2.5: letters
  {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 3.5: ui / instructions
  {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 4.5: characters and special objects
  {
    "byb","txt_byb",0,0,"baskitt","txt_baskitt","vaaver","txt_vaaver","trabab","txt_trabab","keekie","txt_keekie","cbab","txt_cbab","tridoge","txt_tridoge","twooo","txt_twooo","goo","txt_goo","saur","txt_saur",0,0,
    "zarj","txt_zarj","kuewee","txt_kuewee","datteve","txt_datteve","acron","txt_acron","kib","txt_kib","nemee","txt_nemee","wahaw","txt_wahaw","monte","txt_monte",0,0,0,0,0,0,0,0,
    "flimic","txt_flimic","noes","txt_noes","fot","txt_fot","..er","txt_..er","2fiv","txt_2fiv","buf","txt_buf","high.","txt_high.","ba","txt_ba","gat","txt_gat",0,0,0,0,0,0,
    "glitch","txt_glitch","lil","txt_lil","sixx","txt_sixx","210","txt_210","bohpel","txt_bohpel","bhridg","txt_bhridg","man","txt_man",0,0,0,0,0,0,0,0,0,0,
    "aent","txt_aent","citten","txt_citten","snomstr","txt_snomstr","fren","txt_fren","whar","txt_whar","sedl","txt_sedl",0,0,0,0,0,0,0,0,0,0,0,0,
    "kvait","txt_kvait","slim","txt_slim","craewlr","txt_craewlr","soil","txt_soil","aaaeeh","txt_aaaeeh",0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "seabab","txt_seabab","itt","txt_itt","sanik","txt_sanik","menstr","txt_menstr","kook","txt_kook","muum","txt_muum","babbab","txt_babbab","aes","txt_aes","wontapply","txt_wontapply","funni","txt_funni","baddy","txt_baddy","iys","txt_iys",
    "kyyk","txt_kyyk","kmeem","txt_kmeem","hbab","txt_hbab","babnot","txt_babnot","snobab","txt_snobab","jely","txt_jely","itevt","txt_itevt","datti","txt_datti","aba","txt_aba","tratra","txt_tratra","fukc","txt_fukc","zekiel","txt_zekiel",
    "patric","txt_patric","blebl","txt_blebl","licba","txt_licba","lootro","txt_lootro","gmals","txt_gmals","bob","txt_bob","alpha","txt_alpha","haeh","txt_haeh","maeryio","txt_maeryio","zez","txt_zez","kez","txt_kez","faekr","txt_faekr",
    "mez","txt_mez","baab","txt_baab","keeeeeeke","txt_keeeeeeke","tzsh","txt_tzsh","glebab","txt_glebab","meemto","txt_meemto","dood","txt_dood","robert","txt_robert","emme","txt_emme","flir","txt_flir","arvi","txt_arvi","sinx","txt_sinx",
    "pwn","txt_pwn","rok","txt_rok","bihop","txt_bihop","jim","txt_jim","beu","txt_beu","xixe","txt_xixe","bah","txt_bah","musrur","txt_musrur","nice","txt_nice","bahb","txt_bahb","itte!ve","txt_itte!ve","borgitte!","txt_borgitte!",
    "jillt","txt_jillt","beellt","txt_beellt","nalß","txt_nalß","nabby","txt_nabby","robwot","txt_robwot","404","txt_404","flaf","txt_flaf","al23m","txt_al23m","spik2","txt_spik2","katboux","txt_katboux","zezi","txt_zezi","zezzer","txt_zezzer",
    "mawwr","txt_mawwr",0,0,0,0,"spoop","creat","reed","orang","w/fren",0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,"nuek","fridgd","energy","hotte","behinu","arond","icy","nxt",0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,"got","nt",":o","gomyway","u",":(","utoo","stelth",0,"bebe","txt_bebe","txt_txt_bebe",0,0,0,0,0,0,
  },
  -- page 5.5: inanimate objects
  {
    "cherri","txt_cherri","loc","txt_loc","dangoh","txt_dangoh","pick","txt_pick","taad","txt_taad","durm","txt_durm","watrbolt","txt_watrbolt","maell","txt_maell","saev","txt_saev",0,0,0,0,"placeholder","txt_placeholder",
    "gras2","txt_gras2","protyp","txt_protyp",0,0,0,0,"run","txt_run","bogart","txt_bogart",0,0,"nes","txt_nes","catpul","txt_catpul",0,0,0,0,0,0,
    "turnep","txt_turnep","mgama","txt_mgama","mouv","txt_mouv","paino","txt_paino","airkar","txt_airkar","wandrrs","txt_wandrrs",0,0,0,0,0,0,0,0,0,0,0,0,
    "fallage","txt_fallage","flour","txt_flour","fungwe","txt_fungwe","donot","txt_donot","lly","txt_lly","big","txt_big",0,0,"sheild","txt_sheild",0,0,0,0,0,0,0,0,
    "lua","txt_lua","scizor","txt_scizor","lite","txt_lite","zzz","txt_zzz","bulett","txt_bulett","milck","txt_milck",0,0,"strand","txt_strand",0,0,0,0,0,0,0,0,
    "piza","txt_piza","trumpt","txt_trumpt","flyg","txt_flyg","ston","txt_ston","picee","txt_picee","tnt","txt_tnt","brian","txt_brian",0,0,0,0,0,0,0,0,0,0,
    "lug","txt_lug","mblok","txt_mblok","floew","txt_floew","curser","txt_curser","comnnd","txt_comnnd",0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "con1","txt_con1","con2","txt_con2","puf","txt_puf","dirrt","txt_dirrt","esgras","txt_esgras",0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "mushy","txt_mushy","toe","txt_toe","icantbelivehempuliisaddingbeanstobiy","txt_icantbelivehempuliisaddingbeanstobiy","hottedog","txt_hottedog",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "stoen","txt_stoen",0,0,0,0,0,0,0,0,0,0,0,0,0,0,"turnrod","txt_turnrod",0,0,0,0,0,0,
    "chocho","txt_chocho","cartt","txt_cartt","americandepfridwatr","txt_americandepfridwatr","dotti","txt_dotti","papr","txt_papr",0,0,"kees","txt_kees","cd","txt_cd","ßar","txt_ßar","spinklr","txt_spinklr","cledg","txt_cledg","goop","txt_goop",
    "wav","txt_wav","clothe","txt_clothe","panzs","txt_panzs","veggi","txt_veggi","babfood","txt_babfood","spek","txt_spek",0,0,"pien","txt_pien","duran","txt_duran","4ke","txt_4ke","lin2","txt_lin2","lin3","txt_lin3",
    "pc","txt_pc","mildiw","txt_mildiw","ancorn","txt_ancorn","sord","txt_sord","wrench","txt_wrench","limonaid","txt_limonaid","hil","txt_hil","ray","txt_ray","muud","txt_muud",0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "flag","txt_flag","water","txt_water","violet","txt_violet","cake","txt_cake","key","txt_key","door","txt_door","dot","txt_dot",0,0,0,0,0,0,0,0,0,0,
  },
  -- page 6.5: more inaminate objects
  {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 7.5 properties and stuff
  {
    "txt_is","txt_and","txt_has",0,"txt_eat",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "txt_you",0,0,0,0,0,"txt_win2","txt_sink",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,"txt_defeat","txt_shut","txt_open",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "txt_stop","txt_push",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,"txt_move",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,"txt_near",0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,"txt_red2",0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,"txt_blue",0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,"txt_level",0,0,"txt_empty",0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,"txt_not",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 8.8 extra chars
  {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 9.5 platforys modds
  {
    "hey.","txt_hey.",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 10.5
  {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 11.5
  {
    "txt_frensend",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 12.5
  {
    "txt_creates","txt_coom","txt_goawayish","txt_spark","txt_yayy","txt_notice","txt_wierd","txt_v","txt_u?","txt_long",0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
}

tile_grid_width = 24
tile_grid_height = 17

special_objects = {"mous", "lvl", "bordr", "no1", "this"}
