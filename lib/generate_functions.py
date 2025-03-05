#!/usr/bin/env python3

import re

"""
Automatic utility for generating raylib function headers.
"""

C_TO_ZIG = {
    "bool": "bool",
    "char": "u8",
    "double": "f64",
    "float": "f32",
    "int": "c_int",
    "long": "c_long",
    "unsigned char": "u8",
    "unsigned int": "c_uint",
}

ZIGGIFY = {
    "c_int": "i32",
    "c_long": "i64",
    "c_uint": "u32"
}

IGNORE_TYPES = [
    "[*c]Color",
    "[*c]GlyphInfo",
    "[*c]c_int",
    "[*c]c_uint",
    "[*c][*c]u8",
    "[*c][*c]const u8",
    "[*c]Material",
    "[*c]ModelAnimation",
    "[*c]f32",
]
# Some C types have a different sizes on different systems and Zig
# knows that so we tell it to get the system specific size for us.
def c_to_zig_type(c: str) -> str:
    const = "const " if "const " in c else ""
    c = c.replace("const ", "")
    z = C_TO_ZIG.get(c)

    if z is not None:
        return const + z

    return const + c


def ziggify_type(name: str, t: str, func_name) -> str:
    NO_STRINGS = ["data", "fileData", "compData"]

    single = [
        "value", "ptr", "bytesRead", "compDataSize", "dataSize", "outputSize",
        "camera", "collisionPoint", "frames", "image", "colorCount", "dst",
        "texture", "srcPtr", "dstPtr", "count", "codepointSize", "utf8Size",
        "position", "mesh", "materialCount", "material", "model", "animCount",
        "wave", "v1", "v2", "outAxis", "outAngle", "fileSize",
        "AutomationEventList", "list", "batch", "glInternalFormat", "glFormat",
        "glType", "mipmaps", "active", "scroll", "view", "checked", "mouseCell",
        "scrollIndex", "focus", "secretViewActive", "color", "alpha", "colorHsv",
        "translation", "rotation", "scale", "mat"
    ]
    multi = [
        "data", "compData", "points", "fileData", "colors", "pixels",
        "fontChars", "chars", "recs", "codepoints", "textList", "transforms",
        "animations", "samples", "LoadImageColors", "LoadImagePalette",
        "LoadFontData", "LoadCodepoints", "TextSplit", "LoadMaterials",
        "LoadModelAnimations", "LoadWaveSamples", "images",
        "LoadRandomSequence", "sequence", "kernel", "GlyphInfo", "glyphs", "glyphRecs",
        "matf", "rlGetShaderLocsDefault", "locs", "GuiGetIcons", "GuiLoadIcons"
    ]
    string = False

    if name == "text" and t == "[*c][*c]const u8":
        return "[][:0]const u8"

    if t.startswith("[*c]") and name not in single and name not in multi:
        if (t == "[*c]const u8" or t == "[*c]u8") and name not in NO_STRINGS:  # Strings are multis.
            string = True
        else:
            raise ValueError(f"{t} {name} not classified")

    pre = ""
    while t.startswith("[*c]"):
        t = t[4:]
        if string and not t.startswith("[*c]"):
            pre += "[:0]"
        elif name in single:
            pre += "*"
        else:
            pre += "[]"

    if t in ZIGGIFY:
        t = ZIGGIFY[t]

    return pre + t


def add_namespace_to_type(t: str) -> str:
    pre = ""
    while t.startswith("[*c]"):
        t = t[4:]
        pre += "[*c]"

    if t.startswith("const "):
        t = t[6:]
        pre += "const "

    if t.startswith("Gui"):
        t = "rgui." + t
    elif t[0].isupper():
        t = "rl." + t
    elif t in ["float3", "float16"]:
        t = "rlm." + t
    elif t.startswith("rl"):
        t = "rlgl." + t

    return pre + t


def make_return_cast(source_type: str, dest_type: str, inner: str) -> str:
    if source_type == dest_type:
        return inner
    if source_type in ["[*c]const u8", "[*c]u8"]:
        return f"std.mem.span({inner})"

    if source_type in ZIGGIFY:
        return f"@as({dest_type}, {inner})"

    # These all have to be done manually because their sizes depend on the
    # function arguments.
    if source_type in IGNORE_TYPES:
        return None
    else:
        raise ValueError(f"Don't know what to do {source_type} {dest_type} {inner}")


def fix_pointer(name: str, t: str):
    pre = ""
    while name.startswith("*"):
        name = name[1:]
        pre += "[*c]"

    t = pre + t

    if t == "[*c]const void":
        t = "*const anyopaque"
    elif t == "[*c]void":
        t = "*anyopaque"
    elif len(pre) == 0:
        t = t.replace("const ", "")
    return name, t


_fix_enums_data = [
    # arg_name,     new_type,                func_name_regex
    ("key",         "KeyboardKey",           r".*"),
    ("mode",        "CameraMode",            r"UpdateCamera"),
    ("mode",        "BlendMode",             r"BeginBlendMode"),
    ("gesture",     "Gesture",               r".*"),
    ("logLevel",    "TraceLogLevel",         r".*"),
    ("ty",          "FontType",              r".*"),
    ("uniformType", "ShaderUniformDataType", r".*"),
    ("cursor",      "MouseCursor",           r".*"),
    ("format",      "PixelFormat",           r".*"),
    ("newFormat",   "PixelFormat",           r".*"),
    ("layout",      "CubemapLayout",         r".*"),
    ("mapType",     "MaterialMapIndex",      r".*"),
    ("filter",      "TextureFilter",         r"SetTextureFilter"),
    ("wrap",        "TextureWrap",           r"SetTextureWrap"),
    ("flags",       "ConfigFlags",           r"SetWindowState|ClearWindowState|SetConfigFlags"),
    ("flag",        "ConfigFlags",           r"IsWindowState"),
    ("flags",       "Gesture",               r"SetGesturesEnabled"),
    ("button",      "GamepadButton",         r".*GamepadButton.*"),
    ("axis",        "GamepadAxis",           r".*GamepadAxis.*"),
    ("button",      "MouseButton",           r".*MouseButton.*"),
    ("control",     "GuiControl",            r"Gui.etStyle"),
#    ("property",    "GuiControlProperty",    r"Gui.etStyle"),
]
def fix_enums(arg_name, arg_type, func_name):
    if func_name.startswith("rl"):
        return arg_type

    # Hacking specific enums in here.
    # Raylib doesn't use the enums but rather the resulting ints.
    if arg_type == "int" or arg_type == "unsigned int":
        for target_arg_name,new_type,func_name_regex in _fix_enums_data:
            if arg_name==target_arg_name and re.fullmatch(func_name_regex,func_name):
                return new_type
    return arg_type


def convert_name_case(name):
    return name[:1].lower() + name[1:] if name else ''


def parse_header(header_name: str, output_file: str, ext_file: str, prefix: str, prelude_file: str, ext_prelude_file: str, skip_after: str = "#/never\\#"):
    header = open(header_name, mode="r")
    ext_heads = []
    zig_funcs = []
    zig_types = set()

    leftover = ""

    for line in header.readlines():
        if line == skip_after:
            break

        if line.startswith("typedef struct"):
            zig_types.add(line.split(' ')[2])
        elif line.startswith("typedef enum"):
            # Don't trip the general typedef case.
            pass
        elif line.startswith("typedef "):
            zig_types.add(line.split(' ')[2].replace(';', '').strip())

        if not line.startswith(prefix):
            continue

        split_line = line.split(";", 1)

        line = split_line[0]
        if len(split_line) > 1:
            desc = split_line[1].lstrip()
            inline_comment = ("/" + desc) if len(desc) > 0 else ""
        else:
            inline_comment = ""


        if leftover:
            line = leftover + line
            leftover = ""

        line = line.replace("* ", " *")

        line = line.replace(",", ", ")
        line = line.replace("  ", " ")

        # Each (.*) is some variable value.
        result = re.search(
            prefix + "(.*) (.*)start_arg(.*)end_arg(.*)",
            line.replace("(", "start_arg").replace(")", "end_arg"),
        )

        if result is None:
            leftover += line
            continue

        # Get whats in the (.*)'s.
        return_type = result.group(1)
        func_name = result.group(2)
        arguments = result.group(3)

        if func_name == "SetTraceLogCallback":
            continue

        return_type = c_to_zig_type(return_type)
        func_name, return_type = fix_pointer(func_name, return_type)

        if func_name == "GetKeyPressed":
            return_type = "KeyboardKey"
        elif func_name == "GetGamepadButtonPressed":
            return_type = "GamepadButton"
        elif func_name == "GetGestureDetected":
            return_type = "Gesture"

        zig_c_arguments = []
        zig_arguments = []
        zig_call_args = []

        if not arguments:
            arguments = "void"

        for arg in arguments.split(", "):
            if arg == "void":
                break
            if arg == "...":
                zig_c_arguments.append("...")
                continue
            # Everything but the last element (for stuff like "const Vector3").
            arg_type = " ".join(arg.split(" ")[0:-1])
            arg_name = arg.split(" ")[-1]  # Last element should be the name.

            if arg_name == "type":
                arg_name = "ty"

            arg_type = fix_enums(arg_name, arg_type, func_name)

            arg_type = c_to_zig_type(arg_type)
            arg_name, arg_type = fix_pointer(arg_name, arg_type)

            single_opt = [
                ("rlDrawVertexArrayElements", "buffer"),
                ("rlDrawVertexArrayElementsInstanced", "buffer"),
                ("rlEnableStatePointer", "buffer"),
                ("rlSetRenderBatchActive", "batch"),
                ("rlLoadTexture", "data"),
                ("rlLoadTextureCubemap", "data"),
                ("rlLoadShaderBuffer", "data"),
                ("rlLoadShaderCode", "vsCode"),
                ("rlLoadShaderCode", "fsCode"),
            ]

            zig_type = ziggify_type(arg_name, arg_type, func_name)

            if zig_type.startswith("*") and (func_name, arg_name) in single_opt:
                if not arg_type.startswith("[*c]"):
                    arg_type = "?" + arg_type
                zig_type = "?" + zig_type

            zig_types.add(arg_type)
            zig_c_arguments.append(arg_name + ": " + add_namespace_to_type(arg_type))  # Put everything together.
            zig_arguments.append(arg_name + ": " + zig_type)
            if arg_type == zig_type:
                zig_call_args.append(arg_name)
            else:
                if arg_type.startswith("[*c]"):
                    zig_call_args.append(f"@as({arg_type}, @ptrCast({arg_name}))")
                else:
                    zig_call_args.append(f"@as({arg_type}, {arg_name})")
        zig_c_arguments = ", ".join(zig_c_arguments)

        ext_ret = add_namespace_to_type(return_type)
        ext_heads.append(f"pub extern \"c\" fn {func_name}({zig_c_arguments}) {ext_ret};")

        zig_name = convert_name_case(func_name)

        # TODO: Ziggify return type
        zig_arguments = ", ".join(zig_arguments)
        zig_call_args = ", ".join(zig_call_args)

        manual = [
            "TextFormat",
            "TraceLog",
            "LoadShader",
            "ExportDataAsCode",
            "LoadFileData",
            "SaveFileData",
            "LoadImage",
            "LoadImageRaw",
            "LoadImageAnim",
            "LoadImageFromTexture",
            "LoadImageFromScreen",
            "LoadImageFromMemory",
            "LoadMaterialDefault",
            "LoadMaterials",
            "LoadModel",
            "LoadModelFromMesh",
            "LoadTexture",
            "LoadTextureFromImage",
            "LoadTextureCubemap",
            "LoadRenderTexture",
            "LoadWave",
            "LoadSound",
            "LoadMusicStream",
            "LoadAudioStream",
            "DrawMeshInstanced",
            "UnloadModelAnimations",
            "CompressData",
            "DecompressData",
            "EncodeDataBase64",
            "DecodeDataBase64",
            "ComputeCRC32",
            "ComputeMD5",
            "ComputeSHA1",
            "SetWindowIcons",
            "CheckCollisionPointPoly",
            "ColorToInt",
            "GetFontDefault",
            "LoadFont",
            "LoadFontEx",
            "LoadFontFromImage",
            "ImageText",
            "ImageTextEx",
            "GenImageFontAtlas",
            "UnloadFontData",
            "DrawTextCodepoints",
            "LoadUTF8",
            "TextJoin",
            "DrawLineStrip",
            "DrawTriangleFan",
            "DrawTriangleStrip",
            "DrawTriangleStrip3D",
            "GuiTabBar",
            "GuiListViewEx",
            "GuiPanel",
            "GuiScrollPanel",
            "DrawSplineLinear",
            "DrawSplineBasis",
            "DrawSplineCatmullRom",
            "DrawSplineBezierQuadratic",
            "DrawSplineBezierCubic",
            "ImageKernelConvolution",
            "GuiSetStyle",
            "GuiGetStyle"
        ]

        if func_name in manual or "FromMemory" in func_name:
            continue

        zig_return = ziggify_type(func_name, return_type, func_name)
        return_cast = make_return_cast(return_type, zig_return, f"cdef.{func_name}({zig_call_args})")

        if return_cast:
            zig_funcs.append(
                inline_comment +
                f"pub fn {zig_name}({zig_arguments}) {zig_return}" +
                " {\n    " +
                ("return " if zig_return != "void" else "") +
                return_cast + ";"
                "\n}"
            )

    prelude = open(prelude_file, mode="r").read()
    ext_prelude = open(ext_prelude_file, mode="r").read()

    ext_header = open(ext_file, mode="w")
    print(ext_prelude, file=ext_header)
    print("\n".join(ext_heads), file=ext_header)

    zig_header = open(output_file, mode="w")
    print(prelude, file=zig_header)
    print("\n\n".join(zig_funcs), file=zig_header)


if __name__ == "__main__":
    parse_header(
        "raylib.h",
        "raylib.zig",
        "raylib-ext.zig",
        "RLAPI ",
        "preludes/raylib-prelude.zig",
        "preludes/raylib-ext-prelude.zig"
    )
    parse_header(
        "raymath.h",
        "raymath.zig",
        "raymath-ext.zig",
        "RMAPI ",
        "preludes/raymath-prelude.zig",
        "preludes/raymath-ext-prelude.zig"
    )
    parse_header(
        "rlgl.h",
        "rlgl.zig",
        "rlgl-ext.zig",
        "RLAPI ",
        "preludes/rlgl-prelude.zig",
        "preludes/rlgl-ext-prelude.zig",
        "#if defined(RLGL_IMPLEMENTATION)\n"
    )
    parse_header(
        "raygui.h",
        "raygui.zig",
        "raygui-ext.zig",
        "RAYGUIAPI ",
        "preludes/raygui-prelude.zig",
        "preludes/raygui-ext-prelude.zig",
        "#if defined(RAYGUI_IMPLEMENTATION)\n"
    )
