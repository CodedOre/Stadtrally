# Copyright 2022, Frederick Schenk

# --- %CLASS% Script ---
#

extends Node

# -- Enums --

# - The status for the next button -
enum NextStatus {
	DEACTIVE,
	NEXT_PLAYER,
	NEXT_TURN
}


# -- Constants --


# -- Nodes --

# - The information labels -
onready var status_label : Label = $StatusContainer/StatusPanel/StatusLabel

# - The next button -
onready var next_button : Button = $NextButton


# -- Properties --

# - If the UI should be shown -
export (bool) var active setget set_active, get_active

# - Information about the game -
export (int) var current_player setget set_current_player, get_current_player
export (int) var left_moves setget set_left_moves, get_left_moves

# - The status for the next button -
export (NextStatus) var next_status setget set_next_status, get_next_status


# -- Signals --

# - When the game should be exited -
signal exit_game ()

# - When the next button was pressed -
signal next_action ()


# -- Variables --

# - If the UI should be shown -
var __active : bool

# - Information about the game -
var __current_turn : int = 0
var __current_player : int = 0
var __left_moves : int = 0

# - The status for the next button -
var __next_status : int = NextStatus.DEACTIVE


# -- Functions --

# - Runs at startup -
func _ready () -> void:
	# Hides the UI (as this needs to be done proactively)
	set_active (false)

# - Gets the visibilty of the hud -
func get_active () -> bool:
	return __active

# - Sets the visibilty of the hud -
func set_active (value : bool) -> void:
	__active = value
	# Set visibilty of the controls
	$NextButton.visible = __active
	$PauseButton.visible = __active
	$StatusContainer.visible = __active

# - Get the current turn indicator -
func get_current_player () -> int:
	return __current_player

# - Set the current turn indicator -
func set_current_player (value : int) -> void:
	__current_player = value
	update_status_label ()

# - Get the current turn indicator -
func get_left_moves () -> int:
	return __left_moves

# - Set the current turn indicator -
func set_left_moves (value : int) -> void:
	__left_moves = value
	update_status_label ()

# - Sets the content of the status label -
func update_status_label () -> void:
	if __left_moves > 1:
		status_label.text = "Spieler " + str (__current_player) + " hat noch " + str (__left_moves) + " Züge"
	elif __left_moves == 1:
		status_label.text = "Spieler " + str (__current_player) + " hat noch einen Zug"
	else:
		status_label.text = "Spieler " + str (__current_player) + " hat keine Züge mehr!"

# - Get the NextButton status -
func get_next_status () -> int:
	return __next_status

# - Set the NextButton status -
func set_next_status (value : int) -> void:
	__next_status = value
	match value:
		NextStatus.DEACTIVE:
			next_button.text = "Du bist am Zug"
			next_button.visible = false
		NextStatus.NEXT_PLAYER:
			next_button.text = "Nächster Spieler"
			next_button.visible = true if __active else false
		NextStatus.NEXT_TURN:
			next_button.text = "Nächste Runde"
			next_button.visible = true if __active else false
		_:
			push_error ("Value for next_status not an NextStatus enum!")

# - Run when the NextButton is pressed -
func _on_next_action () -> void:
	emit_signal ("next_action")

# - When the pause button was pressed -
func _on_pause () -> void:
	# Display the pause menu
	$PauseBackdrop.visible = true
	$PausePopup.popup_centered ()

# - Cancels the game closing -
func _on_pause_closing () -> void:
	$PausePopup.hide ()

# - Remove backdrop when popup is closed -
func _on_popup_closing () -> void:
	$PauseBackdrop.visible = false

# - Closes the game -
func _on_game_exit () -> void:
	_on_pause_closing ()
	emit_signal ("exit_game")
