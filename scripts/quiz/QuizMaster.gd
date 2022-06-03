# Copyright 2022, Frederick Schenk

# --- QuizMaster Script ---
# Handles the points for the players and quizzes them.

extends Node

# -- Nodes --

# - The QuizScreen displaying the question -
onready var quiz_screen : Control = $QuizScreen


# -- Signals --

# - Emitted when a quiz is completed -
signal quiz_completed ()


# -- Variables --

# - The random number generator -
var _random : RandomNumberGenerator

# - All QuizPositions, their quizzes and who has points there -
var _quiz_storage : Dictionary = {}

# - The currently active player and quiz -
var _current_player : KinematicBody = null
var _current_quiz : int = -1


# -- Functions --

# - Run on startup -
func _ready () -> void:
	# Initializes the random number generator
	_random = RandomNumberGenerator.new ()
	_random.randomize ()

# - Prepares on a new game -
func prepare_quizzes (all_players : Array) -> void:
	# Iterate through each QuizPosition
	for position in get_tree ().get_nodes_in_group ("QuizPosition"):
		var stored_values : Dictionary = {}
		# Store the quiz and the questions already asked
		stored_values ["quiz"] = position.quiz
		stored_values ["used_questions"] = []
		# Store that no player has gotten a point (yet)
		var player_points : Dictionary = {}
		for player in all_players:
			player_points ["player"] = false
		# Store the new values in the storage
		stored_values ["player_points"] = player_points
		_quiz_storage [position] = stored_values
		# Adds the ScorePoints to the hud
		for row in get_tree ().get_nodes_in_group ("ScoreRow"):
			row.add_score_point (position.quiz.index)

# - Runs the quiz for a position -
func start_new_quiz (position : StaticBody) -> void:
	# Get the associated storage for the position
	var values : Dictionary = _quiz_storage [position]
	# Get the quiz
	var quiz : RallyQuiz = values ["quiz"]
	var used_questions : Array = values ["used_questions"]
	_current_quiz = quiz.index
	# Get a random question
	var question : QuizQuestion = _get_random_question (quiz, used_questions)
	# Start the Quiz UI
	quiz_screen.start_new_quiz (quiz, question)

# - Get a random question that was not already asked -
func _get_random_question (quiz : RallyQuiz, used_questions : Array) -> QuizQuestion:
	# Check if all questions were already used
	var all_questions : Array = quiz.questions
	if len (all_questions) == len (used_questions):
		# Reset the used questions
		used_questions = []
	# Get a random index for the questions
	var question_index : int = -1
	while question_index < 0:
		question_index = _random.randi_range (0, len (used_questions) - 1)
		# Rerun the number when this index is already listed as used
		if used_questions.has (question_index):
			question_index = -1
	# Return the question with the random index
	return all_questions [question_index]

# - Run when the quiz was done -
func _on_quiz_completed (correct : bool) -> void:
	# Get the ScoreRow for the current player
	for row in get_tree ().get_nodes_in_group ("ScoreRow"):
		if row.player == _current_player:
			# Get the score point for the current question
			var score_point : Control = row.get_indexed_point (_current_quiz)
			# Set if the player has gotten this point
			score_point.point_given = correct
	# Signals RallyGame that we're done
	emit_signal ("quiz_completed")

# - Updates the current player from RallyGame -
func update_current_player (player : KinematicBody, _moves : int) -> void:
	_current_player = player
