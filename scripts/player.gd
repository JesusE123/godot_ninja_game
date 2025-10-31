class_name Player extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
@export var maxHealth = 30
@onready var currentHealt:int = maxHealth
@onready var enemy  = $"../enemy"
var attacking = false  # Para evitar moverse mientras ataca

func _physics_process(delta: float) -> void:
	# Aplicar gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Si está atacando, no se mueve
	if attacking:
		move_and_slide()
		return

	# Saltar
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Atacar
	if Input.is_action_just_pressed("Attack"):
		attacking = true
		velocity.x = 0
		$AnimatedSprite2D.play("attack")
		$hit_box.monitoring = true
		
		await $AnimatedSprite2D.animation_finished
		
		$hit_box.monitoring = false
		
		attacking = false
		$AnimatedSprite2D.play("idle")
		return  # No seguir moviéndose en este frame

	# Movimiento horizontal
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("idle")
		
	if $AnimatedSprite2D.flip_h:
		$hit_box/CollisionShape2D.position.x = -abs($hit_box/CollisionShape2D.position.x) #izquierda
	else:
		$hit_box/CollisionShape2D.position.x = abs($hit_box/CollisionShape2D.position.x) #derecha

	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	attacking = false
	$AnimatedSprite2D.play("idle")


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		if body.has_method("take_damage"):
			body.take_damage()
	
