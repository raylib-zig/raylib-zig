//! # raylib-zig [core] example - Smooth Pixel-perfect camera
//!
//! raylib-zig (c) Nikolas Wipper 2025

const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width: usize = 800;
    const screen_height: usize = 450;

    const virtual_screen_width: f32 = 160;
    const virtual_screen_height: f32 = 90;

    const virtual_ratio = screen_width / virtual_screen_width;

    rl.initWindow(screen_width, screen_height, "raylib-zig [core] example - smooth pixel-perfect camera");
    defer rl.closeWindow(); // Close window and OpenGL context

    // Game world camera
    var world_space_camera: rl.Camera2D = .{
        .zoom = 1,
        .offset = undefined,
        .rotation = undefined,
        .target = undefined,
    };

    // Smoothing camera
    var screen_space_camera: rl.Camera2D = .{
        .zoom = 1,
        .offset = undefined,
        .rotation = undefined,
        .target = undefined,
    };

    // This is where we'll draw all our objects.
    const target: rl.RenderTexture2D = try rl.loadRenderTexture(
        virtual_screen_width,
        virtual_screen_height,
    );
    defer rl.unloadRenderTexture(target); // Unload render texture

    const rec1 = rl.Rectangle.init(70, 35, 20, 20);
    const rec2 = rl.Rectangle.init(90, 55, 30, 10);
    const rec3 = rl.Rectangle.init(80, 65, 15, 25);

    // The target's height is flipped (in the source Rectangle), due to OpenGL reasons
    const source_rect = rl.Rectangle.init(
        0,
        0,
        @floatFromInt(target.texture.width),
        @floatFromInt(-target.texture.height),
    );
    const dest_rect = rl.Rectangle.init(
        -virtual_ratio,
        -virtual_ratio,
        screen_width + (virtual_ratio * 2),
        screen_height + (virtual_ratio * 2),
    );

    const origin = rl.Vector2.init(0, 0);

    var rotation: f32 = 0;

    var camera_x: f32 = 0;
    var camera_y: f32 = 0;

    rl.setTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Rotate the rectangles, 60 degrees per second
        rotation += 60 * rl.getFrameTime();

        // Make the camera move to demonstrate the effect
        const elapsed_time: f32 = @floatCast(rl.getTime());
        camera_x = (@sin(elapsed_time) * 50) - 10;
        camera_y = @cos(elapsed_time) * 30;

        // Set the camera's target to the values computed above
        screen_space_camera.target = rl.Vector2.init(camera_x, camera_y);

        // Round worldSpace coordinates, keep decimals into screenSpace coordinates
        world_space_camera.target.x = @trunc(screen_space_camera.target.x);
        screen_space_camera.target.x -= world_space_camera.target.x;
        screen_space_camera.target.x *= virtual_ratio;

        world_space_camera.target.y = @trunc(screen_space_camera.target.y);
        screen_space_camera.target.y -= world_space_camera.target.y;
        screen_space_camera.target.y *= virtual_ratio;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginTextureMode(target);
        rl.clearBackground(.white);

        rl.beginMode2D(world_space_camera);
        rl.drawRectanglePro(rec1, origin, rotation, .black);
        rl.drawRectanglePro(rec2, origin, -rotation, .red);
        rl.drawRectanglePro(rec3, origin, rotation + 45, .blue);
        rl.endMode2D();
        rl.endTextureMode();

        rl.beginDrawing();
        rl.clearBackground(.red);

        rl.beginMode2D(screen_space_camera);
        rl.drawTexturePro(target.texture, source_rect, dest_rect, origin, 0, .white);
        rl.endMode2D();

        rl.drawText(
            rl.textFormat("Screen resolution: %ix%i", .{ screen_width, screen_height }),
            10,
            10,
            20,
            .dark_blue,
        );
        rl.drawText(
            rl.textFormat("World resolution: %ix%i", .{ virtual_screen_width, virtual_screen_height }),
            10,
            40,
            20,
            .dark_green,
        );
        rl.drawFPS(rl.getScreenWidth() - 95, 10);
        rl.endDrawing();
        //----------------------------------------------------------------------------------
    }
}
