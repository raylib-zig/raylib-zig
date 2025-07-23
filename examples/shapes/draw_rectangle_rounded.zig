const rl = @import("raylib");
const rgui = @import("raygui");

fn labelFmt(segments: f32) [*c]const u8 {
    if (segments >= 4) return "MANUAL";
    return "AUTO";
}

fn colorFmt(segments: f32) rl.Color {
    if (segments >= 4) return .maroon;
    return .dark_gray;
}

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [shapes] example - draw rectangle rounded");
    defer rl.closeWindow(); // Close window and OpenGL context

    var roundness: f32 = 0.2;
    var width: f32 = 200.0;
    var height: f32 = 100.0;
    var segments: f32 = 0.0;
    var lineThick: f32 = 1.0;

    var drawRect: bool = false;
    var drawRoundedRect: bool = true;
    var drawRoundedLines: bool = false;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        const rec = rl.Rectangle{ .x = (@as(f32, @floatFromInt(rl.getScreenWidth())) - width - 250) / 2.0, .y = (@as(f32, @floatFromInt(rl.getScreenHeight())) - height) / 2.0, .width = width, .height = height };
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawLine(560, 0, 560, rl.getScreenHeight(), .fade(.light_gray, 0.6));
        rl.drawRectangle(560, 0, rl.getScreenWidth() - 500, rl.getScreenHeight(), .fade(.light_gray, 0.3));

        if (drawRect) rl.drawRectangleRec(rec, .fade(.gold, 0.6));
        if (drawRoundedRect) rl.drawRectangleRounded(rec, roundness, @as(i32, @intFromFloat(segments)), .fade(.maroon, 0.2));
        if (drawRoundedLines) rl.drawRectangleRoundedLinesEx(rec, roundness, @as(i32, @intFromFloat(segments)), lineThick, .fade(.maroon, 0.4));

        // Draw GUI controls
        _ = rgui.sliderBar(rl.Rectangle{ .x = 640, .y = 40, .width = 105, .height = 20 }, "Width", rl.textFormat("%.2", .{width}), &width, 0, @as(f32, @floatFromInt(rl.getScreenWidth() - 300)));
        _ = rgui.sliderBar(rl.Rectangle{ .x = 640, .y = 70, .width = 105, .height = 20 }, "Height", rl.textFormat("%.2", .{height}), &height, 0, @as(f32, @floatFromInt(rl.getScreenHeight() - 50)));
        _ = rgui.sliderBar(rl.Rectangle{ .x = 640, .y = 140, .width = 105, .height = 20 }, "Roundness", rl.textFormat("%.2", .{roundness}), &roundness, 0.0, 1.0);
        _ = rgui.sliderBar(rl.Rectangle{ .x = 640, .y = 170, .width = 105, .height = 20 }, "Thickness", rl.textFormat("%.2", .{lineThick}), &lineThick, 0, 20);
        _ = rgui.sliderBar(rl.Rectangle{ .x = 640, .y = 240, .width = 105, .height = 20 }, "Segments", rl.textFormat("%.2", .{segments}), &segments, 0, 60);

        _ = rgui.checkBox(rl.Rectangle{ .x = 640, .y = 320, .width = 20, .height = 20 }, "DrawRoundedRect", &drawRoundedRect);
        _ = rgui.checkBox(rl.Rectangle{ .x = 640, .y = 350, .width = 20, .height = 20 }, "DrawRoundedLines", &drawRoundedLines);
        _ = rgui.checkBox(rl.Rectangle{ .x = 640, .y = 380, .width = 20, .height = 20 }, "DrawRect", &drawRect);

        rl.drawText(rl.textFormat("MODE: %s", .{labelFmt(segments)}), 640, 280, 10, colorFmt(segments));

        rl.drawFPS(10, 10);
        //----------------------------------------------------------------------------------
    }
}
