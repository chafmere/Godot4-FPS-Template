extends CharacterBody3D

@onready var Camera = get_node("%Camera")
@export var subviewport_camera: Camera3D
@export var main_camera:Camera3D
@export var animation_tree: AnimationTree

#const SPEED = 5.0
var _speed: float
const JUMP_VELOCITY = 4.5

var CameraRotation: Vector2 = Vector2(0.0,0.0)
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
enum {GROUND_CROUCH = -1, STANDING = 0, AIR_CROUCH = 1}

@export_category("Lean Parametres")
@export_range(0.0,1.0) var Lean_Speed: float = .2
@export var Right_Lean_Collision: ShapeCast3D
@export var Left_Lean_Collision: ShapeCast3D
var lean_tween
enum {LEFT = 1, CENTRE = 0, RIGHT = -1}

@export_category("Speed Parameters")
@export var Sprint_Timer: Timer
#@export var Sprint_Cooldown_Timer: Timer

@export var Sprint_Cooldown_Time: float = 3.0
@export var Sprint_Time: float = 1.0
@export var Sprint_Replenish_rate: float = 0.30
var Sprint_On_Cooldown: bool = false
var Sprint_Time_Remaining: float = Sprint_Time
@onready var Sprint_Bar: Range = $CanvasLayer/Sprint_Bar

const NORMAL_SPEED = 1
@export_range(1.0,3.0) var Sprint_Speed: float = 2.0
@export_range(0.1,1.0) var Walk_Speed: float = 0.5
var Speed_Modifier: float = NORMAL_SPEED

@export_category("Jump Parameters")
@export var Jump_Peak_Time: float = .5
@export var Jump_Fall_Time: float = .5
@export var Jump_Height: float = 2.0
@export var Jump_Distance: float = 4.0
@export var Coyote_Time: float = .1
@export var Jump_Buffer_Time: float = .2
@onready var coyote_timer: Timer = $Coyote_Timer


# Get the gravity from the project settings to be synced with RigidBody nodes.
var Jump_Gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var Fall_Gravity: float
var Jump_Velocity: float
var Speed: float
var Jump_Available: bool = true
var Jump_Buffer: bool = false


func _ready():
	Update_CameraRotation()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Calculate_Movement_Parameters()
	
func Update_CameraRotation():
	var current_rotation = get_rotation()
	CameraRotation.x = current_rotation.y
	CameraRotation.y = current_rotation.x
	
	
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
		
	if Input.is_action_just_released("sprint") or Input.is_action_just_released("walk"):
		if !(Input.is_action_pressed("walk") or Input.is_action_pressed("sprint")):
			Speed_Modifier = NORMAL_SPEED
			exit_sprint()

	if Input.is_action_just_pressed("sprint") and !Crouched:
		if !Sprint_On_Cooldown:
			Speed_Modifier = Sprint_Speed
			Sprint_Timer.start(Sprint_Time_Remaining)

	if Input.is_action_just_pressed("walk") and !Crouched:
		Speed_Modifier = Walk_Speed

func Calculate_Movement_Parameters()->void:
	Jump_Gravity = (2*Jump_Height)/pow(Jump_Peak_Time,2)
	Fall_Gravity = (2*Jump_Height)/pow(Jump_Fall_Time,2)
	Jump_Velocity = Jump_Gravity * Jump_Peak_Time
	Speed = Jump_Distance/(Jump_Peak_Time+Jump_Fall_Time)
	_speed = Speed

func lean(blend_amount: int):
	if is_on_floor():
		if lean_tween:
			lean_tween.kill()
		
		lean_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
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
			Blend = STANDING
		else:
			Speed_Modifier = NORMAL_SPEED
			exit_sprint()
			
			if is_on_floor():
				Blend = GROUND_CROUCH
			else:
				Blend = AIR_CROUCH
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
	
func exit_sprint():
	if !Sprint_Timer.is_stopped():
		Sprint_Time_Remaining = Sprint_Timer.time_left
		Sprint_Timer.stop()

func Sprint_Replenish(delta):
	var Sprint_Bar_Value

	if !Sprint_On_Cooldown and (Speed_Modifier != Sprint_Speed):
		
		if is_on_floor():
			Sprint_Time_Remaining = move_toward(Sprint_Time_Remaining, Sprint_Time, delta*Sprint_Replenish_rate)
			
		Sprint_Bar_Value= (Sprint_Time_Remaining/Sprint_Time)*100
		
	else:
		Sprint_Bar_Value = (Sprint_Timer.time_left/Sprint_Time)*100
	
	#Sprint_Bar_Value = ((int(Sprint)*Sprint_Time_Remaining)+(int(!Sprint)*Sprint_Timer.time_left)/Sprint_Time)*100
	Sprint_Bar.value = Sprint_Bar_Value
	
	if Sprint_Bar_Value == 100:
		Sprint_Bar.hide()
	else:
		Sprint_Bar.show()

func _process(delta: float) -> void:
	if subviewport_camera:
		subviewport_camera.global_transform = main_camera.global_transform

func _physics_process(delta):
	Sprint_Replenish(delta)
	lean_collision()
		
	if Crouched and Crouch_Blocked:
		if !Crouch_Collision.is_colliding():
			Crouch_Blocked = false
			if !Input.is_action_pressed("crouch") and !Crouch_Toggle:
				Crouch()

	# Add the gravity.
	if not is_on_floor():
		if coyote_timer.is_stopped():
			coyote_timer.start(Coyote_Time)
	
		if velocity.y>0:
			velocity.y -= Jump_Gravity * delta
		else:
			velocity.y -= Fall_Gravity * delta
	else:
		Jump_Available = true
		coyote_timer.stop()
		_speed = (Speed / max((float(Crouched)*Crouch_Speed_Reduction),1)) * Speed_Modifier
		if Jump_Buffer:
			Jump()
			Jump_Buffer = false
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept"):
		if Jump_Available:
			if Crouched:
				Crouch()
			else:
				lean(CENTRE)
				Jump()
		else:
			Jump_Buffer = true
			get_tree().create_timer(Jump_Buffer_Time).timeout.connect(on_jump_buffer_timeout)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	velocity.x = move_toward(velocity.x, direction.x * _speed, Speed)
	velocity.z = move_toward(velocity.z, direction.z * _speed, Speed)

	move_and_slide()

func Jump()->void:
	velocity.y = Jump_Velocity
	Jump_Available = false

func _on_sprint_timer_timeout() -> void:
	Sprint_On_Cooldown = true
	get_tree().create_timer(Sprint_Cooldown_Time).timeout.connect(_on_sprint_cooldown_timeout)
	Speed_Modifier = NORMAL_SPEED
	Sprint_Time_Remaining = 0

func _on_sprint_cooldown_timeout():
	Sprint_On_Cooldown = false


func _on_coyote_timer_timeout() -> void:
	Jump_Available = false

func on_jump_buffer_timeout()->void:
	Jump_Buffer = false
