extends CanvasLayer

# Esta señal (evento) le avisará al Main que es hora de pelear
signal iniciar_pelea

func _ready() -> void:
	# Al arrancar, escondemos los textos
	$Message.hide()
	$Winner.hide()

# Seleccioná tu StartButton, andá a la pestaña Nodos -> Señales
# y conectá la señal "pressed()" a esta función en el HUD:
func _on_start_button_pressed() -> void:
	# 1. Si el botón dice "Revancha", recargamos el nivel desde cero
	if $StartButton.text == "Try again":
		get_tree().reload_current_scene()
		return # Cortamos la ejecución acá para que no siga bajando
	
	# 2. Si el botón decía "Fight", hacemos la lógica normal de arrancar
	$StartButton.hide()
	
	$Message.text = "FIGHT!"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$Message.hide()
	
	iniciar_pelea.emit()

func mostrar_ganador(nombre_ganador: String) -> void:
	# Verificamos si el resultado fue un empate
	if nombre_ganador == "Try again":
		$Winner.text = "DRAW"
	else:
		$Winner.text = nombre_ganador + " wins!"
		
	$Winner.show()
	
	# Opcional: Reutilizamos el botón para una revancha
	$StartButton.text = "Try again"
	$StartButton.position.y += 100
	
	$StartButton.show()
