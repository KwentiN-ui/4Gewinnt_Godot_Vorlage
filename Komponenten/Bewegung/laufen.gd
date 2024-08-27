extends Node

@export var movement_speed: float = 50.0
@export var running_faktor:float = 1.5
var actor: CharacterBody3D

var current_speed: float

func _ready() -> void:
	actor = get_parent().actor

func _physics_process(delta: float) -> void:
	current_speed = get_speed()
	var dir = movement_direction() # Richtungs input WASD + Umsehen
	actor.velocity.x = dir.x * delta * current_speed
	actor.velocity.z = dir.z * delta * current_speed
	actor.move_and_slide()

func get_speed() -> float:
	"""
	Ermittelt die aktuelle Spielergeschwindigkeit in Abhängigkeit der Spielereingaben.
	"""
	if Input.is_action_pressed("sprint"):
		return (running_faktor * movement_speed)
	else:
		return (movement_speed)

func movement_direction() -> Vector3:
	var direction: Vector3 = Vector3.ZERO
	if Input.is_action_pressed("down"):
		direction.z = 1
	if Input.is_action_pressed("up"):
		direction.z = -1
	if Input.is_action_pressed("left"):
		direction.x = -1
	if Input.is_action_pressed("right"):
		direction.x = 1
	var dir = (actor.transform.basis * Vector3(direction.x, 0, direction.z)).normalized()
	return dir
