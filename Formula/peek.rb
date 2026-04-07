class Peek < Formula
  desc "Capture app and web UI screenshots without stealing focus"
  homepage "https://github.com/frr149/peek"
  url "https://github.com/frr149/peek/releases/download/v0.1.1/peek-v0.1.1-macos.tar.gz"
  sha256 "d25b3427664dc86c4859d6314a84f85be36e27be12b076fa3c106ccfb89fa1f1"
  license "MIT"

  depends_on :macos

  def install
    bin.install "peek"
  end

  test do
    assert_match "0.1.1", shell_output("#{bin}/peek --version")
  end
end
