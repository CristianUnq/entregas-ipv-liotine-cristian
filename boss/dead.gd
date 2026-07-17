extends State

func enter() -> void:
	player.velocity = Vector2.ZERO
	player.standing_collision.set_deferred("disabled", true)
	player.laying_collision.set_deferred("disabled", false)
	print("ENTRA EN DEAD ")
	player.animation_player.play("dead")

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
	
	#player.velocity.x = 0
	player.move_and_slide()
	
	#if not player.animation_player.is_playing() or player.animation_player.current_animation != "layingDown":
	#	transitioned.emit(self, "idle")
	
func handle_input(event: InputEvent) -> void:
	pass
