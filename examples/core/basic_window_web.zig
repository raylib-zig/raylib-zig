// A raylib-zig port of https://github.com/raysan5/raylib/blob/master/examples/core/core_basic_window_web.c

const rl = @import("raylib");
const builtin = @import("builtin");

const c = if (builtin.os.tag == .emscripten) @cImport({
    @cInclude("emscripten/emscripten.h");
});

//----------------------------------------------------------------------------------
// Global Variables Definition
//----------------------------------------------------------------------------------
const screenWidth = 800;
const screenHeight = 450;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {

    // Initialization
    //--------------------------------------------------------------------------------------
    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context

    if (builtin.os.tag == .emscripten) {
        c.emscripten_set_main_loop(@ptrCast(&updateDrawFrame), 0, 1);
    } else {
        rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

        // Main game loop
        while (!rl.windowShouldClose()) { // Detect window close button or ESC key
            updateDrawFrame();
        }
    }
}

// Update and Draw one frame
fn updateDrawFrame() void {
    // Update
    //----------------------------------------------------------------------------------
    // TODO: Update your variables here
    //----------------------------------------------------------------------------------

    // Draw
    //----------------------------------------------------------------------------------
    rl.beginDrawing();
    defer rl.endDrawing();

    rl.clearBackground(.white);

    rl.drawText("Congrats! You created your first window!", 190, 200, 20, .light_gray);
    //----------------------------------------------------------------------------------
}
