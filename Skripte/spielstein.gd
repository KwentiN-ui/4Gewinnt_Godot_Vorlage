@tool
extends RigidBody3D
class_name Spielstein

var mesh: MeshInstance3D

@export_range(1, 2) var spieler: int = 1:
	set(neu):
		assert(neu == 1 or neu == 2, "'spieler' darf nur 1 oder 2 sein!")
		spieler = neu
		var farbe: Color
		if spieler == 1:
			farbe = Color(1, 0, 0)
		else:
			farbe = Color(1, 1, 0)
		if mesh:
			mesh.mesh.material.albedo_color = farbe

func _ready() -> void:
	mesh = self.find_child("Spielstein_Mesh")
	self.inertia = Vector3(2.4e-6, 4.0e-6, 2.4e-6)
	spieler = spieler
