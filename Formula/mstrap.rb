class Mstrap < Formula
  desc "Machine bootstrapping tool with a focus on conventions"
  homepage "https://mstrap.dev"
  url "https://github.com/maxfierke/mstrap/archive/v0.2.4.tar.gz"
  sha256 "6ddebd447fd5d89cf25583d6535d3ad37e60c8974205055c3a29a848153a7854"
  license "MIT"

  depends_on "bash" => :build
  depends_on "crystal" => :build
  depends_on "make" => :build

  depends_on "libevent"
  depends_on "openssl"
  depends_on "pcre"

  def install
    system "make", "build", "RELEASE=1"
    bin.install "bin/mstrap"
  end

  test do
    assert_match "mstrap is a tool for bootstrapping development machines",
      shell_output(bin/"mstrap --help")
  end
end
