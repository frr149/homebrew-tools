class Lql < Formula
  desc "Linear Query Language — CLI for Linear optimized for LLM consumption"
  homepage "https://frr.dev"
  version "1.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.4.0/lql-aarch64-apple-darwin.tar.xz"
      sha256 "ee7fdc8e8bf2d55872095a5dd0a2328a43b263c16d0ef49da8ac87f871824574"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.4.0/lql-x86_64-apple-darwin.tar.xz"
      sha256 "3879f8ea4459a7476f5a3fe0baf33bd852420c44124fd87c5aa9c2d6793ddcbf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.4.0/lql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4caa358640af7f8edf12f1911c5bfd0eb166e5b08679a9d1a322026f5d82cde1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.4.0/lql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ba3c81dd955206ce598e739e11e1bca16d515ec1c9b8472693262b81ee28c712"
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
