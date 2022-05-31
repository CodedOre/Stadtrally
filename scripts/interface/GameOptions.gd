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
	# Set the player index and default color
	for i in range (len (player_options)):
		var option : Control = player_options [i]
		option.player_index = i
		option.chosen_color = i

# - Avoids that one color is used multiple times -
func update_player_colors (index : int, color : int) -> void:
	# Prepare Arrays with available colors and duplicating items
	var available_colors : Array = range (6)
	var duplicate_index : Array = []
	# Remove the newly set color from the available colors
	available_colors.erase (color)
	# Iterate through all options
	for i in range (len (player_options)):
		# Ignore the setting option
		if i == index:
			continue
		# Get the option for the index
		var option : Control = player_options [i]
		# Else remove the color as available
		available_colors.erase (option.chosen_color)
		# Note if the option shares the new color
		if option.chosen_color == color:
			duplicate_index.append (option)
	# Check if we can assign colors to items needing them
	if len (available_colors) < len (duplicate_index):
		push_warning ("There might be multiple players with the same color!")
		return
	# Assign the duplicate items one of the available colors
	for i in range (len (duplicate_index)):
		var option : Control = duplicate_index [i]
		var new_color : int = available_colors [i]
		option.chosen_color = new_color

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