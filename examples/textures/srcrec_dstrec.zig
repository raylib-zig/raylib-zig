//!*******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Texture source and destination rectangles
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_srcrec_dstrec.c
//!
//!
//!   Example complexity rating: [★★★☆] 3/4
//!
//!   Example originally created with raylib 1.3, last time updated with raylib 1.3
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2015-2025 Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************/

const rl = @import("raylib");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [textures] examples - texture source and destination rectangles");

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)

    const scarfy = try rl.loadTexture("examples/textures/resources/scarfy.png"); // Texture loading
    defer rl.unloadTexture(scarfy);

    const frame_width: f32 = @floatFromInt(@divFloor(scarfy.width, 6));
    const frame_height: f32 = @floatFromInt(scarfy.height);

    // Source rectangle (part of the texture to use for drawing)
    const source_rec = rl.Rectangle{
        .x = 0.0,
        .y = 0.0,
        .width = frame_width,
        .height = frame_height,
    };

    // Destination rectangle (screen rectangle where drawing part of texture)
    const destination_rec = rl.Rectangle{
        .x = screen_width / 2.0,
        .y = screen_height / 2.0,
        .width = frame_width * 2.0,
        .height = frame_height * 2.0,
    };

    // Origin of the texture (rotation/scale point), it's relative to destination rectangle size
    const origin = rl.Vector2{ .x = @as(f32, frame_width), .y = @as(f32, frame_height) };

    var rotation: f32 = 0;

    rl.setTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        rotation += 1;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        // NOTE: Using DrawTexturePro() we can easily rotate and scale the part of the texture we draw
        // sourceRec defines the part of the texture we use for drawing
        // destRec defines the rectangle where our texture part will fit (scaling it to fit)
        // origin defines the point of the texture used as reference for rotation and scaling
        // rotation defines the texture rotation (using origin as rotation point)
        rl.drawTexturePro(scarfy, source_rec, destination_rec, origin, rotation, .white);

        rl.drawLine(@intFromFloat(destination_rec.x), 0, @intFromFloat(destination_rec.x), screen_height, .gray);
        rl.drawLine(0, @intFromFloat(destination_rec.y), screen_width, @intFromFloat(destination_rec.y), .gray);

        rl.drawText("(c) Scarfy sprite by Eiden Marsal", screen_width - 200, screen_height - 20, 10, .gray);

        //----------------------------------------------------------------------------------
    }
}
