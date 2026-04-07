class Lql < Formula
  desc "Linear Query Language — CLI for Linear optimized for LLM consumption"
  homepage "https://frr.dev"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.3.0/lql-aarch64-apple-darwin.tar.xz"
      sha256 "2dec0cc01f81d81bfe11d5b18364d9220248e8c0fb84d38b4655ca16c86d460d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.3.0/lql-x86_64-apple-darwin.tar.xz"
      sha256 "b7f2016855c379eb4990090e38fdb0ab5dd3fd6cb7df9b1dcd9fe6a856885555"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.3.0/lql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cf3a88d4bbacaa838535f72c882ff2980620c0b385a299dcc6c777794823df98"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.3.0/lql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "905f5dfc91aff8aff6cc980f4a459e197e3710a8dec119f54c697cfdd06aa613"
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
