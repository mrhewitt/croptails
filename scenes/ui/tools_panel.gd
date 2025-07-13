extends PanelContainer


func _ready() -> void:
	ToolManager.enable_tool.connect(on_enable_tool_button)
	
	%ToolTilling.disabled = true
	%ToolTilling.focus_mode = Control.FOCUS_NONE
	
	%ToolWateringCan.disabled = true
	%ToolWateringCan.focus_mode = Control.FOCUS_NONE
	
	%ToolTomato.disabled = true
	%ToolTomato.focus_mode = Control.FOCUS_NONE
	
	%ToolCorn.disabled = true
	%ToolCorn.focus_mode = Control.FOCUS_NONE


func _on_tool_axe_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.AxeWood)


func _on_tool_tilling_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.TillGround)


func _on_tool_watering_can_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.WaterCrops)


func _on_tool_corn_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.PlantCorn)


func _on_tool_tomato_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.PlantTomato)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			ToolManager.select_tool(DataTypes.Tools.None)
			%ToolAxe.release_focus()
			%ToolTilling.release_focus()
			%ToolWateringCan.release_focus()
			%ToolCorn.release_focus()
			%ToolTomato.release_focus()


func on_enable_tool_button(tool: DataTypes.Tools) -> void:
	if tool == DataTypes.Tools.TillGround:
		%ToolTilling.disabled = false
		%ToolTilling.focus_mode = Control.FOCUS_ALL
	
	if tool == DataTypes.Tools.WaterCrops:
		%ToolWateringCan.disabled = false
		%ToolWateringCan.focus_mode = Control.FOCUS_ALL
	
	if tool == DataTypes.Tools.PlantTomato:
		%ToolTomato.disabled = false
		%ToolTomato.focus_mode = Control.FOCUS_ALL
	
	if tool == DataTypes.Tools.PlantCorn:
		%ToolCorn.disabled = false
		%ToolCorn.focus_mode = Control.FOCUS_ALL
