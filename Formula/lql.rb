class Lql < Formula
  desc "Linear Query Language — CLI for Linear optimized for LLM consumption"
  homepage "https://frr.dev"
  version "1.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.5.1/lql-aarch64-apple-darwin.tar.xz"
      sha256 "51f3d7cbdd2b589925c9abb1f2d8044e1fc4aba6a2ef7690cbbc5bdf6847843f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.5.1/lql-x86_64-apple-darwin.tar.xz"
      sha256 "24fc727a4adc07c06ee507965e7d273957c0aa1dfd6fc2175dad2a944129e100"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.5.1/lql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "81af4b067a8fd65774d3aba5a13f0497cec4ffa350ec74464e1d906e93d205fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.5.1/lql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8737e30b057232e98c92f58c18313933d446af57f096e09bac82b3d145aee216"
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
