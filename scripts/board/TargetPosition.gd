# Copyright 2022, Frederick Schenk

# --- TargetPosition Script ---
# The Alpha and Omega of the game board.

tool
extends "res://scripts/board/Position.gd"

# -- Enums --

# - If this is start or finish -
enum TargetType {
	NONE,
	START,
	FINISH
}


# -- Properties --

# - If this is start or finish -
export (TargetType) var target_type setget set_target_type, get_target_type

# - The Location for this Position -
export (String) var location setget set_location, get_location


# -- Variables --

# - Stores the values for the properties -
var _target_type : int
var _location : String


# -- Functions --

# - Gets the current target type -
func get_target_type () -> int:
	return _target_type

# - Sets the target type -
func set_target_type (value : int) -> void:
	_target_type = value
	match _target_type:
		TargetType.NONE:
			$TitleLabel.text = ""
		TargetType.START:
			if ! is_in_group ("StartPosition"):
				add_to_group("StartPosition")
			if is_in_group ("FinishPosition"):
				remove_from_group ("FinishPosition")
			$TitleLabel.text = "Start"
		TargetType.FINISH:
			if ! is_in_group ("FinishPosition"):
				add_to_group("FinishPosition")
			if is_in_group ("StartPosition"):
				remove_from_group ("StartPosition")
			$TitleLabel.text = "Ziel"
		_:
			$TitleLabel.text = "FEHLER!"
			push_error ("TargetPosition: Invalid type for target_type")

# - Gets the set location -
func get_location () -> String:
	return _location

# - Sets a new location -
func set_location (value : String) -> void:
	_location = value
	$TopicLabel.text = _location
