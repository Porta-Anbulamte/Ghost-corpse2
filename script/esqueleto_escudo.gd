extends CharacterBody2D
@export var ossinho_scene: PackedScene

var vida := 5
var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

	var timer := Timer.new()
	timer.wait_time = 1
	timer.autostart = true
	timer.timeout.connect(atirar)
	add_child(timer)

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
	if vida <= 0:
		morrer()
