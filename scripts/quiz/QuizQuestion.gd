# Copyright 2022, Frederick Schenk

# --- QuizQuestion Script ---
# A question to quiz the player.

class_name QuizQuestion
extends Resource

# -- Properties --

# - The question for the player -
export (String) var text

# - All possible answers to the question -
export (Array, String) var answers
export (int) var correct_answer

# - Additional context about the question -
export (String, MULTILINE) var context


# -- Functions --

# - Initializes the class -
func _init (p_text : String = "", p_answers : Array = [], p_correct_answer : int = 0, p_context : String = "") -> void:
	text = p_text
	answers = p_answers
	correct_answer = p_correct_answer
	context = p_context
