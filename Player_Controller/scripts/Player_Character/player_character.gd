extends CharacterBody3D

@onready var Camera = get_node("%Camera")
@export var animation_tree: AnimationTree

const SPEED = 5.0
var _speed = SPEED
const JUMP_VELOCITY = 4.5

var CameraRotation = Vector2(0.0,0.0)
var MouseSensitivity = 0.001

var shake_rotation = 0 
var Start_Shake_Rotation = 0

var Crouched: bool = false
var Crouch_Blocked: bool = false
@export_category("Crouch Parametres")
@export var Crouch_Toggle: bool = false
@export var Crouch_Collision: ShapeCast3D
@export_range(0.0,3.0) var Crouch_Speed_Reduction = 2.0
@export_range(0.0,0.50) var Crouch_Blend_Speed = .2

@export_category("Lean Parametres")
@export_range(0.0,1.0) var Lean_Speed: float = .2
@export var Right_Lean_Collision: ShapeCast3D
@export var Left_Lean_Collision: ShapeCast3D
var lean_tween
enum {LEFT = 1, CENTRE = 0, RIGHT = -1}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if event is InputEventMouseMotion:
		var MouseEvent = event.relative * MouseSensitivity
		CameraLook(MouseEvent)
		
	if event.is_action_pressed("crouch"):
		Crouch()
	if event.is_action_released("crouch"):
		if !Crouch_Toggle and Crouched:
			Crouch()
	
		
	if Input.is_action_just_released("lean_left") or Input.is_action_just_released("lean_right"):
		if !(Input.is_action_pressed("lean_right") or Input.is_action_pressed("lean_left")):
			lean(CENTRE)
	if Input.is_action_just_pressed("lean_left"):
		lean(LEFT)
	if Input.is_action_just_pressed("lean_right"):
		lean(RIGHT)

func lean(blend_amount: int):
	if is_on_floor():
		if lean_tween:
			lean_tween.kill()
		
		lean_tween = get_tree().create_tween()
		lean_tween.tween_property(animation_tree,"parameters/lean_blend/blend_amount", blend_amount, Lean_Speed)

func lean_collision():
	animation_tree["parameters/left_collision_blend/blend_amount"] = lerp(
		float(animation_tree["parameters/left_collision_blend/blend_amount"]),float(Left_Lean_Collision.is_colliding()),Lean_Speed
	)
	animation_tree["parameters/right_collision_blend/blend_amount"] = lerp(
		float(animation_tree["parameters/right_collision_blend/blend_amount"]),float(Right_Lean_Collision.is_colliding()),Lean_Speed
	)

func Crouch():
	var Blend
	if !Crouch_Collision.is_colliding():
		if Crouched:
			Blend = 0
		else:
			if is_on_floor():
				Blend = -1
			else:
				Blend = 1
		var blend_tween = get_tree().create_tween()
		blend_tween.tween_property(animation_tree,"parameters/Crouch_Blend/blend_amount",Blend,Crouch_Blend_Speed)
		Crouched = !Crouched
	else:
		Crouch_Blocked = true


func CameraLook(Movement: Vector2):
	CameraRotation += Movement
	
	transform.basis = Basis()
	Camera.transform.basis = Basis()
	
	rotate_object_local(Vector3(0,1,0),-CameraRotation.x) # first rotate in Y
	Camera.rotate_object_local(Vector3(1,0,0), -CameraRotation.y) # then rotate in X
	CameraRotation.y = clamp(CameraRotation.y,-1.5,1.2)

func _physics_process(delta):

	lean_collision()
	
	if Crouched and Crouch_Blocked:
		if !Crouch_Collision.is_colliding():
			Crouch_Blocked = false
			if !Input.is_action_pressed("crouch") and !Crouch_Toggle:
				Crouch()
				
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		_speed = (SPEED / max((float(Crouched)*Crouch_Speed_Reduction),1))

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if Crouched:
			Crouch()
		else:
			lean(CENTRE)
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	velocity.x = move_toward(velocity.x, direction.x * _speed, SPEED)
	velocity.z = move_toward(velocity.z, direction.z * _speed, SPEED)

	move_and_slide()
