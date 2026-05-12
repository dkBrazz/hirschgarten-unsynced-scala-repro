def _empty_impl(ctx):
    return [DefaultInfo(files = depset())]

def _empty_test_impl(ctx):
    exe = ctx.actions.declare_file(ctx.label.name + ".sh")
    ctx.actions.write(exe, "#!/bin/sh\nexit 0\n", is_executable = True)
    return [DefaultInfo(executable = exe)]

scala_library = rule(
    implementation = _empty_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".scala"]),
        "deps": attr.label_list(),
        "runtime_deps": attr.label_list(),
    },
    test = False,
)

scala_junit_test = rule(
    implementation = _empty_test_impl,
    attrs = {
        "deps": attr.label_list(),
        "runtime_deps": attr.label_list(),
        "tests_from": attr.label_list(),
        "suite_class": attr.string(),
        "suite_label": attr.label(allow_files = False),
    },
    test = True,
)

def generated_specs2_unit_test(name, srcs):
    lib_name = name + "_test"
    scala_library(
        name = lib_name,
        srcs = srcs,
        tags = [
            "generated",
            "no-index",
            "no-tool",
            "app-generated-" + name,
        ],
        testonly = True,
    )

    scala_junit_test(
        name = lib_name + "_test_runner",
        runtime_deps = [":" + lib_name],
        tests_from = [":" + lib_name],
        suite_class = "io.bazel.rulesscala.specs2.Specs2DiscoveredTestSuite",
        tags = [
            "generated",
            "no-index",
            "no-tool",
            "app-generated-" + name,
        ],
        testonly = True,
    )

    native.alias(
        name = "test",
        actual = ":" + lib_name,
        tags = [
            "generated",
            "no-index",
            "no-tool",
            "app-generated-" + name,
        ],
    )
