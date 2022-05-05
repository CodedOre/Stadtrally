# Copyright 2022, Frederick Schenk

# --- PlayerClick Script ---
# Manages movement by clicking on player and position.

extends Node

# -- Signals --

# - Notify RallyGame about used moves -
signal player_moved_to (position)


# -- Variables --

# - The currently active player and it's moves -
var __current_player : KinematicBody = null
var __player_moving : bool = false


# -- Functions --

# - When a player was selected -
func on_selected_player (player : KinematicBody) -> void:
	# Check if the player is active (and can be moved)
	if player == __current_player:
		__player_moving = true

# - When a position was selected -
func on_selected_position (position : Spatial) -> void:
	# Check if a player is moved
	if __player_moving:
		__player_moving = false
		# Notify main script about new position
		emit_signal ("player_moved_to", position)

# - Interrupts movement when player is dragged instead -
func on_drag_interrupt (_player : KinematicBody) -> void:
	# Check if a player is moved
	if __player_moving:
		# Clears moving state
		__player_moving = false

# - Updates the current player from RallyGame -
func update_current_player (player : KinematicBody, _moves : int) -> void:
	__current_player = player
