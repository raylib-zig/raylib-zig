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
    rl_opengl_11_software = 0,
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
pub const rl_cull_distance_near = @as(f64, 0.05);
pub const rl_cull_distance_far = @as(f64, 4000.0);
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

/// Choose the current matrix to be transformed
pub fn rlMatrixMode(mode: i32) void {
    cdef.rlMatrixMode(@as(c_int, mode));
}

/// Push the current matrix to stack
pub fn rlPushMatrix() void {
    cdef.rlPushMatrix();
}

/// Pop latest inserted matrix from stack
pub fn rlPopMatrix() void {
    cdef.rlPopMatrix();
}

/// Reset current matrix to identity matrix
pub fn rlLoadIdentity() void {
    cdef.rlLoadIdentity();
}

/// Multiply the current matrix by a translation matrix
pub fn rlTranslatef(x: f32, y: f32, z: f32) void {
    cdef.rlTranslatef(x, y, z);
}

/// Multiply the current matrix by a rotation matrix
pub fn rlRotatef(angle: f32, x: f32, y: f32, z: f32) void {
    cdef.rlRotatef(angle, x, y, z);
}

/// Multiply the current matrix by a scaling matrix
pub fn rlScalef(x: f32, y: f32, z: f32) void {
    cdef.rlScalef(x, y, z);
}

/// Multiply the current matrix by another matrix
pub fn rlMultMatrixf(matf: []const f32) void {
    cdef.rlMultMatrixf(@as([*c]const f32, @ptrCast(matf)));
}

pub fn rlFrustum(left: f64, right: f64, bottom: f64, top: f64, znear: f64, zfar: f64) void {
    cdef.rlFrustum(left, right, bottom, top, znear, zfar);
}

pub fn rlOrtho(left: f64, right: f64, bottom: f64, top: f64, znear: f64, zfar: f64) void {
    cdef.rlOrtho(left, right, bottom, top, znear, zfar);
}

/// Set the viewport area
pub fn rlViewport(x: i32, y: i32, width: i32, height: i32) void {
    cdef.rlViewport(@as(c_int, x), @as(c_int, y), @as(c_int, width), @as(c_int, height));
}

/// Set clip planes distances
pub fn rlSetClipPlanes(nearPlane: f64, farPlane: f64) void {
    cdef.rlSetClipPlanes(nearPlane, farPlane);
}

/// Get cull plane distance near
pub fn rlGetCullDistanceNear() f64 {
    return cdef.rlGetCullDistanceNear();
}

/// Get cull plane distance far
pub fn rlGetCullDistanceFar() f64 {
    return cdef.rlGetCullDistanceFar();
}

/// Initialize drawing mode (how to organize vertex)
pub fn rlBegin(mode: i32) void {
    cdef.rlBegin(@as(c_int, mode));
}

/// Finish vertex providing
pub fn rlEnd() void {
    cdef.rlEnd();
}

/// Define one vertex (position) - 2 int
pub fn rlVertex2i(x: i32, y: i32) void {
    cdef.rlVertex2i(@as(c_int, x), @as(c_int, y));
}

/// Define one vertex (position) - 2 float
pub fn rlVertex2f(x: f32, y: f32) void {
    cdef.rlVertex2f(x, y);
}

/// Define one vertex (position) - 3 float
pub fn rlVertex3f(x: f32, y: f32, z: f32) void {
    cdef.rlVertex3f(x, y, z);
}

/// Define one vertex (texture coordinate) - 2 float
pub fn rlTexCoord2f(x: f32, y: f32) void {
    cdef.rlTexCoord2f(x, y);
}

/// Define one vertex (normal) - 3 float
pub fn rlNormal3f(x: f32, y: f32, z: f32) void {
    cdef.rlNormal3f(x, y, z);
}

/// Define one vertex (color) - 4 byte
pub fn rlColor4ub(r: u8, g: u8, b: u8, a: u8) void {
    cdef.rlColor4ub(r, g, b, a);
}

/// Define one vertex (color) - 3 float
pub fn rlColor3f(x: f32, y: f32, z: f32) void {
    cdef.rlColor3f(x, y, z);
}

/// Define one vertex (color) - 4 float
pub fn rlColor4f(x: f32, y: f32, z: f32, w: f32) void {
    cdef.rlColor4f(x, y, z, w);
}

/// Enable vertex array (VAO, if supported)
pub fn rlEnableVertexArray(vaoId: u32) bool {
    return cdef.rlEnableVertexArray(@as(c_uint, vaoId));
}

/// Disable vertex array (VAO, if supported)
pub fn rlDisableVertexArray() void {
    cdef.rlDisableVertexArray();
}

/// Enable vertex buffer (VBO)
pub fn rlEnableVertexBuffer(id: u32) void {
    cdef.rlEnableVertexBuffer(@as(c_uint, id));
}

/// Disable vertex buffer (VBO)
pub fn rlDisableVertexBuffer() void {
    cdef.rlDisableVertexBuffer();
}

/// Enable vertex buffer element (VBO element)
pub fn rlEnableVertexBufferElement(id: u32) void {
    cdef.rlEnableVertexBufferElement(@as(c_uint, id));
}

/// Disable vertex buffer element (VBO element)
pub fn rlDisableVertexBufferElement() void {
    cdef.rlDisableVertexBufferElement();
}

/// Enable vertex attribute index
pub fn rlEnableVertexAttribute(index: u32) void {
    cdef.rlEnableVertexAttribute(@as(c_uint, index));
}

/// Disable vertex attribute index
pub fn rlDisableVertexAttribute(index: u32) void {
    cdef.rlDisableVertexAttribute(@as(c_uint, index));
}

/// Enable attribute state pointer
pub fn rlEnableStatePointer(vertexAttribType: i32, buffer: ?*anyopaque) void {
    cdef.rlEnableStatePointer(@as(c_int, vertexAttribType), buffer);
}

/// Disable attribute state pointer
pub fn rlDisableStatePointer(vertexAttribType: i32) void {
    cdef.rlDisableStatePointer(@as(c_int, vertexAttribType));
}

/// Select and active a texture slot
pub fn rlActiveTextureSlot(slot: i32) void {
    cdef.rlActiveTextureSlot(@as(c_int, slot));
}

/// Enable texture
pub fn rlEnableTexture(id: u32) void {
    cdef.rlEnableTexture(@as(c_uint, id));
}

/// Disable texture
pub fn rlDisableTexture() void {
    cdef.rlDisableTexture();
}

/// Enable texture cubemap
pub fn rlEnableTextureCubemap(id: u32) void {
    cdef.rlEnableTextureCubemap(@as(c_uint, id));
}

/// Disable texture cubemap
pub fn rlDisableTextureCubemap() void {
    cdef.rlDisableTextureCubemap();
}

/// Set texture parameters (filter, wrap)
pub fn rlTextureParameters(id: u32, param: i32, value: i32) void {
    cdef.rlTextureParameters(@as(c_uint, id), @as(c_int, param), @as(c_int, value));
}

/// Set cubemap parameters (filter, wrap)
pub fn rlCubemapParameters(id: u32, param: i32, value: i32) void {
    cdef.rlCubemapParameters(@as(c_uint, id), @as(c_int, param), @as(c_int, value));
}

/// Enable shader program
pub fn rlEnableShader(id: u32) void {
    cdef.rlEnableShader(@as(c_uint, id));
}

/// Disable shader program
pub fn rlDisableShader() void {
    cdef.rlDisableShader();
}

/// Enable render texture (fbo)
pub fn rlEnableFramebuffer(id: u32) void {
    cdef.rlEnableFramebuffer(@as(c_uint, id));
}

/// Disable render texture (fbo), return to default framebuffer
pub fn rlDisableFramebuffer() void {
    cdef.rlDisableFramebuffer();
}

/// Get the currently active render texture (fbo), 0 for default framebuffer
pub fn rlGetActiveFramebuffer() u32 {
    return @as(u32, cdef.rlGetActiveFramebuffer());
}

/// Activate multiple draw color buffers
pub fn rlActiveDrawBuffers(count: i32) void {
    cdef.rlActiveDrawBuffers(@as(c_int, count));
}

/// Blit active framebuffer to main framebuffer
pub fn rlBlitFramebuffer(srcX: i32, srcY: i32, srcWidth: i32, srcHeight: i32, dstX: i32, dstY: i32, dstWidth: i32, dstHeight: i32, bufferMask: i32) void {
    cdef.rlBlitFramebuffer(@as(c_int, srcX), @as(c_int, srcY), @as(c_int, srcWidth), @as(c_int, srcHeight), @as(c_int, dstX), @as(c_int, dstY), @as(c_int, dstWidth), @as(c_int, dstHeight), @as(c_int, bufferMask));
}

/// Bind framebuffer (FBO)
pub fn rlBindFramebuffer(target: u32, framebuffer: u32) void {
    cdef.rlBindFramebuffer(@as(c_uint, target), @as(c_uint, framebuffer));
}

/// Enable color blending
pub fn rlEnableColorBlend() void {
    cdef.rlEnableColorBlend();
}

/// Disable color blending
pub fn rlDisableColorBlend() void {
    cdef.rlDisableColorBlend();
}

/// Enable depth test
pub fn rlEnableDepthTest() void {
    cdef.rlEnableDepthTest();
}

/// Disable depth test
pub fn rlDisableDepthTest() void {
    cdef.rlDisableDepthTest();
}

/// Enable depth write
pub fn rlEnableDepthMask() void {
    cdef.rlEnableDepthMask();
}

/// Disable depth write
pub fn rlDisableDepthMask() void {
    cdef.rlDisableDepthMask();
}

/// Enable backface culling
pub fn rlEnableBackfaceCulling() void {
    cdef.rlEnableBackfaceCulling();
}

/// Disable backface culling
pub fn rlDisableBackfaceCulling() void {
    cdef.rlDisableBackfaceCulling();
}

/// Color mask control
pub fn rlColorMask(r: bool, g: bool, b: bool, a: bool) void {
    cdef.rlColorMask(r, g, b, a);
}

/// Set face culling mode
pub fn rlSetCullFace(mode: i32) void {
    cdef.rlSetCullFace(@as(c_int, mode));
}

/// Enable scissor test
pub fn rlEnableScissorTest() void {
    cdef.rlEnableScissorTest();
}

/// Disable scissor test
pub fn rlDisableScissorTest() void {
    cdef.rlDisableScissorTest();
}

/// Scissor test
pub fn rlScissor(x: i32, y: i32, width: i32, height: i32) void {
    cdef.rlScissor(@as(c_int, x), @as(c_int, y), @as(c_int, width), @as(c_int, height));
}

/// Enable point mode
pub fn rlEnablePointMode() void {
    cdef.rlEnablePointMode();
}

/// Disable point mode
pub fn rlDisablePointMode() void {
    cdef.rlDisablePointMode();
}

/// Set the point drawing size
pub fn rlSetPointSize(size: f32) void {
    cdef.rlSetPointSize(size);
}

/// Get the point drawing size
pub fn rlGetPointSize() f32 {
    return cdef.rlGetPointSize();
}

/// Enable wire mode
pub fn rlEnableWireMode() void {
    cdef.rlEnableWireMode();
}

/// Disable wire mode
pub fn rlDisableWireMode() void {
    cdef.rlDisableWireMode();
}

/// Set the line drawing width
pub fn rlSetLineWidth(width: f32) void {
    cdef.rlSetLineWidth(width);
}

/// Get the line drawing width
pub fn rlGetLineWidth() f32 {
    return cdef.rlGetLineWidth();
}

/// Enable line aliasing
pub fn rlEnableSmoothLines() void {
    cdef.rlEnableSmoothLines();
}

/// Disable line aliasing
pub fn rlDisableSmoothLines() void {
    cdef.rlDisableSmoothLines();
}

/// Enable stereo rendering
pub fn rlEnableStereoRender() void {
    cdef.rlEnableStereoRender();
}

/// Disable stereo rendering
pub fn rlDisableStereoRender() void {
    cdef.rlDisableStereoRender();
}

/// Check if stereo render is enabled
pub fn rlIsStereoRenderEnabled() bool {
    return cdef.rlIsStereoRenderEnabled();
}

/// Clear color buffer with color
pub fn rlClearColor(r: u8, g: u8, b: u8, a: u8) void {
    cdef.rlClearColor(r, g, b, a);
}

/// Clear used screen buffers (color and depth)
pub fn rlClearScreenBuffers() void {
    cdef.rlClearScreenBuffers();
}

/// Check and log OpenGL error codes
pub fn rlCheckErrors() void {
    cdef.rlCheckErrors();
}

/// Set blending mode
pub fn rlSetBlendMode(mode: i32) void {
    cdef.rlSetBlendMode(@as(c_int, mode));
}

/// Set blending mode factor and equation (using OpenGL factors)
pub fn rlSetBlendFactors(glSrcFactor: i32, glDstFactor: i32, glEquation: i32) void {
    cdef.rlSetBlendFactors(@as(c_int, glSrcFactor), @as(c_int, glDstFactor), @as(c_int, glEquation));
}

/// Set blending mode factors and equations separately (using OpenGL factors)
pub fn rlSetBlendFactorsSeparate(glSrcRGB: i32, glDstRGB: i32, glSrcAlpha: i32, glDstAlpha: i32, glEqRGB: i32, glEqAlpha: i32) void {
    cdef.rlSetBlendFactorsSeparate(@as(c_int, glSrcRGB), @as(c_int, glDstRGB), @as(c_int, glSrcAlpha), @as(c_int, glDstAlpha), @as(c_int, glEqRGB), @as(c_int, glEqAlpha));
}

/// Initialize rlgl (buffers, shaders, textures, states)
pub fn rlglInit(width: i32, height: i32) void {
    cdef.rlglInit(@as(c_int, width), @as(c_int, height));
}

/// De-initialize rlgl (buffers, shaders, textures)
pub fn rlglClose() void {
    cdef.rlglClose();
}

/// Load OpenGL extensions (loader function required)
pub fn rlLoadExtensions(loader: *anyopaque) void {
    cdef.rlLoadExtensions(loader);
}

/// Get OpenGL procedure address
pub fn rlGetProcAddress(procName: [:0]const u8) *anyopaque {
    return cdef.rlGetProcAddress(@as([*c]const u8, @ptrCast(procName)));
}

/// Get current OpenGL version
pub fn rlGetVersion() i32 {
    return @as(i32, cdef.rlGetVersion());
}

/// Set current framebuffer width
pub fn rlSetFramebufferWidth(width: i32) void {
    cdef.rlSetFramebufferWidth(@as(c_int, width));
}

/// Get default framebuffer width
pub fn rlGetFramebufferWidth() i32 {
    return @as(i32, cdef.rlGetFramebufferWidth());
}

/// Set current framebuffer height
pub fn rlSetFramebufferHeight(height: i32) void {
    cdef.rlSetFramebufferHeight(@as(c_int, height));
}

/// Get default framebuffer height
pub fn rlGetFramebufferHeight() i32 {
    return @as(i32, cdef.rlGetFramebufferHeight());
}

/// Get default texture id
pub fn rlGetTextureIdDefault() u32 {
    return @as(u32, cdef.rlGetTextureIdDefault());
}

/// Get default shader id
pub fn rlGetShaderIdDefault() u32 {
    return @as(u32, cdef.rlGetShaderIdDefault());
}

/// Get default shader locations
pub fn rlGetShaderLocsDefault() [*c]c_int {
    return cdef.rlGetShaderLocsDefault();
}

/// Load a render batch system
pub fn rlLoadRenderBatch(numBuffers: i32, bufferElements: i32) rlRenderBatch {
    return cdef.rlLoadRenderBatch(@as(c_int, numBuffers), @as(c_int, bufferElements));
}

/// Unload render batch system
pub fn rlUnloadRenderBatch(batch: rlRenderBatch) void {
    cdef.rlUnloadRenderBatch(batch);
}

/// Draw render batch data (Update->Draw->Reset)
pub fn rlDrawRenderBatch(batch: *rlRenderBatch) void {
    cdef.rlDrawRenderBatch(@as([*c]rlRenderBatch, @ptrCast(batch)));
}

/// Set the active render batch for rlgl (NULL for default internal)
pub fn rlSetRenderBatchActive(batch: ?*rlRenderBatch) void {
    cdef.rlSetRenderBatchActive(@as([*c]rlRenderBatch, @ptrCast(batch)));
}

/// Update and draw internal render batch
pub fn rlDrawRenderBatchActive() void {
    cdef.rlDrawRenderBatchActive();
}

/// Check internal buffer overflow for a given number of vertex
pub fn rlCheckRenderBatchLimit(vCount: i32) bool {
    return cdef.rlCheckRenderBatchLimit(@as(c_int, vCount));
}

/// Set current texture for render batch and check buffers limits
pub fn rlSetTexture(id: u32) void {
    cdef.rlSetTexture(@as(c_uint, id));
}

/// Load vertex array (vao) if supported
pub fn rlLoadVertexArray() u32 {
    return @as(u32, cdef.rlLoadVertexArray());
}

/// Load a vertex buffer object
pub fn rlLoadVertexBuffer(buffer: *const anyopaque, size: i32, dynamic: bool) u32 {
    return @as(u32, cdef.rlLoadVertexBuffer(buffer, @as(c_int, size), dynamic));
}

/// Load vertex buffer elements object
pub fn rlLoadVertexBufferElement(buffer: *const anyopaque, size: i32, dynamic: bool) u32 {
    return @as(u32, cdef.rlLoadVertexBufferElement(buffer, @as(c_int, size), dynamic));
}

/// Update vertex buffer object data on GPU buffer
pub fn rlUpdateVertexBuffer(bufferId: u32, data: *const anyopaque, dataSize: i32, offset: i32) void {
    cdef.rlUpdateVertexBuffer(@as(c_uint, bufferId), data, @as(c_int, dataSize), @as(c_int, offset));
}

/// Update vertex buffer elements data on GPU buffer
pub fn rlUpdateVertexBufferElements(id: u32, data: *const anyopaque, dataSize: i32, offset: i32) void {
    cdef.rlUpdateVertexBufferElements(@as(c_uint, id), data, @as(c_int, dataSize), @as(c_int, offset));
}

/// Unload vertex array (vao)
pub fn rlUnloadVertexArray(vaoId: u32) void {
    cdef.rlUnloadVertexArray(@as(c_uint, vaoId));
}

/// Unload vertex buffer object
pub fn rlUnloadVertexBuffer(vboId: u32) void {
    cdef.rlUnloadVertexBuffer(@as(c_uint, vboId));
}

/// Set vertex attribute data configuration
pub fn rlSetVertexAttribute(index: u32, compSize: i32, ty: i32, normalized: bool, stride: i32, offset: i32) void {
    cdef.rlSetVertexAttribute(@as(c_uint, index), @as(c_int, compSize), @as(c_int, ty), normalized, @as(c_int, stride), @as(c_int, offset));
}

/// Set vertex attribute data divisor
pub fn rlSetVertexAttributeDivisor(index: u32, divisor: i32) void {
    cdef.rlSetVertexAttributeDivisor(@as(c_uint, index), @as(c_int, divisor));
}

/// Set vertex attribute default value, when attribute to provided
pub fn rlSetVertexAttributeDefault(locIndex: i32, value: *const anyopaque, attribType: i32, count: i32) void {
    cdef.rlSetVertexAttributeDefault(@as(c_int, locIndex), value, @as(c_int, attribType), @as(c_int, count));
}

/// Draw vertex array (currently active vao)
pub fn rlDrawVertexArray(offset: i32, count: i32) void {
    cdef.rlDrawVertexArray(@as(c_int, offset), @as(c_int, count));
}

/// Draw vertex array elements
pub fn rlDrawVertexArrayElements(offset: i32, count: i32, buffer: ?*const anyopaque) void {
    cdef.rlDrawVertexArrayElements(@as(c_int, offset), @as(c_int, count), buffer);
}

/// Draw vertex array (currently active vao) with instancing
pub fn rlDrawVertexArrayInstanced(offset: i32, count: i32, instances: i32) void {
    cdef.rlDrawVertexArrayInstanced(@as(c_int, offset), @as(c_int, count), @as(c_int, instances));
}

/// Draw vertex array elements with instancing
pub fn rlDrawVertexArrayElementsInstanced(offset: i32, count: i32, buffer: ?*const anyopaque, instances: i32) void {
    cdef.rlDrawVertexArrayElementsInstanced(@as(c_int, offset), @as(c_int, count), buffer, @as(c_int, instances));
}

/// Load texture data
pub fn rlLoadTexture(data: ?*const anyopaque, width: i32, height: i32, format: i32, mipmapCount: i32) u32 {
    return @as(u32, cdef.rlLoadTexture(data, @as(c_int, width), @as(c_int, height), @as(c_int, format), @as(c_int, mipmapCount)));
}

/// Load depth texture/renderbuffer (to be attached to fbo)
pub fn rlLoadTextureDepth(width: i32, height: i32, useRenderBuffer: bool) u32 {
    return @as(u32, cdef.rlLoadTextureDepth(@as(c_int, width), @as(c_int, height), useRenderBuffer));
}

/// Load texture cubemap data
pub fn rlLoadTextureCubemap(data: ?*const anyopaque, size: i32, format: i32, mipmapCount: i32) u32 {
    return @as(u32, cdef.rlLoadTextureCubemap(data, @as(c_int, size), @as(c_int, format), @as(c_int, mipmapCount)));
}

/// Update texture with new data on GPU
pub fn rlUpdateTexture(id: u32, offsetX: i32, offsetY: i32, width: i32, height: i32, format: i32, data: *const anyopaque) void {
    cdef.rlUpdateTexture(@as(c_uint, id), @as(c_int, offsetX), @as(c_int, offsetY), @as(c_int, width), @as(c_int, height), @as(c_int, format), data);
}

/// Get OpenGL internal formats
pub fn rlGetGlTextureFormats(format: i32, glInternalFormat: *u32, glFormat: *u32, glType: *u32) void {
    cdef.rlGetGlTextureFormats(@as(c_int, format), @as([*c]c_uint, @ptrCast(glInternalFormat)), @as([*c]c_uint, @ptrCast(glFormat)), @as([*c]c_uint, @ptrCast(glType)));
}

/// Get name string for pixel format
pub fn rlGetPixelFormatName(format: u32) [:0]const u8 {
    return std.mem.span(cdef.rlGetPixelFormatName(@as(c_uint, format)));
}

/// Unload texture from GPU memory
pub fn rlUnloadTexture(id: u32) void {
    cdef.rlUnloadTexture(@as(c_uint, id));
}

/// Generate mipmap data for selected texture
pub fn rlGenTextureMipmaps(id: u32, width: i32, height: i32, format: i32, mipmaps: *i32) void {
    cdef.rlGenTextureMipmaps(@as(c_uint, id), @as(c_int, width), @as(c_int, height), @as(c_int, format), @as([*c]c_int, @ptrCast(mipmaps)));
}

/// Read texture pixel data
pub fn rlReadTexturePixels(id: u32, width: i32, height: i32, format: i32) *anyopaque {
    return cdef.rlReadTexturePixels(@as(c_uint, id), @as(c_int, width), @as(c_int, height), @as(c_int, format));
}

/// Read screen pixel data (color buffer)
pub fn rlReadScreenPixels(width: i32, height: i32) [:0]u8 {
    return std.mem.span(cdef.rlReadScreenPixels(@as(c_int, width), @as(c_int, height)));
}

/// Load an empty framebuffer
pub fn rlLoadFramebuffer() u32 {
    return @as(u32, cdef.rlLoadFramebuffer());
}

/// Attach texture/renderbuffer to a framebuffer
pub fn rlFramebufferAttach(fboId: u32, texId: u32, attachType: i32, texType: i32, mipLevel: i32) void {
    cdef.rlFramebufferAttach(@as(c_uint, fboId), @as(c_uint, texId), @as(c_int, attachType), @as(c_int, texType), @as(c_int, mipLevel));
}

/// Verify framebuffer is complete
pub fn rlFramebufferComplete(id: u32) bool {
    return cdef.rlFramebufferComplete(@as(c_uint, id));
}

/// Delete framebuffer from GPU
pub fn rlUnloadFramebuffer(id: u32) void {
    cdef.rlUnloadFramebuffer(@as(c_uint, id));
}

/// Copy framebuffer pixel data to internal buffer
pub fn rlCopyFramebuffer(x: i32, y: i32, width: i32, height: i32, format: i32, pixels: *anyopaque) void {
    cdef.rlCopyFramebuffer(@as(c_int, x), @as(c_int, y), @as(c_int, width), @as(c_int, height), @as(c_int, format), pixels);
}

/// Resize internal framebuffer
pub fn rlResizeFramebuffer(width: i32, height: i32) void {
    cdef.rlResizeFramebuffer(@as(c_int, width), @as(c_int, height));
}

/// Load shader from code strings
pub fn rlLoadShaderCode(vsCode: [:0]const u8, fsCode: [:0]const u8) u32 {
    return @as(u32, cdef.rlLoadShaderCode(@as([*c]const u8, @ptrCast(vsCode)), @as([*c]const u8, @ptrCast(fsCode))));
}

/// Compile custom shader and return shader id (type: RL_VERTEX_SHADER, RL_FRAGMENT_SHADER, RL_COMPUTE_SHADER)
pub fn rlCompileShader(shaderCode: [:0]const u8, ty: i32) u32 {
    return @as(u32, cdef.rlCompileShader(@as([*c]const u8, @ptrCast(shaderCode)), @as(c_int, ty)));
}

/// Load custom shader program
pub fn rlLoadShaderProgram(vShaderId: u32, fShaderId: u32) u32 {
    return @as(u32, cdef.rlLoadShaderProgram(@as(c_uint, vShaderId), @as(c_uint, fShaderId)));
}

/// Unload shader program
pub fn rlUnloadShaderProgram(id: u32) void {
    cdef.rlUnloadShaderProgram(@as(c_uint, id));
}

/// Get shader location uniform
pub fn rlGetLocationUniform(shaderId: u32, uniformName: [:0]const u8) i32 {
    return @as(i32, cdef.rlGetLocationUniform(@as(c_uint, shaderId), @as([*c]const u8, @ptrCast(uniformName))));
}

/// Get shader location attribute
pub fn rlGetLocationAttrib(shaderId: u32, attribName: [:0]const u8) i32 {
    return @as(i32, cdef.rlGetLocationAttrib(@as(c_uint, shaderId), @as([*c]const u8, @ptrCast(attribName))));
}

/// Set shader value uniform
pub fn rlSetUniform(locIndex: i32, value: *const anyopaque, uniformType: i32, count: i32) void {
    cdef.rlSetUniform(@as(c_int, locIndex), value, @as(c_int, uniformType), @as(c_int, count));
}

/// Set shader value matrix
pub fn rlSetUniformMatrix(locIndex: i32, mat: Matrix) void {
    cdef.rlSetUniformMatrix(@as(c_int, locIndex), mat);
}

/// Set shader value matrices
pub fn rlSetUniformMatrices(locIndex: i32, mat: *const Matrix, count: i32) void {
    cdef.rlSetUniformMatrices(@as(c_int, locIndex), @as([*c]const Matrix, @ptrCast(mat)), @as(c_int, count));
}

/// Set shader value sampler
pub fn rlSetUniformSampler(locIndex: i32, textureId: u32) void {
    cdef.rlSetUniformSampler(@as(c_int, locIndex), @as(c_uint, textureId));
}

/// Set shader currently active (id and locations)
pub fn rlSetShader(id: u32, locs: []i32) void {
    cdef.rlSetShader(@as(c_uint, id), @as([*c]c_int, @ptrCast(locs)));
}

/// Load compute shader program
pub fn rlLoadComputeShaderProgram(shaderId: u32) u32 {
    return @as(u32, cdef.rlLoadComputeShaderProgram(@as(c_uint, shaderId)));
}

/// Dispatch compute shader (equivalent to *draw* for graphics pipeline)
pub fn rlComputeShaderDispatch(groupX: u32, groupY: u32, groupZ: u32) void {
    cdef.rlComputeShaderDispatch(@as(c_uint, groupX), @as(c_uint, groupY), @as(c_uint, groupZ));
}

/// Load shader storage buffer object (SSBO)
pub fn rlLoadShaderBuffer(size: u32, data: ?*const anyopaque, usageHint: i32) u32 {
    return @as(u32, cdef.rlLoadShaderBuffer(@as(c_uint, size), data, @as(c_int, usageHint)));
}

/// Unload shader storage buffer object (SSBO)
pub fn rlUnloadShaderBuffer(ssboId: u32) void {
    cdef.rlUnloadShaderBuffer(@as(c_uint, ssboId));
}

/// Update SSBO buffer data
pub fn rlUpdateShaderBuffer(id: u32, data: *const anyopaque, dataSize: u32, offset: u32) void {
    cdef.rlUpdateShaderBuffer(@as(c_uint, id), data, @as(c_uint, dataSize), @as(c_uint, offset));
}

/// Bind SSBO buffer
pub fn rlBindShaderBuffer(id: u32, index: u32) void {
    cdef.rlBindShaderBuffer(@as(c_uint, id), @as(c_uint, index));
}

/// Read SSBO buffer data (GPU->CPU)
pub fn rlReadShaderBuffer(id: u32, dest: *anyopaque, count: u32, offset: u32) void {
    cdef.rlReadShaderBuffer(@as(c_uint, id), dest, @as(c_uint, count), @as(c_uint, offset));
}

/// Copy SSBO data between buffers
pub fn rlCopyShaderBuffer(destId: u32, srcId: u32, destOffset: u32, srcOffset: u32, count: u32) void {
    cdef.rlCopyShaderBuffer(@as(c_uint, destId), @as(c_uint, srcId), @as(c_uint, destOffset), @as(c_uint, srcOffset), @as(c_uint, count));
}

/// Get SSBO buffer size
pub fn rlGetShaderBufferSize(id: u32) u32 {
    return @as(u32, cdef.rlGetShaderBufferSize(@as(c_uint, id)));
}

/// Bind image texture
pub fn rlBindImageTexture(id: u32, index: u32, format: i32, readonly: bool) void {
    cdef.rlBindImageTexture(@as(c_uint, id), @as(c_uint, index), @as(c_int, format), readonly);
}

/// Get internal modelview matrix
pub fn rlGetMatrixModelview() Matrix {
    return cdef.rlGetMatrixModelview();
}

/// Get internal projection matrix
pub fn rlGetMatrixProjection() Matrix {
    return cdef.rlGetMatrixProjection();
}

/// Get internal accumulated transform matrix
pub fn rlGetMatrixTransform() Matrix {
    return cdef.rlGetMatrixTransform();
}

/// Get internal projection matrix for stereo render (selected eye)
pub fn rlGetMatrixProjectionStereo(eye: i32) Matrix {
    return cdef.rlGetMatrixProjectionStereo(@as(c_int, eye));
}

/// Get internal view offset matrix for stereo render (selected eye)
pub fn rlGetMatrixViewOffsetStereo(eye: i32) Matrix {
    return cdef.rlGetMatrixViewOffsetStereo(@as(c_int, eye));
}

/// Set a custom projection matrix (replaces internal projection matrix)
pub fn rlSetMatrixProjection(proj: Matrix) void {
    cdef.rlSetMatrixProjection(proj);
}

/// Set a custom modelview matrix (replaces internal modelview matrix)
pub fn rlSetMatrixModelview(view: Matrix) void {
    cdef.rlSetMatrixModelview(view);
}

/// Set eyes projection matrices for stereo rendering
pub fn rlSetMatrixProjectionStereo(right: Matrix, left: Matrix) void {
    cdef.rlSetMatrixProjectionStereo(right, left);
}

/// Set eyes view offsets matrices for stereo rendering
pub fn rlSetMatrixViewOffsetStereo(right: Matrix, left: Matrix) void {
    cdef.rlSetMatrixViewOffsetStereo(right, left);
}

/// Load and draw a cube
pub fn rlLoadDrawCube() void {
    cdef.rlLoadDrawCube();
}

/// Load and draw a quad
pub fn rlLoadDrawQuad() void {
    cdef.rlLoadDrawQuad();
}
