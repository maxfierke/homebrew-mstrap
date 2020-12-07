class Mstrap < Formula
  desc "Machine bootstrapping tool with a focus on conventions"
  homepage "https://mstrap.dev"
  url "https://github.com/maxfierke/mstrap/archive/v0.2.6.tar.gz"
  sha256 "611d8c52ab025de29f748193b6aee6e6b1317fb54a97ca01fd4f9f308e5d4ce9"
  license "MIT"

  head do
    url "https://github.com/maxfierke/mstrap.git"
  end

  depends_on "bash" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build

  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "zlib"

  on_macos do
    depends_on "libedit"
  end

  on_linux do
    depends_on "readline"
  end

  resource "crystal" do
    on_macos do
      url "https://github.com/crystal-lang/crystal/releases/download/0.35.1/crystal-0.35.1-1-darwin-x86_64.tar.gz"
      version "0.35.1-1"
      sha256 "7d75f70650900fa9f1ef932779bc23f79a199427c4219204fa9e221c330a1ab6"
    end
    on_linux do
      url "https://github.com/crystal-lang/crystal/releases/download/0.35.1/crystal-0.35.1-1-linux-x86_64.tar.gz"
      version "0.35.1-1"
      sha256 "6c3fd36073b32907301b0a9aeafd7c8d3e9b9ba6e424ae91ba0c5106dc23f7f9"
    end
  end

  def install
    # Use static Crystal compiler, since the one in Homebrew seems to be broken
    # for Linux
    (buildpath/"crystal").install resource("crystal")
    ENV.append_path "PATH", "crystal/bin"
    ENV.append_path "PATH", "crystal/embedded/bin"

    ENV.prepend_path "PKG_CONFIG_PATH", (Formula["libedit"].opt_lib/"pkgconfig")
    ENV.prepend_path "PKG_CONFIG_PATH", (Formula["libevent"].opt_lib/"pkgconfig")
    ENV.prepend_path "PKG_CONFIG_PATH", (Formula["openssl@1.1"].opt_lib/"pkgconfig")
    ENV.prepend_path "PKG_CONFIG_PATH", (Formula["pcre"].opt_lib/"pkgconfig")
    ENV.prepend_path "PKG_CONFIG_PATH", (Formula["zlib"].opt_lib/"pkgconfig")

    ENV.prepend_path "CRYSTAL_LIBRARY_PATH", (buildpath/"crystal/lib/crystal/lib")

    system "make", "build", "RELEASE=1"
    bin.install "bin/mstrap"
  end

  test do
    assert_match "mstrap is a tool for bootstrapping development machines",
      shell_output(bin/"mstrap --help")
  end
end
