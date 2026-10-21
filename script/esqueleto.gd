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
@onready var animated_sprite = $Sprite2D
@onready var efeito = $hurt
@onready var tempodano = $Timerhurt

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	timer -= delta
	match estado:
		Estado.ANDANDO:
			animated_sprite.play("andando")
			speed = 100
			if timer <= 0:
				estado = Estado.MIRANDO
				timer = tempo_mirando
		Estado.MIRANDO:
			speed = 0
			animated_sprite.play("atirando")
			if timer <= 0:
				atirar()
				estado = Estado.RECUPERANDO
				timer = tempo_recuperando
		Estado.RECUPERANDO:
			speed = 0
			animated_sprite.play("parado")
			if timer <= 0:
				estado = Estado.ANDANDO
				timer = tempo_andando
	if player == null:
		return
	var dir := (player.global_position - global_position).normalized()
	velocity = dir * speed
	move_and_slide()
	
	if player.global_position.x > global_position.x:
		$Sprite2D.flip_h = true
	elif player.global_position.x < global_position.x:
		$Sprite2D.flip_h = false


func atirar() -> void:
	while player == null:
		return
	var dir := (player.global_position - global_position).normalized()
	var osso := ossinho_scene.instantiate()
	get_parent().add_child(osso)
	osso.setup(global_position, dir)
	animated_sprite.play("atirando")

func morrer() -> void:
	queue_free()

func levar_dano(qtd: int) -> void:
	vida -= qtd
	if vida <= 0:
		morrer()
	efeito.play("hurt")
	tempodano.start()
	await tempodano.timeout
	efeito.play("RESET")
