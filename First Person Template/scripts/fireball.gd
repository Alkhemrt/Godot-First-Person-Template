extends Node3D

var speed = 25.0
var damage = 25

@onready var ray = $RayCast3D
@onready var mesh = $MeshInstance3D

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -speed) * delta
	
	if ray.is_colliding():
		speed = 0
		mesh.visible = false
		
		var collider = ray.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(damage)
			
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
