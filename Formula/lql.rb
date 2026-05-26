class Lql < Formula
  desc "Linear Query Language — CLI for Linear optimized for LLM consumption"
  homepage "https://frr.dev"
  version "1.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.6.0/lql-aarch64-apple-darwin.tar.xz"
      sha256 "51d8242104ac8861c7f7669269d7dc6579424b45b61c0033899fb8606589e6d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.6.0/lql-x86_64-apple-darwin.tar.xz"
      sha256 "89538be3ae0ebb57cfea215333d24724c3bd30d1cdcdf42d6d4798370f218925"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.6.0/lql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "17c54ff79676815c49c1505adb65483ca494659687cbedd92d637a6dda7c3669"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.6.0/lql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2838a4c5dab61a72a2aa3d8da1342ad0ec0d9cd931b4c64ab446fd905f7c4d5f"
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
