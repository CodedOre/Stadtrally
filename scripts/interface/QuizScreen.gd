# Copyright 2022, Frederick Schenk

# --- QuizScreen Script ---
# Displays a quiz to the player.

extends Control

# -- Constants --

# - The Stylebox-Override for the selected answer -
const RIGHT_ANSWER_STYLE : StyleBox = preload ("res://resources/interface/styles/Quiz/RightField.tres")
const WRONG_ANSWER_STYLE : StyleBox = preload ("res://resources/interface/styles/Quiz/WrongField.tres")
const RIGHT_SELECTED_ANSWER_STYLE : StyleBox = preload ("res://resources/interface/styles/Quiz/RightSelectedField.tres")
const WRONG_SELECTED_ANSWER_STYLE : StyleBox = preload ("res://resources/interface/styles/Quiz/WrongSelectedField.tres")


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
		# warning-ignore:return_value_discarded
		field.connect ("pressed", self, "_check_answer", [i])
		quiz_container.add_child (field)
		_answer_fields.append (field)

# - Checks if the given answer was correct -
func _check_answer (index : int) -> void:
	# Get if the answer is correct
	_chose_correctly = index == _correct_index
	# Modify the answer fields
	for i in range (len (_answer_fields)):
		var field : Button = _answer_fields [i]
		# Disabled them from re-enter
		field.disabled = true
		# Change colors according to if they're right, wrong and selected
		field.add_color_override ("font_color_disabled", Color ("f2f8ff"))
		if i == _correct_index:
			if i == index:
				field.add_stylebox_override ("disabled", RIGHT_SELECTED_ANSWER_STYLE)
			else:
				field.add_stylebox_override ("disabled", RIGHT_ANSWER_STYLE)
		else:
			if i == index:
				field.add_stylebox_override ("disabled", WRONG_SELECTED_ANSWER_STYLE)
			else:
				field.add_stylebox_override ("disabled", WRONG_ANSWER_STYLE)
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
	# Remove answer fields
	for field in _answer_fields:
		field.queue_free ()
	_answer_fields = []
	# Signal the QuizMaster that we're done
	emit_signal ("quiz_done", _chose_correctly)
