# Copyright 2022, Frederick Schenk

# --- PlayerDrag Script ---
# Manages drag and drop actions of an player.

extends Node


# -- Constants --

# - How much the player hovers over the board -
const DRAG_HOVER : Vector3 = Vector3 (0.0, 0.5, 0.0)


# -- Signals --

# - Notify RallyGame about used moves -
signal moves_taken (moves)


# -- Variables --

# - The currently active player and it's moves -
var __current_player : KinematicBody = null
var __left_moves : int = 0
var __player_dragged : bool = false


# -- Functions --

# - Begins the drag action -
func drag_player (player : KinematicBody) -> void:
	# Check if the player is active (and can be dragged)
	if player == __current_player:
		__player_dragged = true

# - Move the player while dragging -
func move_player (position : Vector3) -> void:
	# Check if we drag
	if not __player_dragged:
		return
	# Ignore if Vector is invalid
	if position == Vector3.INF:
		return
	# Set the player to mouse position with a bit of hover
	__current_player.global_transform.origin = position + DRAG_HOVER

# - Stops the drag action -
func drop_player (player : KinematicBody) -> void:
	pass

# - Updates the current player from RallyGame -
func update_current_player (player : KinematicBody, moves : int) -> void:
	__current_player = player
	__left_moves = moves
