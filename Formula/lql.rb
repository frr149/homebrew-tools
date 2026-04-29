class Lql < Formula
  desc "Linear Query Language — CLI for Linear optimized for LLM consumption"
  homepage "https://frr.dev"
  version "1.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.4.1/lql-aarch64-apple-darwin.tar.xz"
      sha256 "1a0a1a3849f10f86b16bd80bd9c7d8fc83becec9ed06e5c928a88c4cbdd5bbaa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.4.1/lql-x86_64-apple-darwin.tar.xz"
      sha256 "ad20153f1dda57dc49a3c501a755015f5d8ba363ec8de00f92038f45982a5bab"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.4.1/lql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e4bd706446934591bf02d5bf27295cf58473e90b448fc747ffc28455013f322f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.4.1/lql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a6a91fdbdac28733d26b1f4036b3c50a1f6f5ba04c49736fb3b31aad994a03c4"
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
