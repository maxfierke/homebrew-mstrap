class Mstrap < Formula
  desc "Machine Bootstrapping tool with a focus on sensible defaults, conventions, and avoidance of vendoring"
  homepage "https://mstrap.dev"
  url "https://github.com/maxfierke/mstrap/archive/v0.2.4.tar.gz"
  sha256 "6ddebd447fd5d89cf25583d6535d3ad37e60c8974205055c3a29a848153a7854"
  license "MIT"

  depends_on "openssl"
  depends_on "pcre"
  depends_on "libevent"

  depends_on "bash" => :build
  depends_on "crystal" => :build
  depends_on "make" => :build

  def install
    system "make", "build", "RELEASE=1"
    bin.install "bin/mstrap"
  end

  test do
    system "make", "test"
  end
end
