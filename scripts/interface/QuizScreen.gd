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


# -- Variables --

# - The answer fields generated -
var _answer_fields : Array = []


# -- Functions --

# - Start a new quiz -
func start_new_quiz (quiz : RallyQuiz, question : QuizQuestion) -> void:
	# Remove remaining answer fields
	for field in _answer_fields:
		remove_child (field)
		_answer_fields.erase (field)
	# Hide the continue button
	continue_button.visible = false
	# Set the information from the quiz to the screen
	title_label.text = "Frage " + str (quiz.index)
	topic_label.text = quiz.topic
	# Set the question field
	question_label.text = question.text
	# Set the context label, but not visible
	context_label.percent_visible = 0
	context_label.text = question.context
	# Create buttons for the answers
	for answer in question.answers:
		var field : Button = Button.new ()
		field.text = answer
		quiz_container.add_child (field)
		_answer_fields.append (field)
