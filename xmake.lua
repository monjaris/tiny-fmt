add_rules("mode.debug", "mode.release")
add_rules("plugin.compile_commands.autoupdate")


if is_mode("debug") then
    optimize = "-O0"
    emit_stack = "-fno-omit-frame-pointer"
elseif is_mode("release") then
    optimize = "-O3"
    emit_stack = ""
    set_policy("build.optimization.lto", true)
end


--- CONFIG
local cxx_flags = {
    optimize,
    "-Wall", "-Wextra",
    emit_stack,
    "-fno-exceptions", "-fno-rtti",
}
set_languages("c++23")
add_cxxflags(table.unpack(cxx_flags))



--- TARGET
after_build(function (target)
    os.cp(target:targetfile(), "$(projectdir)/")
end)


target("tiny-fmt")
    set_kind("$(kind)")
    add_files("src/format.cpp")
    add_includedirs("include", {public = true})
    add_headerfiles("include/(**.hpp)")

    if is_kind("shared") then
        add_defines("TFMT_SHARED")
    elseif is_kind("static") then
    after_build(function (target)
        local targetfile = target:targetfile()
        local sofile = targetfile:match("^(.*)%.[^.]+$") .. ".so"
        os.rm(sofile)
    end)    end

    if is_plat("windows") then
        add_cxxflags("/utf-8")
    end


--- TESTS
target("main") add_files("test/main.cpp") add_deps("tiny-fmt")
target("format") add_files("test/format.cpp") add_deps("tiny-fmt")
target("format_to") add_files("test/format_to.cpp") add_deps("tiny-fmt")
