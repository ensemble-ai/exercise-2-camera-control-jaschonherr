class_name SpeedUpPushZone
extends CameraControllerBase

@export var push_ratio:float = 0.5
@export var pushbox_top_left:Vector2 = Vector2(-6, -6)
@export var pushbox_bottom_right:Vector2 = Vector2(6, 6)
@export var speedup_zone_top_left:Vector2 = Vector2(-3, -3)
@export var speedup_zone_bottom_right:Vector2 = Vector2(3, 3)

func _ready() -> void:
	super()
	position = target.position


func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
		
	var tpos:Vector3 = target.global_position
	var cpos:Vector3 = global_position
	#inner box edges
	var i_left_edge:float = cpos.x + speedup_zone_top_left.x
	var i_right_edge:float = cpos.x + speedup_zone_bottom_right.x
	var i_top_edge:float = cpos.z + speedup_zone_top_left.y
	var i_bottom_edge:float = cpos.z + speedup_zone_bottom_right.y
	#differences between target edge and outer pushbox edges
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x + pushbox_top_left.x)
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + pushbox_bottom_right.x)
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z + pushbox_top_left.y)
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + pushbox_bottom_right.y)
	#camera behvaior based on location
	#corners
	if tpos.x < i_left_edge and tpos.z < i_top_edge:
		_top_left(diff_between_top_edges, diff_between_left_edges, delta)
	elif tpos.x > i_right_edge and tpos.z < i_top_edge:
		_top_right(diff_between_top_edges, diff_between_right_edges, delta)
	elif tpos.x > i_right_edge and tpos.z > i_bottom_edge:
		_bottom_right(diff_between_bottom_edges, diff_between_right_edges, delta)
	elif tpos.x < i_left_edge and tpos.z > i_bottom_edge:
		_bottom_left(diff_between_bottom_edges, diff_between_left_edges, delta)
	#not in a corner
	elif tpos.x < i_left_edge:
		_left(diff_between_left_edges, delta)
	elif tpos.x > i_right_edge:
		_right(diff_between_right_edges, delta)
	elif tpos.z < i_top_edge:
		_top(diff_between_top_edges, delta)
	elif tpos.z > i_bottom_edge:
		_bottom(diff_between_bottom_edges, delta)
		
	super(delta)

	
func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_top_left.y))
	
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_bottom_right.y))
	
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_bottom_right.y))
	
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_top_left.y))
	
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_top_left.y))
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_bottom_right.y))
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_bottom_right.y))
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_top_left.y))
	
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
	
#called when vessel is in the top left corner
func _top_left(diff_between_top_edges:float, diff_between_left_edges:float, delta:float):
	#touching left edge, move at target speed in x dir
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges
	#not touching left edge, move at push ratio * target speed in x dir
	else:
		global_position.x += target.velocity.x * delta * push_ratio		
	#touching top edge, move at target speed in z dir
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges
	#not touching top edge, move at push ratio * target speed in z dir
	else:
		global_position.z += target.velocity.z * delta * push_ratio
		

func _top_right(diff_between_top_edges:float, diff_between_right_edges:float, delta:float):
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges
	else:
		global_position.x += target.velocity.x * delta * push_ratio
		
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges
	else:
		global_position.z += target.velocity.z * delta * push_ratio
		

func _bottom_left(diff_between_bottom_edges:float, diff_between_left_edges:float, delta:float):
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges
	else:
		global_position.x += target.velocity.x * delta * push_ratio
		
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges
	else:
		global_position.z += target.velocity.z * delta * push_ratio
		
		
func _bottom_right(diff_between_bottom_edges:float, diff_between_right_edges:float, delta:float):
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges
	else:
		global_position.x += target.velocity.x * delta * push_ratio
		
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges
	else:
		global_position.z += target.velocity.z * delta * push_ratio	
		
		
func _left(diff_between_left_edges:float, delta:float):
	#touching left edge, move at target speed in x dir
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges
	#only move in x dir when not touching edge if moving towards edge
	elif target.velocity.x < 0:
		global_position.x += target.velocity.x * delta * push_ratio
	#always move at push ratio * target speed in z
	global_position.z += target.velocity.z * delta * push_ratio
	

func _right(diff_between_right_edges:float, delta:float):
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges
	elif target.velocity.x > 0:
		global_position.x += target.velocity.x * delta * push_ratio
	global_position.z += target.velocity.z * delta * push_ratio
	
	
func _top(diff_between_top_edges:float, delta:float):
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges
	elif target.velocity.z < 0:
		global_position.z += target.velocity.z * delta * push_ratio
	global_position.x += target.velocity.x * delta * push_ratio
	
	
func _bottom(diff_between_bottom_edges:float, delta:float):
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges
	elif target.velocity.z > 0:
		global_position.z += target.velocity.z * delta * push_ratio	
	global_position.x += target.velocity.x * delta * push_ratio
