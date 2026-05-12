# Contributing to raylib-zig

Thank you for your interest in contributing to raylib-zig. There are some guidelines you will need to follow in order
to get your contribution added to the project as fast as possible.

## Updates to the Zig version

This binding will never target any Zig version newer than the latest release. Fixes that don't affect compatibility
with the latest release and allow the binding to be used on a pre-release/HEAD version of Zig may be accepted.

## Updates to the raylib version

Usually this binding will stay on the latest release commit for raylib, but occasionally upgrade to a HEAD version when
there are changes made, critical to the Zig build. In those cases there will be a release tag on GitHub, marking the
latest commit that uses a raylib release. Previously there were extra branches for older versions of raylib, but this
approach was abandoned.

## Updates to the binding files

raylib-zig is built mostly through the `generate_functions.py` script. It creates the definitions to access the raw C
functions, and creates aliases with proper Zig argument and return types, Zig style names and errors. The raylib types,
however, are created manually and should only be updated in their respective preludes:
 - `lib/preludes/raylib-prelude.zig` for raylib types
 - `lib/preludes/raymath-prelude.zig` for raymath types
 - `lib/preludes/rlgl-prelude.zig` for rlgl types
 - `lib/preludes/raygui-prelude.zig` for raygui types

Before any commit you make, you should always run `zig build binding` to ensure your changes are persistent
throughout other updates.

## Updates to the build files

Updates to raylib-zig's `build.zig`, as any other contributions to binding files, are very welcome. However, when
updating public names or APIs, you should always ensure that the project template in `project_setup.sh` still
works with them.
