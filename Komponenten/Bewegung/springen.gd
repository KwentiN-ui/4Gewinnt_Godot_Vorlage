extends Node

@export var jump_speed: float = 2
var actor: CharacterBody3D
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	actor = get_parent().actor

func _physics_process(delta: float) -> void:
	jump(delta)

func jump(delta) -> void:
	"""
	Prüft ob die "jump" Action gedrückt wird und löst den Sprung aus.
	"""
	# Schwerkraft wenn in der Luft
	if not actor.is_on_floor():
		actor.velocity.y -= gravity * delta

	# Springen
	elif Input.is_action_just_pressed("jump"):
		actor.velocity.y = jump_speed
