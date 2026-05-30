extends State

func enter() -> void:
	# el personaje se queda quieto
	player.velocity.x = 0
	player.animation_player.play("idle")

func physics_update(delta: float) -> void:
	# gravedad
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
		
	player.move_and_slide()
	
	player.actualizar_mirada()
	
	var direction = Input.get_axis(player.input_prefix + "left", player.input_prefix + "right")
	if direction != 0:
		transitioned.emit(self, "run")

func handle_input(event: InputEvent) -> void:
	# Si apretamos el botón de ataque
	if event.is_action_pressed(player.input_prefix + "attackPunch"):
		transitioned.emit(self, "punch")
		
	elif event.is_action_pressed(player.input_prefix + "jump"):
		transitioned.emit(self, "jump")
		
	elif event.is_action_pressed(player.input_prefix + "attackKick"):
		transitioned.emit(self, "kick")
		
	elif event.is_action_pressed(player.input_prefix + "crouch"):
		transitioned.emit(self, "crouch")
