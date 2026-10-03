--- RULES/POLICIES
add_rules("mode.debug", "mode.release"); set_defaultmode("debug")
add_rules("plugin.compile_commands.autoupdate")

--- TOOLCHAIN
toolchain(".gnu")
    set_kind("standalone"); set_toolset("cxx", "g++")
    set_toolset("as",    "as"); set_toolset("ar",    "ar")
    set_toolset("ld",    "g++"); set_toolset("sh",    "g++")
    set_toolset("ex",    "g++"); set_toolset("strip", "strip")
toolchain_end()

toolchain(".llvm")
    set_kind("standalone"); set_toolset("cxx", "clang++");
    set_toolset("as",    "clang"); set_toolset("ar",    "llvm-ar")
    set_toolset("ld",    "clang++"); set_toolset("sh",    "clang++")
    set_toolset("ex",    "clang++"); set_toolset("strip", "llvm-strip")
toolchain_end()

set_toolchains(".llvm")



--- SCRIPT-BEGIN
    if is_mode("debug") then
        optimize = "-O0"
        lto = "-fno-lto"
        emit_stack = "-fno-omit-frame-pointer"
        set_symbols("debug")
        set_strip("none")
    elseif is_mode("release") then
        optimize = "-O3"
        lto = "-flto"
        emit_stack = ""
        set_symbols("none")
        set_strip("all")
    end
--- SCRIPT-END


--- CONFIG
cxx_flags = {
    optimize,
    "-Wall", "-Wextra", "-Wshadow", "-Wundef", "-Wcast-align", "-Wdouble-promotion",
    lto, emit_stack, "-fno-exceptions", "-fno-rtti"
}
ld_flags = {
    lto
}
set_languages("c++23")
add_includedirs("include/")
add_cxxflags(table.unpack(cxx_flags))
add_ldflags(table.unpack(ld_flags))


--- TARGETS
target("tiny-fmt")
    set_kind("shared")
    set_basename("tinyfmt")

    add_files("src/format.cpp")

    add_defines("TFMT_SHARED")
    add_defines("TFMT_LIB_EXPORT")


--- TESTS
target("main") add_files("test/main.cpp") add_deps("tiny-fmt")
