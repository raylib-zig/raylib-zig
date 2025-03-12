const std = @import("std");
const rl = @import("raylib");

const maxColorCount = 21; // Number of colors available

pub fn getAlpha(state: bool) f32 {
    if (state) {
        return 0.6;
    }
    return 1.0;
}

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [shapes] example - colors palette");
    defer rl.closeWindow(); // Close window and OpenGL context

    const colors = [maxColorCount]rl.Color{
        .dark_gray,
        .maroon,
        .orange,
        .dark_green,
        .dark_blue,
        .dark_purple,
        .dark_brown,
        .gray,
        .red,
        .gold,
        .lime,
        .blue,
        .violet,
        .brown,
        .light_gray,
        .pink,
        .yellow,
        .green,
        .sky_blue,
        .purple,
        .beige,
    };

    const colorNames = [maxColorCount][:0]const u8{
        "DARKGRAY",
        "MAROON",
        "ORANGE",
        "DARKGREEN",
        "DARKBLUE",
        "DARKPURPLE",
        "DARKBROWN",
        "GRAY",
        "RED",
        "GOLD",
        "LIME",
        "BLUE",
        "VIOLET",
        "BROWN",
        "LIGHTGRAY",
        "PINK",
        "YELLOW",
        "GREEN",
        "SKYBLUE",
        "PURPLE",
        "BEIGE",
    };

    var colorsRecs = std.mem.zeroes([maxColorCount]rl.Rectangle);

    var i: u8 = 0;
    while (i < maxColorCount) : (i += 1) {
        colorsRecs[i].x = 20.0 + 100.0 * @as(f32, @floatFromInt(i % 7)) + 10.0 * @as(f32, @floatFromInt(i % 7));
        colorsRecs[i].y = 80.0 + 100.0 * @as(f32, @floatFromInt(i / 7)) + 10.0 * @as(f32, @floatFromInt(i / 7));
        colorsRecs[i].width = 100.0;
        colorsRecs[i].height = 100.0;
    }

    var colorState: [maxColorCount]bool = std.mem.zeroes([maxColorCount]bool);

    var mousePoint = rl.Vector2{ .x = 0.0, .y = 0.0 };

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        mousePoint = rl.getMousePosition();

        i = 0;
        while (i < maxColorCount) : (i += 1) {
            if (rl.checkCollisionPointRec(mousePoint, colorsRecs[i])) {
                colorState[i] = true;
            } else {
                colorState[i] = false;
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawText("raylib colors palette", 28, 42, 20, .black);
        rl.drawText("press SPACE to see all colors", rl.getScreenWidth() - 180, rl.getScreenHeight() - 40, 10, .gray);

        i = 0;
        while (i < maxColorCount) : (i += 1) {
            rl.drawRectangleRec(colorsRecs[i], .fade(colors[i], getAlpha(colorState[i])));

            if (rl.isKeyDown(.space) or colorState[i]) {
                rl.drawRectangle(@intFromFloat(colorsRecs[i].x), @as(i32, @intFromFloat(colorsRecs[i].y)) + @as(i32, @intFromFloat(colorsRecs[i].height)) - 26, @as(i32, @intFromFloat(colorsRecs[i].width)), 20, .black);
                rl.drawRectangleLinesEx(colorsRecs[i], 6, .fade(.black, 0.3));

                rl.drawText(colorNames[i], @as(i32, @intFromFloat(colorsRecs[i].x)) + @as(i32, @intFromFloat(colorsRecs[i].width)) - rl.measureText(colorNames[i], 10) - 12, @as(i32, @intFromFloat(colorsRecs[i].y)) + @as(i32, @intFromFloat(colorsRecs[i].height)) - 20, 10, colors[i]);
            }
        }
        //----------------------------------------------------------------------------------
    }
}
