// raylib-zig (c) 0xdeadbad 2025

const rl = @import("raylib");

const PLAYER_SIZE = 40;

const Rectangle = rl.Rectangle;
const Camera2D = rl.Camera2D;
const Vector2 = rl.Vector2;
const RenderTexture = rl.RenderTexture;

pub fn main() anyerror!void {
    const screenWidth = 800;
    const screenHeight = 440;

    rl.initWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera split screen");
    defer rl.closeWindow();

    var player1 = Rectangle{ .x = 200, .y = 200, .width = PLAYER_SIZE, .height = PLAYER_SIZE };
    var player2 = Rectangle{ .x = 250, .y = 200, .width = PLAYER_SIZE, .height = PLAYER_SIZE };

    var camera1 = Camera2D{
        .target = .{ .x = player1.x, .y = player1.y },
        .offset = .{ .x = 200.0, .y = 200.0 },
        .rotation = 0.0,
        .zoom = 1.0,
    };

    var camera2 = Camera2D{
        .target = .{ .x = player2.x, .y = player2.y },
        .offset = .{ .x = 200.0, .y = 200.0 },
        .rotation = 0.0,
        .zoom = 1.0,
    };

    var screenCamera1 = try RenderTexture.init(screenWidth / 2, screenHeight);
    defer screenCamera1.unload();

    var screenCamera2 = try RenderTexture.init(screenWidth / 2, screenHeight);
    defer screenCamera2.unload();

    const splitScreenRect = Rectangle{
        .x = 0,
        .y = 0,
        .width = @floatFromInt(screenCamera1.texture.width),
        .height = @floatFromInt(-screenCamera1.texture.height),
    };

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        if (rl.isKeyDown(.s)) player1.y += 3.0 else if (rl.isKeyDown(.w)) player1.y -= 3.0;
        if (rl.isKeyDown(.d)) player1.x += 3.0 else if (rl.isKeyDown(.a)) player1.x -= 3.0;

        if (rl.isKeyDown(.up)) player2.y -= 3.0 else if (rl.isKeyDown(.down)) player2.y += 3.0;
        if (rl.isKeyDown(.right)) player2.x += 3.0 else if (rl.isKeyDown(.left)) player2.x -= 3.0;

        camera1.target = .{ .x = player1.x, .y = player1.y };
        camera2.target = .{ .x = player2.x, .y = player2.y };

        rl.beginTextureMode(screenCamera1);

        rl.clearBackground(.ray_white);

        rl.beginMode2D(camera1);

        for (0..@divTrunc(screenWidth, PLAYER_SIZE) + 1) |i|
            rl.drawLineV(.{ .x = @floatFromInt(PLAYER_SIZE * i), .y = 0.0 }, .{ .x = @floatFromInt(PLAYER_SIZE * i), .y = @floatFromInt(screenHeight) }, .light_gray);

        for (0..@divTrunc(screenHeight, PLAYER_SIZE) + 1) |i|
            rl.drawLineV(.{ .x = 0.0, .y = @floatFromInt(PLAYER_SIZE * i) }, .{ .x = @floatFromInt(screenWidth), .y = @floatFromInt(PLAYER_SIZE * i) }, .light_gray);

        for (0..@divTrunc(screenWidth, PLAYER_SIZE)) |i|
            for (0..@divTrunc(screenHeight, PLAYER_SIZE)) |j|
                rl.drawText(rl.textFormat("[%i,%i]", .{ i, j }), @intCast(10 + PLAYER_SIZE * i), @intCast(15 + PLAYER_SIZE * j), 10, .light_gray);

        rl.drawRectangleRec(player1, .red);
        rl.drawRectangleRec(player2, .blue);

        rl.endMode2D();

        rl.drawRectangle(0, 0, @divTrunc(rl.getScreenWidth(), 2), 30, rl.fade(.ray_white, 0.6));
        rl.drawText("PLAYER1: W/S/A/D to move", 10, 10, 10, .maroon);

        rl.endTextureMode();

        rl.beginTextureMode(screenCamera2);
        rl.clearBackground(.ray_white);

        rl.beginMode2D(camera2);

        for (0..@divTrunc(screenWidth, PLAYER_SIZE) + 1) |i|
            rl.drawLineV(.{ .x = @floatFromInt(PLAYER_SIZE * i), .y = 0.0 }, .{ .x = @floatFromInt(PLAYER_SIZE * i), .y = @floatFromInt(screenHeight) }, .light_gray);

        for (0..@divTrunc(screenHeight, PLAYER_SIZE) + 1) |i|
            rl.drawLineV(.{ .x = 0.0, .y = @floatFromInt(PLAYER_SIZE * i) }, .{ .x = @floatFromInt(screenWidth), .y = @floatFromInt(PLAYER_SIZE * i) }, .light_gray);

        for (0..@divTrunc(screenWidth, PLAYER_SIZE)) |i|
            for (0..@divTrunc(screenHeight, PLAYER_SIZE)) |j|
                rl.drawText(rl.textFormat("[%i,%i]", .{ i, j }), @intCast(10 + PLAYER_SIZE * i), @intCast(15 + PLAYER_SIZE * j), 10, .light_gray);

        rl.drawRectangleRec(player1, .red);
        rl.drawRectangleRec(player2, .blue);

        rl.endMode2D();

        rl.drawRectangle(0, 0, @divTrunc(rl.getScreenWidth(), 2), 30, rl.fade(.ray_white, 0.6));
        rl.drawText("PLAYER2: UP/DOWN/LEFT/RIGHT", 10, 10, 10, .dark_blue);

        rl.endTextureMode();

        rl.beginDrawing();
        rl.clearBackground(.black);

        rl.drawTextureRec(screenCamera1.texture, splitScreenRect, .{ .x = 0.0, .y = 0.0 }, .white);
        rl.drawTextureRec(screenCamera2.texture, splitScreenRect, .{ .x = @floatFromInt(screenWidth / 2), .y = 0.0 }, .white);

        rl.drawRectangle(@divTrunc(rl.getScreenWidth(), 2) - 2, 0, 4, screenHeight, .light_gray);

        rl.endDrawing();
    }
}
