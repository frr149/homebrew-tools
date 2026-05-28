class Lql < Formula
  desc "Linear Query Language — CLI for Linear optimized for LLM consumption"
  homepage "https://frr.dev"
  version "1.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.7.0/lql-aarch64-apple-darwin.tar.xz"
      sha256 "40dca8ac284bf6249574282773e909c2129d3aa55b7775741f3842eec253855a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.7.0/lql-x86_64-apple-darwin.tar.xz"
      sha256 "5df77b182fd55b6e7dba7d598e4733a5ad6b077c05bf1693899f252c0e9d8e15"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.7.0/lql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "230adf88b56f9d36e07d3049dd5b047029b2f3c5e2a9812711cf806a6294392f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.7.0/lql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "01e8325066c943e5e0323aa7de80e21a07711e9e87403eefb413ecd963eb83d4"
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
