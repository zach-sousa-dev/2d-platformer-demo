class_name Field
extends Area2D

signal update_gravity_direction(direction: Vector2)
signal add_num_fields(num: int)
@onready var player = $"/root/Scene/Player"
var in_pull := false

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_pull:
		var direction: Vector2 = player.position.direction_to(global_position)
		update_gravity_direction.emit(direction)
		#print(str(direction))
	
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"): return # exit early if not player
	add_num_fields.emit(1)
	in_pull = true

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"): return # exit early if not player
	add_num_fields.emit(-1)
	in_pull = false
