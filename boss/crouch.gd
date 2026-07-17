extends State

func enter() -> void:
	player.velocity = Vector2.ZERO
	player.standing_collision.set_deferred("disabled", true)
	player.crouching_collision.set_deferred("disabled", false)
	player.animation_player.play("crouch")

func physics_update(delta: float) -> void:
	# gravedad
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
		
	player.move_and_slide()
	
	if not Input.is_action_pressed(player.input_prefix + "crouch"):
		transitioned.emit(self, "idle")

func handle_input(event: InputEvent) -> void:
	# Si apretamos el botón de ataque
	if event.is_action_pressed(player.input_prefix + "attackPunch"):
		transitioned.emit(self, "uppercut")
		
	elif event.is_action_pressed(player.input_prefix + "attackKick"):
		transitioned.emit(self, "kick")

func exit() -> void:
	player.standing_collision.set_deferred("disabled", false)
	player.crouching_collision.set_deferred("disabled", true)
