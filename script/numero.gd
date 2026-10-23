extends AnimatedSprite2D

var sala := 0
var timer = 0.5

func _process(delta: float) -> void:
	if sala == 0:
		play("0")
	if sala == 1:
		await get_tree().create_timer(timer).timeout
		play("1")
	if sala == 2:
		await get_tree().create_timer(timer).timeout
		play("2")
	if sala == 3:
		await get_tree().create_timer(timer).timeout
		play("3")
	if sala == 4:
		await get_tree().create_timer(timer).timeout
		play("4")
	if sala == 5:
		await get_tree().create_timer(timer).timeout
		play("5")
	if sala == 6:
		await get_tree().create_timer(timer).timeout
		play("6")
	if sala == 7:
		await get_tree().create_timer(timer).timeout
		play("7")
	if sala == 8:
		await get_tree().create_timer(timer).timeout
		play("8")
	if sala == 9:
		await get_tree().create_timer(timer).timeout
		play("9")

func _on_porta_player_entrou(player: Node2D) -> void:
	sala += 1
