extends Area2D

var sala = 0
signal player_entrou(player: Node2D)

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_entrou.emit(body)
		sala += 1
		print(sala)
