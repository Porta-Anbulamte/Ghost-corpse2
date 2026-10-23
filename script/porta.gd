class_name Porta
extends Area2D

signal player_entrou(player: Node2D)

@onready var sprite_aberta: Sprite2D = $SpriteAberto
@onready var sprite_fechada: Sprite2D = $SpriteFechado

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func definir_aberta(aberta: bool) -> void:
	sprite_aberta.visible = aberta
	sprite_fechada.visible = not aberta
	set_deferred("monitoring", aberta)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_entrou.emit(body)
