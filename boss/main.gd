extends Node

@onready var f1 = $Fighter
@onready var f2 = $Oponente

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	f1.oponente = f2
	f2.oponente = f1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
