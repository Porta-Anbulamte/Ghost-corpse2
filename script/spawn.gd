class_name SpawnPontos
extends Node2D

signal inimigo_nasceu(inimigo: Node2D)

@export var atraso := 1.0
@export var aviso_textura: SpriteFrames   # o desenho do aviso, você coloca depois
@export var sala_minima_tardios := 5

func pontos_sorteados(sala_atual: int) -> Array:
	var pontos := get_children().filter(func(p):
		return not p.is_in_group("spawn_tardio") or sala_atual >= sala_minima_tardios
	)
	pontos.shuffle()
	return pontos

func spawnar(ponto: Node2D, cena: PackedScene) -> void:
	var aviso: AnimatedSprite2D = null
	if aviso_textura != null:
		aviso = AnimatedSprite2D.new()
		aviso.sprite_frames = aviso_textura
		ponto.add_child(aviso)   # nasce na posição do marcador
		aviso.play("default")
	get_tree().create_timer(atraso).timeout.connect(_criar.bind(ponto, cena, aviso))

func _criar(ponto: Node2D, cena: PackedScene, aviso: AnimatedSprite2D) -> void:
	if is_instance_valid(aviso):
		aviso.queue_free()
	var inimigo := cena.instantiate() as Node2D
	get_tree().current_scene.add_child(inimigo)
	inimigo.global_position = ponto.global_position
	inimigo_nasceu.emit(inimigo)
