tool
extends EditorPlugin

func _enter_tree() -> void:
    add_custom_type("Target", "Path2D", preload("target.gd"), preload("./target.svg"))
    
func _exit_tree() -> void:
    remove_custom_type("Target")
