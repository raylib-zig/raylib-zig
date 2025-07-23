const rl = @import("raylib");
const reasing = @import("reasings.zig");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [shapes] example - easings box anim");
    defer rl.closeWindow();

    // Box variables to be animated with easings
    var rec: rl.Rectangle = rl.Rectangle{
        .x = @as(f32, @floatFromInt(rl.getScreenWidth())) / 2.0,
        .y = -100,
        .height = 100,
        .width = 100,
    };
    var rotation: f32 = 0.0;
    var alpha: f32 = 1.0;

    var state: i32 = 0;
    var framesCounter: i32 = 0;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        switch (state) {
            // Move box down to center of screen
            0 => {
                framesCounter += 1;

                // NOTE: Remember that 3rd parameter of easing function refers to
                // desired value variation, do not confuse it with expected final value!
                rec.y = reasing.elasticOut(@floatFromInt(framesCounter), -100, @as(f32, @floatFromInt(rl.getScreenHeight())) / 2.0 + 100, 120);

                if (framesCounter >= 120) {
                    framesCounter = 0;
                    state = 1;
                }
            },
            // Scale box to an horizontal bar
            1 => {
                framesCounter += 1;
                rec.height = reasing.bounceOut(@floatFromInt(framesCounter), 100, -90, 120);
                rec.width = reasing.bounceOut(@floatFromInt(framesCounter), 100, @floatFromInt(rl.getScreenWidth()), 120);

                if (framesCounter >= 120) {
                    framesCounter = 0;
                    state = 2;
                }
            },
            // Rotate horizontal bar rectangle
            2 => {
                framesCounter += 1;
                rotation = reasing.quadOut(@floatFromInt(framesCounter), 0.0, 270.0, 240);

                if (framesCounter >= 240) {
                    framesCounter = 0;
                    state = 3;
                }
            },
            // Increase bar size to fill all screen
            3 => {
                framesCounter += 1;
                rec.height = reasing.circOut(@floatFromInt(framesCounter), 10, @floatFromInt(rl.getScreenWidth()), 120);

                if (framesCounter >= 120) {
                    framesCounter = 0;
                    state = 4;
                }
            },
            // Fade out animation
            4 => {
                framesCounter += 1;
                alpha = reasing.sineOut(@floatFromInt(framesCounter), 1.0, -1.0, 160);

                if (framesCounter >= 160) {
                    framesCounter = 0;
                    state = 5;
                }
            },
            5 => {},
            else => unreachable,
        }

        // Reset animation at any moment
        if (rl.isKeyPressed(.space)) {
            rec = rl.Rectangle{
                .x = @as(f32, @floatFromInt(rl.getScreenWidth())) / 2.0,
                .y = -100,
                .height = 100,
                .width = 100,
            };
            rotation = 0.0;
            alpha = 1.0;
            state = 0;
            framesCounter = 0;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawRectanglePro(rec, rl.Vector2{
            .x = rec.width / 2,
            .y = rec.height / 2,
        }, rotation, .fade(.black, alpha));

        rl.drawText("PRESS [SPACE] TO RESET BOX ANIMATION!", 10, rl.getScreenHeight() - 25, 20, .light_gray);

        //----------------------------------------------------------------------------------
    }
}
