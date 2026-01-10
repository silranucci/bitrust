set shell := ["bash", "-cu"]

# Default: show available commands
default:
    @just --list

# Run all tests with nextest
test *ARGS:
    cargo nextest run {{ARGS}}

# Run tests with coverage report
coverage:
    cargo llvm-cov nextest --html --open

# Run clippy with strict settings
lint:
    cargo clippy --all-targets --all-features -- -D warnings -D clippy::pedantic -A clippy::must_use_candidate -A clippy::missing_errors_doc

# Format code
fmt:
    cargo fmt --all

# Check formatting
fmt-check:
    cargo fmt --all -- --check

# Run benchmarks
bench *ARGS:
    cargo criterion {{ARGS}}

# Generate flamegraph for benchmarks
flame BENCH:
    cargo flamegraph --bench {{BENCH}} -- --bench

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

# Full CI check
ci: fmt-check lint test audit
    @echo "All CI checks passed!"

# Build optimized release
release:
    cargo build --release

# Build with native CPU optimizations
release-native:
    RUSTFLAGS="-C target-cpu=native" cargo build --release

# Run bacon in background (default: check)
watch *ARGS:
    bacon {{ARGS}}

# Expand macros
expand *ARGS:
    cargo expand {{ARGS}}
