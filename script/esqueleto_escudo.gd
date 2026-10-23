extends CharacterBody2D
@export var ossinho_scene: PackedScene
@onready var anim: AnimatedSprite2D = $Sprite2D
@onready var efeito = $efeito
@onready var timer = $Timer

var vida := 5
var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	anim.frame_changed.connect(_on_frame_changed)

	var timer := Timer.new()
	timer.wait_time = 1
	timer.autostart = true
	timer.timeout.connect(atirar)
	add_child(timer)

func iniciar_ataque() -> void:
	anim.play("default")

func _on_frame_changed() -> void:
	if anim.animation == "ataque" and anim.frame == 4:   # frame 4 = o 5º sprite
		atirar()


func atirar() -> void:
	if player == null:
		return
	var dir := (player.global_position - global_position).normalized()
	var osso := ossinho_scene.instantiate()
	get_parent().add_child(osso)
	osso.setup(global_position, dir)

func morrer() -> void:
	queue_free()

func levar_dano(qtd: int) -> void:
	vida -= qtd
	efeito.play("dano")
	timer.start()
	await timer.timeout
	efeito.play("RESET")
	if vida <= 0:
		morrer()
