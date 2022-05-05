# Copyright 2022, Frederick Schenk

# --- RallyGame Script ---
# The main node for the game, managing anything under it.

extends Spatial

# -- Constants --

# - A static number of moves the players are allowed -
const MOVES_PER_TURN : int = 2


# -- Nodes --

# - The BoardManager node -
onready var board_manager : Node = $BoardManager

# - The HUD showing informations -
onready var game_hud : Control = $GameHud

# - The dice for random numbers -
onready var dice : Node = $Dice


# -- Properties --

# - The board to be used in the game -
export (PackedScene) onready var game_board

# -- Signals --

# - Signals when the current player changed -
signal new_current_player (player, moves)


# - Variables -

# - The players that are playing the game -
var __all_players : Array = []

# - Counts the turns in this game -
var __current_turn : int = -1

# - The currently active player -
var __current_id : int = -1
var __current_player : KinematicBody = null

# - How many moves the player still has
var __current_moves : int = -1


# -- Functions --

# - Run on startup -
func _ready () -> void:
	# Initialize the board
	var board : Node = game_board.instance ()
	add_child (board)
	board_manager.generate_move_set ()
	# Note players in tree to use in the game
	__all_players.append_array (get_tree ().get_nodes_in_group ("Player"))
	# Set all players to the start position
	board_manager.set_start_positions (__all_players)
	# Begin the game
	start_game ()

# - Starts the game for the first time -
func start_game () -> void:
	__current_turn = 1
	__current_id = 0
	# Run non-specific turn code
	__on_new_turn ()

# - Starts the turn for the next player (or a new one) -
func continue_turn () -> void:
	# Iterate the player count
	__current_id += 1
	if __current_id >= len (__all_players):
		# When at end of player array, then set new turn
		__current_turn += 1
		__current_id = 0
	# Run non-specific turn code
	__on_new_turn ()

# - Runs on the start of each player turn -
func __on_new_turn () -> void:
	# Set the currently active player
	__current_player = __all_players [__current_id]
	# Get the moves for the player
	__current_moves = dice.roll_dice ()
	# Notify other nodes about the player
	emit_signal ("new_current_player", __current_player, __current_moves)
	# Update the information hud
	game_hud.current_turn = __current_turn
	game_hud.current_player = __current_id
	game_hud.left_moves = __current_moves
	game_hud.next_status = game_hud.NextStatus.DEACTIVE

# - Run when player has taken some moves -
func moves_taken (moves : int) -> void:
	# Remove the moves from storage and ui
	__current_moves -= moves
	game_hud.left_moves = __current_moves
	# Activate next turn if no moves are left
	if __current_moves <= 0:
		if __current_id + 1 >= len (__all_players):
			game_hud.next_status = game_hud.NextStatus.NEXT_TURN
		else:
			game_hud.next_status = game_hud.NextStatus.NEXT_PLAYER
