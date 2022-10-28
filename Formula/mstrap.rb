class Mstrap < Formula
  desc "Machine bootstrapping tool with a focus on conventions"
  homepage "https://mstrap.dev"
  url "https://github.com/maxfierke/mstrap/archive/v0.5.0.tar.gz"
  sha256 "3a7198f31cab88e1d8037f8ec1ffb7fb3a619eb9e0f8d007550a66d357dbf6d8"
  license "MIT"

  bottle do
    root_url "https://github.com/maxfierke/homebrew-mstrap/releases/download/mstrap-0.4.0"
    sha256 cellar: :any,                 catalina:     "1c055dca511c3a9bad5bea3e5ea6ea458b9c5d8ed6f70a56e8405bf40c10fe64"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4886abe27180701a34c4ae49ede3c307cb4c50971c14b52eea46534bf9b03043"
  end

  head do
    url "https://github.com/maxfierke/mstrap.git"
  end

  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "make" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "openssl@3"
  depends_on "pcre"

  uses_from_macos "zlib"

  on_macos do
    depends_on "crystal" => :build
  end

  resource "crystal" do
    on_linux do
      url "https://github.com/crystal-lang/crystal/releases/download/1.6.1/crystal-1.6.1-1-linux-x86_64.tar.gz"
      version "1.6.1-1"
      sha256 "44b1ccacc1c543d419513723f8fb1de942719c91d01b2de912d2159d3311440e"
    end
  end

  def install
    unless OS.mac?
      # Use static Crystal compiler, since the one in Homebrew seems to be broken
      # for Linux
      (buildpath/"crystal").install resource("crystal")
      ENV.prepend_path "PATH", "crystal/bin"
      ENV.prepend_path "PATH", "crystal/embedded/bin"

      ENV.prepend_path "PKG_CONFIG_PATH", (Formula["readline"].opt_lib/"pkgconfig")
      ENV.prepend_path "PKG_CONFIG_PATH", (Formula["zlib"].opt_lib/"pkgconfig")

      ENV.prepend_path "CRYSTAL_LIBRARY_PATH", (buildpath/"crystal/lib/crystal/lib")
    end

    ENV.prepend_path "PKG_CONFIG_PATH", (Formula["libevent"].opt_lib/"pkgconfig")
    ENV.prepend_path "PKG_CONFIG_PATH", (Formula["openssl@3"].opt_lib/"pkgconfig")
    ENV.prepend_path "PKG_CONFIG_PATH", (Formula["pcre"].opt_lib/"pkgconfig")

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
