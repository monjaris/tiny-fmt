add_rules("mode.debug", "mode.release")
add_rules("plugin.compile_commands.autoupdate")

if is_mode("debug") then
    optimize = "-O0"
    emit_stack = "-fno-omit-frame-pointer"
    set_symbols("debug")
    set_strip("none")
elseif is_mode("release") then
    optimize = "-O3"
    emit_stack = ""
    set_symbols("none")
    set_strip("all")
    set_policy("build.optimization.lto", true)
end


set_languages("c++23")

local cxx_flags = {
    optimize,
    "-Wall", "-Wextra",
    emit_stack,
    "-fno-exceptions", "-fno-rtti",
}

add_cxxflags(table.unpack(cxx_flags))


target("tiny-fmt")
    set_basename("tinyfmt")
    set_kind("$(kind)")

    add_files("src/format.cpp")
    add_includedirs("include", {public = true})
    add_headerfiles("include/(**.hpp)")

    if is_kind("shared") then
        add_defines("TFMT_SHARED")
    end

    if is_plat("windows") then
        add_cxxflags("/utf-8")
    end
