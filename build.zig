// raylib-zig (c) Nikolas Wipper 2020-2024

const std = @import("std");
const this = @This();
const rl = @import("raylib");

pub const emcc = @import("emcc.zig");

pub const Options = struct {
    raudio: bool = true,
    rmodels: bool = true,
    rshapes: bool = true,
    rtext: bool = true,
    rtextures: bool = true,
    platform: PlatformBackend = .glfw,
    shared: bool = false,
    linux_display_backend: LinuxDisplayBackend = .X11,
    opengl_version: OpenglVersion = .auto,
};

pub const OpenglVersion = enum {
    auto,
    gl_1_1,
    gl_2_1,
    gl_3_3,
    gl_4_3,
    gles_2,
    gles_3,
};

pub const LinuxDisplayBackend = enum { X11, Wayland, Both };

pub const PlatformBackend = enum {
    glfw,
    rgfw,
    sdl,
    drm,
};

const Program = struct {
    name: []const u8,
    path: []const u8,
    desc: []const u8,
};

fn link(
    b: *std.Build,
    exe: *std.Build.Step.Compile,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    options: Options,
) !void {
    const lib = try getRaylib(b, target, optimize, options);

    const target_os = exe.rootModuleTarget().os.tag;
    switch (target_os) {
        .windows => {
            exe.linkSystemLibrary("winmm");
            exe.linkSystemLibrary("gdi32");
            exe.linkSystemLibrary("opengl32");
        },
        .macos => {
            exe.linkFramework("OpenGL");
            exe.linkFramework("Cocoa");
            exe.linkFramework("IOKit");
            exe.linkFramework("CoreAudio");
            exe.linkFramework("CoreVideo");
        },
        .freebsd, .openbsd, .netbsd, .dragonfly => {
            exe.linkSystemLibrary("GL");
            exe.linkSystemLibrary("rt");
            exe.linkSystemLibrary("dl");
            exe.linkSystemLibrary("m");
            exe.linkSystemLibrary("X11");
            exe.linkSystemLibrary("Xrandr");
            exe.linkSystemLibrary("Xinerama");
            exe.linkSystemLibrary("Xi");
            exe.linkSystemLibrary("Xxf86vm");
            exe.linkSystemLibrary("Xcursor");
        },
        .emscripten, .wasi => {
            // When using emscripten, the libries don't need to be linked
            // because emscripten is going to do that later.
        },
        else => { // Linux and possibly others.
            exe.linkSystemLibrary("GL");
            exe.linkSystemLibrary("rt");
            exe.linkSystemLibrary("dl");
            exe.linkSystemLibrary("m");
            exe.linkSystemLibrary("X11");
        },
    }

    exe.linkLibrary(lib);
}

var _raylib_lib_cache: ?*std.Build.Step.Compile = null;
fn getRaylib(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, options: Options) !*std.Build.Step.Compile {
    if (_raylib_lib_cache) |lib| return lib else {
        const raylib = b.dependency("raylib", .{
            .target = target,
            .optimize = optimize,
            .raudio = options.raudio,
            .rmodels = options.rmodels,
            .rshapes = options.rshapes,
            .rtext = options.rtext,
            .rtextures = options.rtextures,
            .platform = options.platform,
            .shared = options.shared,
            .linux_display_backend = options.linux_display_backend,
            .opengl_version = options.opengl_version,
        });

        const lib = raylib.artifact("raylib");

        const raygui_dep = b.dependency("raygui", .{
            .target = target,
            .optimize = optimize,
        });

        var gen_step = b.addWriteFiles();
        lib.step.dependOn(&gen_step.step);

        const raygui_c_path = gen_step.add("raygui.c", "#define RAYGUI_IMPLEMENTATION\n#include \"raygui.h\"\n");

        var raylib_flags_arr = std.ArrayList([]const u8).init(b.allocator);
        defer raylib_flags_arr.deinit();

        try raylib_flags_arr.appendSlice(&[_][]const u8{
            "-std=gnu99",
            "-D_GNU_SOURCE",
            "-DGL_SILENCE_DEPRECATION=199309L",
            "-fno-sanitize=undefined", // https://github.com/raysan5/raylib/issues/3674
        });

        if (options.shared) {
            try raylib_flags_arr.appendSlice(&[_][]const u8{
                "-fPIC",
                "-DBUILD_LIBTYPE_SHARED",
            });
        }

        lib.addCSourceFile(.{
            .file = raygui_c_path,
            .flags = raylib_flags_arr.items,
        });

        lib.addIncludePath(raylib.path("src"));
        lib.addIncludePath(raygui_dep.path("src"));

        lib.installHeader(raygui_dep.path("src/raygui.h"), "raygui.h");

        b.installArtifact(lib);
        _raylib_lib_cache = lib;
        return lib;
    }
}

fn getModule(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Module {
    if (b.modules.contains("raylib")) {
        return b.modules.get("raylib").?;
    }
    return b.addModule("raylib", .{
        .root_source_file = b.path("lib/raylib.zig"),
        .target = target,
        .optimize = optimize,
    });
}

const gui = struct {
    fn getModule(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Module {
        const raylib = this.getModule(b, target, optimize);
        return b.addModule("raygui", .{
            .root_source_file = b.path("lib/raygui.zig"),
            .imports = &.{.{ .name = "raylib-zig", .module = raylib }},
            .target = target,
            .optimize = optimize,
        });
    }
};

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const defaults = Options{};
    const options = Options{
        .platform = b.option(PlatformBackend, "platform", "Compile raylib in native mode (no X11)") orelse defaults.platform,
        .raudio = b.option(bool, "raudio", "Compile with audio support") orelse defaults.raudio,
        .rmodels = b.option(bool, "rmodels", "Compile with models support") orelse defaults.rmodels,
        .rtext = b.option(bool, "rtext", "Compile with text support") orelse defaults.rtext,
        .rtextures = b.option(bool, "rtextures", "Compile with textures support") orelse defaults.rtextures,
        .rshapes = b.option(bool, "rshapes", "Compile with shapes support") orelse defaults.rshapes,
        .shared = b.option(bool, "shared", "Compile as shared library") orelse defaults.shared,
        .linux_display_backend = b.option(LinuxDisplayBackend, "linux_display_backend", "Linux display backend to use") orelse defaults.linux_display_backend,
        .opengl_version = b.option(OpenglVersion, "opengl_version", "OpenGL version to use") orelse defaults.opengl_version,
    };

    const examples = [_]Program{
        .{
            .name = "raw_stream",
            .path = "examples/audio/raw_stream.zig",
            .desc = "Plays a sine wave",
        },
        .{
            .name = "music_stream",
            .path = "examples/audio/music_stream.zig",
            .desc = "Use music stream to play an audio file",
        },
        .{
            .name = "sound_loading",
            .path = "examples/audio/sound_loading.zig",
            .desc = "Load and play a song",
        },
        .{
            .name = "module_playing",
            .path = "examples/audio/module_playing.zig",
            .desc = "Module playing (streaming)",
        },
        .{
            .name = "basic_screen_manager",
            .path = "examples/core/basic_screen_manager.zig",
            .desc = "Illustrates simple screen manager based on a state machine",
        },
        .{
            .name = "basic_window",
            .path = "examples/core/basic_window.zig",
            .desc = "Creates a basic window with text",
        },
        .{
            .name = "input_keys",
            .path = "examples/core/input_keys.zig",
            .desc = "Simple keyboard input",
        },
        .{
            .name = "input_mouse",
            .path = "examples/core/input_mouse.zig",
            .desc = "Simple mouse input",
        },
        .{
            .name = "input_mouse_wheel",
            .path = "examples/core/input_mouse_wheel.zig",
            .desc = "Mouse wheel input",
        },
        .{
            .name = "input_multitouch",
            .path = "examples/core/input_multitouch.zig",
            .desc = "Multitouch input",
        },
        .{
            .name = "2d_camera",
            .path = "examples/core/2d_camera.zig",
            .desc = "Shows the functionality of a 2D camera",
        },
        .{
            .name = "3d_camera_first_person",
            .path = "examples/core/3d_camera_first_person.zig",
            .desc = "Simple first person demo",
        },
        .{
            .name = "3d_camera_free",
            .path = "examples/core/3d_camera_free.zig",
            .desc = "Shows basic 3d camera initialization",
        },
        .{
            .name = "2d_camera_mouse_zoom",
            .path = "examples/core/2d_camera_mouse_zoom.zig",
            .desc = "Shows mouse zoom demo",
        },
        .{
            .name = "3d_picking",
            .path = "examples/core/3d_picking.zig",
            .desc = "Shows picking in 3d mode",
        },
        .{
            .name = "window_flags",
            .path = "examples/core/window_flags.zig",
            .desc = "Demonstrates various flags used during and after window creation",
        },
        .{
            .name = "raymarching",
            .path = "examples/shaders/raymarching.zig",
            .desc = "Uses a raymarching in a shader to render shapes",
        },
        .{
            .name = "texture_outline",
            .path = "examples/shaders/texture_outline.zig",
            .desc = "Uses a shader to create an outline around a sprite",
        },
        .{
            .name = "logo_raylib",
            .path = "examples/shapes/logo_raylib.zig",
            .desc = "Renders the raylib-zig logo",
        },
        .{
            .name = "logo_raylib_anim",
            .path = "examples/shapes/logo_raylib_anim.zig",
            .desc = "Animates the raylib logo",
        },
        .{
            .name = "basic_shapes",
            .path = "examples/shapes/basic_shapes.zig",
            .desc = "Renders various shapes",
        },
        .{
            .name = "bouncing_ball",
            .path = "examples/shapes/bouncing_ball.zig",
            .desc = "Bouncing ball animation with collision detection",
        },
        .{
            .name = "collision_area",
            .path = "examples/shapes/collision_area.zig",
            .desc = "Demonstrates collision detection",
        },
        .{
            .name = "colors_palette",
            .path = "examples/shapes/colors_palette.zig",
            .desc = "Renders an interactive color palette",
        },
        .{
            .name = "draw_circle_sector",
            .path = "examples/shapes/draw_circle_sector.zig",
            .desc = "Dynamically renders a circle sector using raygui",
        },
        .{
            .name = "draw_rectangle_rounded",
            .path = "examples/shapes/draw_rectangle_rounded.zig",
            .desc = "Dynamically renders a rounded rectangle using raygui",
        },
        .{
            .name = "draw_ring",
            .path = "examples/shapes/draw_ring.zig",
            .desc = "Dynaically renders a ring using raygui",
        },
        .{
            .name = "following_eyes",
            .path = "examples/shapes/following_eyes.zig",
            .desc = "Renders eyes that follow mouse movement",
        },
        .{
            .name = "lines_bezier",
            .path = "examples/shapes/lines_bezier.zig",
            .desc = "Renders an interactive line bezier",
        },
        .{
            .name = "rectangle_scaling",
            .path = "examples/shapes/rectangle_scaling.zig",
            .desc = "Renders a resizable rectangle",
        },
        .{
            .name = "sprite_anim",
            .path = "examples/textures/sprite_anim.zig",
            .desc = "Animate a sprite",
        },
        .{
            .name = "textures_background_scrolling",
            .path = "examples/textures/textures_background_scrolling.zig",
            .desc = "Background scrolling & parallax demo",
        },
        .{
            .name = "text_format_text",
            .path = "examples/text/text_format_text.zig",
            .desc = "Renders variables as text",
        },
        .{
            .name = "text_raylib_fonts",
            .path = "examples/text/text_raylib_fonts.zig",
            .desc = "Show fonts included with raylib",
        },
        .{
            .name = "text_writing_anim",
            .path = "examples/text/text_writing_anim.zig",
            .desc = "Simple text animation",
        },
        .{
            .name = "textures_image_loading",
            .path = "examples/textures/textures_image_loading.zig",
            .desc = "Image loading and texture creation",
        },

        .{
            .name = "models_heightmap",
            .path = "examples/models/models_heightmap.zig",
            .desc = "Heightmap loading and drawing",
        },
        // .{
        //     .name = "shaders_basic_lighting",
        //     .path = "examples/shaders/shaders_basic_lighting.zig",
        //     .desc = "Loads a model and renders it",
        // },
    };

    const raylib = this.getModule(b, target, optimize);
    const raygui = this.gui.getModule(b, target, optimize);

    const raylib_test = b.addTest(.{
        .root_source_file = b.path("lib/raylib.zig"),
        .target = target,
        .optimize = optimize,
    });
    raylib_test.linkLibC();

    const raygui_test = b.addTest(.{
        .root_source_file = b.path("lib/raygui.zig"),
        .target = target,
        .optimize = optimize,
    });
    raygui_test.root_module.addImport("raylib-zig", raylib);
    raygui_test.linkLibC();

    const test_step = b.step("test", "Check for library compilation errors");
    test_step.dependOn(&raylib_test.step);
    test_step.dependOn(&raygui_test.step);

    const examples_step = b.step("examples", "Builds all the examples");

    for (examples) |ex| {
        if (target.query.os_tag == .emscripten) {
            const exe_lib = try emcc.compileForEmscripten(b, ex.name, ex.path, target, optimize);
            exe_lib.root_module.addImport("raylib", raylib);
            exe_lib.root_module.addImport("raygui", raygui);
            const raylib_lib = try getRaylib(b, target, optimize, options);

            // Note that raylib itself isn't actually added to the exe_lib
            // output file, so it also needs to be linked with emscripten.
            exe_lib.linkLibrary(raylib_lib);
            const link_step = try emcc.linkWithEmscripten(b, &[_]*std.Build.Step.Compile{ exe_lib, raylib_lib });
            link_step.addArg("--embed-file");
            link_step.addArg("resources/");

            const run_step = try emcc.emscriptenRunStep(b);
            run_step.step.dependOn(&link_step.step);
            const run_option = b.step(ex.name, ex.desc);

            run_option.dependOn(&run_step.step);
            examples_step.dependOn(&exe_lib.step);
        } else {
            const exe = b.addExecutable(.{
                .name = ex.name,
                .root_source_file = b.path(ex.path),
                .optimize = optimize,
                .target = target,
            });
            try this.link(b, exe, target, optimize, options);
            exe.root_module.addImport("raylib", raylib);
            exe.root_module.addImport("raygui", raygui);

            const run_cmd = b.addRunArtifact(exe);
            const run_step = b.step(ex.name, ex.desc);

            run_step.dependOn(&run_cmd.step);
            examples_step.dependOn(&exe.step);
        }
    }
}
