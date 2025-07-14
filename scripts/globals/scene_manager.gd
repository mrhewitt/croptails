extends Node

const MAIN_SCENE_ROOT_PATH = "/root/MainScene"

var main_scene_path: String =  "res://scenes/main_scene.tscn"
var main_scene_level_root_path: String = "/root/MainScene/GameRoot/LevelRoot"

var levels_scenes: Dictionary = {
	"level1": "res://scenes/levels/level_1.tscn"
} 


func load_main_scene_container() -> void:
	# remove existing game is one if running as user requested to start new
	var main_scene = get_node(MAIN_SCENE_ROOT_PATH)
	if main_scene != null:
		# remove scene from tree to ensure its added with correct name (not generated one as happens
		# when two nodes of same name are added to a scene)
		# queue_free only happens when frame is processes thus just queue_free
		# would leave MainScene in tree still when rest of loading code processses   
		get_tree().root.remove_child(main_scene)
		main_scene.queue_free()
		
	var node: Node = load(main_scene_path).instantiate()
	if node != null:
		get_tree().root.add_child(node)


func load_level(level: String) -> void:
	var scene_path: String = levels_scenes[level]
	if scene_path == null:
		return
		
	var level_scene: Node = load(scene_path).instantiate()
	var level_root: Node = get_node(main_scene_level_root_path)	
	
	if level_root != null:
		var nodes = level_root.get_children()
			
		if nodes != null:
			for node:Node in nodes:
				node.queue_free()
				
		await get_tree().process_frame
	
		level_root.add_child(level_scene)		
