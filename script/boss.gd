extends Node2D

var bala_scene = preload("res://scenes/bala.tscn")

func _on_player_shoot(pos: Vector2, dir: Vector2) -> void:
	var bala = bala_scene.instantiate() as Area2D
	add_child(bala)
	bala.setup(pos, dir)
