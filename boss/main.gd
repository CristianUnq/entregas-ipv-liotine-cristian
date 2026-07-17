extends Node

@onready var hud = $HUD
@onready var f1 = $Fighter
@onready var f2 = $Opponent
@onready var timer = $HUD/Timer
@onready var label = $HUD/TimerLabel
@onready var grito_fight: AudioStreamPlayer = $GritoFight
@onready var risa: AudioStreamPlayer = $Risa
@onready var timer_risa: Timer = $TimerRisa
@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var liu_kang_wins: AudioStreamPlayer = $LiuKangWins
@onready var scorpion_wins: AudioStreamPlayer = $ScorpionWins

var juego_terminado = false

# Se llama cuando el nodo entra al árbol por primera vez.
func _ready() -> void:
	# 1. Cruzamos las referencias (tu código original)
	f1.oponente = f2
	f2.oponente = f1
	
	# 2. Frenamos el reloj para que no cuente el tiempo en el menú
	timer.paused = true
	
	# 3. Congelamos a los jugadores al inicio
	desactivar_jugador(f1)
	desactivar_jugador(f2)
	
	# 4. Conectamos la señal del botón "Fight"
	hud.iniciar_pelea.connect(_on_hud_iniciar_pelea)
	
func desactivar_jugador(jugador: CharacterBody2D) -> void:
	jugador.hide()
	jugador.process_mode = Node.PROCESS_MODE_DISABLED

func _on_hud_iniciar_pelea() -> void:
	# Los hacemos aparecer y los descongelamos
	f1.show()
	f1.process_mode = Node.PROCESS_MODE_INHERIT
	
	f2.show()
	f2.process_mode = Node.PROCESS_MODE_INHERIT
	
	# ¡Arranca la pelea, soltamos el reloj!
	grito_fight.play()
	timer.paused = false
	juego_terminado = false
	
	background_music.play()
	
	timer_risa.start()

# Se llama en cada fotograma.
func _process(delta: float) -> void:
	# Tu código original: actualizamos el reloj en pantalla
	label.text = str(int(timer.time_left))
	
	if juego_terminado:
		return # Si ya terminó, no chequeamos más nada
		
	# K.O. por golpes: Chequeamos continuamente si la vida de alguno llegó a 0
	if f1.barra_vida.value <= 0 or f2.barra_vida.value <= 0:
		finish_game()

# Combinamos tu lógica de muerte con el aviso al HUD
func finish_game() -> void:
	if juego_terminado:
		return
		
	print("terminar juego")
	juego_terminado = true
	timer.paused = true # Frenamos el reloj
	
	var nombre_ganador = "Empate"
	
	# 1. Ejecutamos la función de muerte (que lanza la animación de caer)
	if f1.barra_vida.value != f2.barra_vida.value:
		if f1.barra_vida.value > f2.barra_vida.value:
			f2.player_dead()
			nombre_ganador = "Liu Kang"
		else:
			f1.player_dead()
			nombre_ganador = "Scorpion"
	else:
		f1.player_dead()
		f2.player_dead()
		
	# 2. PAUSA DRAMÁTICA: Esperamos 2 segundos para que caiga y termine la animación
	await get_tree().create_timer(2.0).timeout
	
	# 3. Recién ahora, cuando ya está en el piso, mostramos los carteles
	hud.mostrar_ganador(nombre_ganador)
	
	timer_risa.stop()
	background_music.stop()
	
	if nombre_ganador != "Empate":
		if nombre_ganador == "Scorpion":
			scorpion_wins.play()
		else:
			liu_kang_wins.play()
	else:
		risa.play()


func _on_timer_risa_timeout() -> void:
		risa.play()
	#timer_risa.wait_time = randf_range(20, 50)
	
func _on_timer_timeout() -> void:
	finish_game()
