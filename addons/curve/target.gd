tool
extends Path2D

export (Color) var pathColour = Color.yellow setget set_color
export (float) var width = 1.0 setget set_width

export (Vector2) var _in:Vector2 = Vector2(0, 0) setget _set_in
export (Vector2) var _out:Vector2 = Vector2(0, 0) setget _set_out

export (NodePath) var path_start setget _set_path_start
export (NodePath) var path_end setget _set_path_end

var node_start setget set_start
var node_end setget set_end
var position_start:Vector2
var position_end:Vector2

var node_start_buff
var node_end_buff

func _enter_tree():
    set_process(false)
    curve.clear_points()
    
# histoire de pas avoir d'erreur quand on lance le jeux
func _ready():
    if has_node(path_start):
        set_start(get_node(path_start))
    if has_node(path_end):
        set_end(get_node(path_end))


func _draw():
    if curve.get_point_count() > 1:
        draw_polyline(curve.get_baked_points(), pathColour, width)

func set_color(value):
    pathColour = value
    update()

func set_width(value):
    width = value
    update()

func _set_in(value):
    _in = value
    update()

func _set_out(value):
    _out = value
    update()
    
func _set_path_start(path):
    path_start = path
    if has_node(path):
        set_start(get_node(path))
    
func _set_path_end(path):
    path_end = path
    if has_node(path):
        set_end(get_node(path))

func set_start(value):
    curve.clear_points()
    if value != null:
        node_start = value
        position_start = node_start.position
        node_start_buff = node_start.global_position
        curve.add_point(position_start)

func set_end(value):
    if value != null:
        node_end = value
        position_end = node_end.global_position - node_start.global_position + node_end.position
        node_end_buff = node_end.global_position
        curve.add_point(position_end, _in, _out)
    
func _process(delta):
    if node_end && node_start:
        if node_end_buff != node_end.global_position || node_start_buff != node_start.global_position:
            set_start(node_start)
            set_end(node_end)
        if curve.get_point_count() > 1:
            if position_start.x < position_end.x:
                _in.x = -(int(position_end.x) - int(position_start.x)) / 2
        #        _in.y = (int(end.y) - int(start.y))
                curve.set_point_in(1, _in)
        #        curve.set_point_out(1, _out)
            elif position_start.x > position_end.x:
                _in.x = (int(position_start.x) - int(position_end.x)) / 2
        #        _in.y = (int(end.y) - int(start.y))
                curve.set_point_in(1, _in)
            if position_start.y < position_end.y:
                _in.y = -(int(position_end.y) - int(position_start.y)) * 2 - 250 + (int(position_end.y) - int(position_start.y))
        #        _in.y = -150
                curve.set_point_in(1, _in)
            elif position_start.y > position_end.y:
        #        _in.x = -(int(end.x) - int(start.x)) / 2
                _in.y = -250
                curve.set_point_in(1, _in)
            update()
