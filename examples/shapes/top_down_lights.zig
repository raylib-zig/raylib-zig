const rl = @import("raylib");
const std = @import("std");

// Custom Blend Modes
const RLGL_SRC_ALPHA = 0x0302;
const RLGL_MIN = 0x8007;
const RLGL_MAX = 0x8008;

const MAX_BOXES = 20;
/// MAX_BOXES *3. Each box can cast up to two shadow volumes for the edges it is away from, and one for the box itself
const MAX_SHADOWS = MAX_BOXES * 3;
const MAX_LIGHTS = 16;

// Shadow geometry type
const ShadowGeometry = struct {
    vertices: [4]rl.Vector2,
};

// Light info type
const LightInfo = struct {
    /// Is this light slot active?
    active: bool,
    /// Does this light need to be updated?
    dirty: bool,
    /// Is this light in a valid position?
    valid: bool,

    /// Light position
    position: rl.Vector2,
    /// Alpha mask for the light
    mask: rl.RenderTexture,
    /// The distance the light touches
    outerRadius: f32,
    /// A cached rectangle of the light bounds to help with culling
    bounds: rl.Rectangle,

    shadows: [MAX_SHADOWS]ShadowGeometry,
    shadowCount: usize,
};

var lights: [MAX_LIGHTS]LightInfo = undefined;

// Move a light and mark it as dirty so that we update it's mask next frame
fn MoveLight(slot: usize, x: f32, y: f32) void {
    lights[slot].dirty = true;
    lights[slot].position.x = x;
    lights[slot].position.y = y;

    // update the cached bounds
    lights[slot].bounds.x = x - lights[slot].outerRadius;
    lights[slot].bounds.y = y - lights[slot].outerRadius;
}

// Compute a shadow volume for the edge
// It takes the edge and projects it back by the light radius and turns it into a quad
fn computeShadowVolumeForEdge(slot: usize, sp: rl.Vector2, ep: rl.Vector2) void {
    if (lights[slot].shadowCount >= MAX_SHADOWS) return;

    const extension = lights[slot].outerRadius * 2;

    const spVector = rl.math.vector2Normalize(rl.math.vector2Subtract(sp, lights[slot].position));
    const spProjection = rl.math.vector2Add(sp, rl.math.vector2Scale(spVector, extension));

    const epVector = rl.math.vector2Normalize(rl.math.vector2Subtract(ep, lights[slot].position));
    const epProjection = rl.math.vector2Add(ep, rl.math.vector2Scale(epVector, extension));

    lights[slot].shadows[lights[slot].shadowCount].vertices[0] = sp;
    lights[slot].shadows[lights[slot].shadowCount].vertices[1] = ep;
    lights[slot].shadows[lights[slot].shadowCount].vertices[2] = epProjection;
    lights[slot].shadows[lights[slot].shadowCount].vertices[3] = spProjection;

    lights[slot].shadowCount += 1;
}

// Draw the light and shadows to the mask for a light
fn drawLightMask(slot: usize) void {
    // Use the light mask
    rl.beginTextureMode(lights[slot].mask);
    defer rl.endTextureMode();

    rl.clearBackground(.white);

    // Force the blend mode to only set the alpha of the destination
    rl.gl.rlSetBlendFactors(RLGL_SRC_ALPHA, RLGL_SRC_ALPHA, RLGL_MIN);
    rl.gl.rlSetBlendMode(@intFromEnum(rl.gl.rlBlendMode.rl_blend_custom));
    // defer going back to normal blend mode
    defer rl.gl.rlSetBlendMode(@intFromEnum(rl.gl.rlBlendMode.rl_blend_alpha));

    // If we are valid, then draw the light radius to the alpha mask
    if (lights[slot].valid) rl.drawCircleGradient(@intFromFloat(lights[slot].position.x), @intFromFloat(lights[slot].position.y), lights[slot].outerRadius, rl.colorAlpha(.white, 0), .white);

    rl.gl.rlDrawRenderBatchActive();

    // Cut out the shadows from the light radius by forcing the alpha to maximum
    rl.gl.rlSetBlendMode(@intFromEnum(rl.gl.rlBlendMode.rl_blend_alpha));
    rl.gl.rlSetBlendFactors(RLGL_SRC_ALPHA, RLGL_SRC_ALPHA, RLGL_MAX);
    rl.gl.rlSetBlendMode(@intFromEnum(rl.gl.rlBlendMode.rl_blend_custom));

    // Draw the shadows to the alpha mask
    for (0..lights[slot].shadowCount) |i| {
        rl.drawTriangleFan(&lights[slot].shadows[i].vertices, .white);
    }

    rl.gl.rlDrawRenderBatchActive();
}

// Setup a light
fn setupLight(slot: usize, x: f32, y: f32, radius: f32) !void {
    lights[slot].active = true;
    lights[slot].valid = false; // The light must prove it is valid
    lights[slot].mask = try rl.loadRenderTexture(rl.getScreenWidth(), rl.getScreenHeight());
    lights[slot].outerRadius = radius;

    lights[slot].bounds.width = radius * 2;
    lights[slot].bounds.height = radius * 2;

    MoveLight(slot, x, y);

    // Force the render texture to have something in it
    drawLightMask(slot);
}

// See if a light needs to update it's mask
// fn UpdateLight(slot: usize, Rectangle* boxes, int count) bool
fn updateLight(slot: usize, boxes: []rl.Rectangle) bool {
    if (!lights[slot].active or !lights[slot].dirty) return false;

    lights[slot].dirty = false;
    lights[slot].shadowCount = 0;
    lights[slot].valid = false;

    for (boxes) |box| {
        // Are we in a box? if so we are not valid
        if (rl.checkCollisionPointRec(lights[slot].position, box)) return false;

        // If this box is outside our bounds, we can skip it
        if (!rl.checkCollisionRecs(lights[slot].bounds, box)) continue;

        // Check the edges that are on the same side we are, and cast shadow volumes out from them

        // Top
        var sp = rl.Vector2{ .x = box.x, .y = box.y };
        var ep = rl.Vector2{ .x = box.x + box.width, .y = box.y };

        if (lights[slot].position.y > ep.y) computeShadowVolumeForEdge(slot, sp, ep);

        // Right
        sp = ep;
        ep.y += box.height;
        if (lights[slot].position.x < ep.x) computeShadowVolumeForEdge(slot, sp, ep);

        // Bottom
        sp = ep;
        ep.x -= box.width;
        if (lights[slot].position.y < ep.y) computeShadowVolumeForEdge(slot, sp, ep);

        // Left
        sp = ep;
        ep.y -= box.height;
        if (lights[slot].position.x > ep.x) computeShadowVolumeForEdge(slot, sp, ep);

        // The box itself
        lights[slot].shadows[lights[slot].shadowCount].vertices[0] = rl.Vector2{ .x = box.x, .y = box.y };
        lights[slot].shadows[lights[slot].shadowCount].vertices[1] = rl.Vector2{ .x = box.x, .y = box.y + box.height };
        lights[slot].shadows[lights[slot].shadowCount].vertices[2] = rl.Vector2{ .x = box.x + box.width, .y = box.y + box.height };
        lights[slot].shadows[lights[slot].shadowCount].vertices[3] = rl.Vector2{ .x = box.x + box.width, .y = box.y };
        lights[slot].shadowCount += 1;
    }

    lights[slot].valid = true;

    drawLightMask(slot);

    return true;
}

// Set up some boxes
fn setupBoxes(boxes: []rl.Rectangle) void {
    boxes[0] = rl.Rectangle{ .x = 150, .y = 80, .width = 40, .height = 40 };
    boxes[1] = rl.Rectangle{ .x = 1200, .y = 700, .width = 40, .height = 40 };
    boxes[2] = rl.Rectangle{ .x = 200, .y = 600, .width = 40, .height = 40 };
    boxes[3] = rl.Rectangle{ .x = 1000, .y = 50, .width = 40, .height = 40 };
    boxes[4] = rl.Rectangle{ .x = 500, .y = 350, .width = 40, .height = 40 };

    for (5..boxes.len) |i| {
        boxes[i] = rl.Rectangle{
            .x = @floatFromInt(rl.getRandomValue(0, rl.getScreenWidth())),
            .y = @floatFromInt(rl.getRandomValue(0, rl.getScreenHeight())),
            .width = @floatFromInt(rl.getRandomValue(10, 100)),
            .height = @floatFromInt(rl.getRandomValue(10, 100)),
        };
    }
}

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [shapes] example - top down lights");
    defer rl.closeWindow(); // Close window and OpenGL context

    // Initialize our 'world' of boxes
    var boxes: [MAX_BOXES]rl.Rectangle = undefined;
    setupBoxes(&boxes);

    // Create a checkerboard ground texture
    const img = rl.genImageChecked(64, 64, 32, 32, .dark_brown, .dark_gray);
    defer rl.unloadImage(img);
    const backgroundTexture = try rl.loadTextureFromImage(img);
    defer rl.unloadTexture(backgroundTexture);

    // Create a global light mask to hold all the blended lights
    const lightMask = try rl.loadRenderTexture(rl.getScreenWidth(), rl.getScreenHeight());
    defer rl.unloadRenderTexture(lightMask);

    // Setup initial light
    try setupLight(0, 600, 400, 300);
    defer {
        //deinitialize light
        for (&lights) |*light| {
            if (light.active) rl.unloadRenderTexture(light.mask);
        }
    }
    var nextLight: usize = 1;

    var showLines = false;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // Drag light 0
        if (rl.isMouseButtonDown(.left)) MoveLight(0, rl.getMousePosition().x, rl.getMousePosition().y);

        // Make a new light
        if (rl.isMouseButtonPressed(.right) and (nextLight < MAX_LIGHTS)) {
            try setupLight(nextLight, rl.getMousePosition().x, rl.getMousePosition().y, 200);
            nextLight += 1;
        }

        // Toggle debug info
        if (rl.isKeyPressed(.f1)) showLines = !showLines;

        // Update the lights and keep track if any were dirty so we know if we need to update the master light mask
        var dirtyLights = false;
        for (0..MAX_LIGHTS) |i| {
            if (updateLight(i, &boxes)) dirtyLights = true;
        }

        // Update the light mask
        if (dirtyLights) {
            // Build up the light mask
            rl.beginTextureMode(lightMask);
            defer rl.endTextureMode();

            rl.clearBackground(.black);

            // Force the blend mode to only set the alpha of the destination
            rl.gl.rlSetBlendFactors(RLGL_SRC_ALPHA, RLGL_SRC_ALPHA, RLGL_MIN);
            rl.gl.rlSetBlendMode(@intFromEnum(rl.gl.rlBlendMode.rl_blend_custom));
            defer rl.gl.rlSetBlendMode(@intFromEnum(rl.gl.rlBlendMode.rl_blend_alpha));

            // Merge in all the light masks
            for (lights) |light| {
                if (light.active) rl.drawTextureRec(light.mask.texture, rl.Rectangle{
                    .x = 0,
                    .y = 0,
                    .width = @floatFromInt(rl.getScreenWidth()),
                    .height = @floatFromInt(-rl.getScreenHeight()),
                }, rl.Vector2.zero(), .white);
            }

            rl.gl.rlDrawRenderBatchActive();
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);

        // Draw the tile background
        rl.drawTextureRec(backgroundTexture, rl.Rectangle{
            .x = 0,
            .y = 0,
            .width = @floatFromInt(rl.getScreenWidth()),
            .height = @floatFromInt(rl.getScreenHeight()),
        }, rl.Vector2.zero(), .white);

        // Overlay the shadows from all the lights
        rl.drawTextureRec(lightMask.texture, rl.Rectangle{
            .x = 0,
            .y = 0,
            .width = @floatFromInt(rl.getScreenWidth()),
            .height = @floatFromInt(-rl.getScreenHeight()),
        }, rl.Vector2.zero(), rl.colorAlpha(.white, if (showLines) 0.75 else 1.0));

        // Draw the lights
        for (0..MAX_LIGHTS) |i| {
            if (lights[i].active) rl.drawCircle(@intFromFloat(lights[i].position.x), @intFromFloat(lights[i].position.y), 10, if (i == 0) .yellow else .white);
        }

        if (showLines) {
            for (0..lights[0].shadowCount) |s| {
                rl.drawTriangleFan(&lights[0].shadows[s].vertices, .dark_purple);
            }

            for (boxes) |box| {
                if (rl.checkCollisionRecs(box, lights[0].bounds)) rl.drawRectangleRec(box, .purple);

                rl.drawRectangleLines(@intFromFloat(box.x), @intFromFloat(box.y), @intFromFloat(box.width), @intFromFloat(box.height), .dark_blue);
            }

            rl.drawText("(F1) Hide Shadow Volumes", 10, 50, 10, .green);
        } else {
            rl.drawText("(F1) Show Shadow Volumes", 10, 50, 10, .green);
        }

        rl.drawFPS(screenWidth - 80, 10);
        rl.drawText("Drag to move light #1", 10, 10, 10, .dark_green);
        rl.drawText("Right click to add new light", 10, 30, 10, .dark_green);
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------

    //--------------------------------------------------------------------------------------

}
