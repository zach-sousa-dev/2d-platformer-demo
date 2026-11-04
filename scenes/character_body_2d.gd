extends CharacterBody2D

# Stats
const SPEED = 150.0
const JUMP_VELOCITY = -300.0

# Nodes
@onready var anim = $AnimatedSprite2D
@onready var level = "../TileMapLayer"
@onready var backdrop: Sprite2D = $Backdrop
@onready var audioPlayer: AudioStreamPlayer2D = $PlayerSounds
@onready var musicPlayer: AudioStreamPlayer2D = $Music

# Assets
var jumpSound = preload("res://sounds/jump.wav")

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		anim.play("fall")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		audioPlayer.stream = jumpSound
		audioPlayer.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			anim.play("run")
		if direction > 0:
			anim.flip_h = false
		else:
			anim.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			anim.play("stand")

	# I like having the character be snapped to the pixels, at least horizontally
	velocity.x = floor(velocity.x)
	
	move_and_slide()
	
	backdrop.move_local_x(velocity.x * delta * -0.25)
	backdrop.move_local_y(velocity.y * delta * -0.25)
