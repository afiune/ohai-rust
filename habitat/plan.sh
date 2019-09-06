pkg_name=ohai
pkg_origin=afiune
pkg_maintainer="Salim Afiune <afiune@chef.io>"
pkg_description="Ohai profiles your system and emits JSON"
pkg_license=('Apache-2.0')
pkg_deps=()
pkg_bin_dirs=(bin)
pkg_build_deps=(
  core/musl
  core/zlib-musl
  core/rust
  core/gcc
)

pkg_version() {
  cat "${SRC_PATH}/VERSION"
}

do_before() {
  do_default_before
  update_pkg_version
}

do_prepare() {
  export CARGO_TARGET_DIR
  export LD_LIBRARY_PATH
  export LIBARCHIVE_LDFLAGS
  export LIBARCHIVE_STATIC=true

  export rustc_target="x86_64-unknown-linux-musl"
  build_line "Setting rustc_target=$rustc_target"

  la_ldflags="-L$(pkg_path_for zlib-musl)/lib -lz"
  LIBARCHIVE_LDFLAGS="$la_ldflags"

  # Used by Cargo to use a pristine, isolated directory for all compilation
  CARGO_TARGET_DIR="$HAB_CACHE_SRC_PATH/$pkg_dirname"
  build_line "Setting CARGO_TARGET_DIR=$CARGO_TARGET_DIR"

  # Used to find libgcc_s.so.1 when compiling `build.rs` in dependencies.
  LD_LIBRARY_PATH=$(pkg_path_for gcc)/lib
  build_line "Setting LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
}

do_build() {
  ( cd "$SRC_PATH" || exit_with "unable to cd into source directory" 2
    cargo build --release --target=$rustc_target --verbose
  )
}

do_install() {
  install -v -D "$CARGO_TARGET_DIR/$rustc_target/release/$pkg_name" \
    "$pkg_prefix/bin/$pkg_name"
}
