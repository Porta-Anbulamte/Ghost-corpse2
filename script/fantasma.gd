extends CharacterBody2D

var vida := 2
var player: Node2D
enum Estado {PARADO, DASH, PAUSA}
var estado = Estado.PARADO
var timer := 1
var tempo_parado := 10
var tempo_pausa := 10
var tempo_dash := 10
var speed = 0
var dir : Vector2

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	timer -= delta
	match estado:
		Estado.PARADO:
			speed = 0
			velocity = dir * speed
			if timer <=0:
				estado = Estado.DASH
				timer = tempo_dash
			dir = (player.global_position - global_position).normalized()
		Estado.DASH:
			speed = 500
			if timer <=0:
				estado = Estado.PAUSA
				timer = tempo_pausa
			velocity = dir * speed
		Estado.PAUSA:
			speed = 0
			velocity = dir * speed
			if timer <= 0:
				estado = Estado.PARADO
				timer = tempo_parado
	move_and_slide()

func levar_dano(qtd: int) -> void:
	vida -= qtd
	if vida <= 0:
		queue_free()
