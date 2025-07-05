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

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [shapes] example - draw ring");
    defer rl.closeWindow(); // Close window and OpenGL context

    const center = rl.Vector2{ .x = @as(f32, @floatFromInt(rl.getScreenWidth() - 300)) / 2.0, .y = @as(f32, @floatFromInt(rl.getScreenHeight())) / 2.0 };

    var innerRadius: f32 = 80.0;
    var outerRadius: f32 = 190.0;

    var startAngle: f32 = 0.0;
    var endAngle: f32 = 360.0;
    var segments: f32 = 0.0;

    var drawRing = true;
    var drawRingLines = false;
    var drawCircleLines = false;

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

        if (drawRing) rl.drawRing(center, innerRadius, outerRadius, startAngle, endAngle, @intFromFloat(segments), .fade(.maroon, 0.3));
        if (drawRingLines) rl.drawRingLines(center, innerRadius, outerRadius, startAngle, endAngle, @intFromFloat(segments), .fade(.black, 0.4));
        if (drawCircleLines) rl.drawCircleSectorLines(center, outerRadius, startAngle, endAngle, @intFromFloat(segments), .fade(.black, 0.4));

        // Draw GUI controls
        //------------------------------------------------------------------------------
        _ = rgui.sliderBar(rl.Rectangle{ .x = 600, .y = 40, .width = 120, .height = 20 }, "StartAngle", rl.textFormat("%.2", .{startAngle}), &startAngle, -450, 450);
        _ = rgui.sliderBar(rl.Rectangle{ .x = 600, .y = 70, .width = 120, .height = 20 }, "EndAngle", rl.textFormat("%.2", .{endAngle}), &endAngle, -450, 450);

        _ = rgui.sliderBar(rl.Rectangle{ .x = 600, .y = 140, .width = 120, .height = 20 }, "InnerRadius", rl.textFormat("%.2", .{innerRadius}), &innerRadius, 0, 100);
        _ = rgui.sliderBar(rl.Rectangle{ .x = 600, .y = 170, .width = 120, .height = 20 }, "OuterRadius", rl.textFormat("%.2", .{outerRadius}), &outerRadius, 0, 200);

        _ = rgui.sliderBar(rl.Rectangle{ .x = 600, .y = 240, .width = 120, .height = 20 }, "Segments", rl.textFormat("%.2", .{segments}), &segments, 0, 100);

        _ = rgui.checkBox(rl.Rectangle{ .x = 600, .y = 320, .width = 20, .height = 20 }, "Draw Ring", &drawRing);
        _ = rgui.checkBox(rl.Rectangle{ .x = 600, .y = 350, .width = 20, .height = 20 }, "Draw RingLines", &drawRingLines);
        _ = rgui.checkBox(rl.Rectangle{ .x = 600, .y = 380, .width = 20, .height = 20 }, "Draw CircleLines", &drawCircleLines);
        //------------------------------------------------------------------------------

        const minSegments: f32 = math.ceil((endAngle - startAngle) / 90);
        rl.drawText(rl.textFormat("MODE: %s", .{labelFmt(segments, minSegments)}), 600, 270, 10, colorFmt(segments, minSegments));

        rl.drawFPS(10, 10);
        //----------------------------------------------------------------------------------
    }
}
