class_name PositionLockLerp
extends CameraControllerBase

@export var follow_speed:float = target.BASE_SPEED * 0.5
@export var catchup_speed:float = target.BASE_SPEED * 0.8
@export var leash_distance:float = 7


func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var cpos_vec2:Vector2 = Vector2(global_position.x, global_position.z)
	var tpos_vec2:Vector2 = Vector2(target.global_position.x, target.global_position.z)
	var dist:float = cpos_vec2.distance_to(tpos_vec2)
	var x_diff = target.global_position.x - global_position.x
	var z_diff = target.global_position.z - global_position.z
		
	if dist != 0:
		if target.velocity != Vector3(0, 0, 0):
			if dist < leash_distance:
				global_position += follow_speed * Vector3(x_diff / dist, 0, z_diff / dist) * delta
			else:
				global_position += target.BASE_SPEED * Vector3(x_diff / dist, 0, z_diff / dist) * delta
		else:
			global_position += catchup_speed * Vector3(x_diff / dist, 0, z_diff / dist) * delta
	
	if dist < 0.5 && target.velocity == Vector3(0, 0, 0):
		global_position = target.global_position
	
	super(delta)
	
func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	immediate_mesh.surface_add_vertex(Vector3(2.5, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(-2.5, 0, 0))
	
	immediate_mesh.surface_add_vertex(Vector3(0, 0, 2.5))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -2.5))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
