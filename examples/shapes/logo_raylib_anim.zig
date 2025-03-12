const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [shapes] example - raylib logo animation");
    defer rl.closeWindow(); // Close window and OpenGL context

    const logoPositionX = (screenWidth / 2) - 128;
    const logoPositionY = (screenHeight / 2) - 128;

    var framesCounter: u8 = 0;
    var lettersCount: u8 = 0;

    var topSideRecWidth: i32 = 16;
    var leftSideRecHeight: i32 = 16;

    var bottomSideRecWidth: i32 = 16;
    var rightSideRecHeight: i32 = 16;

    var state: u8 = 0;
    var alpha: f32 = 1.0;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if (state == 0) {
            framesCounter += 1;
            if (framesCounter == 120) {
                state = 1;
                framesCounter = 0;
            }
        } else if (state == 1) {
            topSideRecWidth += 4;
            leftSideRecHeight += 4;

            if (topSideRecWidth == 256) state = 2;
        } else if (state == 2) // State 2: Bottom and right bars growing
        {
            bottomSideRecWidth += 4;
            rightSideRecHeight += 4;

            if (bottomSideRecWidth == 256) state = 3;
        } else if (state == 3) // State 3: Letters appearing (one by one)
        {
            framesCounter += 1;

            if (@mod(framesCounter, 12) == 0) // Every 12 frames, one more letter!
            {
                lettersCount += 1;
                framesCounter = 0;
            }

            if (lettersCount >= 10) // When all letters have appeared, just fade out everything
            {
                alpha -= 0.02;

                if (alpha <= 0.0) {
                    alpha = 0.0;
                    state = 4;
                }
            }
        } else if (state == 4) // State 4: Reset and Replay
        {
            if (rl.isKeyPressed(.r)) {
                framesCounter = 0;
                lettersCount = 0;

                topSideRecWidth = 16;
                leftSideRecHeight = 16;

                bottomSideRecWidth = 16;
                rightSideRecHeight = 16;

                alpha = 1.0;
                state = 0; // Return to State 0
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        if (state == 0) {
            if (@mod(framesCounter, @as(u8, 15)) == 0) rl.drawRectangle(logoPositionX, logoPositionY, 16, 16, .black);
        } else if (state == 1) {
            rl.drawRectangle(logoPositionX, logoPositionY, topSideRecWidth, 16, .black);
            rl.drawRectangle(logoPositionX, logoPositionY, 16, leftSideRecHeight, .black);
        } else if (state == 2) {
            rl.drawRectangle(logoPositionX, logoPositionY, topSideRecWidth, 16, .black);
            rl.drawRectangle(logoPositionX, logoPositionY, 16, leftSideRecHeight, .black);

            rl.drawRectangle(logoPositionX + 240, logoPositionY, 16, rightSideRecHeight, .black);
            rl.drawRectangle(logoPositionX, logoPositionY + 240, bottomSideRecWidth, 16, .black);
        } else if (state == 3) {
            rl.drawRectangle(logoPositionX, logoPositionY, topSideRecWidth, 16, .fade(.black, alpha));
            rl.drawRectangle(logoPositionX, logoPositionY + 16, 16, leftSideRecHeight - 32, .fade(.black, alpha));

            rl.drawRectangle(logoPositionX + 240, logoPositionY + 16, 16, rightSideRecHeight - 32, .fade(.black, alpha));
            rl.drawRectangle(logoPositionX, logoPositionY + 240, bottomSideRecWidth, 16, .fade(.black, alpha));

            rl.drawRectangle(
                (@divFloor(rl.getScreenWidth(), @as(i32, 2))) - 112,
                (@divFloor(rl.getScreenHeight(), @as(i32, 2))) - 112,
                224,
                224,
                .fade(.ray_white, alpha),
            );

            rl.drawText(rl.textSubtext("raylib", 0, lettersCount), @divFloor(rl.getScreenWidth(), @as(i32, 2)) - 44, @divFloor(rl.getScreenHeight(), @as(i32, 2)) + 48, 50, .fade(.black, alpha));
        } else if (state == 4) {
            rl.drawText("[R] REPLAY", 340, 200, 20, .gray);
        }

        //----------------------------------------------------------------------------------
    }
}
