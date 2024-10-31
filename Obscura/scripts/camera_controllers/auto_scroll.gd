class_name AutoScroll
extends CameraControllerBase


@export var top_left:Vector2 = Vector2(-5, -5)
@export var bottom_right:Vector2 = Vector2(5, 5)
@export var autoscroll_speed:Vector3 = Vector3(0.1, 0, 0)


func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	global_position += autoscroll_speed
	target.global_position += autoscroll_speed

	var tpos:Vector3 = target.global_position
	var cpos:Vector3 = global_position

	var left_edge:float = cpos.x + top_left.x
	var right_edge:float = cpos.x + bottom_right.x
	var top_edge:float = cpos.z + top_left.y
	var bottom_edge:float = cpos.z + bottom_right.y
	
	#outer push box
	#left
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - left_edge
	if diff_between_left_edges < 0:
		target.global_position.x = left_edge + target.WIDTH / 2.0
	#right
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - right_edge
	if diff_between_right_edges > 0:
		target.global_position.x = right_edge - target.WIDTH / 2.0
	#top
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - top_edge
	if diff_between_top_edges < 0:
		target.global_position.z = top_edge + target.HEIGHT / 2.0
	#bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - bottom_edge
	if diff_between_bottom_edges > 0:
		target.global_position.z = bottom_edge - target.HEIGHT / 2.0

	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	immediate_mesh.surface_add_vertex(Vector3(top_left.x, 0, top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(bottom_right.x, 0, top_left.y))
	
	immediate_mesh.surface_add_vertex(Vector3(bottom_right.x, 0, top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(bottom_right.x, 0, bottom_right.y))
	
	immediate_mesh.surface_add_vertex(Vector3(bottom_right.x, 0, bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(top_left.x, 0, bottom_right.y))
	
	immediate_mesh.surface_add_vertex(Vector3(top_left.x, 0, bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(top_left.x, 0, top_left.y))
	
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
