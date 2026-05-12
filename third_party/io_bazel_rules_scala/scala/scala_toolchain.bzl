def _fake_scala_toolchain_impl(ctx):
    return [platform_common.ToolchainInfo(scalacopts = [])]

fake_scala_toolchain = rule(
    implementation = _fake_scala_toolchain_impl,
)
