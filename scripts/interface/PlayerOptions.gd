# Copyright 2022, Frederick Schenk

# --- PlayerOptions Script ---
# The interface for setting a player.

extends Control

# -- Enums --

# - What this control will display -
enum DisplayMode {
	HIDDEN,
	ADD,
	OPTIONS
}


# -- Nodes --

# - The root nodes for the display modes -
onready var hidden_container : MarginContainer = $HiddenContainer
onready var add_button : Button = $AddButton
onready var player_display : PanelContainer = $PlayerDisplay

# - The button to remove a player -
onready var remove_button : Button = $PlayerDisplay/RemovePositioner/RemoveButton


# -- Properties --

# - If this player could be removed -
export (bool) var player_removable = true setget set_player_removable, get_player_removable

# - The set display mode -
export (DisplayMode) var display_mode = DisplayMode.HIDDEN setget set_display_mode, get_display_mode

# - The color chosen for the player -
var chosen_color : int = 0 setget set_chosen_color, get_chosen_color

# - The index for the player on this field
var player_index : int = 0 setget set_player_index, get_player_index


# -- Signals --

# - Signaled when player should be added or removed
signal add_player ()
signal remove_player ()

# - Signaled when a color was chosen -
signal color_chosen (index, color)


# -- Variables --

# - The color chosen for the player -
var _chosen_color : int

# - The index for this PlayerOptions -
var _player_index : int

# - Stores the player_removable -
var _player_removable : bool

# - Currently active display mode -
var _display_mode : int


# -- Functions --

# - Run at startup -
func _ready () -> void:
	# Connect the menu action for the color menu
	var color_popup : PopupMenu = $PlayerDisplay/ActionPanel/ActionsContainer/ColorButton.get_popup ()
	color_popup.connect ("id_pressed", self, "set_new_color")

# - Set a new color after menu entry -
func set_new_color (value : int) -> void:
	set_chosen_color (value)
	emit_signal("color_chosen", _player_index, _chosen_color)

# - Gets the chosen color -
func get_chosen_color () -> int:
	return _chosen_color

# - Sets the chosen color -
func set_chosen_color (value : int) -> void:
	_chosen_color = value
	$PlayerDisplay/PlayerContainer/PlayerViewport/Player.color = _chosen_color

# - Gets if the player can be removed -
func get_player_removable () -> bool:
	return _player_removable

# - Sets if the player can be removed -
func set_player_removable (value : bool) -> void:
	_player_removable = value
	$PlayerDisplay/RemovePositioner/RemoveButton.visible = _player_removable

# - Get the display mode -
func get_display_mode () -> int:
	return _display_mode

# - Set the display mode -
func set_display_mode (value : int) -> void:
	# Ensure a correct DisplayMode
	match value:
		DisplayMode.ADD:
			_display_mode = value
		DisplayMode.OPTIONS:
			_display_mode = value
		_:
			_display_mode = DisplayMode.HIDDEN
	# Set the controls visibilty
	$AddButton.visible = _display_mode == DisplayMode.ADD
	$PlayerDisplay.visible = _display_mode == DisplayMode.OPTIONS

# - Get the display mode -
func get_player_index () -> int:
	return _player_index

# - Set the display mode -
func set_player_index (value : int) -> void:
	_player_index = value
	$PlayerDisplay/ActionPanel/ActionsContainer/PlayerLabel.text = "Spieler " + str (_player_index + 1)

# - Activated when the AddButton is pressed -
func _on_add_player () -> void:
	emit_signal ("add_player")

# - Activated when the RemoveButton is pressed -
func _on_remove_player () -> void:
	emit_signal ("remove_player")
