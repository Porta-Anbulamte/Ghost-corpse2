extends CharacterBody2D
@export var ossinho_scene: PackedScene

var speed = 100
var vida := 3
var player: Node2D
@export var tempo_andando := 1
@export var tempo_mirando := 0.5
@export var tempo_recuperando := 0.5
enum Estado { ANDANDO, MIRANDO, RECUPERANDO }
var estado := Estado.ANDANDO
var timer := 1.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	timer -= delta
	match estado:
		Estado.ANDANDO:
			speed = 100
			if timer <= 0:
				estado = Estado.MIRANDO
				timer = tempo_mirando
		Estado.MIRANDO:
			speed = 0
			if timer <= 0:
				atirar()
				estado = Estado.RECUPERANDO
				timer = tempo_recuperando
		Estado.RECUPERANDO:
			speed = 0
			if timer <= 0:
				estado = Estado.ANDANDO
				timer = tempo_andando
	if player == null:
		return
	var dir := (player.global_position - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

func atirar() -> void:
	while player == null:
		return
	var dir := (player.global_position - global_position).normalized()
	var osso := ossinho_scene.instantiate()
	get_parent().add_child(osso)
	osso.setup(global_position, dir)

func morrer() -> void:
	queue_free()

func levar_dano(qtd: int) -> void:
	vida -= qtd
	if vida <= 0:
		morrer()
