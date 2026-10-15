extends CharacterBody2D

var direcao: Vector2
var speed: int = 330
var vida := 3
var vida_max := 3
signal shoot(pos: Vector2, dir: Vector2)
signal dano(vida: int) 
var tiro = true
@export var cadencia = 0.4
var tempo := 0.0
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var y_inicial: float = sprite.position.y

func _physics_process(delta: float) -> void:
	get_input()
	direcao = Input.get_vector("left", "right", "up", "down")
	velocity = direcao * speed
	move_and_slide()
	
	if direcao.x > 0:
		$Sprite2D.flip_h = true
	elif direcao.x < 0:
		$Sprite2D.flip_h = false

func get_input():
	if Input.is_action_pressed("shot") and tiro:
		tiro = false
		shoot.emit(position, get_local_mouse_position().normalized())
		await get_tree().create_timer(cadencia).timeout
		tiro = true

func levar_dano(qtd: int) -> void:
	vida -= qtd
	dano.emit(vida)
	if vida <= 0:
		get_tree().reload_current_scene()

func _process(delta: float) -> void:
	tempo += delta
	$Sprite2D.position.y = sin(tempo * 5.0) * 10.0
	
	if direcao != Vector2.ZERO:
		sprite.rotation = sin(tempo * 5.0) * deg_to_rad(5.0)
	else:
		sprite.rotation = lerp(sprite.rotation, 0.0, 7.0 * delta)

func curar(qtd: int) -> void:
	vida = mini(vida + qtd, vida_max)
	dano.emit(vida)
