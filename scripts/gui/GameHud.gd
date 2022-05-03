# Copyright 2022, Frederick Schenk

# --- GameHud Script ---
# Provides information about the game to the user.

extends Control

# -- Enums --

# - The status for the next button -
enum NextStatus {
	DEACTIVE,
	NEXT_PLAYER,
	NEXT_TURN
}


# -- Nodes --

# - The information labels -
onready var turns_label : Label = $HudPanel/PanelBox/InformationGrid/TurnsValue
onready var player_label : Label = $HudPanel/PanelBox/InformationGrid/PlayerValue
onready var moves_label : Label = $HudPanel/PanelBox/InformationGrid/MovesValue

# - The next button -
onready var next_button : Button = $HudPanel/PanelBox/NextButton


# -- Properties --

# - Information about the game -
export (int) var current_turn setget set_current_turn, get_current_turn
export (int) var current_player setget set_current_player, get_current_player
export (int) var left_moves setget set_left_moves, get_left_moves

# - The status for the next button -
export (NextStatus) var next_status setget set_next_status, get_next_status


# -- Signals --

# - When the next button was pressed -
signal next_action ()


# -- Variables --

# - Information about the game -
var __current_turn : int = 0
var __current_player : int = 0
var __left_moves : int = 0

# - The status for the next button -
var __next_status : int = NextStatus.DEACTIVE


# -- Functions --

# - Get the current turn indicator -
func get_current_turn () -> int:
	return __current_turn

# - Set the current turn indicator -
func set_current_turn (value : int) -> void:
	__current_turn = value
	turns_label.text = str (__current_turn)

# - Get the current turn indicator -
func get_current_player () -> int:
	return __current_player

# - Set the current turn indicator -
func set_current_player (value : int) -> void:
	__current_player = value
	player_label.text = str (__current_player)

# - Get the current turn indicator -
func get_left_moves () -> int:
	return __left_moves

# - Set the current turn indicator -
func set_left_moves (value : int) -> void:
	__left_moves = value
	moves_label.text = str (__left_moves)

# - Get the NextButton status -
func get_next_status () -> int:
	return __next_status

# - Set the NextButton status -
func set_next_status (value : int) -> void:
	__next_status = value
	match value:
		NextStatus.DEACTIVE:
			next_button.text = "Your turn"
			next_button.disabled = true
		NextStatus.NEXT_PLAYER:
			next_button.text = "Next Player"
			next_button.disabled = false
		NextStatus.NEXT_TURN:
			next_button.text = "Next Turn"
			next_button.disabled = false
		_:
			push_error ("Value for next_status not an NextStatus enum!")

# - Run when the NextButton is pressed -
func _on_next_action() -> void:
	emit_signal ("next_action")
