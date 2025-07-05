// raylib [shaders] example - Hybrid Rendering
//
// Example complexity rating: [★★★★] 4/4
//
// Example originally created with raylib 4.2, last time updated with raylib 4.2
//
// Example contributed by Buğra Alptekin Sarı (@BugraAlptekinSari) and reviewed by Ramon Santamaria (@raysan5)
//
// Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
// BSD-like license that allows static linking with closed source software
//
// Copyright (c) 2022-2025 Buğra Alptekin Sarı (@BugraAlptekinSari)

const rl = @import("raylib");
const pi = @import("std").math.pi;

//------------------------------------------------------------------------------------
// Declare custom Structs
//------------------------------------------------------------------------------------

const RayLocs = struct {
    cam_pos: i32,
    cam_dir: i32,
    screen_center: i32,
};

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [shaders] example - write depth buffer");
    defer rl.closeWindow();        // Close window and OpenGL context


    // This Shader calculates pixel depth and color using raymarch
    const shdr_raymarch: rl.Shader = try rl.loadShader(null, "resources/shaders/glsl330/hybrid_raymarch.fs");
    defer rl.unloadShader(shdr_raymarch);

    // This Shader is a standard rasterization fragment shader with the addition of depth writing
    // You are required to write depth for all shaders if one shader does it
    const shdr_raster: rl.Shader = try rl.loadShader(null, "resources/shaders/glsl330/hybrid_raster.fs");
    defer rl.unloadShader(shdr_raster);

    // Declare Struct used to store camera locs.
    const march_locs: RayLocs = .{
        .cam_pos = rl.getShaderLocation(shdr_raymarch, "camPos"),
        .cam_dir = rl.getShaderLocation(shdr_raymarch, "camDir"),
        .screen_center = rl.getShaderLocation(shdr_raymarch, "screenCenter"),
    };

    // Transfer screenCenter position to shader. Which is used to calculate ray direction. 
    const screen_center: rl.Vector2 = .init(screen_width / 2.0, screen_height / 2.0);
    rl.setShaderValue(shdr_raymarch, march_locs.screen_center , &screen_center , .vec2);

    // Use Customized function to create writable depth texture buffer
    const target: rl.RenderTexture2D = try loadRenderTextureDepthTex(screen_width, screen_height);
    defer unloadRenderTextureDepthTex(target);

    // Define the camera to look into our 3d world
    var camera: rl.Camera = .{
        .position = .init(0.5, 1, 1.5),  // Camera position
        .target = .init(0, 0.5, 0),      // Camera looking at point
        .up = .init(0, 1, 0),            // Camera up vector (rotation towards target)
        .fovy = 45,                      // Camera field-of-view Y
        .projection = .perspective,      // Camera projection type
    };

    // Camera FOV is pre-calculated in the camera Distance.
    const cam_dist: f32 = 1.0 / @tan(camera.fovy * 0.5 * (pi / 180.0));

    rl.setTargetFPS(60);               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose())    // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        camera.update(.orbital);

        // Update Camera Postion in the ray march shader.
        rl.setShaderValue(shdr_raymarch, march_locs.cam_pos, &camera.position, .vec3);

        // Update Camera Looking Vector. Vector length determines FOV.
        const cam_dir: rl.Vector3 = .scale(.normalize(.subtract(camera.target, camera.position)), cam_dist);
        rl.setShaderValue(shdr_raymarch, march_locs.cam_dir, &cam_dir, .vec3);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        // Draw into our custom render texture (framebuffer)
        {
            target.begin();
            defer target.end();

            rl.clearBackground(.white);

            // Raymarch Scene
            rl.gl.rlEnableDepthTest(); //Manually enable Depth Test to handle multiple rendering methods.
            {
                shdr_raymarch.activate();
                defer shdr_raymarch.deactivate();
                rl.drawRectangleRec(.init(0, 0, screen_width, screen_height), .white);
            }

            // Rasterize Scene
            {
                rl.beginMode3D(camera);
                defer rl.endMode3D();

                shdr_raster.activate();
                defer shdr_raster.deactivate();

                rl.drawCubeWiresV(.init(0, 0.5, 1), .init(1, 1, 1), .red);
                rl.drawCubeV(.init(0, 0.5, 1), .init(1, 1, 1), .purple);
                rl.drawCubeWiresV(.init(0, 0.5, -1), .init(1, 1, 1), .dark_green);
                rl.drawCubeV(.init(0, 0.5, -1), .init(1, 1, 1), .yellow);
                rl.drawGrid(10, 1);
            }
        }

        // Draw into screen our custom render texture 
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        target.texture.drawRec(.init(0, 0, screen_width, -screen_height), .init(0, 0), .white);
        rl.drawFPS(10, 10);
    }
}

//------------------------------------------------------------------------------------
// Define custom functions required for the example
//------------------------------------------------------------------------------------
// Load custom render texture, create a writable depth texture buffer
fn loadRenderTextureDepthTex(width: i32, height: i32) !rl.RenderTexture2D {
    const id = rl.gl.rlLoadFramebuffer(); // Load an empty framebuffer
    if (id <= 0) {
        return error.LoadFrameBufferFail;
    }

    rl.gl.rlEnableFramebuffer(id);
    defer rl.gl.rlDisableFramebuffer();

    const pix_format: i32 = @intFromEnum(rl.gl.rlPixelFormat.rl_pixelformat_uncompressed_r8g8b8a8);

    const target: rl.RenderTexture2D = .{
        .id = id,
        // Create color texture (default to RGBA)
        .texture = .{
            .id = rl.gl.rlLoadTexture(null, width, height, pix_format, 1),
            .width = width,
            .height = height,
            .format = .uncompressed_r8g8b8a8,
            .mipmaps = 1,
        },
        // Create depth texture buffer (instead of raylib default renderbuffer)
        .depth = .{
            .id = rl.gl.rlLoadTextureDepth(width, height, false),
            .width = width,
            .height = height,
            .format = .compressed_etc2_rgb, //DEPTH_COMPONENT_24BIT?
            .mipmaps = 1,
        }
    };

    // Attach color texture and depth texture to FBO
    const channel0: i32 = @intFromEnum(rl.gl.rlFramebufferAttachType.rl_attachment_color_channel0);
    const depth: i32 = @intFromEnum(rl.gl.rlFramebufferAttachType.rl_attachment_depth);
    const texture2d: i32 = @intFromEnum(rl.gl.rlFramebufferAttachTextureType.rl_attachment_texture2d);
    rl.gl.rlFramebufferAttach(target.id, target.texture.id, channel0, texture2d, 0);
    rl.gl.rlFramebufferAttach(target.id, target.depth.id, depth, texture2d, 0);

    // Check if fbo is complete with attachments (valid)
    if (rl.gl.rlFramebufferComplete(target.id)) {
        rl.traceLog(.info, "FBO: [ID %i] Framebuffer object created successfully", .{ target.id });
    }

    return target;
}

// Unload render texture from GPU memory (VRAM)
fn unloadRenderTextureDepthTex(target: rl.RenderTexture2D) void {
    // Color texture attached to FBO is deleted
    rl.gl.rlUnloadTexture(target.texture.id);
    rl.gl.rlUnloadTexture(target.depth.id);

    // NOTE: Depth texture is automatically
    // queried and deleted before deleting framebuffer
    rl.gl.rlUnloadFramebuffer(target.id);
}
