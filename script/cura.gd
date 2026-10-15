extends Area2D

@export var quantidade := 1

func _ready() -> void:
	add_to_group("cura")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.vida < body.vida_max:
		body.curar(quantidade)
		queue_free()
