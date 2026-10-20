extends CharacterBody2D

enum Estado { PARADO, DASH, PAUSA }

@export var vida := 99
@export var tempo_parado := 1.0
@export var tempo_pausa := 0.8
@export var velocidade_dash := 900.0
@export var frenagem := 1500.0
@export var tempo_mira_travada := 0.3  # no fim do PARADO a mira trava, dá pra desviar
@export var tempo_dash_min := 0.2
@export var tempo_dash_max := 1.5
@export var tempo_extra := 0.15        # ele passa um pouco do ponto mirado
@export var atravessa_paredes := false  # false = ele para ao bater numa parede

var estado: Estado = Estado.PARADO
var timer := 0.0
var dir := Vector2.ZERO
var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	timer = tempo_parado

func _physics_process(delta: float) -> void:
	if player == null:
		return

	timer -= delta

	match estado:
		Estado.PARADO:
			velocity = velocity.move_toward(Vector2.ZERO, frenagem * delta)
			if timer > tempo_mira_travada:
				dir = global_position.direction_to(player.global_position)
			if timer <= 0:
				estado = Estado.DASH
				# duração proporcional à distância: ele alcança o player de qualquer lugar
				var distancia := global_position.distance_to(player.global_position)
				timer = clampf(distancia / velocidade_dash + tempo_extra, tempo_dash_min, tempo_dash_max)

		Estado.DASH:
			velocity = dir * velocidade_dash
			if timer <= 0:
				estado = Estado.PAUSA
				timer = tempo_pausa

		Estado.PAUSA:
			velocity = velocity.move_toward(Vector2.ZERO, frenagem * delta)
			if timer <= 0:
				estado = Estado.PARADO
				timer = tempo_parado

	mover(delta)

func mover(delta: float) -> void:
	if atravessa_paredes:
		# movimento em linha reta, sem colisão física com nada
		global_position += velocity * delta
	else:
		# para ao bater, sem deslizar
		var colisao := move_and_collide(velocity * delta)
		if colisao and estado == Estado.DASH:
			estado = Estado.PAUSA
			timer = tempo_pausa

func levar_dano(qtd: int) -> void:
	vida -= qtd
	if vida <= 0:
		queue_free()
