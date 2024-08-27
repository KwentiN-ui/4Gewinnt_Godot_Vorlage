extends Node


@export var kamera: Node3D

var actor: CharacterBody3D

var max_dist = 2 # maximaler Greifabstand für den Raycast
var raycast_length: float

var objekt_aufgenommen: bool = false
var objekt: RigidBody3D

func _ready() -> void:
	raycast_length = max_dist
	actor = get_parent().actor


func get_greifbar(node: Node) -> bool:
	"""
	Prüft, ob ein RigidBody die Komponente "greifbar" besitzt.
	"""
	if node is RigidBody3D:
		var komponenten = node.get_node_or_null("Komponenten")
		if komponenten:
			return komponenten.has_node("Greifbar")
	return false

func _physics_process(_delta: float) -> void:
	var viewport_mitte = get_viewport().get_visible_rect().size / 2

	if objekt_aufgenommen:
		var c_t = 1 # translatorische Steifigkeit
		var c_r = 1e-4 # rotatorische Steifigkeit

		var zielposition:Vector3 = actor.global_position + kamera.project_ray_normal(viewport_mitte) * raycast_length
		var kraft = (zielposition - objekt.global_position) * c_t
		objekt.apply_central_force(kraft)

		var zeiger = kamera.global_position - objekt.global_position # Vektor der vom Objekt zur Kamera zeigt
		var theta = zeiger.angle_to(objekt.global_basis.y) # Winkeldifferenz in rad
		
		objekt.apply_torque(zeiger.normalized().cross(objekt.global_basis.y) * theta * c_r)

		if Input.is_action_pressed("right_click"):
			objekt_aufgenommen = false
			raycast_length = max_dist
		
		if Input.is_action_just_released("max_dist_plus"):
			raycast_length += 0.01
			
		elif Input.is_action_just_released("max_dist_minus"):
			raycast_length -= 0.01
		
		raycast_length = clamp(raycast_length, 0.1, 3)

	elif Input.is_action_just_pressed("left_click"):
		# Raycast erzeugen
		var space_state = kamera.get_world_3d().direct_space_state
		var origin = kamera.project_ray_origin(viewport_mitte)
		var end = origin + kamera.project_ray_normal(viewport_mitte) * max_dist
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		
		var result = space_state.intersect_ray(query)
		
		if result:
			if get_greifbar(result["collider"]):
				objekt_aufgenommen = true
				raycast_length = 0.2
				objekt = result["collider"]
