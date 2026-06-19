extends State

func enter() -> void:
	# el personaje se queda quieto
	#const FORCE_X_UPPERCUT = 200.0
	const FORCE_Y_UPPERCUT = -300.0
	var direction = player.direction_after_hit
	
	print("aun no Entro a ningun golpe")
	if player.tipo_golpe_recibido == "uppercut":
		player.animation_player.play("layingDown")
		player.velocity.x = direction * (player.FORCE_HIT / 2)
		player.velocity.y = FORCE_Y_UPPERCUT
	else:
		print("Entro a normal")
		player.animation_player.play("hit")
		player.velocity.x = direction * player.FORCE_HIT
		player.velocity.y = 0
	print("Salio del if")

func physics_update(delta: float) -> void:
	# gravedad
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
	
	print(player.velocity.x)
	player.velocity.x = move_toward(player.velocity.x, 0, 1500 * delta)
		
	player.move_and_slide()
	
	print(player.velocity.x)
	# Le preguntamos al AnimationPlayer si ya terminó de reproducir.
	print("Esta reproduciendose el animation player de hit")
	print(player.animation_player.is_playing())
	if player.is_on_floor() and not player.animation_player.is_playing() :
		print("aun no entro a ningun estado")
		if player.tipo_golpe_recibido == "normal":
			print("entro a idle")
			transitioned.emit(self, "idle")
		else: 
			print("entro a laydown")
			transitioned.emit(self, "layDown")

func handle_input(event: InputEvent) -> void:
	# Si apretamos el botón de ataque
	#if event.is_action_pressed(player.input_prefix + "attackPunch"):
	#	transitioned.emit(self, "punch")
		
	#elif event.is_action_pressed(player.input_prefix + "jump"):
	#	transitioned.emit(self, "jump")
		
	#elif event.is_action_pressed(player.input_prefix + "attackKick"):
	#	transitioned.emit(self, "kick")
	pass
