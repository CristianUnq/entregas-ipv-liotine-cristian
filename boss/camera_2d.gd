extends Camera2D

var fuerza_actual: float = 0.0
var desvanecimiento: float = 10.0

func sacudir(fuerza: float) -> void:
	fuerza_actual = fuerza

func _process(delta: float) -> void:
	
	if fuerza_actual > 0:

		fuerza_actual = lerpf(fuerza_actual, 0.0, desvanecimiento * delta)
		
		offset = Vector2(
			randf_range(-fuerza_actual, fuerza_actual), 
			randf_range(-fuerza_actual, fuerza_actual)
		)
	else:
		offset = Vector2.ZERO
