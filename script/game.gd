extends Node2D

var bala_scene = preload("res://scenes/bala.tscn")
@export var label_salas: Label
@export var label_dano: Label
@export var inimigos_cenas: Array[PackedScene]
@export var quantidade := 4
@export var spawns: SpawnPontos
@export var porta: Area2D
@export var inicio: Marker2D
var sala:=0
var vivos := 0 

func _ready() -> void:
	porta.player_entrou.connect(_on_porta_player_entrou)
	spawns.inimigo_nasceu.connect(_on_inimigo_nasceu)
	iniciar_rodada()

func iniciar_rodada() -> void:
	ativar_porta(false)

	var pontos := spawns.pontos_sorteados()
	var total := mini(quantidade, pontos.size())
	vivos = total

	if total == 0:
		ativar_porta(true)
		return

	for i in total:
		spawns.spawnar(pontos[i], inimigos_cenas.pick_random())

func _on_inimigo_saiu() -> void:
	if not is_inside_tree():
		return
	vivos -= 1
	if vivos <= 0:
		ativar_porta(true)

func ativar_porta(ativa: bool) -> void:
	porta.visible = ativa
	porta.set_deferred("monitoring", ativa)

func _on_porta_player_entrou(player: Node2D) -> void:
	get_tree().call_group("osso","queue_free")
	player.global_position = inicio.global_position
	quantidade += 1
	sala += 1
	atualizar_contador_sala()
	iniciar_rodada()

func atualizar_contador_sala() -> void:
	label_salas.text = "Salas: " + str(sala)


func _on_player_shoot(pos: Vector2, dir: Vector2) -> void:
	var bala = bala_scene.instantiate() as Area2D
	$bala.add_child(bala)
	bala.setup(pos, dir)


func _on_player_dano(vida: int) -> void:
	label_dano.text = "Vida: " + str(vida) 

func _on_inimigo_nasceu(inimigo: Node2D) -> void:
	inimigo.tree_exited.connect(_on_inimigo_saiu)
