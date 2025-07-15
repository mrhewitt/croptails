extends Panel

@onready var animated_sprite_2d: AnimatedSprite2D = $Emote/AnimatedSprite2D
@onready var emote_idle_timer: Timer = $Emote/EmoteIdleTimer

var idle_emotes: Array = ["emote_1_idle","emote_2_blink","emote_3_ear_wave","emote_4_blink"]


func _ready() -> void:
	play_emote(idle_emotes[0])
	InventoryManager.inventory_updated.connect(on_inventory_changed)
	GameDialogueManager.feel_the_animals.connect(on_feed_animals)


func play_emote(animation: String) -> void:
	animated_sprite_2d.play(animation)


func play_talking_animation(character: String) -> void:
	var talking_animation: String = character.to_lower() + "_talking" 
	if animated_sprite_2d.sprite_frames.has_animation(talking_animation):
		play_emote(talking_animation)
	else:
		play_emote("emote_12_talking")


func _on_emote_idle_timer_timeout() -> void:
	var index = randi_range(0,idle_emotes.size()-1)
	play_emote( idle_emotes[index] )
	
	
func on_inventory_changed(collectable_name: String, collectable_count: int) -> void:
	play_emote("emote_7_excited")	
	
	
func on_feed_animals() -> void:
	play_emote("emote_6_love_kiss")	
	
	
