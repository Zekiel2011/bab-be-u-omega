RELEASE_BUILD = false

DEFAULT_WIDTH = 800
DEFAULT_HEIGHT = 600

ANIM_TIMER = 180
MAX_MOVE_TIMER = 80
MAX_UNDO_DELAY = 150
MIN_UNDO_DELAY = 50
UNDO_SPEED = 5
UNDO_DELAY = MAX_UNDO_DELAY
repeat_keys = {"wasd","udlr","numpad","ijkl","space","undo"}

is_mobile = love.system.getOS() == "Android" or love.system.getOS() == "iOS"
emulating_mobile = false
--is_mobile = 

PACK_UNIT_V1 = "hhhb" -- TILE, X, Y, DIR
PACK_UNIT_V2 = "hhhhbs" -- ID, TILE, X, Y, DIR, SPECIALS
PACK_UNIT_V3 = "llhhbs" -- ID, TILE, X, Y, DIR, SPECIALS

PACK_SPECIAL_V2 = "ss" -- KEY, VALUE

profile = {
  name = "bab"
}

defaultsettings = {
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
}
color_names = {"reed", "orang", "yello", "grun", "cyeann", "bleu", "purp", "pinc", "whit", "blacc", "graey", "brwn", "corl", "limeme", "golld"}

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
colour_for_palette[3][3] = "purp"
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
  ["un:)"] = ":)",
  nedkee = "fordor",
  fordor = "nedkee",
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
  "inverted",
  "space",
  "variant",
  "volcano",
  "scribble",
  "mono",
  "babatiles",
  "baba",
  "mspaint mod",
  "r",
  "corruption",
  "granddad",
  "gramfild",
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
    0, "txt_be", "txt_&", "txt_got", "txt_nt", "txt_every1", "txt_no1", "txt_txt", "txt_wurd", "txt_txtify", 0, "txt_wait...", "txt_mous", "txt_clikt", "txt_nxt", "txt_stayther", "lvl", "txt_lvl",
    "bab", "txt_bab", "txt_u", "kee", "txt_kee", "txt_fordor", "txt_goooo", "txt_icy", "txt_icyyyy", "txt_behinu", "txt_moar", "txt_sans", "txt_liek", "txt_infloop", "lin", "txt_lin", "selctr", "txt_selctr",
    "keek", "txt_keek", "txt_walk", "dor", "txt_dor", "txt_nedkee", "txt_frens", "txt_gang", "txt_utoo", "txt_utres", "txt_delet", "txt_an", "txt_haet", "txt_mayb", "txt_that", "txt_ignor", "txt_curse", "txt_...",
    "flog", "txt_flog", "txt_:)", "colld", "txt_colld", "txt_fridgd", "txt_direction", "txt_ouch", "txt_slep", "txt_protecc", "txt_sidekik", "txt_brite", "txt_lit", "txt_tranparnt", "txt_torc", "txt_vs", "txt_nuek", "txt_''",
    "roc", "txt_roc", "txt_goawaypls", "laav", "txt_laav", "txt_hotte","txt_visitfren", "txt_w/fren", "txt_arond", "txt_frenles", "txt_copkat", "txt_zawarudo", "txt_timles", "txt_behind", "txt_beside", "txt_lookaway", "txt_notranform", "this",
    "wal", "txt_wal", "txt_nogo", "l..uv", "txt_l..uv", "gras", "txt_gras", "txt_creat", "txt_lookat", "txt_spoop", "txt_yeet", "txt_turncornr", "txt_corekt", "txt_goarnd", "txt_mirrarnd", "txt_past", 0, "txt_sing",
    "watr", "txt_watr", "txt_noswim", "meem", "txt_meem", "dayzy", "txt_dayzy", "txt_snacc", "txt_seenby" , "txt_stalk", "txt_moov", "txt_folowal", "txt_rong", "txt_her", "txt_thr", "txt_rithere", "txt_the", 0,
    "skul", "txt_skul", "txt_:(", "til", "txt_til", "hurcane", "txt_hurcane", "gunne", "txt_gunne", "wog", "txt_wog", 0, "txt_shy...", "txt_munwalk", "txt_sidestep", "txt_diagstep", "txt_hopovr", "txt_knightstep",
    "boux", "txt_boux", "txt_comepls", "os", "txt_os", "bup", "txt_bup", "han", "txt_han", "fenss", "txt_fenss", 0, 0, "hol", "txt_hol", "txt_poortoll", "txt_blacc", "txt_reed",
    "bellt", "txt_bellt", "txt_go", "tre", "txt_tre", "piler", "txt_piler", "hatt", "txt_hatt", "hedg", "txt_hedg", 0, 0, "rif", "txt_rif", "txt_glued", "txt_whit", "txt_orang",
    "boll", "txt_boll", "txt_:o", "frut", "txt_frut", "kirb", "txt_kirb", "katany", "txt_katany", "metl", "txt_metl", 0, 0, 0, 0, "txt_enby", "txt_colrful", "txt_yello",
    "clok", "txt_clok", "txt_tryagain", "txt_noundo", "txt_undo", "slippers", "txt_slippers", "firbolt", "txt_firbolt", "jail", "txt_jail", "itt", "txt_itt", "zez", "txt_zez", "txt_tranz", "txt_rave", "txt_grun",
    "splittr", "txt_splittr", "txt_split", "steev", "txt_steev", "boy", "txt_boy", "icbolt", "txt_icbolt", "platfor", "txt_platfor", "chain", "txt_chain", 0, 0, "txt_gay", "txt_stelth", "txt_cyeann",
    "chekr", "txt_chekr", "txt_diag", "txt_ortho", "txt_haetflor", "arro", "txt_arro", "txt_gomyway", "txt_spin", "txt_noturn", "txt_stubbn", "txt_rotatbl", 0, 0, "txt_pinc", "txt_qt", "txt_paint", "txt_bleu",
    "clowd", "txt_clowd", "txt_flye", "txt_tall", "txt_haetskye", "ghostfren", "txt_ghostfren", "robobot", "txt_robobot", "sparkl", "txt_sparkl", "spik", "txt_spik", "spiky", "txt_spiky", "bordr", "txt_bordr", "txt_purp",
    nil
  },
  -- page 2: letters
  {
    "letter_a","letter_b","letter_c","letter_d","letter_e","letter_f","letter_g","letter_h","letter_i","letter_j","letter_k","letter_l","letter_m","letter_n","letter_o","letter_p","letter_q","letter_r",
    "letter_s","letter_t","letter_u","letter_v","letter_w","letter_x","letter_y","letter_z","letter_.","letter_colon","letter_parenthesis","letter_'","letter_/","letter_1","letter_2","letter_3","letter_4","letter_5",
    0,0,0,0,0,0,0,"letter_π","letter_$","letter_;","letter_>",0,0,"letter_6","letter_7","letter_8","letter_9","letter_o",
	"letter_go","letter_come","letter_pls","letter_away","letter_my","letter_no","letter_way","letter_ee","letter_fren","letter_ll","letter_bolt","letter_ol",0,0,0,"letter_*","txt_numa","txt_lethers",
	"txt_c_sharp","txt_d_sharp","txt_f_sharp","txt_g_sharp","txt_a_sharp","txt_sharp","txt_flat","letter_ae","letter_¢","letter_!",0,0,0,0,0,0,0,0,
	"letter_ba","letter_ke","letter_ek","letter_me","letter_em","letter_ga","letter_al","letter_ut","letter_lk","letter_wa",0,0,0,0,0,0,0,
  },
  -- page 3: ui / instructions
  {
    "ui_esc",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "ui_tab","ui_q","ui_w","ui_e","ui_r","ui_t","ui_y","ui_u","ui_i","ui_o","ui_p","ui_[","ui_-","ui_=","ui_`","ui_7","ui_8","ui_9",
    "ui_cap","ui_a","ui_s","ui_d","ui_f","ui_g","ui_h","ui_j","ui_k","ui_l","ui_;","ui_'","ui_return",0,0,"ui_4","ui_5","ui_6",
    "ui_shift",0,"ui_z","ui_x","ui_c","ui_v","ui_b","ui_n","ui_m","ui_,","ui_.","ui_/",0,0,0,"ui_1","ui_2","ui_3",
    "ui_ctrl","ui_gui","ui_alt",0,"ui_space",0,0,0,0,0,0,0,0,0,0,"ui_arrow","ui_0","ui_del",
    "txt_press","txt_f1","txt_2pley","txt_f2","txt_2edit","ui_leftclick","ui_rightclick",0,0,0,0,0,0,0,0,0,"txt_yuiy","ui_box",
    0,"ui_walk",0,0,"ui_reset",0,0,"ui_undo",0,0,"ui_wait",0,0,"ui_activat",0,0,"ui_clik",0,0,"ui_walk2",0,
    0,"ui_walk3",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 4: characters and special objects
  {
    "bab","txt_bab","kat","txt_kat","flof","txt_flof","babby","txt_babby","bad","txt_bad","fof","txt_fof",0,0,"lila","txt_lila","vite","txt_vite",
    "keek","txt_keek","creb","txt_creb","shrim","txt_shrim","moo","txt_moo","toby","txt_toby","jij","txt_jij",0,0,"pata","txt_pata","jill","txt_jill",
    "meem","txt_meem","statoo","txt_statoo","flamgo","txt_flamgo","migri","txt_migri","temmi","txt_temmi","ballt","txt_ballt",0,0,"slab","txt_slab","zsoob","txt_zsoob",
    "skul","txt_skul","beeee","txt_beeee","gul","txt_gul","kva","txt_kva","bunmy","txt_bunmy","cic","txt_cic",0,0,"notnat","txt_notnat","she","txt_she",
    "ghostfren","txt_ghostfren","fishe","txt_fishe","starrfishe","txt_starrfishe","pidgin","txt_pidgin","slogkat","txt_slogkat","evil","txt_evil",0,0,"ally","txt_ally","butcher","txt_butcher",
    "robobot","txt_robobot","snek","txt_snek","sneel","txt_sneel","swan","txt_swan","b..er","txt_b..er","itte!","txt_itte!",0,0,0,0,"pitta","txt_pitta",
    "woug","txt_woug","bog","txt_bog","enbybog","txt_enbybog","spoder","txt_spoder","niko","txt_niko","tu","txt_tu","smoll","txt_smoll",0,0,"tot","txt_tot",
    "kirb","txt_kirb","ripof","txt_ripof","trob","txt_trob","cavebab","txt_cavebab","detox","txt_detox","nyowo","txt_nyowo","amoung","txt_amoung",0,0,0,0,
    "bup","txt_bup","butflye","txt_butflye","boooo","txt_boooo","prime","txt_prime","grimkid","txt_grimkid","dad","txt_dad","bellby","txt_bellby",0,0,0,0,
    "boy","txt_boy","wurm","txt_wurm","madi","txt_madi","angle","txt_angle","boogie","txt_boogie","aka","txt_aka","nyaka","txt_nyaka","beeb","txt_beeb",0,0,
    "steev","txt_steev","ratt","txt_ratt","badi","txt_badi","dvl","txt_dvl","assh","txt_assh","obby","txt_obby","chad.","txt_chad.","sehseh","txt_sehseh","ehceec","txt_ehceec",
    "han","txt_han","iy","txt_iy","lisp","txt_lisp","paw","txt_paw","humuhumunukunukuapua'a","txt_humuhumunukunukuapua'a","day","txt_day",0,0,0,0,0,0,
    "snoman","txt_snoman","pingu","txt_pingu","der","txt_der","ginn","txt_ginn","snom","txt_snom","ses","txt_ses","hey","txt_hey",0,0,"square","txt_square",
    "kapa","txt_kapa","urei","txt_urei","ryugon","txt_ryugon","viruse","txt_viruse","slog","txt_slog","pati","txt_pati","then","txt_then",0,0,"triangle","txt_triangle",
    "os","txt_os","hors","txt_hors","mimi","txt_mimi","err","txt_err","scorpino","txt_scorpino","gargle","txt_gargle","baba","txt_baba",0,0,"oat","txt_oat",
  },
  -- page 5: inanimate objects
  {
    "wal","txt_wal","bellt","txt_bellt","hurcane","txt_hurcane","buble","txt_buble","katany","txt_katany","petnygrame","txt_petnygrame","firbolt","txt_firbolt","hol","txt_hol","golf","txt_golf",
    "til","txt_til","arro","txt_arro","clowd","txt_clowd","snoflak","txt_snoflak","gunne","txt_gunne","scarr","txt_scarr","litbolt","txt_litbolt","rif","txt_rif","paint","txt_paint",
    "watr","txt_watr","colld","txt_colld","rein","txt_rein","icecub","txt_icecub","slippers","txt_slippers","pudll","txt_pudll","icbolt","txt_icbolt","win","txt_win","press","txt_press",
    "laav","txt_laav","dor","txt_dor","kee","txt_kee","roc","txt_roc","hatt","txt_hatt","extre","txt_extre","poisbolt","txt_poisbolt","smol","txt_smol","pumkin","txt_pumkin",
    "gras","txt_gras","algay","txt_algay","flog","txt_flog","boux","txt_boux","knif","txt_knif","heg","txt_heg","timbolt","txt_timbolt","tor","txt_tor","grav","txt_grav",
    "hedg","txt_hedg","banboo","txt_banboo","boll","txt_boll","l..uv","txt_l..uv","wips","txt_wips","pepis","txt_pepis","pixbolt","txt_pixbolt","dling","txt_dling","pen","txt_pen",
    "metl","txt_metl","vien","txt_vien","leef","txt_leef","karot","txt_karot","fir","txt_fir","eeg","txt_eeg","foreeg","txt_foreeg","forbeeee","txt_forbeeee","cil","txt_cil",
    "jail","txt_jail","ladr","txt_ladr","pallm","txt_pallm","coco","txt_coco","rouz","txt_rouz","noet","txt_noet","lili","txt_lili","weeb","txt_weeb","3den","txt_3den",
    "fenss","txt_fenss","platfor","txt_platfor","tre","txt_tre","stum","txt_stum","dayzy","txt_dayzy","lie","txt_lie","reffil","txt_reffil","ofin","txt_ofin","ches","txt_ches",
    "cobll","txt_cobll","spik","txt_spik","frut","txt_frut","fungye","txt_fungye","red","txt_red","lie/8","txt_lie/8","vlc","txt_vlc","foru","txt_foru","rod","txt_rod",
    "wuud","txt_wuud","spiky","txt_spiky","parsol","txt_parsol","clok","txt_clok","ufu","txt_ufu","rockit","txt_rockit","swim","txt_swim","yanying","txt_yanying","casete","txt_casete",
    "brik","txt_brik","sparkl","txt_sparkl","sanglas","txt_sanglas","bullb","txt_bullb","son","txt_son","muun","txt_muun","bac","txt_bac","warn","txt_warn","piep","txt_piep",
    "san","txt_san","piler","txt_piler","sancastl","txt_sancastl","shel","txt_shel","starr","txt_starr","cor","txt_cor","byc","txt_byc","gorder","txt_gorder","tuba","txt_tuba",
    "glas","txt_glas","bom","txt_bom","sine","txt_sine","kar","txt_kar","can","txt_can","ger","txt_ger","sirn","txt_sirn","chain","txt_chain","sloop","txt_sloop",
    "trol","txt_trol","wut","txt_wut","wat","txt_wat","splittr","txt_splittr","toggl","txt_toggl","bon","txt_bon","battry","txt_battry","chekr","txt_chekr","do$h","txt_do$h",
  },
  -- page 6: more inanimate objects
  {
    "fube","txt_fube","tronk","txt_tronk","cart","txt_cart","drop","txt_drop","woosh","txt_woosh","tanc","txt_tanc","gato","txt_gato","painbuct","txt_painbuct","sinyroc","txt_sinyroc",
    "colect","txt_colect","zig","txt_zig","pixl","txt_pixl","prop","txt_prop","qb","txt_qb","panlie","txt_panlie","cheez","txt_cheez","nuzt","txt_nuzt","xplod","txt_xplod",
    "tobm","txt_tobm","steam","txt_steam","pois","txt_pois","tres","txt_tres","extres","txt_extres","decaey","txt_decaey","predayzy","txt_predayzy","couhc","txt_couhc","clif","txt_clif",
    "whee","txt_whee","joycon","txt_joycon","stik","txt_stik","rubbe","txt_rubbe","mhatt","txt_mhatt","noe","txt_noe","yea","txt_yea",0,0,0,0,
    "furt","txt_furt","hous","txt_hous","¢ont","txt_¢ont","bok","txt_bok","banananana","txt_banananana",0,0,0,0,0,0,0,0,
    "flag","txt_flag","ray","txt_ray","cair","txt_cair","seewead","txt_seewead",0,0,0,0,0,0,0,0,0,0,
    "chocho","txt_chocho","cartt","txt_cartt","americandepfridwatr","txt_americandepfridwatr","dotti","txt_dotti",0,0,0,0,0,0,0,0,0,0,
    "papr","txt_papr","cake","txt_cake","kees","txt_kees",0,0,0,0,0,0,0,0,0,0,0,0,
    "spinklr","txt_spinklr",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "voom","txt_voom","wan","txt_wan","mug","txt_mug","die","txt_die",0,0,0,0,0,0,0,0,0,0,
    "sno","txt_sno","bel","txt_bel","wres","txt_wres","bowie","txt_bowie","sant","txt_sant","canedy","txt_canedy","bolble","txt_bolble","now","txt_now","cooky","txt_cooky",
    0,0,"pot","txt_pot","sweep","txt_sweep","candl","txt_candl","which","txt_which","corndy","txt_corndy","maglit","txt_maglit","cracc","txt_cracc",0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  },
  -- page 7: properties, verbs and conditions
  {
    "txt_be","txt_&","txt_got","txt_creat","txt_snacc","txt_spoop","txt_copkat","txt_moov","txt_yeet","txt_liek","txt_haet","txt_stalk","txt_ignor","txt_paint","txt_vs","txt_sing","txt_soko","txt_lookat",
    "txt_u","txt_utoo","txt_utres","txt_y'all","txt_w","txt_:)","txt_noswim","txt_ouch","txt_protecc",0,"txt_nxt","txt_stayther","txt_wont","txt_giv",0,"txt_rp",0,"txt_lookaway",
    "txt_go","txt_goooo","txt_icy","txt_icyyyy","txt_stubbn","txt_:(","txt_nedkee","txt_fordor","txt_wurd",0,"txt_infloop","txt_plsdont","txt_oob","txt_frenles","txt_timles","txt_lit","txt_corekt","txt_rong",
    "txt_nogo","txt_goawaypls","txt_comepls","txt_sidekik","txt_diagkik","txt_delet","txt_hotte","txt_fridgd","txt_thingify",0,"txt_rythm","txt_curse","txt_alt","txt_clikt","txt_past","txt_wun","txt_an","txt_mayb",
    "txt_visitfren","txt_slep","txt_shy...","txt_behinu","txt_walk","txt_:o","txt_moar","txt_split","txt_txtify",0,"txt_dragbl","txt_nodrag",0,"txt_wait...","txt_samefloat","txt_samepaint","txt_sameface",0,
    "txt_flye","txt_tall","txt_haetskye","txt_haetflor","txt_zomb","txt_un:)","txt_gone","txt_nuek","txt_n'tify",0,0,0,0,"txt_w/fren","txt_arond","txt_sans","txt_seenby","txt_behind",
    "txt_diag","txt_ortho","txt_gomyway",0,0,"txt_boring","txt_bce","txt_notranform","txt_ify",0,0,0,0,"txt_that","txt_thatbe","txt_thatgot","txt_meow","txt_beside",
    "txt_turncornr","txt_folowal","txt_hopovr","txt_reflecc",0,0,0,0,0,0,0,0,0,"txt_reed","txt_orang","txt_yello","txt_grun","txt_cyeann",
    "txt_munwalk","txt_sidestep","txt_diagstep","txt_knightstep",0,"txt_tryagain","txt_noundo","txt_undo","txt_zawarudo","txt_brite","txt_torc","txt_tranparnt",0,"txt_bleu","txt_purp","txt_pinc","txt_whit","txt_graey",
    "txt_spin","txt_rotatbl","txt_noturn","txt_stukc",0,"txt_poortoll","txt_goarnd","txt_mirrarnd","txt_glued",0,0,0,0,0,"txt_rave","txt_colrful","txt_blacc","txt_brwn",
    "txt_upleft","txt_up","txt_upright","txt_thicc",0,"txt_her","txt_thr","txt_rithere","txt_the","txt_deez",0,0,0,0,"txt_stelth","txt_qt","txt_thonk","txt_cool",
    "txt_left","txt_direction","txt_right",0,0,0,0,0,0,0,0,0,0,"txt_gay","txt_lesbab","txt_tranz","txt_ace","txt_aro",
    "txt_downleft","txt_down","txt_downright",0,0,"selctr","txt_selctr","txt_frens","txt_groop","txt_gang","txt_themself",0,0,"txt_pan","txt_bi","txt_enby","txt_fluid","txt_πoly",
    0,0,0,0,0,"lvl","txt_lvl","txt_txt","txt_no1","txt_every1","txt_every2","this","txt_mous",0,0,0,0,"txt_lesbad",
    "txt_...","txt_''","txt_nt","txt_anti",0,"bordr","txt_bordr","lin","txt_lin","txt_lethers","txt_numa","txt_toen","txt_yuiy",0,0,0,0,0,
  },
  -- page 8: more characters and stuff
  {
    0,0,"itt","txt_itt","spirt","txt_spirt","menstr","txt_menstr","kook","txt_kook","muum","txt_muum","badbad","txt_badbad","babbab","txt_babbab","bibi","txt_bibi",
    "keke","txt_keke","baddy","txt_baddy","iys","txt_iys","kyyk","txt_kyyk","kmeem","txt_kmeem","hbab","txt_hbab","babnot","txt_babnot","snobab","txt_snobab","jely","txt_jely",
    "aba","txt_aba","tratra","txt_tratra",0,0,"zekiel","txt_zekiel","patric","txt_patric","blebl","txt_blebl","licba","txt_licba","snoffe","txt_snoffe","gmals","txt_gmals",
    "maeryio","txt_maeryio","zez","txt_zez","duf","txt_duf","baab","txt_baab","keeeeeeke","txt_keeeeeeke","tzsh","txt_tzsh","tesho","txt_tesho","glebab","txt_glebab",0,0,
    "pwn","txt_pwn","rok","txt_rok","bihop","txt_bihop","foof","txt_foof","jim","txt_jim","joj","txt_joj","beu","txt_beu","xixe","txt_xixe",0,0,
    "hempuli","txt_hempuli","arvi","txt_arvi","itte!ve","txt_itte!ve","borgitte!","txt_borgitte!",0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "zezi","txt_zezi","zezzer","txt_zezzer",0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "lokkeek","txt_lokkeek","dorrkeek","txt_dorrkeek","skulnbon","txt_skulnbon",0,0,":o","gomyway",0,0,0,0,0,"bebe","txt_bebe","txt_txt_bebe",
  },
  -- page 9: Platfory's modds
  {
	"platfory","txt_platfory","wiki","txt_wiki","whenthe","txt_whenthe","him","txt_him","bruhbruh","txt_bruhbruh","monokeek","txt_monokeek",0,0,"gunguy","txt_gunguy","bologna","txt_bologna",
	"whiz","txt_whiz","monsert","txt_monsert",0,0,0,0,0,0,0,0,"it","txt_it","lol","txt_lol",0,0,
	"ubu","txt_ubu",0,0,0,0,"waly","txt_waly",0,0,"wowbrutal","txt_wowbrutal",0,0,"heeh2","txt_heeh2",0,0,
	"sammah","txt_sammah","sallt","txt_sallt","huro","txt_huro","chonke","txt_chonke","quiq","txt_quiq",0,0,0,0,0,0,0,0,
	"txt_gud","txt_awdul","txt_nft","txt_corl","txt_limeme","txt_matic","txt_yesgo","txt_did",0,0,0,0,0,0,0,0,0,0,
	"muuv","pooosh","redbloodcell","tholl","stne",0,0,0,0,0,0,0,0,0,0,0,0,0,
	"be","goawaypls","nedkee","fordor","every1","every2","every3","txtify",":)",0,0,0,0,"direction",0,0,0,0,
	"snacc","ouch","lookat","nogo","walk","flye",0,0,0,0,0,0,0,0,0,0,0,0,
	"beb","txt_beb","dad","txt_dad","day","txt_day","getboux","txt_getboux","obby","txt_obby","tu","txt_tu","then","txt_then","hey","txt_hey",0,0,
	"zekiel2","txt_zekiel2","menstr2","txt_menstr2","jely2","txt_jely2","babtoo","txt_babtoo",0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,"txt_mtalmaje","txt_tinbolt",0,0,0,0,0,0,0,0,0,"txt_xx__xx",
	0,0,0,0,0,0,"mtalmaje","tinbolt",0,0,0,0,0,0,0,0,0,"xx__xx",
	"canyon","txt_canyon","lokc","txt_lokc","pikc","txt_pikc","sog","txt_sog","eexe","txt_eexe","bandana","txt_bandana","bead","txt_bead","bloop","txt_bloop","boug","txt_boug",
	"drincc","txt_drincc","read","txt_read","cbush","txt_cbush","cap","txt_cap","lopikckc","txt_lopikckc",0,0,0,0,0,0,0,0,
  },
  -- page 10: the extra propertys and stuff
  {
    "txt_iscome","txt_befit",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "txt_halfu","txt_yays","txt_when",0,0,0,0,0,0,"txt_huh",0,0,0,0,0,0,0,0,
    "txt_lookwithme","txt_shiftaway","txt_march",0,0,0,0,0,0,"txt_unhuh",0,0,0,0,0,0,0,0,
    "txt_halfnogo",0,0,0,0,0,0,0,0,"txt_/:o",0,0,0,0,0,"txt_whuhd",0,0,
    "txt_dirgo",0,0,0,0,"txt_:p",0,0,0,"txt_boem",0,0,0,0,0,0,0,0,
    "txt_living","txt_vsel","txt_stalkskye","txt_stalkflor",0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,"txt_ufor",0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,"txt_idk","txt_knobout",0,0,0,0,0,0,0,0,
    0,0,0,"txt_vibe",0,0,0,0,0,0,"txt_scream",0,"txt_golden_be",0,0,0,0,0,
    "txt_loep",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "txt_altsprite","txt_altsprite2",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"txt_golld",
    "txt_uhhh",0,0,0,0,0,"txt_groop2","txt_groop3","txt_groop4","txt_groop5","txt_groop6","txt_xwx","txt_crye",0,0,0,"txt_bigender","txt_gaymen",
    "txt_^o^","txt_east","txt_west",0,0,0,0,0,0,0,0,0,0,0,0,0,"txt_samroc","txt_cube",
    "txt_template","txt_template2",0,0,"txt_seventyfive","txt_energy","txt_energy2","txt_on","txt_on2",0,0,0,0,"txt_un:O","txt_pathz","txt_zip","txt_ad","txt_subt",
  },
}
tile_grid_width = 18
tile_grid_height = 15

if settings["unfinished_words"] then
  table.insert(selector_grid_contents, {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"txt_camra","camra",
    "txt_offgrid","txt_rond",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "txt_halfstep",0,0,0,0,0,0,0,0,0,0,0,0,0,"ouch","aaaaaa","therealqt","zawarudo",
    "txt_every3","txt_n'tifyyy",0,0,0,0,0,0,0,0,0,"me","lookat","snacc","&","sans","copkat","ditto",
    "txt_all1",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"bab0",
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    "wog","txt_wog",0,0,0,0,0,0,0,0,0,0,0,0,"jams","txt_jams","meeeep","txt_meeeep",
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,"ui_s","ui_p","ui_o","ui_i","ui_l","ui_e","ui_r","ui_s",0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 
    0,"txt_is","txt_and","txt_not","txt_eat",0,0,0,0,0,0,0,0,0,0,0,0,0,
    "baba","txt_baba","txt_you",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,"txt_push",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  })
end

if settings["baba"] then
  table.insert(selector_grid_contents, {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,"no1ghost",0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  })
end

special_objects = {"mous", "lvl", "bordr", "no1", "this"}
