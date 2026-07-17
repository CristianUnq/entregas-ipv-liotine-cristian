extends Camera2D

@export var jugador1: CharacterBody2D
@export var jugador2: CharacterBody2D

# Acá es donde tenés que bajar el número (a 200 o 250) si le subís el Zoom a la cámara.
@export var distancia_maxima: float = 300.0 

var fuerza_actual: float = 0.0
var desvanecimiento: float = 10.0

func sacudir(fuerza: float) -> void:
	fuerza_actual = fuerza

func _physics_process(delta: float) -> void:
	# --- 1. SEGUIR A LOS LUCHADORES Y LIMITAR BORDES ---
	if jugador1 != null and jugador2 != null:
		var distancia = abs(jugador1.global_position.x - jugador2.global_position.x)
			
		# Si se estiran más del ancho permitido, los bloqueamos
		if distancia > distancia_maxima:
			var pared_izq = global_position.x - (distancia_maxima / 2.0)
			var pared_der = global_position.x + (distancia_maxima / 2.0)
			
			if jugador1.global_position.x < jugador2.global_position.x:
				jugador1.global_position.x = max(jugador1.global_position.x, pared_izq)
				jugador2.global_position.x = min(jugador2.global_position.x, pared_der)
			else:
				jugador1.global_position.x = min(jugador1.global_position.x, pared_der)
				jugador2.global_position.x = max(jugador2.global_position.x, pared_izq)
				
		# Centramos la cámara entre los dos
		#global_position.x = (jugador1.global_position.x + jugador2.global_position.x) / 2.0
		var punto_medio = (jugador1.global_position.x + jugador2.global_position.x) / 2.0
		# Usamos lerpf para deslizar la cámara suavemente hacia el punto medio
		global_position.x = lerpf(global_position.x, punto_medio, 10.0 * delta)

	# --- 2. TEMBLOR DE PANTALLA ---
	if fuerza_actual > 0:
		fuerza_actual = lerpf(fuerza_actual, 0.0, desvanecimiento * delta)
		offset = Vector2(
			randf_range(-fuerza_actual, fuerza_actual), 
			randf_range(-fuerza_actual, fuerza_actual)
		)
	else:
		offset = Vector2.ZERO
