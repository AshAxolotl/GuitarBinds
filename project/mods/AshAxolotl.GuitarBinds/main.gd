extends Node

const MOD_ID = "AshAxolotl.GuitarBinds"

onready var TackleBox = get_node_or_null("/root/TackleBox")
onready var KeybindsAPI = get_node_or_null("/root/BlueberryWolfiAPIs/KeybindsAPI")

var DEFAULT_SETTINGS = {"numpad binds": true, "numpad based of guitar menu postion": false}
var settings = {}

func _ready():
	# Load Tackle Box / Settings
	if TackleBox == null:
		push_error("TackbleBox was not found using default settings. pls install tacklebox to change settings!")
		settings = DEFAULT_SETTINGS
	else:
		TackleBox.connect("mod_config_updated", self, "mod_config_updated")
		settings = TackleBox.get_mod_config(MOD_ID) 
		if settings.size() != DEFAULT_SETTINGS.size():
			for key in DEFAULT_SETTINGS.keys():
				DEFAULT_SETTINGS[key] = settings.get(key, DEFAULT_SETTINGS[key])
			TackleBox.set_mod_config(MOD_ID, DEFAULT_SETTINGS)
			settings = TackleBox.get_mod_config(MOD_ID)
			
	# Register keybinds
	KeybindsAPI.register_keybind({
	  "action_name": "guitar_string_1",
	  "title": "Guitar String 1",
	  "key": KEY_Q,
	})
	KeybindsAPI.register_keybind({
	  "action_name": "guitar_string_2",
	  "title": "Guitar String 2",
	  "key": KEY_W,
	})
	KeybindsAPI.register_keybind({
	  "action_name": "guitar_string_3",
	  "title": "Guitar String 3",
	  "key": KEY_E,
	})
	KeybindsAPI.register_keybind({
	  "action_name": "guitar_string_4",
	  "title": "Guitar String 4",
	  "key": KEY_R,
	})
	KeybindsAPI.register_keybind({
	  "action_name": "guitar_string_5",
	  "title": "Guitar String 5",
	  "key": KEY_T,
	})
	KeybindsAPI.register_keybind({
	  "action_name": "guitar_string_6",
	  "title": "Guitar String 6",
	  "key": KEY_Y,
	})
	change_numpad_keybinds()

func mod_config_updated(mod_id, new_config):
	if mod_id == MOD_ID:
		settings = new_config
		change_numpad_keybinds()
	
func change_numpad_keybinds():
	var new_key_binds = {"bind_1": KEY_KP_1, "bind_2": KEY_KP_2, "bind_3": KEY_KP_3, "bind_4": KEY_KP_4, "bind_5": KEY_KP_5, "bind_6": KEY_KP_6, "bind_7": KEY_KP_7, "bind_8": KEY_KP_8, "bind_9": KEY_KP_9}
	var new_key_binds_position = {"bind_1": KEY_KP_7, "bind_2": KEY_KP_8, "bind_3": KEY_KP_9, "bind_4": KEY_KP_4, "bind_5": KEY_KP_5, "bind_6": KEY_KP_6, "bind_7": KEY_KP_1, "bind_8": KEY_KP_2, "bind_9": KEY_KP_3}
	if settings["numpad binds"]:
		if settings["numpad based of guitar menu postion"]:
			bind_numpad_keybinds(new_key_binds_position, new_key_binds)
		else:
			bind_numpad_keybinds(new_key_binds, new_key_binds_position)
	else:
		bind_numpad_keybinds({}, new_key_binds)
		bind_numpad_keybinds({}, new_key_binds_position)

func bind_numpad_keybinds(add, remove):
	for key in remove:
		var remove_input_event = InputEventKey.new()
		remove_input_event.set_scancode(remove[key])
		InputMap.action_erase_event(key, remove_input_event)
		
		if key in add:
			var input_event = InputEventKey.new()
			input_event.set_scancode(add[key])
			InputMap.action_add_event(key, input_event)
