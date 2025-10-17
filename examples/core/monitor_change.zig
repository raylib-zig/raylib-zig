// raylib-zig (c) 2025 Maicon Santana (@maiconpintoabreu)

const std = @import("std");
const rl = @import("raylib");

const MAX_MONITORS = 10;

// Monitor Details
const Monitor = struct {
    position: rl.Vector2,
    name: [*c]const u8,
    width: i32,
    height: i32,
    physicalWidth: i32,
    physicalHeight: i32,
    refreshRate: i32,
};

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth: i32 = 800;
    const screenHeight: i32 = 450;

    var monitors: [MAX_MONITORS]Monitor = undefined;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - monitor change");
    defer rl.closeWindow(); // Close window and OpenGL context

    var currentMonitorIndex: i32 = rl.getCurrentMonitor();
    var monitorCount: usize = 0;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------

        // Variables to find the max x and Y to calculate the scale
        var maxWidth: i32 = 1;
        var maxHeight: i32 = 1;

        // Monitor offset is to fix when monitor position x is negative
        var monitorOffsetX: f32 = 0;

        // Rebuild monitors array every frame
        monitorCount = @intCast(rl.getMonitorCount());
        for (0..monitorCount) |i| {
            const intI: i32 = @intCast(i);
            monitors[i] = .{
                .position = rl.getMonitorPosition(intI),
                .name = rl.getMonitorName(intI),
                .width = rl.getMonitorWidth(intI),
                .height = rl.getMonitorHeight(intI),
                .physicalWidth = rl.getMonitorPhysicalWidth(intI),
                .physicalHeight = rl.getMonitorPhysicalHeight(intI),
                .refreshRate = rl.getMonitorRefreshRate(intI),
            };
            if (monitors[i].position.x < monitorOffsetX) {
                monitorOffsetX = monitors[i].position.x * -1.0;
            }

            const width: i32 = @as(i32, @intFromFloat(monitors[i].position.x)) + monitors[i].width;
            const height: i32 = @as(i32, @intFromFloat(monitors[i].position.y)) + monitors[i].height;

            if (maxWidth < width) maxWidth = width;
            if (maxHeight < height) maxHeight = height;
        }

        if (rl.isKeyPressed(.enter) and monitorCount > 1) {
            currentMonitorIndex += 1;

            // Set index to 0 if the last one
            if (currentMonitorIndex == monitorCount) currentMonitorIndex = 0;

            rl.setWindowMonitor(currentMonitorIndex); // Move window to currentMonitorIndex
        } else {
            // Get currentMonitorIndex if manually moved
            currentMonitorIndex = rl.getCurrentMonitor();
        }

        var monitorScale: f32 = 0.6;

        const intMonitorOffsetX: i32 = @intFromFloat(monitorOffsetX);

        if (maxHeight > maxWidth + intMonitorOffsetX) {
            monitorScale *= @as(f32, @floatFromInt(screenHeight)) / @as(f32, @floatFromInt(maxHeight));
        } else {
            monitorScale *= @as(f32, @floatFromInt(screenWidth)) / @as(f32, @floatFromInt((maxWidth + intMonitorOffsetX)));
        }

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawText("Press [Enter] to move window to next monitor available", 20, 20, 20, .dark_gray);

        rl.drawRectangleLines(20, 60, screenWidth - 40, screenHeight - 100, .dark_gray);

        // Draw Monitor Rectangles with information inside
        for (0..monitorCount) |i| {
            // Calculate retangle position and size using monitorScale
            const rec: rl.Rectangle = .{
                .x = (monitors[i].position.x + monitorOffsetX) * monitorScale + 140,
                .y = monitors[i].position.y * monitorScale + 80,
                .width = @as(f32, @floatFromInt(monitors[i].width)) * monitorScale,
                .height = @as(f32, @floatFromInt(monitors[i].height)) * monitorScale,
            };

            // Draw monitor name and information inside the rectangle
            rl.drawText(
                rl.textFormat("[%i] %s", .{ i, monitors[i].name }),
                @intFromFloat(rec.x + 10.0),
                @intFromFloat(rec.y + (100.0 * monitorScale)),
                @as(i32, @intFromFloat(120.0 * monitorScale)),
                .blue,
            );
            rl.drawText(rl.textFormat("Resolution: [%ipx x %ipx]\nRefreshRate: [%ihz]\nPhysical Size: [%imm x %imm]\nPosition: %3.0f x %3.0f", .{
                monitors[i].width,
                monitors[i].height,
                monitors[i].refreshRate,
                monitors[i].physicalWidth,
                monitors[i].physicalHeight,
                monitors[i].position.x,
                monitors[i].position.y,
            }), @intFromFloat(rec.x + 10), @intFromFloat(rec.y + (200 * monitorScale)), @as(i32, @intFromFloat(120.0 * monitorScale)), .dark_gray);

            // Highlight current monitor
            if (i == currentMonitorIndex) {
                rl.drawRectangleLinesEx(rec, 5, .red);
                const windowPosition: rl.Vector2 = .{
                    .x = (rl.getWindowPosition().x + monitorOffsetX) * monitorScale + 140,
                    .y = rl.getWindowPosition().y * monitorScale + 80,
                };

                // Draw window position based on monitors
                rl.drawRectangleV(
                    windowPosition,
                    .{ .x = @as(f32, @floatFromInt(screenWidth)) * monitorScale, .y = @as(f32, @floatFromInt(screenHeight)) * monitorScale },
                    rl.fade(.green, 0.5),
                );
            } else {
                rl.drawRectangleLinesEx(rec, 5, .gray);
            }
        }
        //----------------------------------------------------------------------------------
    }
}
