extends Node
class_name InventoryComponent

@export var item_database: ItemDatabase

var items: Array[Dictionary] = [] # [{id:String, quantity:int}]

# --- ADICIONAR ITEM RESPEITANDO STACK ---
func add_item(id: String, quantity: int = 1) -> void:
	var item_info = item_database.get_item(id)
	if not item_info:
		return

	for i in items:
		if i.id == id and i.quantity < item_info.max_stack:
			var can_add = min(quantity, item_info.max_stack - i.quantity)
			i.quantity += can_add
			quantity -= can_add
			if quantity <= 0:
				return
	if quantity > 0:
		items.append({"id": id, "quantity": quantity})

# --- REMOVER ITEM ---
func remove_item(id: String, amount: int = 1) -> void:
	for i in items:
		if i.id == id:
			i.quantity = i.quantity - amount
			if i.quantity <= 0:
				items.erase(i)
			return

# --- MOVER / TROCAR ITENS ---
func move_item(from_index: int, to_index: int) -> void:
	if from_index < 0 or from_index >= items.size():
		return
	if to_index < 0 or to_index >= items.size():
		return
	items.insert(to_index, items.pop_at(from_index))

func swap_items(index_a: int, index_b: int) -> void:
	if index_a < items.size() and index_b < items.size():
		var temp = items[index_a]
		items[index_a] = items[index_b]
		items[index_b] = temp

# --- DIVIDIR STACK ---
func split_stack(slot_index: int, amount: int) -> void:
	if slot_index >= items.size():
		return
	var slot = items[slot_index]
	if amount <= 0 or amount >= slot.quantity:
		return
	slot.quantity -= amount
	items.append({"id": slot.id, "quantity": amount})

# --- CONSULTA ---
func has_item(id: String, quantity: int = 1) -> bool:
	return get_quantity(id) >= quantity

func get_quantity(id: String) -> int:
	var total = 0
	for i in items:
		if i.id == id:
			total += i.quantity
	return total

# --- Organização ---
func compact() -> void:
	var compacted: Array = []
	for i in items:
		var added = false
		for c in compacted:
			if c.id == i.id:
				c.quantity += i.quantity
				added = true
				break
		if not added:
			compacted.append(i.duplicate())
	items = compacted

func get_all_items():
	return items
