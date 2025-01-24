extends Node3D

var speed = 50.0
var damage = 15

@onready var ray = $RayCast3D
@onready var mesh = $MeshInstance3D
@onready var particles = $BulletParticle

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -speed) * delta
	
	if ray.is_colliding():
		speed = 0
		mesh.visible = false
		particles.emitting = true
		
		var collider = ray.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(damage)
		
		await get_tree().create_timer(1.0).timeout
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
