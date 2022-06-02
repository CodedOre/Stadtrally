# Copyright 2022, Frederick Schenk

# --- QuizQuestion Script ---
# A question to quiz the player.

tool
class_name RallyQuiz
extends Resource

# -- Properties --

# - The index for this question -
export (int) var index

# - What the quiz is about -
export (String) var topic

# - All question in this quiz -
export (Array, Resource) var questions setget set_questions, get_questions


# -- Variables --

# - Stores the possible answers -
var _questions : Array


# -- Functions --

# - Initializes the class -
func _init (p_index : int = 0, p_topic : String = "", p_questions : Array = []) -> void:
	index = p_index
	topic = p_topic
	questions = p_questions

# - Gets the possible answers -
func get_questions () -> Array:
	return _questions

# - Sets the possible answers
func set_questions (value : Array) -> void:
	_questions = value
	# Remove all items that are not answers
	for i in len (_questions):
		if ! _questions [i] is QuizQuestion:
			_questions [i] = null
