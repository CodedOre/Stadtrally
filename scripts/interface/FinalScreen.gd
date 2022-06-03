# Copyright 2022, Frederick Schenk

# --- FinalScreen Script ---
# Displays the result of the game

extends Control

# -- Nodes --

# - The container holding the players -
onready var player_container : VBoxContainer = $FinalPanel/PanelContainer/PlayerContainer


# -- Signals --

# - When to return to the main menu -
signal return_to_main ()


# -- Functions --

# - Displays the screen with a player order -
func display_winners (players : Array) -> void:
	# Create a entry for each player
	for i in range (len (players)):
		var player : KinematicBody = players [i]
		var player_label : Label = Label.new ()
		player_label.text = str (i + 1) + " - " + str (player.player_name)
		player_container.add_child (player_label)
	# Show the UI
	show ()

# - When the return button is pressed -
func _on_return () -> void:
	# Hide the UI
	hide ()
	# Clear the player list
	for child in player_container.get_children ():
		child.queue_free ()
	# Return over RallyGame
	emit_signal ("return_to_main")
