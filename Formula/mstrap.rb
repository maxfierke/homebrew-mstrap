class Mstrap < Formula
  desc "Machine bootstrapping tool with a focus on conventions"
  homepage "https://mstrap.dev"
  url "https://github.com/maxfierke/mstrap/archive/v0.5.2.tar.gz"
  sha256 "22e640ca413bb5e4e131c522665fa9d28bde228daa8eb6f0a411590cc32763f7"
  license "MIT"

  bottle do
    root_url "https://github.com/maxfierke/homebrew-mstrap/releases/download/mstrap-0.5.1"
    sha256 cellar: :any,                 monterey:     "9e8bd84a169fa64caaa7e771f984333d520069f87e2c55206c8335be026b2184"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7674816dcd9b26cc57df9cbc44ec4833f846186f6a1c5570c79c4288eb6a123f"
  end

  head do
    url "https://github.com/maxfierke/mstrap.git"
  end

  depends_on "bash" => :build
  depends_on "crystal" => :build
  depends_on "make" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "zlib"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", (Formula["libevent"].opt_lib/"pkgconfig")
    ENV.prepend_path "PKG_CONFIG_PATH", (Formula["openssl@3"].opt_lib/"pkgconfig")
    ENV.prepend_path "PKG_CONFIG_PATH", (Formula["pcre2"].opt_lib/"pkgconfig")

    # This seems... wrong.
    ENV.prepend_path "PATH", Formula["crystal"].bin

    # Skip things like ameba
    ENV["SHARDS_OPTS"] = "--without-development"

    system "make", "build", "RELEASE=1"
    bin.install "bin/mstrap"
  end

  test do
    assert_match "mstrap is a tool for bootstrapping development machines",
      shell_output(bin/"mstrap --help")
  end
end
