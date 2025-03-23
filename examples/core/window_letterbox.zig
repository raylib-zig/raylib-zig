const rl = @import("raylib");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() !void {
    const windowWidth = 800;
    const windowHeight = 450;

    const gameScreenWidth = 640;
    const gameScreenHeight = 480;

    // Enable config flags for resizable window and vertical synchro
    rl.setConfigFlags(.{ .window_resizable = true, .vsync_hint = true });

    rl.initWindow(windowWidth, windowHeight, "raylib [core] example - window scale letterbox");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setWindowMinSize(320, 240);

    // Render texture initialization, used to hold the rendering result so we can easily resize it
    const target = try rl.loadRenderTexture(gameScreenWidth, gameScreenHeight);
    defer rl.unloadRenderTexture(target); // Unload render texture
    rl.setTextureFilter(target.texture, .bilinear); // Texture scale filter to use

    var colors: [10]rl.Color = undefined;
    for (0..10) |i| {
        colors[i] = .init(
            @intCast(rl.getRandomValue(100, 250)),
            @intCast(rl.getRandomValue(50, 150)),
            @intCast(rl.getRandomValue(10, 100)),
            255,
        );
    }

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // Compute required framebuffer scaling
        const scale = @min(
            @divFloor(rl.getScreenWidth(), gameScreenWidth),
            @divFloor(rl.getScreenHeight(), gameScreenHeight),
        );

        if (rl.isKeyPressed(.space)) {
            // Recalculate random colors for the bars
            for (0..10) |i| {
                colors[i] = .init(
                    @intCast(rl.getRandomValue(100, 250)),
                    @intCast(rl.getRandomValue(50, 150)),
                    @intCast(rl.getRandomValue(10, 100)),
                    255,
                );
            }
        }

        // Update virtual mouse (clamped mouse value behind game screen)
        const mouse = rl.getMousePosition();
        var virtualMouse: rl.Vector2 = .init(0, 0);
        virtualMouse.x = (mouse.x - @as(f32, @floatFromInt(rl.getScreenWidth() - (gameScreenWidth * scale))) * 0.5) / @as(f32, @floatFromInt(scale));
        virtualMouse.y = (mouse.y - @as(f32, @floatFromInt(rl.getScreenHeight() - (gameScreenHeight * scale))) * 0.5) / @as(f32, @floatFromInt(scale));
        virtualMouse = rl.math.vector2Clamp(virtualMouse, .init(0, 0), .init(gameScreenWidth, gameScreenHeight));

        // Apply the same transformation as the virtual mouse to the real mouse (i.e. to work with raygui)
        //SetMouseOffset(-(GetScreenWidth() - (gameScreenWidth*scale))*0.5f, -(GetScreenHeight() - (gameScreenHeight*scale))*0.5f);
        //SetMouseScale(1/scale, 1/scale);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        // Draw everything in the render texture, note this will not be rendered on screen, yet
        {
            rl.beginTextureMode(target);
            defer rl.endTextureMode();

            rl.clearBackground(.white); // Clear render texture background color

            for (0..10) |i| {
                const offset = @as(i32, @intCast(i));

                rl.drawRectangle(
                    0,
                    (gameScreenHeight / 10) * offset,
                    gameScreenWidth,
                    gameScreenHeight / 10,
                    colors[i],
                );
            }

            rl.drawText("If executed inside a window,\nyou can resize the window,\nand see the screen scaling!", 10, 25, 20, .white);
            rl.drawText(rl.textFormat("Default Mouse: [%i , %i]", .{
                @as(i32, @intFromFloat(mouse.x)),
                @as(i32, @intFromFloat(mouse.y)),
            }), 350, 25, 20, .green);
            rl.drawText(rl.textFormat("Virtual Mouse: [%i , %i]", .{
                @as(i32, @intFromFloat(virtualMouse.x)),
                @as(i32, @intFromFloat(virtualMouse.y)),
            }), 350, 55, 20, .yellow);
        }

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black); // Clear screen background

        // Draw render texture to screen, properly scaled
        rl.drawTexturePro(
            target.texture,
            .init(0.0, 0.0, @floatFromInt(target.texture.width), @floatFromInt(-target.texture.height)),
            .init(
                @as(f32, @floatFromInt(rl.getScreenWidth() - (gameScreenWidth * scale))) * 0.5,
                @as(f32, @floatFromInt(rl.getScreenHeight() - (gameScreenHeight * scale))) * 0.5,
                @floatFromInt(gameScreenWidth * scale),
                @floatFromInt(gameScreenHeight * scale),
            ),
            .init(0, 0),
            0,
            .white,
        );
        //--------------------------------------------------------------------------------------
    }
}
