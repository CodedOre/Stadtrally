# Copyright 2022, Frederick Schenk

# --- RallyGame Script ---
# The main node for the game, managing anything under it.

extends Spatial

# -- Properties --

# - The board to be used in the game -
export (PackedScene) onready var game_board


# -- Functions --

# - Run on startup -
func _ready () -> void:
	# Initialize the board
	var board : Node = game_board.instance ()
	add_child (board)
