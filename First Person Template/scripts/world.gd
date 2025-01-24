extends Node3D

# Onready Variables
@onready var player = $Game/Player
@onready var hit_rect = $UI/ColorRect
@onready var camera = $Game/Player/Head/Camera3D
@onready var head = $Game/Player/Head

# Camera Shake Variables
var shake_intensity: float = 0.1
var shake_duration: float = 0.2
var shake_timer: float = 0

func _process(_delta: float) -> void:
	get_tree().call_group("hostile", "update_target_location", player.global_transform.origin)
	
	# Apply screen shake
	if shake_timer > 0:
		shake_timer -= _delta
		camera.global_transform.origin += Vector3(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		# Reset the camera's position after shaking
		if shake_timer <= 0:
			camera.global_transform.origin = head.global_transform.origin


func _on_player_player_hit() -> void:
	# Start screen shake
	shake_timer = shake_duration
	
	hit_rect.visible = true
	await get_tree().create_timer(0.2).timeout
	hit_rect.visible = false
	
