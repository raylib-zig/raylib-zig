const rl = @import("raylib");
const Color = rl.Color;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [text] example - text writing anim");
    defer rl.closeWindow(); // Close window and OpenGL context

    const message = "This sample illustrates a text writing\nanimation effect! Check it out! ;)";

    var framesCounter: i32 = 0;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        framesCounter += if (rl.isKeyDown(.space)) 8 else 1;

        if (rl.isKeyPressed(.enter)) framesCounter = 0;
        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();

        rl.clearBackground(Color.white);

        rl.drawText(rl.textSubtext(message, 0, @divFloor(framesCounter, 10)), 210, 160, 20, Color.maroon);

        rl.drawText("PRESS [ENTER] to RESTART!", 240, 260, 20, Color.light_gray);
        rl.drawText("HOLD [SPACE] to SPEED UP!", 239, 300, 20, Color.light_gray);

        rl.endDrawing();
        //----------------------------------------------------------------------------------
    }
}
