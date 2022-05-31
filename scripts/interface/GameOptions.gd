# Copyright 2022, Frederick Schenk

# --- GameOptions Script ---
# Allows to set options and players for a new game.

extends Control

# -- Constants --

# - The default player count -
const DEFAULT_PLAYER_COUNT : int = 1


# -- Nodes --

# - All PlayerOptions for selectable players -
onready var player_options : Array = [
	$OptionsContainer/PlayerPanel/PlayerGrid/PlayerOptions1,
	$OptionsContainer/PlayerPanel/PlayerGrid/PlayerOptions2,
	$OptionsContainer/PlayerPanel/PlayerGrid/PlayerOptions3,
	$OptionsContainer/PlayerPanel/PlayerGrid/PlayerOptions4,
	$OptionsContainer/PlayerPanel/PlayerGrid/PlayerOptions5,
	$OptionsContainer/PlayerPanel/PlayerGrid/PlayerOptions6
]


# -- Properties --

# - How many players are selected -
var player_count : int setget set_player_count, get_player_count


# -- Signals --

# - Signals to Main an new action -
signal move_to_main_menu ()


# -- Variables --

# - Stores how many player are selected -
var _player_count : int


# -- Functions --

# - Run at startup -
func _ready() -> void:
	set_player_count (DEFAULT_PLAYER_COUNT)

# - Gets the player count -
func get_player_count () -> int:
	return _player_count

# - Sets the player count -
func set_player_count (value : int) -> void:
	_player_count = clamp (value, 0, len (player_options))
	for i in range (len (player_options)):
		var option : Control = player_options [i]
		if i < _player_count:
			option.display_mode = option.DisplayMode.OPTIONS
		elif i == _player_count:
			option.display_mode = option.DisplayMode.ADD
		else:
			option.display_mode = option.DisplayMode.HIDDEN

# - Changes the current player count to some degree -
func update_player_count (amount : int) -> void:
	set_player_count (_player_count + amount)

# - Moves back to the main menu -
func _on_back_pressed() -> void:
	emit_signal ("move_to_main_menu")
