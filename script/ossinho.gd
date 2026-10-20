extends Area2D

var direcao: Vector2

func setup(pos: Vector2, dir: Vector2) -> void:
	global_position = pos + dir * 50 
	direcao = dir

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direcao * 300 * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.levar_dano(1)
		queue_free()
