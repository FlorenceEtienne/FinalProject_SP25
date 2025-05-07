extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

#handle the destination of the enemy temp
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var rand_pos := Vector3.ZERO; 
		#when you hit the space bar generate new random position as the same dimensions as csgbox3D's floor
		#randf_range generates a random float between two parameters
		#when passed into the navigation server it will map to the nearest valid position on the map
		rand_pos.x = randf_range(-10.0, 10.0);
		rand_pos.z = randf_range(-10.0, 10.0);
		navigation_agent_3d.set_target_position(rand_pos); #once valid it is passed into the server with set position to target

#func update_target_location(target_location):
	#pass
		
func _physics_process(_delta) -> void:
	var destination = navigation_agent_3d.get_next_path_position(); #next path position is assigned to destination variable 
	var local_destination = destination - global_position; #find a local position in that position
	var direction = local_destination.normalized(); #make a direction by taking the local position and normalizing it
	
	velocity = direction * 5.0; #moving enemy to that destination by using the direction then multiply it by a speed
	move_and_slide(); #use to help mesh move smoothly when the character body (3D) applies velocity to itself
