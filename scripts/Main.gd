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

# - Game nodes -
onready var main_menu : Control = $MainMenu
onready var game_options : Control = $GameOptions
onready var rally_game : Spatial = $RallyGame


# -- Properties --

# - The display mode -
export (DisplayMode) var display_mode setget set_display_mode, get_display_mode


# -- Variables --

# - Currently active display mode -
var _display_mode : int


# -- Functions --

# - Gets the display mode -
func get_display_mode () -> int:
	return _display_mode

# - Sets the display mode -
func set_display_mode (value : int) -> void:
	_display_mode = value
	# Set the nodes visibilty
	main_menu.visible = _display_mode == DisplayMode.MAIN_MENU
	game_options.visible = _display_mode == DisplayMode.GAME_OPTIONS
	rally_game.visible = _display_mode == DisplayMode.INGAME

# - Starts a new game -
func _on_new_game (set_players : Array, set_board : PackedScene) -> void:
	set_display_mode (DisplayMode.INGAME)
	rally_game.start_new_game (set_players, set_board)
