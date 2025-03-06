#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
  PROJECT_NAME='Project'
else
  PROJECT_NAME=$1
fi

mkdir "$PROJECT_NAME" && cd "$PROJECT_NAME" || exit
touch build.zig
echo "Generating project files..."
echo 'const std = @import("std");
const rlz = @import("raylib_zig");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    
    const raylib_dep = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib = raylib_dep.module("raylib");
    const raylib_artifact = raylib_dep.artifact("raylib");

    //web exports are completely separate
    if (target.query.os_tag == .emscripten) {
        const exe_lib = try rlz.emcc.compileForEmscripten(b, "'$PROJECT_NAME'", "src/main.zig", target, optimize);

        exe_lib.linkLibrary(raylib_artifact);
        exe_lib.root_module.addImport("raylib", raylib);

        // Note that raylib itself is not actually added to the exe_lib output file, so it also needs to be linked with emscripten.
        const link_step = try rlz.emcc.linkWithEmscripten(b, &[_]*std.Build.Step.Compile{ exe_lib, raylib_artifact });
        //this lets your program access files like "resources/my-image.png":
        link_step.addArg("--embed-file");
        link_step.addArg("resources/");

        b.getInstallStep().dependOn(&link_step.step);
        const run_step = try rlz.emcc.emscriptenRunStep(b);
        run_step.step.dependOn(&link_step.step);
        const run_option = b.step("run", "Run '$PROJECT_NAME'");
        run_option.dependOn(&run_step.step);
        return;
    }

    const exe = b.addExecutable(.{ .name = "'$PROJECT_NAME'", .root_source_file = b.path("src/main.zig"), .optimize = optimize, .target = target });

    exe.linkLibrary(raylib_artifact);
    exe.root_module.addImport("raylib", raylib);

    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run '$PROJECT_NAME'");
    run_step.dependOn(&run_cmd.step);

    b.installArtifact(exe);
}' >> build.zig

echo '.{
    .name = .raylib_zig,
    .version = "0.0.1",
    .fingerprint = 0xc4cfa8c610114f28,
    .dependencies = .{
        .raylib = .{
            .url = "git+https://github.com/raysan5/raylib#e70f9157bcae046804e754e98a2694adcfdbfa5d",
            .hash = "1220f6aef0d678ba6e3d67a60069b5f32dc965a930c797f463840d224759d615b864",
        },
        .raygui = .{
            .url = "git+https://github.com/raysan5/raygui#76b36b597edb70ffaf96f046076adc20d67e7827",
            .hash = "1220ce6e40b454766d901ac4a19b2408f84365fcad4e4840c788b59f34a0ed698883",
        },
        .raylib_zig = .{
            .url = "git+https://github.com/Not-Nik/raylib-zig?ref=devel#57a8a21b486af47d62cb8ce39a0c7902019a86d2",
            .hash = "raylib_zig-5.6.0-dev-KE8RELUtBQD9ynf9BONdwukHlR4Ib8k_hZZUkqUPO7uJ",
        },
    },
    .paths = .{""},
}' >> build.zig.zon

zig fetch --save git+https://github.com/Not-Nik/raylib-zig#devel

mkdir src
mkdir resources
touch resources/placeholder.txt

cp ../examples/core/basic_window.zig src/main.zig
