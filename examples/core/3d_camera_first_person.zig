// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");

const MAX_COLUMNS = 20;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - 3d camera first person");
    defer rl.closeWindow(); // Close window and OpenGL context

    var camera = rl.Camera3D{
        .position = .init(4, 2, 4),
        .target = .init(0, 1.8, 0),
        .up = .init(0, 1, 0),
        .fovy = 60,
        .projection = .perspective,
    };

    var heights: [MAX_COLUMNS]f32 = undefined;
    var positions: [MAX_COLUMNS]rl.Vector3 = undefined;
    var colors: [MAX_COLUMNS]rl.Color = undefined;

    for (0..heights.len) |i| {
        heights[i] = @as(f32, @floatFromInt(rl.getRandomValue(1, 12)));
        positions[i] = .init(
            @as(f32, @floatFromInt(rl.getRandomValue(-15, 15))),
            heights[i] / 2.0,
            @as(f32, @floatFromInt(rl.getRandomValue(-15, 15))),
        );
        colors[i] = .init(
            @as(u8, @intCast(rl.getRandomValue(20, 255))),
            @as(u8, @intCast(rl.getRandomValue(10, 55))),
            30,
            255,
        );
    }

    rl.disableCursor(); // Limit cursor to relative movement inside the window
    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        camera.update(.first_person);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        {
            camera.begin();
            defer camera.end();

            // Draw ground
            rl.drawPlane(.init(0, 0, 0), .init(32, 32), .light_gray);
            rl.drawCube(.init(-16.0, 2.5, 0.0), 1.0, 5.0, 32.0, .blue); // Draw a blue wall
            rl.drawCube(.init(16.0, 2.5, 0.0), 1.0, 5.0, 32.0, .lime); // Draw a green wall
            rl.drawCube(.init(0.0, 2.5, 16.0), 32.0, 5.0, 1.0, .gold); // Draw a yellow wall

            // Draw some cubes around
            for (heights, 0..) |height, i| {
                rl.drawCube(positions[i], 2.0, height, 2.0, colors[i]);
                rl.drawCubeWires(positions[i], 2.0, height, 2.0, .maroon);
            }
        }

        rl.drawRectangle(10, 10, 220, 70, .fade(.sky_blue, 0.5));
        rl.drawRectangleLines(10, 10, 220, 70, .blue);

        rl.drawText("First person camera default controls:", 20, 20, 10, .black);
        rl.drawText("- Move with keys: W, A, S, D", 40, 40, 10, .dark_gray);
        rl.drawText("- Mouse move to look around", 40, 60, 10, .dark_gray);
        //----------------------------------------------------------------------------------
    }
}
