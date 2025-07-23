const std = @import("std");
const math = std.math;
const rl = @import("raylib");
const rgui = @import("raygui");

fn labelFmt(segments: f32, minSegments: f32) [*c]const u8 {
    if (segments >= minSegments) return "MANUAL";
    return "AUTO";
}

fn colorFmt(segments: f32, minSegments: f32) rl.Color {
    if (segments >= minSegments) return .maroon;
    return .dark_gray;
}

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [shapes] example - draw circle sector");
    defer rl.closeWindow(); // Close window and OpenGL context

    const center = rl.Vector2{ .x = @as(f32, @floatFromInt(rl.getScreenWidth() - 300)) / 2.0, .y = @as(f32, @floatFromInt(rl.getScreenHeight())) / 2.0 };

    var outerRadius: f32 = 180.0;
    var startAngle: f32 = 0.0;
    var endAngle: f32 = 180.0;
    var segments: f32 = 10.0;
    var minSegments: f32 = 4;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // NOTE: All variables update happens inside GUI control functions
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawLine(500, 0, 500, rl.getScreenHeight(), .fade(.light_gray, 0.6));
        rl.drawRectangle(500, 0, rl.getScreenWidth() - 500, rl.getScreenHeight(), .fade(.light_gray, 0.3));

        rl.drawCircleSector(center, outerRadius, startAngle, endAngle, @as(i32, @intFromFloat(segments)), .fade(.maroon, 0.3));
        rl.drawCircleSectorLines(center, outerRadius, startAngle, endAngle, @as(i32, @intFromFloat(segments)), .fade(.maroon, 0.6));

        // Draw GUI controls
        _ = rgui.sliderBar(rl.Rectangle{ .x = 600, .y = 40, .width = 120, .height = 20 }, "StartAngle", rl.textFormat("%.2", .{startAngle}), &startAngle, 0, 720);
        _ = rgui.sliderBar(rl.Rectangle{ .x = 600, .y = 70, .width = 120, .height = 20 }, "EndAngle", rl.textFormat("%.2", .{endAngle}), &endAngle, 0, 720);

        _ = rgui.sliderBar(rl.Rectangle{ .x = 600, .y = 140, .width = 120, .height = 20 }, "Radius", rl.textFormat("%.2", .{outerRadius}), &outerRadius, 0, 200);
        _ = rgui.sliderBar(rl.Rectangle{ .x = 600, .y = 170, .width = 120, .height = 20 }, "Segments", rl.textFormat("%.2", .{segments}), &segments, 0, 100);

        minSegments = math.trunc(math.ceil((endAngle - startAngle) / 90));
        rl.drawText(rl.textFormat("MODE: %s", .{labelFmt(segments, minSegments)}), 600, 200, 10, colorFmt(segments, minSegments));

        rl.drawFPS(10, 10);
        //----------------------------------------------------------------------------------
    }
}
