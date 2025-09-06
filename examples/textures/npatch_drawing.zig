//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - N-patch drawing
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_npatch_drawing.c
//!
//!   Example complexity rating: [★★★☆] 3/4
//!
//!   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
//!
//!   Example originally created with raylib 2.0, last time updated with raylib 2.5
//!
//!   Example contributed by Jorge A. Gomes (@overdev) and reviewed by Ramon Santamaria (@raysan5)
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2018-2025 Jorge A. Gomes (@overdev) and Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************

const rl = @import("raylib");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [textures] example - N-patch drawing");
    defer rl.closeWindow();

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    var nPatchTexture = try rl.loadTexture("examples/textures/resources/ninepatch_button.png");
    defer nPatchTexture.unload();

    const origin = rl.Vector2{ .x = 0, .y = 0 };

    // Position and size of the n-patches
    var dstRec1 = rl.Rectangle{ .x = 480.0, .y = 160.0, .width = 32.0, .height = 32.0 };
    var dstRec2 = rl.Rectangle{ .x = 160.0, .y = 160.0, .width = 32.0, .height = 32.0 };
    var dstRecH = rl.Rectangle{ .x = 160.0, .y = 93.0, .width = 32.0, .height = 32.0 };
    var dstRecV = rl.Rectangle{ .x = 92.0, .y = 160.0, .width = 32.0, .height = 32.0 };

    // A 9-patch (NPATCH_NINE_PATCH) changes its sizes in both axis
    const ninePatchInfo1 = rl.NPatchInfo{ .source = .{
        .x = 0.0,
        .y = 0.0,
        .width = 64.0,
        .height = 64.0,
    }, .left = 12, .top = 40, .right = 12, .bottom = 12, .layout = .nine_patch };
    const ninePatchInfo2 = rl.NPatchInfo{ .source = .{
        .x = 0.0,
        .y = 128.0,
        .width = 64.0,
        .height = 64.0,
    }, .left = 16, .top = 16, .right = 16, .bottom = 16, .layout = .nine_patch };

    // A horizontal 3-patch (NPATCH_THREE_PATCH_HORIZONTAL) changes its sizes along the x axis only
    const h3PatchInfo = rl.NPatchInfo{ .source = .{
        .x = 0.0,
        .y = 64.0,
        .width = 64.0,
        .height = 64.0,
    }, .left = 8, .top = 8, .right = 8, .bottom = 8, .layout = .three_patch_horizontal };

    // A vertical 3-patch (NPATCH_THREE_PATCH_VERTICAL) changes its sizes along the y axis only
    const v3PatchInfo = rl.NPatchInfo{ .source = .{
        .x = 0.0,
        .y = 192.0,
        .width = 64.0,
        .height = 64.0,
    }, .left = 6, .top = 6, .right = 6, .bottom = 6, .layout = .three_patch_vertical };

    rl.setTargetFPS(60);
    //---------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        const mousePosition = rl.getMousePosition();

        // Resize the n-patches based on mouse position
        dstRec1.width = mousePosition.x - dstRec1.x;
        dstRec1.height = mousePosition.y - dstRec1.y;
        dstRec2.width = mousePosition.x - dstRec2.x;
        dstRec2.height = mousePosition.y - dstRec2.y;
        dstRecH.width = mousePosition.x - dstRecH.x;
        dstRecV.height = mousePosition.y - dstRecV.y;

        // Set a minimum width and/or height
        if (dstRec1.width < 1.0) dstRec1.width = 1.0;
        if (dstRec1.width > 300.0) dstRec1.width = 300.0;
        if (dstRec1.height < 1.0) dstRec1.height = 1.0;
        if (dstRec2.width < 1.0) dstRec2.width = 1.0;
        if (dstRec2.width > 300.0) dstRec2.width = 300.0;
        if (dstRec2.height < 1.0) dstRec2.height = 1.0;
        if (dstRecH.width < 1.0) dstRecH.width = 1.0;
        if (dstRecV.height < 1.0) dstRecV.height = 1.0;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        // Draw the n-patches
        rl.drawTextureNPatch(nPatchTexture, ninePatchInfo2, dstRec2, origin, 0.0, .white);
        rl.drawTextureNPatch(nPatchTexture, ninePatchInfo1, dstRec1, origin, 0.0, .white);
        rl.drawTextureNPatch(nPatchTexture, h3PatchInfo, dstRecH, origin, 0.0, .white);
        rl.drawTextureNPatch(nPatchTexture, v3PatchInfo, dstRecV, origin, 0.0, .white);

        // Draw the source texture
        rl.drawRectangleLines(5, 88, 74, 266, .blue);
        rl.drawTexture(nPatchTexture, 10, 93, .white);
        rl.drawText("TEXTURE", 15, 360, 10, .dark_gray);

        rl.drawText("Move the mouse to stretch or shrink the n-patches", 10, 20, 20, .dark_gray);

        //----------------------------------------------------------------------------------
    }
}
