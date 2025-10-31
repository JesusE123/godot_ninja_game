class_name enemy extends  CharacterBody2D
var move_speed = 50
var is_attack := false
var is_hit := false
@onready var player = $"../Player"
@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if is_hit:
		move_and_slide()
		return
		
	if !is_attack and player:
		sprite.play("run")
		
		var move_direction = (player.position - position).normalized()
		if move_direction:
			velocity = move_direction * move_speed
			if move_direction.x != 0:
				sprite.flip_h = move_direction.x < 0
		move_and_slide()
		
		
func take_damage() -> void:
	print("el enemigo ha recibido daño")
	is_hit = true
	sprite.play("take_hit")
	return
	

	


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "take_hit":
		is_hit = false
		sprite.play("run")
