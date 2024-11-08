extends Node2D
class_name LifeUp

export var collectible_name := "life_up_0"
var timer := 0.0
var last_time_increased := 0.0
var amount_to_increase := 2
var executing := false

func _ready() -> void:
	Event.listen("player_set",self,"call_deferred_already_got")

func call_deferred_already_got() -> void:
	call_deferred("handle_already_got")

func handle_already_got() -> void:
	if collectible_name in GameManager.collectibles:
		queue_free()
	
func _physics_process(delta: float) -> void:
	process_increase_health(delta)

func process_increase_health(delta) -> void:
	if timer > 0:
		timer += delta
		if timer > 1.5:
			increase_health()
	if amount_to_increase == 0:
		timer = 0
		GameManager.unpause(name)
		amount_to_increase = -1
	if amount_to_increase < 0:
		if not $audioStreamPlayer2D.playing:
			queue_free()

func increase_health():
	if timer > last_time_increased + 0.06 and amount_to_increase > 0:
		GameManager.player.max_health += 1
		GameManager.player.recover_health(1)
		last_time_increased = timer
		amount_to_increase -= 1
		$audioStreamPlayer2D.play()

func _on_area2D_body_entered(body: Node) -> void:
	if not executing:
		if body.is_in_group("Player"):
			GameManager.pause(name)
			timer = 0.01
			$audioStreamPlayer2D2.play()
			executing = true
			visible = false
			GameManager.add_collectible_to_savedata(collectible_name)
			achievement_check()

func achievement_check() -> void:
	print("Achievements: checking hearts...")
	var hearts = 0
	for collectible in GameManager.collectibles:
		if "life_up" in collectible:
			hearts += 1
	
	if hearts == 8:
		Achievements.unlock("COLLECTALLHEARTS")
	else:
		Savefile.save()
