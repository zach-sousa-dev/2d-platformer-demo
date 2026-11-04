# This script handles destroying the coin when in contact with the player,
# and emitting a signal (recieved by scene.gd) that it was collected.

class_name CoinPickup
extends Area2D

signal collected(value: int)
@export var value: int = 1
var available: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

# Called when the player touches the coin.
func _on_body_entered(body: Node2D) -> void:
	if not available or not body.is_in_group("player"):
		return
	available = false
	collected.emit(value)
	queue_free()
