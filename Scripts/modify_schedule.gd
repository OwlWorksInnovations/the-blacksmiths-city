extends Control

@onready var npc_dropdown: OptionButton = $VBoxContainer/NPCDropdown
@onready var hour_input: LineEdit = $VBoxContainer/HBoxContainer/HourInput
@onready var location_input: LineEdit = $VBoxContainer/HBoxContainer/LocationInput
@onready var entry_list: ItemList = $VBoxContainer/ScrollContainer/EntryList

var current_schedule: NPCSchedule
var listed_npcs: Array[Node] = []

func _ready() -> void:
	populate_npc_dropdown()
	_on_npc_dropdown_item_selected(npc_dropdown.selected)

func populate_npc_dropdown() -> void:
	npc_dropdown.clear()
	listed_npcs = get_tree().get_nodes_in_group("NPC")
	
	if listed_npcs.is_empty():
		npc_dropdown.add_item("No NPCs found")
		npc_dropdown.disabled = true
		return
		
	npc_dropdown.disabled = false
	for npc in listed_npcs:
		var npc_name: String = npc.get("character_name") if "character_name" in npc else npc.name
		npc_dropdown.add_item(npc_name)

func _on_npc_dropdown_item_selected(index: int) -> void:
	if index < 0 or index >= listed_npcs.size():
		return
		
	var target_npc = listed_npcs[index]
	
	if is_instance_valid(target_npc) and "schedule" in target_npc:
		if target_npc.schedule != null:
			current_schedule = target_npc.schedule
		else:
			current_schedule = NPCSchedule.new()
			
		_refresh_entry_list_ui()

func _on_add_entry_pressed() -> void:
	var hour_val: float = hour_input.text.to_float()
	var loc_val: String = location_input.text.strip_edges()
	
	if loc_val.is_empty():
		return
		
	var new_entry := ScheduleEntry.new()
	new_entry.start_hour = hour_val
	new_entry.location_group = loc_val
	
	current_schedule.entries.append(new_entry)
	_refresh_entry_list_ui()
	
	hour_input.clear()
	location_input.clear()

func _on_entry_list_item_activated(index: int) -> void:
	if current_schedule and index < current_schedule.entries.size():
		current_schedule.entries.remove_at(index)
		_refresh_entry_list_ui()

func _refresh_entry_list_ui() -> void:
	entry_list.clear()
	if current_schedule == null:
		return
		
	for entry in current_schedule.entries:
		entry_list.add_item("%.2f -> %s" % [entry.start_hour, entry.location_group])

func _on_assign_to_npc_button_pressed() -> void:
	var selected_idx: int = npc_dropdown.selected
	if selected_idx < 0 or selected_idx >= listed_npcs.size():
		return
		
	var target_npc = listed_npcs[selected_idx]
	
	if is_instance_valid(target_npc) and "schedule" in target_npc:
		target_npc.schedule = current_schedule
		
		if target_npc.has_method("set_time"):
			target_npc.set_time(target_npc.current_time)
			
		print("Schedule updated for ", target_npc.name)
