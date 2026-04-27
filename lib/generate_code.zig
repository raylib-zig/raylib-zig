//! Automatic utility for generating the code.

const std = @import("std");

const eql = std.mem.eql;
const startsWith = std.mem.startsWith;
const endsWith = std.mem.endsWith;
const concat = std.mem.concat;
const join = std.mem.join;
const replace = std.mem.replace;
const replaceOwned = std.mem.replaceOwned;
const allocPrint = std.fmt.allocPrint;

const ArrayList = std.ArrayList;

const C_TO_ZIG: std.StaticStringMap([]const u8) = .initComptime(.{
    .{ "bool", "bool" },
    .{ "char", "u8" },
    .{ "double", "f64" },
    .{ "float", "f32" },
    .{ "int", "c_int" },
    .{ "long", "c_long" },
    .{ "unsigned char", "u8" },
    .{ "unsigned int", "c_uint" },
});

const ZIGGIFY: std.StaticStringMap([]const u8) = .initComptime(.{
    .{ "c_int", "i32" },
    .{ "c_long", "i64" },
    .{ "c_uint", "u32" },
});

const IGNORE_C_TYPE: std.StaticStringMap(void) = .initComptime(.{
    .{"rlGetShaderLocsDefault"},
});

const TRIVIAL_SIZE: std.StaticStringMap(void) = .initComptime(.{
    .{"LoadFileData"},
    .{"CompressData"},
    .{"DecompressData"},
    .{"EncodeDataBase64"},
    .{"DecodeDataBase64"},
    .{"ExportImageToMemory"},
    .{"LoadImagePalette"},
    .{"LoadCodepoints"},
    .{"TextSplit"},
    // .{"LoadMaterials"},
    .{"LoadModelAnimations"},
});

const HAS_ERROR = TRIVIAL_SIZE;

// todo: Make this automatic, by adding a IsXValid check in this script
const MANUAL: std.StaticStringMap(void) = .initComptime(.{
    .{"TextFormat"},
    .{"TraceLog"},
    .{"LoadShader"},
    .{"LoadRandomSequence"},
    .{"ExportDataAsCode"},
    .{"SaveFileData"},
    .{"LoadImage"},
    .{"LoadImageRaw"},
    .{"LoadImageAnim"},
    .{"LoadImageFromTexture"},
    .{"LoadImageFromScreen"},
    .{"LoadImageFromMemory"},
    .{"LoadImageColors"},
    .{"LoadMaterialDefault"},
    .{"LoadMaterials"},
    .{"LoadModel"},
    .{"LoadModelFromMesh"},
    .{"LoadTexture"},
    .{"LoadTextureFromImage"},
    .{"LoadTextureCubemap"},
    .{"LoadRenderTexture"},
    .{"LoadWave"},
    .{"LoadWaveSamples"},
    .{"LoadSound"},
    .{"LoadMusicStream"},
    .{"LoadAudioStream"},
    .{"DrawMeshInstanced"},
    .{"UnloadModelAnimations"},
    .{"ComputeCRC32"},
    .{"ComputeMD5"},
    .{"ComputeSHA1"},
    .{"ComputeSHA256"},
    .{"SetWindowIcons"},
    .{"CheckCollisionPointPoly"},
    .{"ColorToInt"},
    .{"GetFontDefault"},
    .{"LoadFont"},
    .{"LoadFontEx"},
    .{"LoadFontFromImage"},
    .{"LoadFontData"},
    .{"ImageText"},
    .{"ImageTextEx"},
    .{"GenImageFontAtlas"},
    .{"UnloadFontData"},
    .{"DrawTextCodepoints"},
    .{"LoadUTF8"},
    .{"LoadTextLines"},
    .{"UnloadTextLines"},
    .{"TextJoin"},
    .{"DrawLineStrip"},
    .{"DrawTriangleFan"},
    .{"DrawTriangleStrip"},
    .{"DrawTriangleStrip3D"},
    .{"GuiTabBar"},
    .{"GuiListViewEx"},
    .{"GuiPanel"},
    .{"GuiScrollPanel"},
    .{"GuiButton"},
    .{"GuiLabelButton"},
    .{"GuiCheckBox"},
    .{"GuiTextBox"},
    .{"DrawSplineLinear"},
    .{"DrawSplineBasis"},
    .{"DrawSplineCatmullRom"},
    .{"DrawSplineBezierQuadratic"},
    .{"DrawSplineBezierCubic"},
    .{"ImageKernelConvolution"},
    .{"GuiGetIcons"},
    .{"GuiLoadIcons"},
    .{"GuiSetStyle"},
    .{"GuiGetStyle"},
});

/// Some C types have a different sizes on different systems and Zig
/// knows that so we tell it to get the system specific size for us.
fn cToZigType(allocator: std.mem.Allocator, c: []const u8) ![]const u8 {
    const const_string = "const ";

    const c_ = try replaceOwned(u8, allocator, c, const_string, "");
    defer allocator.free(c_);

    const prefix = if (c_.len < c.len) const_string else "";
    const base = C_TO_ZIG.get(c_) orelse c_;

    return try concat(allocator, u8, &.{ prefix, base });
}

test "c to zig type" {
    const allocator = std.testing.allocator;
    const expectEqualStrings = std.testing.expectEqualStrings;

    const c_type = try cToZigType(allocator, "char");
    defer allocator.free(c_type);
    try expectEqualStrings("u8", c_type);

    const c_type_const = try cToZigType(allocator, "const int");
    defer allocator.free(c_type_const);
    try expectEqualStrings("const c_int", c_type_const);
}

const _NO_STRINGS: std.StaticStringMap(void) = .initComptime(.{
    .{"data"},
    .{"fileData"},
    .{"compData"},
});

const _SINGLE: std.StaticStringMap(void) = .initComptime(.{
    .{"value"},               .{"ptr"},            .{"bytesRead"},
    .{"compDataSize"},        .{"dataSize"},       .{"outputSize"},
    .{"camera"},              .{"collisionPoint"}, .{"frames"},
    .{"image"},               .{"colorCount"},     .{"dst"},
    .{"texture"},             .{"srcPtr"},         .{"dstPtr"},
    .{"count"},               .{"codepointSize"},  .{"utf8Size"},
    .{"position"},            .{"mesh"},           .{"materialCount"},
    .{"material"},            .{"model"},          .{"animCount"},
    .{"wave"},                .{"v1"},             .{"v2"},
    .{"outAxis"},             .{"outAngle"},       .{"fileSize"},
    .{"AutomationEventList"}, .{"list"},           .{"batch"},
    .{"glInternalFormat"},    .{"glFormat"},       .{"glType"},
    .{"mipmaps"},             .{"active"},         .{"scroll"},
    .{"view"},                .{"checked"},        .{"mouseCell"},
    .{"scrollIndex"},         .{"focus"},          .{"secretViewActive"},
    .{"color"},               .{"alpha"},          .{"colorHsv"},
    .{"translation"},         .{"rotation"},       .{"scale"},
    .{"mat"},                 .{"glyphCount"},
});

const _MULTI: std.StaticStringMap(void) = .initComptime(.{
    .{"data"},             .{"compData"},            .{"points"},
    .{"fileData"},         .{"colors"},              .{"pixels"},
    .{"fontChars"},        .{"chars"},               .{"recs"},
    .{"codepoints"},       .{"textList"},            .{"transforms"},
    .{"animations"},       .{"samples"},             .{"LoadImageColors"},
    .{"LoadImagePalette"}, .{"LoadFontData"},        .{"LoadCodepoints"},
    .{"LoadMaterials"},    .{"LoadModelAnimations"}, .{"LoadWaveSamples"},
    .{"images"},           .{"LoadRandomSequence"},  .{"sequence"},
    .{"kernel"},           .{"GlyphInfo"},           .{"glyphs"},
    .{"glyphRecs"},        .{"matf"},                .{"rlGetShaderLocsDefault"},
    .{"locs"},             .{"GuiGetIcons"},         .{"GuiLoadIcons"},
});

fn ziggifyType(allocator: std.mem.Allocator, name: []const u8, t: []const u8, func_name: []const u8) ![]const u8 {
    if (IGNORE_C_TYPE.get(func_name) != null) {
        return try allocator.dupe(u8, t);
    }

    if (endsWith(u8, func_name, "Equals") and eql(u8, t, "c_int")) {
        return try allocator.dupe(u8, "bool");
    }

    var string = false;

    if (eql(u8, name, "text") and
        (eql(u8, t, "[*c][*c]const u8") or eql(u8, t, "[*c][*c]u8")))
    {
        return try allocator.dupe(u8, "[][:0]const u8");
    }

    if (startsWith(u8, t, "[*c]") and
        _SINGLE.get(name) == null and
        _MULTI.get(name) == null)
    {
        if ((eql(u8, t, "[*c]const u8") or
            eql(u8, t, "[*c]u8") or
            eql(u8, name, "TextSplit")) and
            _NO_STRINGS.get(name) == null)
        { // Strings are multis.
            string = true;
        } else {
            std.log.debug("{s} {s} not classified", .{ t, name });
            return error.TypeNotClassified;
        }
    }

    var pre_list: ArrayList(u8) = .empty;
    defer pre_list.deinit(allocator);

    var t_ = t;
    while (startsWith(u8, t_, "[*c]")) {
        t_ = t_[4..];

        const piece =
            if (TRIVIAL_SIZE.get(func_name) != null and pre_list.items.len == 0)
                "[]"
            else if (string and !startsWith(u8, t_, "[*c]"))
                "[:0]"
            else if (_SINGLE.get(name) != null)
                "*"
            else
                "[]";

        try pre_list.appendSlice(allocator, piece);
    }

    const pre = pre_list.items;

    const base = ZIGGIFY.get(t_) orelse t_;

    const error_ = if (HAS_ERROR.get(name) != null) "RaylibError!" else "";

    return try concat(allocator, u8, &.{ error_, pre, base });
}

test "ziggify type" {
    const allocator = std.testing.allocator;
    const expectEqualStrings = std.testing.expectEqualStrings;
    const expectError = std.testing.expectError;

    const simple = try ziggifyType(allocator, "alpha", "f32", "ColorAlpha");
    defer allocator.free(simple);
    try expectEqualStrings("f32", simple);

    const list_of_list = try ziggifyType(allocator, "glyphRecs", "[*c][*c]Rectangle", "GenImageFontAtlas");
    defer allocator.free(list_of_list);
    try expectEqualStrings("[][]Rectangle", list_of_list);

    const list_of_float = try ziggifyType(allocator, "alpha", "[*c]f32", "GuiColorBarAlpha");
    defer allocator.free(list_of_float);
    try expectEqualStrings("*f32", list_of_float);

    const list_of_string = try ziggifyType(allocator, "text", "[*c][*c]u8", "UnloadTextLines");
    defer allocator.free(list_of_string);
    try expectEqualStrings("[][:0]const u8", list_of_string);

    const string_raylib_error = try ziggifyType(allocator, "LoadFileData", "[*c]u8", "LoadFileData");
    defer allocator.free(string_raylib_error);
    try expectEqualStrings("RaylibError![]u8", string_raylib_error);

    const string_type_not_classified = ziggifyType(allocator, "LoadFileData", "[*c]float", "LoadFileData");
    try expectError(error.TypeNotClassified, string_type_not_classified);

    const equals_bool = try ziggifyType(allocator, "FloatEquals", "c_int", "FloatEquals");
    defer allocator.free(equals_bool);
    try expectEqualStrings("bool", equals_bool);

    const ignore_c_type = try ziggifyType(allocator, "rlGetShaderLocsDefault", "[*c]c_int", "rlGetShaderLocsDefault");
    defer allocator.free(ignore_c_type);
    try expectEqualStrings("[*c]c_int", ignore_c_type);
}

fn addNamespaceToType(allocator: std.mem.Allocator, t: []const u8) ![]const u8 {
    var pre_list: ArrayList(u8) = .empty;
    defer pre_list.deinit(allocator);

    var t_ = t;
    while (startsWith(u8, t_, "[*c]")) {
        t_ = t_[4..];
        try pre_list.appendSlice(allocator, "[*c]");
    }

    if (startsWith(u8, t_, "const ")) {
        t_ = t_[6..];
        try pre_list.appendSlice(allocator, "const ");
    }

    const pre = pre_list.items;

    return if (startsWith(u8, t_, "Gui"))
        try concat(allocator, u8, &.{ pre, "rgui.", t_[3..] })
    else if (t_.len > 0 and std.ascii.isUpper(t_[0]))
        try concat(allocator, u8, &.{ pre, "rl.", t_ })
    else if (eql(u8, t_, "float3") or eql(u8, t_, "float16"))
        try concat(allocator, u8, &.{ pre, "rlm.", t_ })
    else if (startsWith(u8, t_, "rl"))
        try concat(allocator, u8, &.{ pre, "rlgl.", t_ })
    else
        try concat(allocator, u8, &.{ pre, t_ });
}

test "add namespace to type" {
    const allocator = std.testing.allocator;
    const expectEqualStrings = std.testing.expectEqualStrings;

    const gui_namespace = try addNamespaceToType(allocator, "GuiControl");
    defer allocator.free(gui_namespace);
    try expectEqualStrings("rgui.Control", gui_namespace);

    const rl_namespace = try addNamespaceToType(allocator, "[*c]const Matrix");
    defer allocator.free(rl_namespace);
    try expectEqualStrings("[*c]const rl.Matrix", rl_namespace);

    const rlm_namespace = try addNamespaceToType(allocator, "float3");
    defer allocator.free(rlm_namespace);
    try expectEqualStrings("rlm.float3", rlm_namespace);

    const rlgl_namespace = try addNamespaceToType(allocator, "rlRenderBatch");
    defer allocator.free(rlgl_namespace);
    try expectEqualStrings("rlgl.rlRenderBatch", rlgl_namespace);

    const no_namespace = try addNamespaceToType(allocator, "c_int");
    defer allocator.free(no_namespace);
    try expectEqualStrings("c_int", no_namespace);
}

fn makeReturnCast(
    allocator: std.mem.Allocator,
    func_name: []const u8,
    source_type: []const u8,
    dest_type: []const u8,
    inner: []const u8,
) ![]const u8 {
    if (eql(u8, source_type, dest_type) or IGNORE_C_TYPE.get(func_name) != null) {
        return try allocator.dupe(u8, inner);
    }

    const inner_ = if (startsWith(u8, source_type, "[*c][*c]"))
        try allocPrint(allocator, "@as([*][:0]{s}, @ptrCast({s}))", .{ source_type[8..], inner })
    else
        inner;
    defer if (startsWith(u8, source_type, "[*c][*c]")) allocator.free(inner_);

    if (TRIVIAL_SIZE.get(func_name) != null) {
        return try allocPrint(allocator, "{s}[0..@as(usize, @intCast(_len))]", .{inner_});
    }

    if (endsWith(u8, func_name, "Equals")) {
        return try allocPrint(allocator, "{s} == 1", .{inner_});
    }

    if (eql(u8, source_type, "[*c]const u8") or eql(u8, source_type, "[*c]u8")) {
        return try allocPrint(allocator, "std.mem.span({s})", .{inner_});
    }

    if (ZIGGIFY.get(source_type) != null) {
        return try allocPrint(allocator, "@as({s}, {s})", .{ dest_type, inner_ });
    }

    std.log.debug("Don't know what to do with '{s}': {s} {s} {s}", .{ func_name, source_type, dest_type, inner_ });
    return error.UncastableReturn;
}

test "make return cast" {
    const allocator = std.testing.allocator;
    const expectEqualStrings = std.testing.expectEqualStrings;
    const expectError = std.testing.expectError;

    const list_of_string = try makeReturnCast(allocator, "TextSplit", "[*c][*c]u8", "RaylibError![][:0]u8", "_ptr");
    defer allocator.free(list_of_string);
    try expectEqualStrings("@as([*][:0]u8, @ptrCast(_ptr))[0..@as(usize, @intCast(_len))]", list_of_string);

    const ignore_c_type = try makeReturnCast(allocator, "rlGetShaderLocsDefault", "[*c]c_int", "[*c]c_int", "cdef.rlGetShaderLocsDefault()");
    defer allocator.free(ignore_c_type);
    try expectEqualStrings("cdef.rlGetShaderLocsDefault()", ignore_c_type);

    const ends_with_equals = try makeReturnCast(allocator, "FloatEquals", "c_int", "bool", "cdef.FloatEquals(x, y)");
    defer allocator.free(ends_with_equals);
    try expectEqualStrings("cdef.FloatEquals(x, y) == 1", ends_with_equals);

    const mem_span = try makeReturnCast(allocator, "GetClipboardText", "[*c]const u8", "[:0]const u8", "cdef.GetClipboardText()");
    defer allocator.free(mem_span);
    try expectEqualStrings("std.mem.span(cdef.GetClipboardText())", mem_span);

    const ziggify = try makeReturnCast(allocator, "GetFileModTime", "c_long", "i64", "cdef.GetFileModTime(@as([*c]const u8, @ptrCast(fileName)))");
    defer allocator.free(ziggify);
    try expectEqualStrings("@as(i64, cdef.GetFileModTime(@as([*c]const u8, @ptrCast(fileName))))", ziggify);

    const uncastable = makeReturnCast(allocator, "GetFileModTime", "foo", "i64", "cdef.GetFileModTime(@as([*c]const u8, @ptrCast(fileName)))");
    try expectError(error.UncastableReturn, uncastable);
}

fn fixPointer(
    allocator: std.mem.Allocator,
    name: []const u8,
    t: []const u8,
) !@Tuple(&.{ []const u8, []const u8 }) {
    var pre_list: ArrayList(u8) = .empty;
    defer pre_list.deinit(allocator);

    var name_ = name;
    while (startsWith(u8, name_, "*")) {
        name_ = name_[1..];
        try pre_list.appendSlice(allocator, "[*c]");
    }

    name_ = try allocator.dupe(u8, name_);
    errdefer allocator.free(name_);

    const pre = pre_list.items;

    const pre_t = try concat(allocator, u8, &.{ pre, t });
    defer allocator.free(pre_t);

    const t_ = if (eql(u8, name_, "rlGetProcAddress"))
        try allocator.dupe(u8, "?*const anyopaque")
    else if (eql(u8, pre_t, "[*c]const void"))
        try allocator.dupe(u8, "*const anyopaque")
    else if (eql(u8, pre_t, "[*c]void"))
        try allocator.dupe(u8, "*anyopaque")
    else if (pre.len == 0)
        try replaceOwned(u8, allocator, pre_t, "const ", "")
    else
        try allocator.dupe(u8, pre_t);
    errdefer allocator.free(t_);

    return .{ name_, t_ };
}

test "fix pointer" {
    const allocator = std.testing.allocator;
    const expectEqualStrings = std.testing.expectEqualStrings;

    const list_of_string_name, const list_of_string_t = try fixPointer(allocator, "**text", "u8");
    defer allocator.free(list_of_string_name);
    defer allocator.free(list_of_string_t);
    try expectEqualStrings("text", list_of_string_name);
    try expectEqualStrings("[*c][*c]u8", list_of_string_t);

    const get_proc_address_name, const get_proc_address_t = try fixPointer(allocator, "*rlGetProcAddress", "void");
    defer allocator.free(get_proc_address_name);
    defer allocator.free(get_proc_address_t);
    try expectEqualStrings("rlGetProcAddress", get_proc_address_name);
    try expectEqualStrings("?*const anyopaque", get_proc_address_t);

    const ptr_const_anyopaque_name, const ptr_const_anyopaque_t = try fixPointer(allocator, "*value", "const void");
    defer allocator.free(ptr_const_anyopaque_name);
    defer allocator.free(ptr_const_anyopaque_t);
    try expectEqualStrings("value", ptr_const_anyopaque_name);
    try expectEqualStrings("*const anyopaque", ptr_const_anyopaque_t);

    const ptr_anyopaque_name, const ptr_anyopaque_t = try fixPointer(allocator, "*GetWindowHandle", "void");
    defer allocator.free(ptr_anyopaque_name);
    defer allocator.free(ptr_anyopaque_t);
    try expectEqualStrings("GetWindowHandle", ptr_anyopaque_name);
    try expectEqualStrings("*anyopaque", ptr_anyopaque_t);

    const remove_const_name, const remove_const_t = try fixPointer(allocator, "v", "const Vector3");
    defer allocator.free(remove_const_name);
    defer allocator.free(remove_const_t);
    try expectEqualStrings("v", remove_const_name);
    try expectEqualStrings("Vector3", remove_const_t);

    const same_name, const same_t = try fixPointer(allocator, "bounds", "Rectangle");
    defer allocator.free(same_name);
    defer allocator.free(same_t);
    try expectEqualStrings("bounds", same_name);
    try expectEqualStrings("Rectangle", same_t);
}

const FixEnum = struct {
    arg_name: []const u8,
    new_type: []const u8,
    func_name_regex: []const u8,
};

const FIX_ENUMS_DATA = [_]FixEnum{
    .{ .arg_name = "key", .new_type = "KeyboardKey", .func_name_regex = "*" },
    .{ .arg_name = "mode", .new_type = "CameraMode", .func_name_regex = "UpdateCamera" },
    .{ .arg_name = "mode", .new_type = "BlendMode", .func_name_regex = "BeginBlendMode" },
    .{ .arg_name = "gesture", .new_type = "Gesture", .func_name_regex = "*" },
    .{ .arg_name = "logLevel", .new_type = "TraceLogLevel", .func_name_regex = "*" },
    .{ .arg_name = "ty", .new_type = "FontType", .func_name_regex = "*" },
    .{ .arg_name = "uniformType", .new_type = "ShaderUniformDataType", .func_name_regex = "*" },
    .{ .arg_name = "cursor", .new_type = "MouseCursor", .func_name_regex = "*" },
    .{ .arg_name = "format", .new_type = "PixelFormat", .func_name_regex = "*" },
    .{ .arg_name = "newFormat", .new_type = "PixelFormat", .func_name_regex = "*" },
    .{ .arg_name = "layout", .new_type = "CubemapLayout", .func_name_regex = "*" },
    .{ .arg_name = "mapType", .new_type = "MaterialMapIndex", .func_name_regex = "*" },
    .{ .arg_name = "filter", .new_type = "TextureFilter", .func_name_regex = "SetTextureFilter" },
    .{ .arg_name = "wrap", .new_type = "TextureWrap", .func_name_regex = "SetTextureWrap" },
    .{ .arg_name = "flags", .new_type = "ConfigFlags", .func_name_regex = "SetWindowState|ClearWindowState|SetConfigFlags" },
    .{ .arg_name = "flag", .new_type = "ConfigFlags", .func_name_regex = "IsWindowState" },
    .{ .arg_name = "flags", .new_type = "Gesture", .func_name_regex = "SetGesturesEnabled" },
    .{ .arg_name = "button", .new_type = "GamepadButton", .func_name_regex = "*GamepadButton*" },
    .{ .arg_name = "axis", .new_type = "GamepadAxis", .func_name_regex = "*GamepadAxis*" },
    .{ .arg_name = "button", .new_type = "MouseButton", .func_name_regex = "*MouseButton*" },
    .{ .arg_name = "control", .new_type = "GuiControl", .func_name_regex = "GuiGetStyle|GuiSetStyle" }, // "Gui" prefix needed here for type parsing later
    // .{ .arg_name = "property", .new_type = "GuiControlProperty", .func_name_regex = "GuiGetStyle|GuiSetStyle" }, // "Gui" prefix needed here for type parsing later
};

fn matchPattern(pattern: []const u8, value: []const u8) bool {
    // "*"
    if (eql(u8, pattern, "*")) return true;

    // "*something*"
    if (startsWith(u8, pattern, "*") and
        endsWith(u8, pattern, "*"))
    {
        const inner = pattern[1 .. pattern.len - 1];
        return std.mem.find(u8, value, inner) != null;
    }

    // "A|B|C"
    if (std.mem.findScalar(u8, pattern, '|')) |_| {
        var it = std.mem.splitScalar(u8, pattern, '|');
        while (it.next()) |part| {
            if (eql(u8, part, value)) return true;
        }
        return false;
    }

    // exact match
    return eql(u8, pattern, value);
}

fn fixEnums(
    allocator: std.mem.Allocator,
    arg_name: []const u8,
    arg_type: []const u8,
    func_name: []const u8,
) ![]const u8 {
    if (startsWith(u8, func_name, "rl")) {
        return try allocator.dupe(u8, arg_type);
    }

    // Hacking specific enums in here.
    // Raylib doesn't use the enums but rather the resulting ints.
    if (eql(u8, arg_type, "int") or eql(u8, arg_type, "unsigned int")) {
        for (FIX_ENUMS_DATA) |item| {
            if (eql(u8, arg_name, item.arg_name) and matchPattern(item.func_name_regex, func_name)) {
                return try allocator.dupe(u8, item.new_type);
            }
        }
    }

    return try allocator.dupe(u8, arg_type);
}

test "fix enums" {
    const allocator = std.testing.allocator;
    const expectEqualStrings = std.testing.expectEqualStrings;

    const any_function = try fixEnums(allocator, "key", "int", "IsKeyPressed");
    defer allocator.free(any_function);
    try expectEqualStrings("KeyboardKey", any_function);

    const specific_function = try fixEnums(allocator, "mode", "int", "UpdateCamera");
    defer allocator.free(specific_function);
    try expectEqualStrings("CameraMode", specific_function);

    const some_function = try fixEnums(allocator, "flags", "unsigned int", "ClearWindowState");
    defer allocator.free(some_function);
    try expectEqualStrings("ConfigFlags", some_function);

    const contain_function = try fixEnums(allocator, "button", "int", "IsGamepadButtonPressed");
    defer allocator.free(contain_function);
    try expectEqualStrings("GamepadButton", contain_function);

    const rl_function = try fixEnums(allocator, "r", "bool", "rlColorMask");
    defer allocator.free(rl_function);
    try expectEqualStrings("bool", rl_function);

    const other_function = try fixEnums(allocator, "*text", "char", "GuiTextInputBox");
    defer allocator.free(other_function);
    try expectEqualStrings("char", other_function);
}

fn convertName(allocator: std.mem.Allocator, name: []const u8) ![]const u8 {
    if (name.len == 0) {
        return try allocator.dupe(u8, "");
    }

    var name_ = name;

    if (startsWith(u8, name_, "Gui")) {
        name_ = name_[3..];
        if (name_.len == 0) {
            return try allocator.dupe(u8, "");
        }
    }

    var n_ = try allocator.dupe(u8, name_);
    n_[0] = std.ascii.toLower(n_[0]);

    return n_;
}

test "convert name" {
    const allocator = std.testing.allocator;
    const expectEqualStrings = std.testing.expectEqualStrings;

    const empty = try convertName(allocator, "");
    defer allocator.free(empty);
    try expectEqualStrings("", empty);

    const lower_case = try convertName(allocator, "Vector4Add");
    defer allocator.free(lower_case);
    try expectEqualStrings("vector4Add", lower_case);

    const gui = try convertName(allocator, "GuiGetFont");
    defer allocator.free(gui);
    try expectEqualStrings("getFont", gui);
}

const SingleOpt = struct {
    func: []const u8,
    arg: []const u8,
};

const SINGLE_OPT_DATA = [_]SingleOpt{
    .{ .func = "rlDrawVertexArrayElements", .arg = "buffer" },
    .{ .func = "rlDrawVertexArrayElementsInstanced", .arg = "buffer" },
    .{ .func = "rlEnableStatePointer", .arg = "buffer" },
    .{ .func = "rlSetRenderBatchActive", .arg = "batch" },
    .{ .func = "rlLoadTexture", .arg = "data" },
    .{ .func = "rlLoadTextureCubemap", .arg = "data" },
    .{ .func = "rlLoadShaderBuffer", .arg = "data" },
    .{ .func = "rlLoadShaderCode", .arg = "vsCode" },
    .{ .func = "rlLoadShaderCode", .arg = "fsCode" },
    .{ .func = "GuiTextInputBox", .arg = "secretViewActive" },
    .{ .func = "GuiSlider", .arg = "textLeft" },
    .{ .func = "GuiSlider", .arg = "textRight" },
    .{ .func = "GuiSlider", .arg = "value" },
    .{ .func = "GuiSliderBar", .arg = "textLeft" },
    .{ .func = "GuiSliderBar", .arg = "textRight" },
    .{ .func = "GuiSliderBar", .arg = "value" },
    .{ .func = "GuiProgressBar", .arg = "textLeft" },
    .{ .func = "GuiProgressBar", .arg = "textRight" },
    .{ .func = "GuiProgressBar", .arg = "value" },
};

fn isSingleOpt(func_name: []const u8, arg_name: []const u8) bool {
    for (SINGLE_OPT_DATA) |item| {
        if (eql(u8, item.func, func_name) and eql(u8, item.arg, arg_name)) {
            return true;
        }
    }
    return false;
}

const CFunction = struct {
    return_type: []const u8,
    name: []const u8,
    argument_list: ArrayList(CFunctionArgument),
    inline_comment: []const u8,

    const Self = @This();

    const CFunctionArgument = struct {
        type: []const u8,
        name: []const u8,
    };

    pub fn initLine(
        allocator: std.mem.Allocator,
        line: []const u8,
        prefix: []const u8,
    ) !Self {
        if (!startsWith(u8, line, prefix)) return error.InvalidCFunction;

        var split_line = std.mem.splitScalar(u8, line, ';');
        var line_func = split_line.first();
        const line_desc = std.mem.trimStart(u8, split_line.rest(), &std.ascii.whitespace);

        // increase length, so alloc
        var line_ = try replaceOwned(u8, allocator, line_func, ",", ", ");
        defer allocator.free(line_);

        // same length, so keep buffer
        _ = replace(u8, line_, "* ", " *", line_);

        // decrease length, so new variable with slice
        var total_replaced: usize = 0;
        var replaced: usize = 1;
        while (replaced > 0) {
            replaced = replace(u8, line_, "  ", " ", line_);
            total_replaced += replaced;
        }
        line_func = line_[0 .. line_.len - total_replaced];

        var i: usize = prefix.len;
        var index: usize = undefined;

        // return_type
        index = std.mem.findScalarPos(u8, line_func, i, '(') orelse return error.InvalidCFunction;
        index = i + (std.mem.findScalarLast(u8, line_func[i..index], ' ') orelse return error.InvalidCFunction);
        const return_type = try allocator.dupe(u8, line_func[i..index]);
        errdefer allocator.free(return_type);
        i = index + 1;

        // name
        index = std.mem.findScalarPos(u8, line_func, i, '(') orelse return error.InvalidCFunction;
        const name = try allocator.dupe(u8, line_func[i..index]);
        errdefer allocator.free(name);
        i = index + 1;

        // arguments
        index = std.mem.findScalarPos(u8, line_func, i, ')') orelse return error.InvalidCFunction;
        const arguments = try allocator.dupe(u8, line_func[i..index]);
        defer allocator.free(arguments);
        i = index + 1;

        var argument_list: ArrayList(CFunctionArgument) = .empty;
        errdefer {
            for (argument_list.items) |arg| {
                allocator.free(arg.type);
                allocator.free(arg.name);
            }
            argument_list.deinit(allocator);
        }

        var split_arguments = std.mem.splitSequence(u8, arguments, ", ");
        while (split_arguments.next()) |argument| {
            var arg_type: []const u8 = undefined;
            var arg_name: []const u8 = undefined;

            if (std.mem.findScalarLast(u8, argument, ' ')) |idx| {
                arg_type = try allocator.dupe(u8, argument[0..idx]);
                arg_name = try allocator.dupe(u8, argument[idx + 1 ..]);
            } else {
                arg_type = try allocator.dupe(u8, argument[0..]);
                arg_name = try allocator.dupe(u8, "");
            }

            try argument_list.append(allocator, CFunctionArgument{
                .type = arg_type,
                .name = arg_name,
            });
        }

        // inline_comment
        const inline_comment = if (line_desc.len > 0)
            try concat(allocator, u8, &.{ "/", line_desc, "\n" })
        else
            try allocator.dupe(u8, "");
        errdefer allocator.free(inline_comment);

        return .{
            .return_type = return_type,
            .name = name,
            .argument_list = argument_list,
            .inline_comment = inline_comment,
        };
    }

    pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
        allocator.free(self.return_type);
        allocator.free(self.name);
        allocator.free(self.inline_comment);

        var argument_list = self.argument_list;
        for (argument_list.items) |arg| {
            allocator.free(arg.type);
            allocator.free(arg.name);
        }
        argument_list.deinit(allocator);
    }
};

fn parseHeader(
    allocator: std.mem.Allocator,
    io: std.Io,
    header_file: []const u8,
    prelude_file: []const u8,
    ext_prelude_file: []const u8,
    output_file: []const u8,
    ext_output_file: []const u8,
    prefix: []const u8,
    skip_after: []const u8,
) !void {
    var ext_heads: ArrayList([]const u8) = .empty;
    defer {
        for (ext_heads.items) |item| {
            allocator.free(item);
        }
        ext_heads.deinit(allocator);
    }

    var zig_funcs: ArrayList([]const u8) = .empty;
    defer {
        for (zig_funcs.items) |item| {
            allocator.free(item);
        }
        zig_funcs.deinit(allocator);
    }

    var header = try std.Io.Dir.cwd().openFile(io, header_file, .{ .mode = .read_only });
    defer header.close(io);

    var header_buffer: [1024]u8 = undefined;
    var header_reader = header.reader(io, &header_buffer);

    while (try header_reader.interface.takeDelimiter('\n')) |line| {
        if (eql(u8, line, skip_after)) break;

        if (!startsWith(u8, line, prefix)) continue;

        const c_function_info = CFunction.initLine(allocator, line, prefix) catch |err| switch (err) {
            error.InvalidCFunction => continue,
            else => return err,
        };
        defer c_function_info.deinit(allocator);

        var return_type: []const u8 = try allocator.dupe(u8, c_function_info.return_type);
        defer allocator.free(return_type);

        var func_name: []const u8 = try allocator.dupe(u8, c_function_info.name);
        defer allocator.free(func_name);

        const argument_list = c_function_info.argument_list;
        const inline_comment = c_function_info.inline_comment;

        if (eql(u8, func_name, "SetTraceLogCallback")) continue;

        return_type = blk: {
            const return_type_ = try cToZigType(allocator, return_type);
            allocator.free(return_type);
            break :blk return_type_;
        };

        func_name, return_type = blk: {
            const func_name_, const return_type_ = try fixPointer(allocator, func_name, return_type);
            allocator.free(func_name);
            allocator.free(return_type);
            break :blk .{ func_name_, return_type_ };
        };

        return_type = blk: {
            if (eql(u8, func_name, "GetKeyPressed")) {
                const return_type_ = try allocator.dupe(u8, "KeyboardKey");
                allocator.free(return_type);
                break :blk return_type_;
            } else if (eql(u8, func_name, "GetGamepadButtonPressed")) {
                const return_type_ = try allocator.dupe(u8, "GamepadButton");
                allocator.free(return_type);
                break :blk return_type_;
            } else if (eql(u8, func_name, "GetGestureDetected")) {
                const return_type_ = try allocator.dupe(u8, "Gesture");
                allocator.free(return_type);
                break :blk return_type_;
            }

            break :blk return_type;
        };

        var zig_c_arguments: ArrayList([]const u8) = .empty;
        defer {
            for (zig_c_arguments.items) |item| {
                allocator.free(item);
            }
            zig_c_arguments.deinit(allocator);
        }

        var zig_arguments: ArrayList([]const u8) = .empty;
        defer {
            for (zig_arguments.items) |item| {
                allocator.free(item);
            }
            zig_arguments.deinit(allocator);
        }

        var zig_call_args: ArrayList([]const u8) = .empty;
        defer {
            for (zig_call_args.items) |item| {
                allocator.free(item);
            }
            zig_call_args.deinit(allocator);
        }

        const zig_name = try convertName(allocator, func_name);
        defer allocator.free(zig_name);

        for (argument_list.items) |argument| {
            if (argument.name.len == 0) {
                if (eql(u8, argument.type, "void")) break;

                if (eql(u8, argument.type, "...")) {
                    try zig_c_arguments.append(allocator, try allocator.dupe(u8, "..."));
                    continue;
                }
            }

            var arg_type: []const u8 = try allocator.dupe(u8, argument.type);
            defer allocator.free(arg_type);

            var arg_name: []const u8 = try allocator.dupe(u8, argument.name);
            defer allocator.free(arg_name);

            if (eql(u8, arg_name, "type")) {
                allocator.free(arg_name);
                arg_name = try allocator.dupe(u8, "ty");
            }

            arg_type = blk: {
                const arg_type_ = try fixEnums(allocator, arg_name, arg_type, func_name);
                allocator.free(arg_type);
                break :blk arg_type_;
            };

            arg_type = blk: {
                const arg_type_ = try cToZigType(allocator, arg_type);
                allocator.free(arg_type);
                break :blk arg_type_;
            };

            arg_name, arg_type = blk: {
                const arg_name_, const arg_type_ = try fixPointer(allocator, arg_name, arg_type);
                allocator.free(arg_name);
                allocator.free(arg_type);
                break :blk .{ arg_name_, arg_type_ };
            };

            if (eql(u8, arg_name, zig_name)) {
                arg_name = blk: {
                    const arg_name_ = try concat(allocator, u8, &.{ arg_name, "_" });
                    allocator.free(arg_name);
                    break :blk arg_name_;
                };
            }

            var zig_type = try ziggifyType(allocator, arg_name, arg_type, func_name);
            defer allocator.free(zig_type);

            if (isSingleOpt(func_name, arg_name)) {
                if (!startsWith(u8, arg_type, "[*c]")) {
                    arg_type = blk: {
                        const arg_type_ = try concat(allocator, u8, &.{ "?", arg_type });
                        allocator.free(arg_type);
                        break :blk arg_type_;
                    };
                }
                zig_type = blk: {
                    const zig_type_ = try concat(allocator, u8, &.{ "?", zig_type });
                    allocator.free(zig_type);
                    break :blk zig_type_;
                };
            }

            const namespaced_arg_type = try addNamespaceToType(allocator, arg_type);
            defer allocator.free(namespaced_arg_type);

            // Put everything together.

            try zig_c_arguments.append(
                allocator,
                try concat(allocator, u8, &.{ arg_name, ": ", namespaced_arg_type }),
            );

            try zig_arguments.append(
                allocator,
                try concat(allocator, u8, &.{ arg_name, ": ", zig_type }),
            );

            if (eql(u8, arg_type, zig_type)) {
                try zig_call_args.append(allocator, try allocator.dupe(u8, arg_name));
            } else {
                if (startsWith(u8, arg_type, "[*c]")) {
                    try zig_call_args.append(
                        allocator,
                        try allocPrint(
                            allocator,
                            "@as({s}, @ptrCast({s}))",
                            .{ arg_type, arg_name },
                        ),
                    );
                } else {
                    try zig_call_args.append(
                        allocator,
                        try allocPrint(
                            allocator,
                            "@as({s}, {s})",
                            .{ arg_type, arg_name },
                        ),
                    );
                }
            }
        }

        const all_zig_c_arguments = try join(allocator, ", ", zig_c_arguments.items);
        defer allocator.free(all_zig_c_arguments);

        const ext_ret = try addNamespaceToType(allocator, return_type);
        defer allocator.free(ext_ret);

        try ext_heads.append(
            allocator,
            try allocPrint(
                allocator,
                "pub extern \"c\" fn {s}({s}) {s};",
                .{ func_name, all_zig_c_arguments, ext_ret },
            ),
        );

        var func_prelude: ArrayList(u8) = .empty;
        defer func_prelude.deinit(allocator);

        if (TRIVIAL_SIZE.get(func_name) != null) {
            if (zig_arguments.pop()) |arg| allocator.free(arg);
            if (zig_call_args.pop()) |arg| allocator.free(arg);
            try zig_call_args.append(
                allocator,
                try allocator.dupe(u8, "@as([*c]c_int, @ptrCast(&_len))"),
            );
            try func_prelude.appendSlice(allocator, "var _len: i32 = 0;\n    ");
        }

        const all_zig_arguments = try join(allocator, ", ", zig_arguments.items);
        defer allocator.free(all_zig_arguments);

        const all_zig_call_args = try join(allocator, ", ", zig_call_args.items);
        defer allocator.free(all_zig_call_args);

        if (MANUAL.get(func_name) != null or
            std.mem.find(u8, func_name, "FromMemory") != null) continue;

        var inner = try allocPrint(
            allocator,
            "cdef.{s}({s})",
            .{ func_name, all_zig_call_args },
        );
        defer allocator.free(inner);

        if (TRIVIAL_SIZE.get(func_name) != null) {
            const func_prelude_ = try allocPrint(
                allocator,
                "const _ptr = {s};\n    if (_ptr == 0) return RaylibError.{s};\n    ",
                .{ inner, func_name },
            );
            defer allocator.free(func_prelude_);

            try func_prelude.appendSlice(allocator, func_prelude_);

            allocator.free(inner);
            inner = try allocator.dupe(u8, "_ptr");
        }

        const zig_return = try ziggifyType(allocator, func_name, return_type, func_name);
        defer allocator.free(zig_return);

        const return_cast = try makeReturnCast(allocator, func_name, return_type, zig_return, inner);
        defer allocator.free(return_cast);

        if (return_cast.len > 0) {
            const return_ = if (!eql(u8, zig_return, "void")) "return " else "";
            try zig_funcs.append(
                allocator,
                try allocPrint(
                    allocator,
                    "{s}pub fn {s}({s}) {s} {{\n    {s}{s}{s};\n}}",
                    .{
                        inline_comment,
                        zig_name,
                        all_zig_arguments,
                        zig_return,
                        func_prelude.items,
                        return_,
                        return_cast,
                    },
                ),
            );
        }
    }

    const all_ext_heads = try join(allocator, "\n", ext_heads.items);
    defer allocator.free(all_ext_heads);

    const all_zig_funcs = try join(allocator, "\n\n", zig_funcs.items);
    defer allocator.free(all_zig_funcs);

    try std.Io.Dir.copyFile(.cwd(), ext_prelude_file, .cwd(), ext_output_file, io, .{});
    try std.Io.Dir.copyFile(.cwd(), prelude_file, .cwd(), output_file, io, .{});

    var ext_header = try std.Io.Dir.cwd().openFile(io, ext_output_file, .{ .mode = .read_write });
    defer ext_header.close(io);

    var ext_header_writer = ext_header.writer(io, &.{});
    try ext_header_writer.seekTo(try ext_header.length(io));
    try ext_header_writer.interface.print("\n{s}\n", .{all_ext_heads});
    try ext_header_writer.interface.flush();

    var zig_header = try std.Io.Dir.cwd().openFile(io, output_file, .{ .mode = .read_write });
    defer zig_header.close(io);

    var zig_header_writer = zig_header.writer(io, &.{});
    try zig_header_writer.seekTo(try zig_header.length(io));
    try zig_header_writer.interface.print("\n{s}\n", .{all_zig_funcs});
    try zig_header_writer.interface.flush();
}

const usage =
    \\Usage: generate_code [options]
    \\
    \\Options:
    \\
    \\  --header-file HEADER_FILE
    \\
    \\  --prelude-file PRELUDE_FILE
    \\  --ext-prelude-file EXT_PRELUDE_FILE
    \\
    \\  --output-file OUTPUT_FILE
    \\  --ext-output-file EXT_OUTPUT_FILE
    \\
    \\  --prefix PREFIX
    \\  --skip-after SKIP_AFTER
    \\
;

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const gpa = init.gpa;
    const io = init.io;

    const args = try init.minimal.args.toSlice(arena);

    if (args.len < 2) {
        var file_writer = std.Io.File.stdout().writer(io, &.{});
        try file_writer.interface.writeAll(usage);
        return;
    }

    var opt_header_file_path: ?[]const u8 = null;
    var opt_prelude_file_path: ?[]const u8 = null;
    var opt_ext_prelude_file_path: ?[]const u8 = null;

    var opt_output_file_path: ?[]const u8 = null;
    var opt_ext_output_file_path: ?[]const u8 = null;

    var opt_prefix: ?[]const u8 = null;
    var opt_skip_after: ?[]const u8 = null;

    {
        var i: usize = 1;
        while (i < args.len) : (i += 1) {
            const arg = args[i];
            if (eql(u8, "-h", arg) or eql(u8, "--help", arg)) {
                var file_writer = std.Io.File.stdout().writer(io, &.{});
                try file_writer.interface.writeAll(usage);
                return;
            } else if (eql(u8, "--header-file", arg)) {
                i += 1;
                if (i > args.len) fatal("expected argument after '{s}'", .{arg});
                if (opt_header_file_path != null) fatal("duplicated {s} argument", .{arg});
                opt_header_file_path = args[i];
            } else if (eql(u8, "--prelude-file", arg)) {
                i += 1;
                if (i > args.len) fatal("expected argument after '{s}'", .{arg});
                if (opt_prelude_file_path != null) fatal("duplicated {s} argument", .{arg});
                opt_prelude_file_path = args[i];
            } else if (eql(u8, "--ext-prelude-file", arg)) {
                i += 1;
                if (i > args.len) fatal("expected argument after '{s}'", .{arg});
                if (opt_ext_prelude_file_path != null) fatal("duplicated {s} argument", .{arg});
                opt_ext_prelude_file_path = args[i];
            } else if (eql(u8, "--output-file", arg)) {
                i += 1;
                if (i > args.len) fatal("expected argument after '{s}'", .{arg});
                if (opt_output_file_path != null) fatal("duplicated {s} argument", .{arg});
                opt_output_file_path = args[i];
            } else if (eql(u8, "--ext-output-file", arg)) {
                i += 1;
                if (i > args.len) fatal("expected argument after '{s}'", .{arg});
                if (opt_ext_output_file_path != null) fatal("duplicated {s} argument", .{arg});
                opt_ext_output_file_path = args[i];
            } else if (eql(u8, "--prefix", arg)) {
                i += 1;
                if (i > args.len) fatal("expected argument after '{s}'", .{arg});
                if (opt_prefix != null) fatal("duplicated {s} argument", .{arg});
                opt_prefix = args[i];
            } else if (eql(u8, "--skip-after", arg)) {
                i += 1;
                if (i > args.len) fatal("expected argument after '{s}'", .{arg});
                if (opt_skip_after != null) fatal("duplicated {s} argument", .{arg});
                opt_skip_after = args[i];
            } else {
                fatal("unrecognized argument: '{s}'", .{arg});
            }
        }
    }

    const header_file_path = opt_header_file_path orelse fatal("missing --header-file", .{});
    const prelude_file_path = opt_prelude_file_path orelse fatal("missing --prelude-file", .{});
    const ext_prelude_file_path = opt_ext_prelude_file_path orelse fatal("missing --ext-prelude-file", .{});
    const output_file_path = opt_output_file_path orelse fatal("missing --output-file", .{});
    const ext_output_file_path = opt_ext_output_file_path orelse fatal("missing --ext-output-file", .{});
    const prefix = opt_prefix orelse fatal("missing --prefix", .{});
    const skip_after = opt_skip_after orelse "#/never\\#";

    try parseHeader(
        gpa,
        io,
        header_file_path,
        prelude_file_path,
        ext_prelude_file_path,
        output_file_path,
        ext_output_file_path,
        prefix,
        skip_after,
    );
}

fn fatal(comptime format: []const u8, args: anytype) noreturn {
    std.debug.print(format ++ "\n", args);
    std.process.exit(1);
}
