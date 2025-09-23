//! # raylib-zig [core] example - 3d camera split screen
//!
//! raylib-zig (c) Nikolas Wipper 2025

const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib-zig [core] example - 3d camera split screen");
    defer rl.closeWindow(); // Close window and OpenGL context

    // Setup player 1 camera and screen
    var camera_player1: rl.Camera = .{
        .fovy = 45,
        .up = .init(0, 1, 0),
        .target = .init(0, 1, 0),
        .position = .init(0, 1, -3),
        .projection = .perspective,
    };
    const screen_player1 = try rl.loadRenderTexture(screen_width / 2, screen_height);
    defer rl.unloadRenderTexture(screen_player1); // Unload render texture

    // Setup player two camera and screen
    var camera_player2: rl.Camera = .{
        .fovy = 45,
        .up = .init(0, 1, 0),
        .target = .init(0, 3, 0),
        .position = .init(-3, 3, 0),
        .projection = .perspective,
    };

    const screen_player2 = try rl.loadRenderTexture(screen_width / 2, screen_height);
    defer rl.unloadRenderTexture(screen_player2); // Unload render texture

    // Build a flipped rectangle the size of the split view to use for drawing later
    const split_screen_rect: rl.Rectangle = .init(
        0,
        0,
        @floatFromInt(screen_player1.texture.width),
        @floatFromInt(-screen_player1.texture.height),
    );

    // Grid data
    const count = 5;
    const spacing: f32 = 4;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // If anyone moves this frame, how far will they move based on the time since the last frame
        // this moves things at 10 world units per second, regardless of the actual FPS
        const offset_frame = 10 * rl.getFrameTime();

        // Move Player1 forward and backwards (no turning)
        if (rl.isKeyDown(.w)) {
            camera_player1.position.z += offset_frame;
            camera_player1.target.z += offset_frame;
        } else if (rl.isKeyDown(.s)) {
            camera_player1.position.z -= offset_frame;
            camera_player1.target.z -= offset_frame;
        }

        // Move Player2 forward and backwards (no turning)
        if (rl.isKeyDown(.up)) {
            camera_player2.position.x += offset_frame;
            camera_player2.target.x += offset_frame;
        } else if (rl.isKeyDown(.down)) {
            camera_player2.position.x -= offset_frame;
            camera_player2.target.x -= offset_frame;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        // Draw Player1 view to the render texture
        screen_player1.begin();
        rl.clearBackground(.sky_blue);

        camera_player1.begin();

        // Draw scene: grid of cube trees on a plane to make a "world"
        drawScene(count, spacing);

        // Draw a cube at each player's position
        rl.drawCube(camera_player1.position, 1, 1, 1, .red);
        rl.drawCube(camera_player2.position, 1, 1, 1, .blue);

        camera_player1.end();

        rl.drawRectangle(0, 0, @divExact(rl.getScreenWidth(), 2), 40, rl.fade(.white, 0.8));
        rl.drawText("PLAYER1: W/S to move", 10, 10, 20, .maroon);

        screen_player1.end();

        // Draw Player2 view to the render texture
        screen_player2.begin();
        rl.clearBackground(.sky_blue);

        camera_player2.begin();

        drawScene(count, spacing);

        // Draw a cube at each player's position
        rl.drawCube(camera_player1.position, 1, 1, 1, .red);
        rl.drawCube(camera_player2.position, 1, 1, 1, .blue);

        camera_player2.end();

        rl.drawRectangle(0, 0, @divExact(rl.getScreenWidth(), 2), 40, rl.fade(.white, 0.8));
        rl.drawText("PLAYER2: UP/DOWN to move", 10, 10, 20, .dark_blue);

        screen_player2.end();

        // Draw both views render textures to the screen side by side
        rl.beginDrawing();
        rl.clearBackground(.black);

        rl.drawTextureRec(screen_player1.texture, split_screen_rect, .zero(), .white);
        rl.drawTextureRec(
            screen_player2.texture,
            split_screen_rect,
            .init(screen_width / 2, 0),
            .white,
        );

        rl.drawRectangle(
            @divExact(rl.getScreenWidth(), 2) - 2,
            0,
            4,
            rl.getScreenHeight(),
            .light_gray,
        );
        rl.endDrawing();
        //----------------------------------------------------------------------------------
    }
}

// NOTE: Using comptime_int makes our code much simpler, however if tree count
//       is only runtime known this function will need extra work!
fn drawScene(tree_count: comptime_int, tree_spacing: f32) void {
    // Simple world plane
    rl.drawPlane(.zero(), .init(50, 50), .beige);

    // Cube trees
    var x = -tree_count * tree_spacing;
    while (x <= tree_count * tree_spacing) {
        var z = -tree_count * tree_spacing;
        while (z <= tree_count * tree_spacing) {
            rl.drawCube(.init(x, 1.5, z), 1, 1, 1, .lime);
            rl.drawCube(.init(x, 0.5, z), 0.25, 1, 0.25, .brown);
            z += tree_spacing;
        }
        x += tree_spacing;
    }
}
