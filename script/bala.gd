extends Area2D

var direcao: Vector2

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	queue_free()

func setup(pos: Vector2, dir: Vector2):
	position = pos + dir * 70
	direcao = dir

func _physics_process(delta: float) -> void:
	position +=direcao * 300 * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("inimigo"):
		body.levar_dano(1)
		queue_free()
