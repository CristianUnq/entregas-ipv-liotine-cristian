extends State

func enter() -> void:
	player.animation_player.play("run")
	pass

func physics_update(delta: float) -> void:
	# Gravedad
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta

	# 2. Movimiento Horizontal
	var direction := Input.get_axis(player.input_prefix + "left", player.input_prefix + "right")
	
	player.actualizar_mirada()
	
	if direction != 0:
		# Le aplicamos la velocidad constante
		player.velocity.x = direction * player.SPEED
	else:
		# Si soltó el botón, frenamos y avisamos que queremos volver a Idle
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
		transitioned.emit(self, "idle")
		
	player.move_and_slide()

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed(player.input_prefix + "attackPunch"):
		transitioned.emit(self, "punch")
		
	elif event.is_action_pressed(player.input_prefix + "jump"):
		transitioned.emit(self, "jump")
		
	elif event.is_action_pressed(player.input_prefix + "attackKick"):
		transitioned.emit(self, "kick")
		
	elif event.is_action_pressed(player.input_prefix + "crouch"):
		transitioned.emit(self, "crouch")
