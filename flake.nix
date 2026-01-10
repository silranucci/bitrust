{
  description = "BitRust - A Bitcask implementation in Rust";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" "clippy" "rustfmt" "llvm-tools-preview" ];
        };

        linuxPkgs = with pkgs; [
          valgrind
          heaptrack
        ];

        darwinPkgs = with pkgs; [
          darwin.apple_sdk.frameworks.Security
          darwin.apple_sdk.frameworks.SystemConfiguration
          libiconv
        ];

        commonPkgs = with pkgs; [
          # Rust toolchain
          rustToolchain

          # Development workflow
          bacon
          cargo-nextest
          cargo-audit
          cargo-outdated
          cargo-expand
          cargo-flamegraph
          cargo-criterion
          cargo-deny
          cargo-llvm-cov

          # Build tools
          lld
          clang

          # Protobuf/gRPC
          protobuf
          grpcurl
          buf

          # Utilities
          just
          hyperfine
        ];

      in
      {
        devShells.default = pkgs.mkShell {
          name = "bitcask-dev";

          buildInputs = commonPkgs
            ++ pkgs.lib.optionals pkgs.stdenv.isLinux linuxPkgs
            ++ pkgs.lib.optionals pkgs.stdenv.isDarwin darwinPkgs;

          env = {
            RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";
            RUST_BACKTRACE = "1";
            CARGO_TERM_COLOR = "always";
          };

          shellHook = ''
            # Configure lld as linker (cross-platform)
            export RUSTFLAGS="-C link-arg=-fuse-ld=lld"

            echo ""
            echo "🦀 Bitcask Development Environment"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "  Rust:    $(rustc --version)"
            echo "  Linker:  lld"
            echo "  Platform: ${system}"
            echo ""
            echo "📋 Commands: just --list"
            echo ""
          '';
        };
      }
    );
}
