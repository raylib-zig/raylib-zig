//! # raylib-zig [core] example - VR Simulator (Oculus Rift CV1 parameters)
//!
//! raylib-zig (c) Nikolas Wipper 2025

const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    // NOTE: screen_width/screen_height should match VR device aspect ratio
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib-zig [core] example - vr simulator");
    defer rl.closeWindow(); // Close window and OpenGL context

    // VR device parameters definition
    const device: rl.VrDeviceInfo = .{
        // Oculus Rift CV1 parameters for simulator
        .hResolution = 2160, // Horizontal resolution in pixels
        .vResolution = 1200, // Vertical resolution in pixels
        .hScreenSize = 0.133793, // Horizontal size in meters
        .vScreenSize = 0.0669, // Vertical size in meters
        .vScreenCenter = 0.1003465, // NOTE: this value is (h_size + v_size) / 2
        .eyeToScreenDistance = 0.041, // Distance between eye and display in meters
        .lensSeparationDistance = 0.07, // Lens separation distance in meters
        .interpupillaryDistance = 0.07, // IPD (distance between pupils) in meters

        // NOTE: CV1 uses fresnel-hybrid-asymmetric lenses with specific compute shaders
        // Following parameters are just an approximation to CV1 distortion stereo rendering
        .lensDistortionValues = .{ 1, 0.22, 0.24, 0 },
        .chromaAbCorrection = .{ 0.996, -0.004, 1.014, 0 },
    };

    // Load VR stereo config for VR device parameters (Oculus Rift CV1 parameters)
    const config: rl.VrStereoConfig = rl.loadVrStereoConfig(device);
    defer rl.unloadVrStereoConfig(config);

    // Distortion shader (uses device lens distortion and chroma)
    const distortion = try rl.loadShader(null, "resources/shaders/glsl330/distortion.fs");
    defer rl.unloadShader(distortion);

    // Update distortion shader with lens and distortion-scale parameters
    rl.setShaderValue(
        distortion,
        rl.getShaderLocation(distortion, "leftLensCenter"),
        @ptrCast(&config.leftLensCenter),
        .vec2,
    );
    rl.setShaderValue(
        distortion,
        rl.getShaderLocation(distortion, "rightLensCenter"),
        @ptrCast(&config.rightLensCenter),
        .vec2,
    );
    rl.setShaderValue(
        distortion,
        rl.getShaderLocation(distortion, "leftScreenCenter"),
        @ptrCast(&config.leftScreenCenter),
        .vec2,
    );
    rl.setShaderValue(
        distortion,
        rl.getShaderLocation(distortion, "rightScreenCenter"),
        @ptrCast(&config.rightScreenCenter),
        .vec2,
    );

    rl.setShaderValue(
        distortion,
        rl.getShaderLocation(distortion, "scale"),
        @ptrCast(&config.scale),
        .vec2,
    );
    rl.setShaderValue(
        distortion,
        rl.getShaderLocation(distortion, "scaleIn"),
        @ptrCast(&config.scaleIn),
        .vec2,
    );
    rl.setShaderValue(
        distortion,
        rl.getShaderLocation(distortion, "deviceWarpParam"),
        @ptrCast(&device.lensDistortionValues),
        .vec4,
    );
    rl.setShaderValue(
        distortion,
        rl.getShaderLocation(distortion, "chromaAbParam"),
        @ptrCast(&device.chromaAbCorrection),
        .vec4,
    );

    // Initialize framebuffer for stereo rendering
    // NOTE: Screen size should match HMD aspect ratio
    const target: rl.RenderTexture2D = try rl.loadRenderTexture(device.hResolution, device.vResolution);
    defer rl.unloadRenderTexture(target); // Unload stereo render fb

    // The target's height is flipped (in the source Rectangle), due to OpenGL reasons
    const source_rect = rl.Rectangle.init(
        0,
        0,
        @floatFromInt(target.texture.width),
        @floatFromInt(-target.texture.height),
    );
    const dest_rect = rl.Rectangle.init(0, 0, screen_width, screen_height);

    // Define the camera to look into our 3d world
    var camera: rl.Camera = .{
        .position = rl.Vector3.init(5, 2, 5), // Camera position
        .target = rl.Vector3.init(0, 2, 0), // Camera looking at point
        .up = rl.Vector3.init(0, 1, 0), // Camera up vector
        .fovy = 60, // Camera field-of-view Y
        .projection = .perspective, // Camera projection type
    };

    const cube_position = rl.Vector3.init(0, 0, 0);

    rl.disableCursor(); // Limit cursor to relative movement inside the window

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.updateCamera(&camera, .first_person);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginTextureMode(target);
        rl.clearBackground(.white);
        rl.beginVrStereoMode(config);
        rl.beginMode3D(camera);

        rl.drawCube(cube_position, 2, 2, 2, .red);
        rl.drawCubeWires(cube_position, 2, 2, 2, .maroon);
        rl.drawGrid(40, 1);

        rl.endMode3D();
        rl.endVrStereoMode();
        rl.endTextureMode();

        rl.beginDrawing();
        rl.clearBackground(.white);
        rl.beginShaderMode(distortion);
        rl.drawTexturePro(
            target.texture,
            source_rect,
            dest_rect,
            rl.Vector2.init(0, 0),
            0,
            .white,
        );
        rl.endShaderMode();
        rl.drawFPS(10, 10);
        rl.endDrawing();
        //----------------------------------------------------------------------------------
    }
}
