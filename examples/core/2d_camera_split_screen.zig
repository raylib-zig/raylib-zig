//! # raylib-zig [core] example - 2d camera split screen
//!
//! raylib-zig (c) Nikolas Wipper 2025

const rl = @import("raylib");

const PLAYER_SIZE = 40;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 440;

    rl.initWindow(screen_width, screen_height, "raylib-zig [core] example - 2d camera split screen");
    defer rl.closeWindow(); // Close window and OpenGL context

    var player1 = rl.Rectangle.init(200, 200, PLAYER_SIZE, PLAYER_SIZE);
    var player2 = rl.Rectangle.init(250, 200, PLAYER_SIZE, PLAYER_SIZE);

    var camera1: rl.Camera2D = .{
        .target = rl.Vector2.init(player1.x, player1.y),
        .offset = rl.Vector2.init(200, 200),
        .rotation = 0,
        .zoom = 1,
    };

    var camera2: rl.Camera2D = .{
        .target = rl.Vector2.init(player2.x, player2.y),
        .offset = rl.Vector2.init(200, 200),
        .rotation = 0,
        .zoom = 1,
    };

    const screen_camera1 = try rl.loadRenderTexture(screen_width / 2, screen_height);
    const screen_camera2 = try rl.loadRenderTexture(screen_width / 2, screen_height);
    defer rl.unloadRenderTexture(screen_camera1); // Unload render texture
    defer rl.unloadRenderTexture(screen_camera2); // Unload render texture

    // Build a flipped rectangle the size of the split view to use for drawing later
    const split_screen_rect = rl.Rectangle.init(
        0,
        0,
        @floatFromInt(screen_camera1.texture.width),
        @floatFromInt(-screen_camera1.texture.height),
    );

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------

        if (rl.isKeyDown(.s)) player1.y += 3 else if (rl.isKeyDown(.w)) player1.y -= 3;
        if (rl.isKeyDown(.d)) player1.x += 3 else if (rl.isKeyDown(.a)) player1.x -= 3;

        if (rl.isKeyDown(.down)) player2.y += 3 else if (rl.isKeyDown(.up)) player2.y -= 3;
        if (rl.isKeyDown(.right)) player2.x += 3 else if (rl.isKeyDown(.left)) player2.x -= 3;

        camera1.target = rl.Vector2.init(player1.x, player1.y);
        camera2.target = rl.Vector2.init(player2.x, player2.y);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginTextureMode(screen_camera1);
        rl.clearBackground(.white);

        rl.beginMode2D(camera1);

        // Draw full scene with first camera
        drawScene(screen_width, screen_height);

        rl.drawRectangleRec(player1, .red);
        rl.drawRectangleRec(player2, .blue);
        rl.endMode2D();

        rl.drawRectangle(0, 0, @divFloor(rl.getScreenWidth(), 2), 30, rl.fade(.white, 0.6));
        rl.drawText("PLAYER1: W/S/A/D to move", 10, 10, 10, .maroon);

        rl.endTextureMode();

        rl.beginTextureMode(screen_camera2);
        rl.clearBackground(.white);

        rl.beginMode2D(camera2);

        // Draw full scene with second camera
        drawScene(screen_width, screen_height);

        rl.drawRectangleRec(player1, .red);
        rl.drawRectangleRec(player2, .blue);

        rl.endMode2D();

        rl.drawRectangle(0, 0, @divFloor(rl.getScreenWidth(), 2), 30, rl.fade(.white, 0.6));
        rl.drawText("PLAYER2: UP/DOWN/LEFT/RIGHT to move", 10, 10, 10, .dark_blue);

        rl.endTextureMode();

        // Draw both views render textures to the screen side by side
        rl.beginDrawing();
        rl.clearBackground(.black);

        rl.drawTextureRec(screen_camera1.texture, split_screen_rect, rl.Vector2.init(0, 0), .white);
        rl.drawTextureRec(screen_camera2.texture, split_screen_rect, rl.Vector2.init(screen_width / 2, 0), .white);

        rl.drawRectangle(@divFloor(rl.getScreenWidth(), 2) - 2, 0, 4, rl.getScreenHeight(), .light_gray);
        rl.endDrawing();
        //----------------------------------------------------------------------------------
    }
}

// NOTE: Using comptime_int makes our code much simpler, however if width and height
//       are only runtime known this function will need extra work!
fn drawScene(width: comptime_int, height: comptime_int) void {
    for (0..width / PLAYER_SIZE + 1) |i|
        rl.drawLineV(
            rl.Vector2.init(@floatFromInt(PLAYER_SIZE * i), 0),
            rl.Vector2.init(@floatFromInt(PLAYER_SIZE * i), height),
            .light_gray,
        );

    for (0..height / PLAYER_SIZE + 1) |i|
        rl.drawLineV(
            rl.Vector2.init(0, @floatFromInt(PLAYER_SIZE * i)),
            rl.Vector2.init(width, @floatFromInt(PLAYER_SIZE * i)),
            .light_gray,
        );

    for (0..width / PLAYER_SIZE) |i|
        for (0..height / PLAYER_SIZE) |j|
            rl.drawText(
                rl.textFormat("[%i,%i]", .{ i, j }),
                @intCast(10 + PLAYER_SIZE * i),
                @intCast(15 + PLAYER_SIZE * j),
                10,
                .light_gray,
            );
}
