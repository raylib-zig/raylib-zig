const rl = @import("raylib");

pub fn main() anyerror!void {
    const screenWidth: i32 = 800;
    const screenHeight: i32 = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [models] example - box collisions");

    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer rl.closeWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    // Define the camera to look into our 3d world
    const camera: rl.Camera = .{
        .position = .{ .x = 0.0, .y = 10.0, .z = 10.0 },
        .target = .{ .x = 0.0, .y = 0.0, .z = 0.0 },
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },
        .fovy = 45.0,
        .projection = .perspective,
    };

    var playerPosition: rl.Vector3 = .{ .x = 0.0, .y = 1.0, .z = 2.0 };
    const playerSize: rl.Vector3 = .{ .x = 1.0, .y = 2.0, .z = 1.0 };
    var playerColor: rl.Color = .green;

    const enemyBoxPos: rl.Vector3 = .{ .x = -4.0, .y = 1.0, .z = 0.0 };
    const enemyBoxSize: rl.Vector3 = .{ .x = 2.0, .y = 2.0, .z = 2.0 };

    const enemySpherePos: rl.Vector3 = .{ .x = 4.0, .y = 0.0, .z = 0.0 };
    const enemySphereSize: f32 = 1.5;

    var collision: bool = false;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!rl.windowShouldClose()) {
        // Update
        //----------------------------------------------------------------------------------

        // Move player
        if (rl.isKeyDown(.right)) playerPosition.x += 0.2 else if (rl.isKeyDown(.left)) playerPosition.x -= 0.2 else if (rl.isKeyDown(.down)) playerPosition.z += 0.2 else if (rl.isKeyDown(.up)) playerPosition.z -= 0.2;

        collision = false;

        // Check collisions player vs enemy-box
        if (rl.checkCollisionBoxes(.{
            .min = .{
                .x = playerPosition.x - playerSize.x / 2,
                .y = playerPosition.y - playerSize.y / 2,
                .z = playerPosition.z - playerSize.z / 2,
            },
            .max = .{
                .x = playerPosition.x + playerSize.x / 2,
                .y = playerPosition.y + playerSize.y / 2,
                .z = playerPosition.z + playerSize.z / 2,
            },
        }, .{
            .min = .{
                .x = enemyBoxPos.x - enemyBoxSize.x / 2,
                .y = enemyBoxPos.y - enemyBoxSize.y / 2,
                .z = enemyBoxPos.z - enemyBoxSize.z / 2,
            },
            .max = .{
                .x = enemyBoxPos.x + enemyBoxSize.x / 2,
                .y = enemyBoxPos.y + enemyBoxSize.y / 2,
                .z = enemyBoxPos.z + enemyBoxSize.z / 2,
            },
        })) collision = true;

        // Check collisions player vs enemy-sphere
        if (rl.checkCollisionBoxSphere(.{
            .min = .{
                .x = playerPosition.x - playerSize.x / 2,
                .y = playerPosition.y - playerSize.y / 2,
                .z = playerPosition.z - playerSize.z / 2,
            },
            .max = .{
                .x = playerPosition.x + playerSize.x / 2,
                .y = playerPosition.y + playerSize.y / 2,
                .z = playerPosition.z + playerSize.z / 2,
            },
        }, enemySpherePos, enemySphereSize)) collision = true;

        if (collision) playerColor = .red else playerColor = .green;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);
        {
            rl.beginMode3D(camera);
            defer rl.endMode3D();

            // Draw enemy-box
            rl.drawCube(enemyBoxPos, enemyBoxSize.x, enemyBoxSize.y, enemyBoxSize.z, .gray);
            rl.drawCubeWires(enemyBoxPos, enemyBoxSize.x, enemyBoxSize.y, enemyBoxSize.z, .dark_gray);

            // Draw enemy-sphere
            rl.drawSphere(enemySpherePos, enemySphereSize, .gray);
            rl.drawSphereWires(enemySpherePos, enemySphereSize, 16, 16, .dark_gray);

            // Draw player
            rl.drawCubeV(playerPosition, playerSize, playerColor);

            rl.drawGrid(10, 1.0); // Draw a grid

        }

        rl.drawText("Move player with arrow keys to collide", 220, 40, 20, .gray);

        rl.drawFPS(10, 10);

        //----------------------------------------------------------------------------------
    }
}
