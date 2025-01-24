extends CharacterBody3D

# Variables
const SPEED = 7.0
var time_since_last_attack = 0.0
var attack_cooldown = 2.0

# Health variables
var max_hp = 50
var current_hp = max_hp

# Others
var instance
var fireball = load("res://scenes/fireball.tscn")

@onready var nav_agent = $NavigationAgent3D
@onready var ray = $RayCast3D

# Player position for aiming
var player_position: Vector3


func _process(delta: float) -> void:
	time_since_last_attack += delta
	
	# Update movement
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	nav_agent.set_velocity(new_velocity)


func update_target_location(target_location):
	# Set navigation target
	nav_agent.target_position = target_location
	# Update player position for aiming
	player_position = target_location + Vector3(0,1,0)

func _on_navigation_agent_3d_target_reached() -> void:
	# Check cooldown
	if time_since_last_attack >= attack_cooldown:
		# Spawn the fireball
		instance = fireball.instantiate()
		instance.position = ray.global_position
		
		# Calculate the direction to the player, including Y-axis
		var direction_to_player = (player_position - ray.global_position).normalized()
		
		# Orient the fireball toward the player
		instance.transform.basis = Basis.looking_at(direction_to_player, Vector3.UP)
		
		get_parent().add_child(instance)
		time_since_last_attack = 0.0


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()

func take_damage(damage: int) -> void:
	current_hp -= damage
	if current_hp <= 0:
		die()

func die() -> void:
	queue_free()
