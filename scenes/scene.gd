extends Node2D

var score: int = 0
var total: int = 0

@onready var score_label: Label = $"HUD/Score Label"
@onready var audio_player: AudioStreamPlayer2D = $"CoinSoundPlayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in $Coins.get_children():
		var coin := child as CoinPickup
		if coin:
			total += 1
			coin.collected.connect(_on_coin_collected)
	score_label.text = "Coins: 0/" + str(total)


func _on_coin_collected(value: int) -> void:
	audio_player.play()
	score += value
	score_label.text = "Coins: " + str(score) + "/" + str(total)
