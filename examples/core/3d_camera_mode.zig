//! # raylib-zig [core] example - 3d camera mode
//!
//! raylib-zig (c) Nikolas Wipper 2025

const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib-zig [core] example - 3d camera mode");
    defer rl.closeWindow(); // Close window and OpenGL context

    // Define the camera to look into our 3d world
    const camera: rl.Camera3D = .{
        .position = .init(0, 10, 10), // Camera position
        .target = .zero(), // Camera looking at point
        .up = .init(0, 1, 0), // Camera up vector (rotation towards target)
        .fovy = 45, // Camera field-of-view Y
        .projection = .perspective, // Camera mode type
    };

    const cube_position: rl.Vector3 = .init(0, 0, 0);

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();

        rl.clearBackground(.white);

        camera.begin();

        rl.drawCube(cube_position, 2, 2, 2, .red);
        rl.drawCubeWires(cube_position, 2, 2, 2, .maroon);

        rl.drawGrid(10, 1);

        camera.end();

        rl.drawText("Welcome to the third dimension!", 10, 40, 20, .dark_gray);

        rl.drawFPS(10, 10);

        rl.endDrawing();
        //----------------------------------------------------------------------------------
    }
}
