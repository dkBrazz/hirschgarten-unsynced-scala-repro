# Hirschgarten Unsynced Scala Repro

This workspace mirrors the relevant Wix project shape:

- `test/com/acme/unsynced/UnsyncedTest.scala` is owned by a generated parent target in the root package.
- `test/com/acme/synced/NormallySyncedTest.scala` is owned by a sibling package target with its own `BUILD.bazel`.
- `.bazelrc` excludes targets tagged `no-index`/`no-tool`, which skips only the generated parent target during sync.

Open this directory as a Bazel project in Hirschgarten:

```text
hirschgarten-unsynced-scala-repro
```

Use the project view file:

```text
hirschgarten-unsynced-scala-repro/.bazelbsp/.bazelproject
```

After sync, compare these files:

```text
test/com/acme/unsynced/UnsyncedTest.scala
test/com/acme/synced/NormallySyncedTest.scala
```

Expected result with the regression: the first file is red and shown as "not in sync scope"; the second file is synced normally.

Useful Bazel checks:

```sh
bazel query 'rdeps(//:all, //:test/com/acme/unsynced/UnsyncedTest.scala)'
bazel query 'rdeps(//test/com/acme/synced:all, //test/com/acme/synced:NormallySyncedTest.scala)'
bazel build --nobuild //:sync-repro_test //test/com/acme/synced:syncing
```

The two queries show that Bazel owns both files. The build command shows only the sibling target is analyzed because the root generated target is filtered out by `--build_tag_filters`.
