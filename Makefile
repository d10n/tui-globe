# SPDX-License-Identifier: GPL-3.0-or-later
.PHONY: build run test fmt fmt-check lint check license-check static clean

build:
	cargo build

run:
	cargo run

test:
	cargo test --all-targets

fmt:
	cargo fmt --all

fmt-check:
	cargo fmt --all --check

lint:
	cargo clippy --all-targets --all-features -- -D warnings

check: fmt-check lint test

license-check:
	@missing=`find . -path ./target -prune -o \
		-type f -name "*.rs" \
		-exec sh -c 'head -1 "$$1" | grep -q "^// SPDX-License[-]Identifier:" || echo "$$1"' _ {} \;`; \
	if [ -n "$$missing" ]; then \
		echo "Missing SPDX-License-Identifier header on line 1:"; \
		echo "$$missing"; \
		exit 1; \
	fi
	reuse lint

static:
	CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS="-C target-feature=+crt-static" \
		cargo build --release --target x86_64-unknown-linux-gnu --target-dir target/crt-static

clean:
	cargo clean
