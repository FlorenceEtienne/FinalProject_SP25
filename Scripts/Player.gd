extends RigidBody3D

# the colon next to the "=" is used to differentiate and group different variables from regular variables
# 
var mouse_sense := 0.001;  #the speed the camera rotates proportionally to the mouse input
var twist_input := 0.0; #stores how much the mouse moves horizontally
var pitch_input := 0.0; #stores how much the mouse moves vertically


@onready var twist_pivot := $TwistPivot;
@onready var pitch_pivot := $TwistPivot/PitchPivot;

func _ready() -> void: #start function
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED); #on start of game change mouse to captured
	
#update function #loop updates every 60 frames #delta is how many seconds since the last frame (time is measured in floats)
func _process(delta: float) -> void: 
	var input := Vector3.ZERO;
	input.x = Input.get_axis("move_left", "move_right");
	input.z = Input.get_axis("move_forward", "move_backward");
	
	apply_central_force(twist_pivot.basis * input * 1200.0 * delta); #force in a 3D direction for the rigidbody #multiplying the velocity (direction * speed) by 1200.0 * delta
	
	#stop mouse from being captured
	if Input.is_action_just_pressed("ui_cancel"): #in this condition the following code for the mouse input will make the cursor visible when the cancel action (esc input) is pressed
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
		
	if Input.is_action_just_pressed("mouse_appearance"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
		
	twist_pivot.rotate_y(twist_input);
	pitch_pivot.rotate_x(pitch_input);
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		#the parameter shown as degrees but to the system it's in radians 
		#for this i will need to set the same value to limit rotation
		deg_to_rad(-30),
		deg_to_rad(-30)
	);
	twist_input = 0.0;
	pitch_input = 0.0;
	
func _unhandled_input(event: InputEvent) -> void: #if the mouse capture action is canceled, this event will be ignored (camera stops moving due to mouse_sense not assigned to it)
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED: 
			twist_input = -event.relative.x * mouse_sense; #values will be negative so the cam rotates in the same direction as mouse 
			pitch_input = -event.relative.y * mouse_sense;
