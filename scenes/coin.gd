class_name CoinPickup
extends Area2D

signal collected(value: int)
@export var value: int = 1
var available: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not available or not body.is_in_group("player"):
		return
	available = false
	collected.emit(value)
	queue_free()
