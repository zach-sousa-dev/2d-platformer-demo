# This script handles everything to do with the base player controls.


extends CharacterBody2D

# Stats
const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var gravity_direction = Vector2.DOWN
var fake_velocity = Vector2.DOWN
var num_fields: int = 0

# Nodes
@onready var anim = $AnimatedSprite2D
@onready var backdrop: Sprite2D = $/root/Scene/Backdrop
@onready var audioPlayer: AudioStreamPlayer2D = $PlayerSounds

# Assets
var jumpSound = preload("res://sounds/jump.wav")

func _ready() -> void:
	add_to_group("player")
	for child in $"/root/Scene/Planets".get_children():
		var planet := child.get_child(1) as Field
		planet.update_gravity_direction.connect(_on_gravity_direction_updated)
		planet.add_num_fields.connect(_on_add_num_fields)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		fake_velocity.y += get_gravity().y * delta
		anim.play("fall")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		fake_velocity.y = JUMP_VELOCITY
		audioPlayer.stream = jumpSound
		audioPlayer.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		fake_velocity.x = direction * SPEED
		if is_on_floor():
			anim.play("run")
		if direction > 0:
			anim.flip_h = false
		else:
			anim.flip_h = true
	else:
		fake_velocity.x = move_toward(fake_velocity.x, 0, SPEED)
		if is_on_floor():
			anim.play("stand")
			
			
	velocity = fake_velocity.rotated(Vector2.DOWN.angle_to(gravity_direction))
	#rotation = move_toward(rotation, Vector2.DOWN.angle_to(gravity_direction), 10 * delta)
	rotation = Vector2.DOWN.angle_to(gravity_direction)
	move_and_slide()
	
	# Parallax effect
	backdrop.move_local_x(velocity.x * delta * -0.05)
	backdrop.move_local_y(velocity.y * delta * -0.05)
	
func _on_gravity_direction_updated(direction: Vector2) -> void:
	gravity_direction = direction
	up_direction = -gravity_direction

func _on_add_num_fields(num: int) -> void:
	num_fields += num
	if num_fields < 1:
		gravity_direction = Vector2.DOWN
		up_direction = Vector2.UP
