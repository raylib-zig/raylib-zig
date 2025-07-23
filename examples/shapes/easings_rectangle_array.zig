const rl = @import("raylib");
const reasings = @import("reasings.zig");

const RECS_WIDTH = 50;
const RECS_HEIGHT = 50;
const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 450;

const MAX_RECS_X = SCREEN_WIDTH / RECS_WIDTH;
const MAX_RECS_Y = SCREEN_HEIGHT / RECS_HEIGHT;

const PLAY_TIME_IN_FRAMES = 240; // At 60 fps = 4 seconds

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------

    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "raylib [shapes] example - easings rectangle array");
    defer rl.closeWindow(); // Close window and OpenGL context

    var recs: [MAX_RECS_X * MAX_RECS_Y]rl.Rectangle = undefined;

    for (0..MAX_RECS_Y) |y| {
        for (0..MAX_RECS_X) |x| {
            recs[y * MAX_RECS_X + x].x = RECS_WIDTH / 2.0 + RECS_WIDTH * @as(f32, @floatFromInt(x));
            recs[y * MAX_RECS_X + x].y = RECS_HEIGHT / 2.0 + RECS_HEIGHT * @as(f32, @floatFromInt(y));
            recs[y * MAX_RECS_X + x].width = RECS_WIDTH;
            recs[y * MAX_RECS_X + x].height = RECS_HEIGHT;
        }
    }

    var rotation: f32 = 0.0;
    var framesCounter: i32 = 0;
    var state: i32 = 0; // Rectangles animation state: 0-Playing, 1-Finished

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (state == 0) {
            framesCounter += 1;

            for (&recs) |*rec| {
                rec.height = reasings.circOut(@floatFromInt(framesCounter), RECS_HEIGHT, -RECS_HEIGHT, PLAY_TIME_IN_FRAMES);
                rec.width = reasings.circOut(@floatFromInt(framesCounter), RECS_WIDTH, -RECS_WIDTH, PLAY_TIME_IN_FRAMES);

                if (rec.height < 0) rec.height = 0;
                if (rec.width < 0) rec.width = 0;

                if ((rec.height == 0) and (rec.width == 0)) state = 1; // Finish playing

                rotation = reasings.linearIn(@floatFromInt(framesCounter), 0.0, 360.0, PLAY_TIME_IN_FRAMES);
            }
        } else if ((state == 1) and rl.isKeyPressed(.space)) {
            // When animation has finished, press space to restart
            framesCounter = 0;

            for (&recs) |*rec| {
                rec.height = RECS_HEIGHT;
                rec.width = RECS_WIDTH;
            }

            state = 0;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);
        if (state == 0) {
            for (recs) |rec| {
                rl.drawRectanglePro(rec, rl.Vector2{
                    .x = rec.width / 2,
                    .y = rec.height / 2,
                }, rotation, .red);
            }
        } else if (state == 1) rl.drawText("PRESS [SPACE] TO PLAY AGAIN!", 240, 200, 20, .gray);

        //----------------------------------------------------------------------------------
    }
}
