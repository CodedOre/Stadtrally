# Copyright 2022, Frederick Schenk

# --- Main Script ---
# The root node for the game, under which all can be found.

extends Node

# -- Enums --

# - The mode the UI is on -
enum DisplayMode {
	MAIN_MENU = 10,
	GAME_OPTIONS = 20,
	INGAME = 30
}


# -- Nodes --

# - Interface nodes -
onready var main_menu : Control = $MainMenu
onready var game_options : Control = $GameOptions


# -- Properties --

# - The display mode -
export (DisplayMode) var display_mode setget set_display_mode, get_display_mode


# -- Variables --

# - Currently active display mode -
var _display_mode : int


# -- Functions --

# - Get and set the display mode -
func get_display_mode () -> int:
	return _display_mode

func set_display_mode (value : int) -> void:
	_display_mode = value
	# Set the interface node visibilty
	main_menu.visible = _display_mode == DisplayMode.MAIN_MENU
	game_options.visible = _display_mode == DisplayMode.GAME_OPTIONS
