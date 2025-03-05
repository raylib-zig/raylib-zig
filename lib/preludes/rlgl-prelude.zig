// raylib-zig (c) Nikolas Wipper 2024

const rl = @import("raylib.zig");
const std = @import("std");

pub const cdef = @import("rlgl-ext.zig");

test {
    std.testing.refAllDeclsRecursive(@This());
}

const Matrix = rl.Matrix;

pub const rlVertexBuffer = extern struct {
    elementCount: c_int,
    vertices: [*c]f32,
    texcoords: [*c]f32,
    normals: [*c]f32,
    colors: [*c]u8,
    indices: [*c]c_ushort,
    vaoId: c_uint,
    vboId: [5]c_uint,
};

pub const rlDrawCall = extern struct {
    mode: c_int,
    vertexCount: c_int,
    vertexAlignment: c_int,
    textureId: c_uint,
};

pub const rlRenderBatch = extern struct {
    bufferCount: c_int,
    currentBuffer: c_int,
    vertexBuffer: [*c]rlVertexBuffer,
    draws: [*c]rlDrawCall,
    drawCounter: c_int,
    currentDepth: f32,
};

pub const rlGlVersion = enum(c_int) {
    rl_opengl_11 = 1,
    rl_opengl_21 = 2,
    rl_opengl_33 = 3,
    rl_opengl_43 = 4,
    rl_opengl_es_20 = 5,
    rl_opengl_es_30 = 6,
};

pub const rlTraceLogLevel = enum(c_int) {
    rl_log_all = 0,
    rl_log_trace = 1,
    rl_log_debug = 2,
    rl_log_info = 3,
    rl_log_warning = 4,
    rl_log_error = 5,
    rl_log_fatal = 6,
    rl_log_none = 7,
};

pub const rlPixelFormat = enum(c_int) {
    rl_pixelformat_uncompressed_grayscale = 1,
    rl_pixelformat_uncompressed_gray_alpha = 2,
    rl_pixelformat_uncompressed_r5g6b5 = 3,
    rl_pixelformat_uncompressed_r8g8b8 = 4,
    rl_pixelformat_uncompressed_r5g5b5a1 = 5,
    rl_pixelformat_uncompressed_r4g4b4a4 = 6,
    rl_pixelformat_uncompressed_r8g8b8a8 = 7,
    rl_pixelformat_uncompressed_r32 = 8,
    rl_pixelformat_uncompressed_r32g32b32 = 9,
    rl_pixelformat_uncompressed_r32g32b32a32 = 10,
    rl_pixelformat_uncompressed_r16 = 11,
    rl_pixelformat_uncompressed_r16g16b16 = 12,
    rl_pixelformat_uncompressed_r16g16b16a16 = 13,
    rl_pixelformat_compressed_dxt1_rgb = 14,
    rl_pixelformat_compressed_dxt1_rgba = 15,
    rl_pixelformat_compressed_dxt3_rgba = 16,
    rl_pixelformat_compressed_dxt5_rgba = 17,
    rl_pixelformat_compressed_etc1_rgb = 18,
    rl_pixelformat_compressed_etc2_rgb = 19,
    rl_pixelformat_compressed_etc2_eac_rgba = 20,
    rl_pixelformat_compressed_pvrt_rgb = 21,
    rl_pixelformat_compressed_pvrt_rgba = 22,
    rl_pixelformat_compressed_astc_4x4_rgba = 23,
    rl_pixelformat_compressed_astc_8x8_rgba = 24,
};

pub const rlTextureFilter = enum(c_int) {
    rl_texture_filter_point = 0,
    rl_texture_filter_bilinear = 1,
    rl_texture_filter_trilinear = 2,
    rl_texture_filter_anisotropic_4x = 3,
    rl_texture_filter_anisotropic_8x = 4,
    rl_texture_filter_anisotropic_16x = 5,
};

pub const rlBlendMode = enum(c_int) {
    rl_blend_alpha = 0,
    rl_blend_additive = 1,
    rl_blend_multiplied = 2,
    rl_blend_add_colors = 3,
    rl_blend_subtract_colors = 4,
    rl_blend_alpha_premultiply = 5,
    rl_blend_custom = 6,
    rl_blend_custom_separate = 7,
};

pub const rlShaderLocationIndex = enum(c_uint) {
    rl_shader_loc_vertex_position = 0,
    rl_shader_loc_vertex_texcoord01 = 1,
    rl_shader_loc_vertex_texcoord02 = 2,
    rl_shader_loc_vertex_normal = 3,
    rl_shader_loc_vertex_tangent = 4,
    rl_shader_loc_vertex_color = 5,
    rl_shader_loc_matrix_mvp = 6,
    rl_shader_loc_matrix_view = 7,
    rl_shader_loc_matrix_projection = 8,
    rl_shader_loc_matrix_model = 9,
    rl_shader_loc_matrix_normal = 10,
    rl_shader_loc_vector_view = 11,
    rl_shader_loc_color_diffuse = 12,
    rl_shader_loc_color_specular = 13,
    rl_shader_loc_color_ambient = 14,
    rl_shader_loc_map_albedo = 15,
    rl_shader_loc_map_metalness = 16,
    rl_shader_loc_map_normal = 17,
    rl_shader_loc_map_roughness = 18,
    rl_shader_loc_map_occlusion = 19,
    rl_shader_loc_map_emission = 20,
    rl_shader_loc_map_height = 21,
    rl_shader_loc_map_cubemap = 22,
    rl_shader_loc_map_irradiance = 23,
    rl_shader_loc_map_prefilter = 24,
    rl_shader_loc_map_brdf = 25,
};

pub const rlShaderUniformDataType = enum(c_uint) {
    rl_shader_uniform_float = 0,
    rl_shader_uniform_vec2 = 1,
    rl_shader_uniform_vec3 = 2,
    rl_shader_uniform_vec4 = 3,
    rl_shader_uniform_int = 4,
    rl_shader_uniform_ivec2 = 5,
    rl_shader_uniform_ivec3 = 6,
    rl_shader_uniform_ivec4 = 7,
    rl_shader_uniform_uint = 8,
    rl_shader_uniform_uivec2 = 9,
    rl_shader_uniform_uivec3 = 10,
    rl_shader_uniform_uivec4 = 11,
    rl_shader_uniform_sampler2d = 12,
};

pub const rlShaderAttributeDataType = enum(c_uint) {
    rl_shader_attrib_float = 0,
    rl_shader_attrib_vec2 = 1,
    rl_shader_attrib_vec3 = 2,
    rl_shader_attrib_vec4 = 3,
};

pub const rlFramebufferAttachType = enum(c_uint) {
    rl_attachment_color_channel0 = 0,
    rl_attachment_color_channel1 = 1,
    rl_attachment_color_channel2 = 2,
    rl_attachment_color_channel3 = 3,
    rl_attachment_color_channel4 = 4,
    rl_attachment_color_channel5 = 5,
    rl_attachment_color_channel6 = 6,
    rl_attachment_color_channel7 = 7,
    rl_attachment_depth = 100,
    rl_attachment_stencil = 200,
};

pub const rlFramebufferAttachTextureType = enum(c_uint) {
    rl_attachment_cubemap_positive_x = 0,
    rl_attachment_cubemap_negative_x = 1,
    rl_attachment_cubemap_positive_y = 2,
    rl_attachment_cubemap_negative_y = 3,
    rl_attachment_cubemap_positive_z = 4,
    rl_attachment_cubemap_negative_z = 5,
    rl_attachment_texture2d = 100,
    rl_attachment_renderbuffer = 200,
};

pub const rlCullMode = enum(c_uint) {
    rl_cull_face_front = 0,
    rl_cull_face_back = 1,
};

pub const rl_default_batch_buffer_elements = @as(i32, 8192);
pub const rl_default_batch_buffers = @as(i32, 1);
pub const rl_default_batch_drawcalls = @as(i32, 256);
pub const rl_default_batch_max_texture_units = @as(i32, 4);
pub const rl_max_matrix_stack_size = @as(i32, 32);
pub const rl_max_shader_locations = @as(i32, 32);
pub const rl_cull_distance_near = @as(f64, 0.01);
pub const rl_cull_distance_far = @as(f64, 1000.0);
pub const rl_texture_wrap_s = @as(i32, 0x2802);
pub const rl_texture_wrap_t = @as(i32, 0x2803);
pub const rl_texture_mag_filter = @as(i32, 0x2800);
pub const rl_texture_min_filter = @as(i32, 0x2801);
pub const rl_texture_filter_nearest = @as(i32, 0x2600);
pub const rl_texture_filter_linear = @as(i32, 0x2601);
pub const rl_texture_filter_mip_nearest = @as(i32, 0x2700);
pub const rl_texture_filter_nearest_mip_linear = @as(i32, 0x2702);
pub const rl_texture_filter_linear_mip_nearest = @as(i32, 0x2701);
pub const rl_texture_filter_mip_linear = @as(i32, 0x2703);
pub const rl_texture_filter_anisotropic = @as(i32, 0x3000);
pub const rl_texture_mipmap_bias_ratio = @as(i32, 0x4000);
pub const rl_texture_wrap_repeat = @as(i32, 0x2901);
pub const rl_texture_wrap_clamp = @as(i32, 0x812f);
pub const rl_texture_wrap_mirror_repeat = @as(i32, 0x8370);
pub const rl_texture_wrap_mirror_clamp = @as(i32, 0x8742);
pub const rl_modelview = @as(i32, 0x1700);
pub const rl_projection = @as(i32, 0x1701);
pub const rl_texture = @as(i32, 0x1702);
pub const rl_lines = @as(i32, 0x0001);
pub const rl_triangles = @as(i32, 0x0004);
pub const rl_quads = @as(i32, 0x0007);
pub const rl_unsigned_byte = @as(i32, 0x1401);
pub const rl_float = @as(i32, 0x1406);
pub const rl_stream_draw = @as(i32, 0x88e0);
pub const rl_stream_read = @as(i32, 0x88e1);
pub const rl_stream_copy = @as(i32, 0x88e2);
pub const rl_static_draw = @as(i32, 0x88e4);
pub const rl_static_read = @as(i32, 0x88e5);
pub const rl_static_copy = @as(i32, 0x88e6);
pub const rl_dynamic_draw = @as(i32, 0x88e8);
pub const rl_dynamic_read = @as(i32, 0x88e9);
pub const rl_dynamic_copy = @as(i32, 0x88ea);
pub const rl_fragment_shader = @as(i32, 0x8b30);
pub const rl_vertex_shader = @as(i32, 0x8b31);
pub const rl_compute_shader = @as(i32, 0x91b9);
pub const rl_zero = @as(i32, 0);
pub const rl_one = @as(i32, 1);
pub const rl_src_color = @as(i32, 0x0300);
pub const rl_one_minus_src_color = @as(i32, 0x0301);
pub const rl_src_alpha = @as(i32, 0x0302);
pub const rl_one_minus_src_alpha = @as(i32, 0x0303);
pub const rl_dst_alpha = @as(i32, 0x0304);
pub const rl_one_minus_dst_alpha = @as(i32, 0x0305);
pub const rl_dst_color = @as(i32, 0x0306);
pub const rl_one_minus_dst_color = @as(i32, 0x0307);
pub const rl_src_alpha_saturate = @as(i32, 0x0308);
pub const rl_constant_color = @as(i32, 0x8001);
pub const rl_one_minus_constant_color = @as(i32, 0x8002);
pub const rl_constant_alpha = @as(i32, 0x8003);
pub const rl_one_minus_constant_alpha = @as(i32, 0x8004);
pub const rl_func_add = @as(i32, 0x8006);
pub const rl_min = @as(i32, 0x8007);
pub const rl_max = @as(i32, 0x8008);
pub const rl_func_subtract = @as(i32, 0x800a);
pub const rl_func_reverse_subtract = @as(i32, 0x800b);
pub const rl_blend_equation = @as(i32, 0x8009);
pub const rl_blend_equation_rgb = @as(i32, 0x8009);
pub const rl_blend_equation_alpha = @as(i32, 0x883d);
pub const rl_blend_dst_rgb = @as(i32, 0x80c8);
pub const rl_blend_src_rgb = @as(i32, 0x80c9);
pub const rl_blend_dst_alpha = @as(i32, 0x80ca);
pub const rl_blend_src_alpha = @as(i32, 0x80cb);
pub const rl_blend_color = @as(i32, 0x8005);
pub const rl_read_framebuffer = @as(i32, 0x8ca8);
pub const rl_draw_framebuffer = @as(i32, 0x8ca9);
pub const rl_default_shader_attrib_location_position = @as(i32, 0);
pub const rl_default_shader_attrib_location_texcoord = @as(i32, 1);
pub const rl_default_shader_attrib_location_normal = @as(i32, 2);
pub const rl_default_shader_attrib_location_color = @as(i32, 3);
pub const rl_default_shader_attrib_location_tangent = @as(i32, 4);
pub const rl_default_shader_attrib_location_texcoord2 = @as(i32, 5);
pub const rl_default_shader_attrib_location_indices = @as(i32, 6);
pub const rl_default_shader_attrib_location_boneids = @as(i32, 7);
pub const rl_default_shader_attrib_location_boneweights = @as(i32, 5);
pub const rl_default_shader_attrib_location_instance_tx = @as(i32, 9);
