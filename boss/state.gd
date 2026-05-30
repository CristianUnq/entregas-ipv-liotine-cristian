extends Node
class_name State

# Señal que avisa a la máquina de estados que queremos cambiar de estado
signal transitioned(state, new_state_name)

var player: CharacterBody2D

func enter() -> void:
	pass

func exit() -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass
