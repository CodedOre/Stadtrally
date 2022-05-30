# Copyright 2022, Frederick Schenk

# --- ClosingDialog Script ---
# Confirms that the game should be closed.

extends Node

# -- Nodes --

# - Nodes connected to the game quit dialog -
onready var close_backdrop : ColorRect = $PopupBackdrop
onready var close_popup : PopupDialog = $ClosePopup


# -- Functions --

# - Run at startup -
func _ready () -> void:
	get_tree ().set_auto_accept_quit (false)

# - Looks for closing notifications -
func _notification(what) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_on_closing_requested ()

# - Activates the close popup -
func _on_closing_requested () -> void:
	close_backdrop.visible = true
	close_popup.popup_centered ()

# - Cancels the game closing -
func _on_closing_cancelled () -> void:
	close_popup.hide ()

# - Remove backdrop when popup is closed -
func _on_popup_closing () -> void:
	close_backdrop.visible = false

# - Closes the game -
func _on_closing_confirmed () -> void:
	get_tree ().quit ()
