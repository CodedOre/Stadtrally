# Copyright 2022, Frederick Schenk

# --- QuizScreen Script ---
# Displays a quiz to the player.

extends Control

# -- Nodes --

# - The main container -
onready var quiz_container : VBoxContainer = $QuizContainer

# - Labels related to the quiz -
onready var title_label : Label = $QuizContainer/TitleLabel
onready var topic_label : Label = $QuizContainer/QuizPanel/PanelContainer/TopicLabel

# - Labels related to the question
onready var question_label : Label = $QuizContainer/QuizPanel/PanelContainer/QuestionLabel
onready var result_label : Label = $QuizContainer/QuizPanel/PanelContainer/ResultLabel
onready var context_label : Label = $QuizContainer/QuizPanel/PanelContainer/ContextLabel

# - The button to continue after the quiz -
onready var continue_button : Button = $ContinueButton


# -- Signals --

# - Notices the quiz is done -
signal quiz_done (correct)


# -- Variables --

# - The answer fields generated -
var _answer_fields : Array = []

# - The index for the right answer -
var _correct_index : int = -1

# - If the player chose correctly -
var _chose_correctly : bool = false


# -- Functions --

# - Start a new quiz -
func start_new_quiz (quiz : RallyQuiz, question : QuizQuestion) -> void:
	# Remove remaining answer fields
	for field in _answer_fields:
		remove_child (field)
		_answer_fields.erase (field)
	# Hide the continue button
	continue_button.visible = false
	# Clean the result label
	result_label.text = ""
	# Set the information from the quiz to the screen
	title_label.text = "Frage " + str (quiz.index)
	topic_label.text = quiz.topic
	# Set the question field
	question_label.text = question.text
	# Set the context label, but not visible
	context_label.percent_visible = 0
	context_label.text = question.context
	# Set other variables used later
	_correct_index = question.correct_answer
	# Create buttons for the answers
	for i in range (len (question.answers)):
		var answer : String = question.answers [i]
		var field : Button = Button.new ()
		field.text = answer
		field.connect ("pressed", self, "_check_answer", [i])
		quiz_container.add_child (field)
		_answer_fields.append (field)

# - Checks if the given answer was correct -
func _check_answer (index : int) -> void:
	# Get if the answer is correct
	_chose_correctly = index == _correct_index
	# Set the result on the label
	if _chose_correctly:
		result_label.text = "Richtig!"
		result_label.add_color_override ("font_color", Color ("2da52d"))
	else:
		result_label.text = "Falsch!"
		result_label.add_color_override ("font_color", Color ("c80000"))
	# Display the context
	context_label.percent_visible = 1
	# Allow to continue
	continue_button.visible = true

# - Return to the game -
func _on_continue () -> void:
	emit_signal ("quiz_done", _chose_correctly)
