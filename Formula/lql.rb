class Lql < Formula
  desc "Linear Query Language — CLI for Linear optimized for LLM consumption"
  homepage "https://frr.dev"
  version "1.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.7.1/lql-aarch64-apple-darwin.tar.xz"
      sha256 "58dd8b6b5375d4f5b4dc6a247f3db17ff71157fbd3e49462983677bab50b608b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.7.1/lql-x86_64-apple-darwin.tar.xz"
      sha256 "2de4dca4d090f3cfdd6f0f8d5015c0947d25ac5a889e47f5c7cf1f5f6a6da6e9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.7.1/lql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b81f36e06788a281201e99e0b4229c884a969e2b71937134fdf211176053557e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.7.1/lql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "48d15b0b86eba6e529ecacfcdd230a85ad62dea4ca6af3cd0944b18e9757e6ad"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "lql" if OS.mac? && Hardware::CPU.arm?
    bin.install "lql" if OS.mac? && Hardware::CPU.intel?
    bin.install "lql" if OS.linux? && Hardware::CPU.arm?
    bin.install "lql" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
