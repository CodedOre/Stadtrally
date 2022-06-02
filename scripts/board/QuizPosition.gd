# Copyright 2022, Frederick Schenk

# --- QuizPosition Script ---
# Players will be quizzed if they land here.

tool
extends "res://scripts/board/Position.gd"

# -- Properties --

# - The quiz connected to this position -
export (Resource) var quiz setget set_quiz, get_quiz


# -- Signals --


# -- Variables --

# - Stores the quiz -
var _quiz : Resource


# -- Functions --

# - Gets the current quiz -
func get_quiz () -> Resource:
	return _quiz

# - Sets a new quiz -
func set_quiz (value : Resource) -> void:
	# Don't set the resource if it's not a quiz
	_quiz = value if value is RallyQuiz else null
	# Set the values for the labels
	var quiz_index : String = str (_quiz.index) if _quiz != null else "X"
	$TitleLabel.text = "Frage " + quiz_index
	$TopicLabel.text = _quiz.topic if _quiz != null else "Thema"
