// raylib-zig (c) 2025 Maicon Santana (@maiconpintoabreu)

const builtin = @import("builtin");
const rl = @import("raylib");

const GLSL_VERSION: i16 = if (builtin.cpu.arch.isWasm()) 100 else 330;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - monitor change");
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer rl.closeWindow(); // Close window and OpenGL context

    // Texture to test static drawing
    const fudesumi: rl.Texture2D = try rl.loadTexture("examples/shaders/resources/fudesumi.png");
    defer fudesumi.unload();
    // Texture to test moving drawing
    const raysan: rl.Texture2D = try rl.loadTexture("examples/shaders/resources/raysan.png");
    defer raysan.unload();

    // Load shader to be used on postprocessing
    const shader: rl.Shader = try rl.loadShader(
        null,
        rl.textFormat("examples/shaders/resources/shaders/glsl%i/ascii.fs", .{GLSL_VERSION}),
    );

    // These locations are used to send data to the GPU
    const resolutionLoc: i32 = rl.getShaderLocation(shader, "resolution");
    const fontSizeLoc: i32 = rl.getShaderLocation(shader, "fontSize");

    // Set the character size for the ASCII effect
    // Fontsize should be 9 or more
    var fontSize: f32 = 9.0;

    // Send the updated values to the shader
    const resolution: rl.Vector2 = .{ .x = @floatFromInt(screenWidth), .y = @floatFromInt(screenHeight) };
    rl.setShaderValue(shader, resolutionLoc, &resolution, .vec2);

    var circlePos: rl.Vector2 = .{ .x = 40.0, .y = @as(f32, @floatFromInt(screenHeight)) * 0.5 };
    var circleSpeed: f32 = 1.0;

    // RenderTexture to apply the postprocessing later
    const target: rl.RenderTexture2D = try rl.loadRenderTexture(screenWidth, screenHeight);

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        circlePos.x += circleSpeed;
        if ((circlePos.x > 200.0) or (circlePos.x < 40.0)) circleSpeed *= -1; // Revert speed

        if (rl.isKeyPressed(.left) and (fontSize > 9.0)) fontSize -= 1.0; // Reduce fontSize
        if (rl.isKeyPressed(.right) and (fontSize < 15.0)) fontSize += 1.0; // Increase fontSize

        // Set fontsize for the shader
        rl.setShaderValue(shader, fontSizeLoc, &fontSize, .float);

        // Draw
        //----------------------------------------------------------------------------------
        {
            rl.beginTextureMode(target);
            defer rl.endTextureMode();

            rl.clearBackground(.white);

            // Draw scene in our render texture
            rl.drawTexture(fudesumi, 500, -30, .white);
            rl.drawTextureV(raysan, circlePos, .white);
        }
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(.ray_white);
        {
            rl.beginShaderMode(shader);
            defer rl.endShaderMode();
            // Draw the scene texture (that we rendered earlier) to the screen
            // The shader will process every pixel of this texture
            rl.drawTextureRec(target.texture, .{
                .x = 0,
                .y = 0,
                .width = @floatFromInt(target.texture.width),
                .height = -@as(f32, @floatFromInt(target.texture.height)),
            }, .zero(), .white);
        }

        rl.drawRectangle(0, 0, screenWidth, 40, .black);
        rl.drawText(rl.textFormat("Ascii effect - FontSize:%2.0f - [Left] -1 [Right] +1 ", .{fontSize}), 120, 10, 20, .light_gray);
        rl.drawFPS(10, 10);
        //----------------------------------------------------------------------------------
    }
}
