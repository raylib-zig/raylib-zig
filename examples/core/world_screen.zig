//! # raylib-zig [core] examples - World to screen
//!
//! raylib-zig (c) Nikolas Wipper 2025

const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width: usize = 800;
    const screen_height: usize = 450;

    rl.initWindow(screen_width, screen_height, "raylib-zig [core] example - world screen");
    defer rl.closeWindow(); // Close window and OpenGL context

    // Define the camera to look into our 3d world
    var camera: rl.Camera = .{
        .position = rl.Vector3.init(10, 10, 10), // Camera position
        .target = rl.Vector3.init(0, 0, 0), // Camera looking at point
        .up = rl.Vector3.init(0, 1, 0), // Camera up vector (rotation towards target)
        .fovy = 45, // Camera field-of-view Y
        .projection = .perspective, // Camera projection type
    };

    const cube_position = rl.Vector3.init(0, 0, 0);
    var cube_screen_position = rl.Vector2.init(0, 0);

    rl.disableCursor(); // Limit cursor to relative movement inside the window

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.updateCamera(&camera, .third_person);

        // Calculate cube screen space position (with a little offset to be in top)
        cube_screen_position = rl.getWorldToScreen(
            rl.Vector3.init(cube_position.x, cube_position.y + 2.5, cube_position.z),
            camera,
        );
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();

        rl.clearBackground(.white);

        rl.beginMode3D(camera);

        rl.drawCube(cube_position, 2, 2, 2, .red);
        rl.drawCubeWires(cube_position, 2, 2, 2, .maroon);

        rl.drawGrid(10, 1);

        rl.endMode3D();

        rl.drawText(
            "Enemy: 100 / 100",
            @as(
                i32,
                @intFromFloat(cube_screen_position.x),
            ) - @divFloor(rl.measureText("Enemy: 100/100", 20), 2),
            @as(
                i32,
                @intFromFloat(cube_screen_position.y),
            ),
            20,
            .black,
        );

        rl.drawText(
            rl.textFormat("Cube position in screen space coordinates: [%i, %i]", .{
                @as(i32, @intFromFloat(cube_screen_position.x)),
                @as(i32, @intFromFloat(cube_screen_position.y)),
            }),
            10,
            10,
            20,
            .lime,
        );
        rl.drawText(
            "Text 2d should be always on top of the cube",
            10,
            40,
            20,
            .gray,
        );

        rl.endDrawing();
        //----------------------------------------------------------------------------------
    }
}
