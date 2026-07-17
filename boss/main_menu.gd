extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Acordate de conectar la señal pressed() del botón Jugar a esta función
func _on_boton_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Main.tscn")
