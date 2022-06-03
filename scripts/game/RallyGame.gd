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
onready var game_hud : Node = $GameHud
onready var final_screen : Control = $FinalScreen

# - The dice for random numbers -
onready var dice : Node = $Dice

# - The nodes for the quizzes -
onready var quiz_master : Node = $QuizMaster
onready var quiz_screen : Control = $QuizMaster/QuizScreen


# -- Signals --

# - Signalled when a game should be stopped -
signal game_stopped ()

# - Signals when the current player changed -
signal new_current_player (player, moves)


# - Variables -

# - The players that are playing the game -
var __all_players : Array = []
var __finish_order : Array = []

# - The current game board -
var __game_board : Node = null

# - Counts the turns in this game -
var __current_turn : int = -1

# - The currently active player -
var __current_id : int = -1
var __current_player : KinematicBody = null

# - How many moves the player still has
var __current_moves : int = -1


# -- Functions --

# - Begins a new game with a set of players and a board -
func start_new_game (set_players : Array, board : PackedScene) -> void:
	# Initialize the board
	__game_board = board.instance ()
	add_child (__game_board)
	board_manager.generate_move_set ()
	# Set the players in the game
	for player in set_players:
		add_child (player)
		__all_players.append (player)
	# Set all players to the start position
	board_manager.set_start_positions (__all_players)
	# Create the ScoreRows on the GameHud
	game_hud.create_score_rows (__all_players)
	# Prepare the quiz
	quiz_master.prepare_quizzes ()
	# Set game state variables
	__current_turn = 1
	__current_id = 0
	# Activate the game and hud
	game_hud.active = true
	# Start the turn
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
	# Skip if player is finished
	if __current_player.has_finished:
		continue_turn ()
	# Get the moves for the player
	__current_moves = dice.roll_dice ()
	# Notify other nodes about the player
	emit_signal ("new_current_player", __current_player, __current_moves)
	# Update the information hud
	game_hud.current_player = __current_player
	game_hud.left_moves = __current_moves
	game_hud.next_status = game_hud.NextStatus.DEACTIVE

# - Run when player has moved -
func player_moved (moves : int, new_pos : StaticBody) -> void:
	# Remove the moves from storage and ui
	__current_moves -= moves
	game_hud.left_moves = __current_moves
	# When no moves are left
	if __current_moves <= 0:
		# Start the quiz if the player is on a quiz field
		if new_pos.is_in_group ("QuizPosition"):
			quiz_master.start_new_quiz (new_pos)
			game_hud.active = false
			quiz_screen.visible = true
		# Note the player is finished when it's the FinishPosition
		if new_pos.is_in_group ("FinishPosition"):
			__player_in_finish (__current_player)
		# Allow to move to the next player/turn
		if __current_id + 1 >= len (__all_players):
			game_hud.next_status = game_hud.NextStatus.NEXT_TURN
		else:
			game_hud.next_status = game_hud.NextStatus.NEXT_PLAYER

# - Actions when a player reached the finish -
func __player_in_finish (player : KinematicBody) -> void:
	# Note the player in the order he arrived
	player.has_finished = true
	__finish_order.append (player)
	# Show the first in the finish in the game hud
	if len (__finish_order) > 0:
		game_hud.winning_player = __finish_order [0]
	# Move to the FinalScreen when all players are in the finish
	if len (__finish_order) == len (__all_players):
		game_hud.active = false
		final_screen.display_winners (__finish_order)

# - Continues the game when the quiz is completed -
func __on_quiz_completed () -> void:
	# Just change the visible UI
	quiz_screen.visible = false
	game_hud.active = true

# - Stops the game -
func __on_game_stop () -> void:
	# Clear game variables
	__current_id = -1
	__current_moves = -1
	__current_turn = -1
	__current_player = null
	# Clear players and board
	if __game_board != null:
		__game_board.queue_free ()
		__game_board = null
	if len (__all_players) != 0:
		for player in __all_players:
			player.queue_free ()
	__all_players = []
	__finish_order = []
	__game_board = null
	# Hide the UI
	game_hud.active = false
	game_hud.winning_player = null
	# Signal the exit
	emit_signal ("game_stopped")
