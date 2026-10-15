extends CharacterBody2D

@export var velocidade := 100
var vida := 2
var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if player == null:
		return
	var dir := (player.global_position - global_position).normalized()
	velocity = dir * velocidade
	move_and_slide()
	
	for i in get_slide_collision_count():
		var corpo = get_slide_collision(i).get_collider()
		if corpo != null and corpo.is_in_group("player"):
			corpo.levar_dano(1)
			queue_free()
			return

func levar_dano(qtd: int) -> void:
	vida -= qtd
	if vida <= 0:
		queue_free()
