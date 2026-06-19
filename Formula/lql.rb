class Lql < Formula
  desc "Linear Query Language — CLI for Linear optimized for LLM consumption"
  homepage "https://frr.dev"
  version "1.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.7.2/lql-aarch64-apple-darwin.tar.xz"
      sha256 "8d1a20507dc9b0c43f1acb32a59e08889d76b546f6177eb8917201a5a23feb3d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.7.2/lql-x86_64-apple-darwin.tar.xz"
      sha256 "a41e861d91e5ee4b1755204645ff0f74c3d05d8ea54b08c5d1b6f2468713a900"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.7.2/lql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5be82d02e70c4f9505c0b2d7dbe09ff6e3434cdf38152216636b1d693c6a97f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.7.2/lql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ba03eefee253d9416d0f113715927242d991d3c6e94149cee010d94b239d076c"
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
