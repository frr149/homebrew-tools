class Lql < Formula
  desc "Linear Query Language — CLI for Linear optimized for LLM consumption"
  homepage "https://frr.dev"
  version "1.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.8.0/lql-aarch64-apple-darwin.tar.xz"
      sha256 "7027dd1952f71a835cd0376c4d01cba647598ed145bfd2bd86b9bfb98cc5c174"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.8.0/lql-x86_64-apple-darwin.tar.xz"
      sha256 "38ed78707c3ab4252a8340f4dd6672a472dc8deb1938ab207126dae55a703493"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.8.0/lql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7bab5aefd5381ddcbdc3fbb442fa8ef33f6ce883a67996a81d259096ffd6d13b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.8.0/lql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3c3bbaaaacd053dc45976a1ee64556510343089a07bbebafa94eb722d0d51676"
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
