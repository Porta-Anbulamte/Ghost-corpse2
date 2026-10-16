class_name SpawnPontos
extends Node2D

signal inimigo_nasceu(inimigo: Node2D)

@export var atraso := 1.0
@export var aviso_textura: Texture2D   # o desenho do aviso, você coloca depois
@export var sala_minima_tardios := 5

func pontos_sorteados(sala_atual: int) -> Array:
	var pontos := get_children().filter(func(p):
		return not p.is_in_group("spawn_tardio") or sala_atual >= sala_minima_tardios
	)
	pontos.shuffle()
	return pontos

func spawnar(ponto: Node2D, cena: PackedScene) -> void:
	var aviso: Sprite2D = null
	if aviso_textura != null:
		aviso = Sprite2D.new()
		aviso.texture = aviso_textura
		ponto.add_child(aviso)   # nasce na posição do marcador
	get_tree().create_timer(atraso).timeout.connect(_criar.bind(ponto, cena, aviso))

func _criar(ponto: Node2D, cena: PackedScene, aviso: Sprite2D) -> void:
	if is_instance_valid(aviso):
		aviso.queue_free()
	var inimigo := cena.instantiate() as Node2D
	get_tree().current_scene.add_child(inimigo)
	inimigo.global_position = ponto.global_position
	inimigo_nasceu.emit(inimigo)
