extends CharacterBody3D

# Einstellungen
@export_range(0.5,10) var mouse_sensitivity: float = 1.0

# Nodes
@export var camera: Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	mouse_mode_change() # MOUSE_CAPTURED wenn im Spiel (zum Umsehen)


func mouse_mode_change() -> void:
	if Input.is_action_pressed("uncapture_Mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_pressed("left_click") && Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# hoch / runter 
		var rot = camera.global_rotation
		rot.x -= event.relative.y / (900 / mouse_sensitivity)
		rot.x = clamp(rot.x, deg_to_rad(-85), deg_to_rad(85))
		camera.global_rotation.x = rot.x
		
		# rechts / links
		global_rotation.y -= event.relative.x / (900 / mouse_sensitivity)
