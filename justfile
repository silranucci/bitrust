set shell := ["bash", "-cu"]

# Show available commands
default:
    @just --list

# BUILD

# Build all crates
build:
    cargo build --workspace

# Build release
release:
    cargo build --workspace --release

# Build with native CPU optimizations
release-native:
    RUSTFLAGS="-C target-cpu=native" cargo build --workspace --release

# TEST

# Run all tests with nextest
test *ARGS:
    cargo nextest run --workspace {{ARGS}}

# Run tests for a specific crate
test-crate CRATE *ARGS:
    cargo nextest run -p {{CRATE}} {{ARGS}}

# Run tests with coverage
coverage:
    cargo llvm-cov nextest --workspace --html --open

#  LINT/FORMAT

# Run clippy on all crates
lint:
    cargo clippy --workspace --all-targets -- -D warnings

# Format all code
fmt:
    cargo fmt --all

# Check formatting
fmt-check:
    cargo fmt --all -- --check

# Full CI check
ci: fmt-check lint test audit
    @echo "All CI checks passed!"

# RUN

# Run the server
server *ARGS:
    cargo run --bin bitcaskd -- {{ARGS}}

# Run the server (release)
server-release *ARGS:
    cargo run --release --bin bitcaskd -- {{ARGS}}

# Run the CLI
cli *ARGS:
    cargo run --bin bitcask -- {{ARGS}}

# Run the CLI (release)
cli-release *ARGS:
    cargo run --release --bin bitcask -- {{ARGS}}

# BENCHMARK/PROFILE

# Run benchmarks
bench *ARGS:
    cargo criterion {{ARGS}}

# Generate flamegraph
flame BENCH:
    cargo flamegraph --bench {{BENCH}} -- --bench

# gRPC/PROTO

# Lint proto files with buf
proto-lint:
    buf lint proto

# Format proto files
proto-fmt:
    buf format proto -w

# Test gRPC calls with grpcurl (server must be running)
grpc-list:
    grpcurl -plaintext '[::1]:50051' list

grpc-get KEY:
    grpcurl -plaintext -d '{"key":"{{KEY}}"}' '[::1]:50051' bitcask.v1.BitcaskService/Get

grpc-put KEY VALUE:
    grpcurl -plaintext -d '{"key":"{{KEY}}","value":"{{VALUE}}"}' '[::1]:50051' bitcask.v1.BitcaskService/Put

grpc-stats:
    grpcurl -plaintext '[::1]:50051' bitcask.v1.BitcaskService/Stats

# UTILITIES

# Security audit
audit:
    cargo audit
    cargo deny check

# Check for outdated dependencies
outdated:
    cargo outdated -R

# Clean build artifacts
clean:
    cargo clean

# Watch mode (bacon)
watch *ARGS:
    bacon {{ARGS}}

# Expand macros
expand *ARGS:
    cargo expand {{ARGS}}
