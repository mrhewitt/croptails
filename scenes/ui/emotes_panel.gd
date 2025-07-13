extends Panel

@onready var animated_sprite_2d: AnimatedSprite2D = $Emote/AnimatedSprite2D
@onready var emote_idle_timer: Timer = $Emote/EmoteIdleTimer

var idle_emotes: Array = ["emote_1_idle","emote_2_blink","emote_3_ear_wave","emote_4_blink"]


func _ready() -> void:
	play_emote(idle_emotes[0])
	

func play_emote(animation: String) -> void:
	animated_sprite_2d.play(animation)


func play_talking_animation() -> void:
	play_emote("emote_12_talking")


func _on_emote_idle_timer_timeout() -> void:
	var index = randi_range(0,idle_emotes.size()-1)
	play_emote( idle_emotes[index] )
	
