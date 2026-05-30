extends State

func enter() -> void:
	# 1. Al entrar, le damos el impulso hacia arriba al jugador instantáneamente
	player.velocity.y = player.JUMP_VELOCITY
	
	# player.animation_player.play("jump")

func physics_update(delta: float) -> void:
	# Gravedad
	player.velocity.y += player.gravity * delta

	# Control Aéreo
	var direction := Input.get_axis(player.input_prefix + "left", player.input_prefix + "right")
	if direction != 0:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
		
	player.move_and_slide()

	player.actualizar_mirada()

	if player.is_on_floor():
		# si caemos mientras apretamos hacia adelante, 
		# vamos directo a correr. Si caemos sin apretar nada, vamos a Idle.
		if direction != 0:
			transitioned.emit(self, "run")
		else:
			transitioned.emit(self, "idle")

func handle_input(event: InputEvent) -> void:
	# ¿Qué pasa si aprieta ataque mientras está en el aire?
	# Acá es donde más adelante podria derivar a un "jump_punch_state"
	pass
