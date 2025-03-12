// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");

const MAX_BUILDINGS = 100;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - 2d camera");
    defer rl.closeWindow(); // Close window and OpenGL context

    var player = rl.Rectangle{ .x = 400, .y = 280, .width = 40, .height = 40 };
    var buildings: [MAX_BUILDINGS]rl.Rectangle = undefined;
    var buildColors: [MAX_BUILDINGS]rl.Color = undefined;

    var spacing: i32 = 0;

    for (0..buildings.len) |i| {
        buildings[i].width = @as(f32, @floatFromInt(rl.getRandomValue(50, 200)));
        buildings[i].height = @as(f32, @floatFromInt(rl.getRandomValue(100, 800)));
        buildings[i].y = screenHeight - 130 - buildings[i].height;
        buildings[i].x = @as(f32, @floatFromInt(-6000 + spacing));

        spacing += @as(i32, @intFromFloat(buildings[i].width));

        buildColors[i] = .init(
            @as(u8, @intCast(rl.getRandomValue(200, 240))),
            @as(u8, @intCast(rl.getRandomValue(200, 240))),
            @as(u8, @intCast(rl.getRandomValue(200, 250))),
            255,
        );
    }

    var camera = rl.Camera2D{
        .target = .init(player.x + 20, player.y + 20),
        .offset = .init(screenWidth / 2, screenHeight / 2),
        .rotation = 0,
        .zoom = 1,
    };

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------

        // Player movement
        if (rl.isKeyDown(.right)) {
            player.x += 2;
        } else if (rl.isKeyDown(.left)) {
            player.x -= 2;
        }

        // Camera target follows player
        camera.target = .init(player.x + 20, player.y + 20);

        // Camera rotation controls
        if (rl.isKeyDown(.a)) {
            camera.rotation -= 1;
        } else if (rl.isKeyDown(.s)) {
            camera.rotation += 1;
        }

        // Limit camera rotation to 80 degrees (-40 to 40)
        camera.rotation = rl.math.clamp(camera.rotation, -40, 40);

        // Camera zoom controls
        camera.zoom += rl.getMouseWheelMove() * 0.05;

        camera.zoom = rl.math.clamp(camera.zoom, 0.1, 3.0);

        // Camera reset (zoom and rotation)
        if (rl.isKeyPressed(.r)) {
            camera.zoom = 1.0;
            camera.rotation = 0.0;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        {
            camera.begin();
            defer camera.end();

            rl.drawRectangle(-6000, 320, 13000, 8000, .dark_gray);

            for (buildings, 0..) |building, i| {
                rl.drawRectangleRec(building, buildColors[i]);
            }

            rl.drawRectangleRec(player, .red);

            rl.drawLine(
                @as(i32, @intFromFloat(camera.target.x)),
                -screenHeight * 10,
                @as(i32, @intFromFloat(camera.target.x)),
                screenHeight * 10,
                .green,
            );
            rl.drawLine(
                -screenWidth * 10,
                @as(i32, @intFromFloat(camera.target.y)),
                screenWidth * 10,
                @as(i32, @intFromFloat(camera.target.y)),
                .green,
            );
        }

        rl.drawText("SCREEN AREA", 640, 10, 20, .red);

        rl.drawRectangle(0, 0, screenWidth, 5, .red);
        rl.drawRectangle(0, 5, 5, screenHeight - 10, .red);
        rl.drawRectangle(screenWidth - 5, 5, 5, screenHeight - 10, .red);
        rl.drawRectangle(0, screenHeight - 5, screenWidth, 5, .red);

        rl.drawRectangle(10, 10, 250, 113, .fade(.sky_blue, 0.5));
        rl.drawRectangleLines(10, 10, 250, 113, .blue);

        rl.drawText("Free 2d camera controls:", 20, 20, 10, .black);
        rl.drawText("- Right/Left to move Offset", 40, 40, 10, .dark_gray);
        rl.drawText("- Mouse Wheel to Zoom in-out", 40, 60, 10, .dark_gray);
        rl.drawText("- A / S to Rotate", 40, 80, 10, .dark_gray);
        rl.drawText("- R to reset Zoom and Rotation", 40, 100, 10, .dark_gray);
        //----------------------------------------------------------------------------------
    }
}
