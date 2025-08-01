extends Node2D

const GAME_DIALOGUE_BALLOON = preload("res://dialogue/game_dialogue_balloon.tscn")
const CORN_HARVEST = preload("res://scenes/objects/plants/corn_harvest.tscn")
const TOMATO_HARVEST = preload("res://scenes/objects/plants/tomato_harvest.tscn")

@export var dialogue_start_command: String
@export var food_drop_height: int = 40
@export var reward_output_radius: int = 20
@export var output_reward_scenes: Array[PackedScene] = []

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var reward_marker: Marker2D = $RewardMarker
@onready var interactable_label_component: Control = $InteractableLabelComponent
@onready var feed_component: FeedComponent = $FeedComponent

var in_range: bool = false
var is_chest_open: bool = false


func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	on_interactable_deactivated()
	
	GameDialogueManager.feel_the_animals.connect(on_feed_the_aniamls)
	
	feed_component.food_receive.connect(on_food_receive)
	
	
func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true	
			
	
func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
	in_range = false
	if is_chest_open:
		animated_sprite_2d.play("chest_close")
		is_chest_open = false


func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("show_dialogue"):
			animated_sprite_2d.play("chest_open")
			is_chest_open = true
			
			# create some dialogue 
			var balloon: BaseGameDialogueBalloon = GAME_DIALOGUE_BALLOON.instantiate()
			get_tree().root.add_child(balloon)
			balloon.start(load("res://dialogue/conversations/chest.dialogue"), dialogue_start_command)


func on_feed_the_aniamls() -> void:
	if in_range:
		trigger_feed_harvest("corn", CORN_HARVEST)
		trigger_feed_harvest("tomato", TOMATO_HARVEST)


func trigger_feed_harvest(inventory_item: String, scene: Resource) -> void:
	var inventory: Dictionary = InventoryManager.inventory
	
	if !inventory.has(inventory_item):
		return
		
	var inventory_item_count = inventory[inventory_item]
	
	for i in inventory_item_count:
		var harvest_instance = scene.instantiate() as Node2D
		harvest_instance.global_position = Vector2(global_position.x, global_position.y - food_drop_height)
		get_tree().root.add_child(harvest_instance)
		var target_position = global_position
		
		var time_delay = 0.2
		await get_tree().create_timer(time_delay).timeout
		
		var tween = get_tree().create_tween()
		tween.tween_property(harvest_instance, "position", target_position, 1)
		tween.tween_property(harvest_instance, "scale", Vector2(0.5,0.5), 1)
		tween.tween_callback(harvest_instance.queue_free)
		
		InventoryManager.remove_collectable(inventory_item)


func on_food_receive(area: Area2D) -> void:
	call_deferred("add_reward_scene")
	

func add_reward_scene() -> void:
	for scene in output_reward_scenes:
		var reward_scene: Node2D = scene.instantiate()
		var reward_position: Vector2i = get_random_position_in_circle(reward_marker.global_position, reward_output_radius)
		reward_scene.global_position = reward_position
		get_tree().root.add_child(reward_scene)


func get_random_position_in_circle(center: Vector2, radius: int) -> Vector2i:
	var angle = randf() * TAU
	var distance_from_center = radius
	
	var x: int = center.x + distance_from_center * cos(angle)
	var y: int = center.y + distance_from_center * sin(angle)
	
	return Vector2i(x,y)
