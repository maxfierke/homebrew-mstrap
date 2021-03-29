class Mstrap < Formula
  desc "Machine bootstrapping tool with a focus on conventions"
  homepage "https://mstrap.dev"
  url "https://github.com/maxfierke/mstrap/archive/v0.3.1.tar.gz"
  sha256 "87a27a5087d2330d824625ce5ff8cdf93fef64d8abfd871fd858feca6199362b"
  license "MIT"

  bottle do
    root_url "https://github.com/maxfierke/homebrew-mstrap/releases/download/mstrap-0.3.1"
    sha256 cellar: :any,                 catalina:     "5e03aa1be95689bd73039a0b1c1e44066025c46449ae91dd26a187e078e391f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "80be70d4983469a551a3332094383269d6695a9d383893f57aa577f4302db648"
  end

  head do
    url "https://github.com/maxfierke/mstrap.git"
  end

  depends_on "bash" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build

  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "libedit" if OS.mac?
  uses_from_macos "zlib"

  on_macos do
    depends_on "bdw-gc"
    depends_on "crystal" => :build
  end

  on_linux do
    depends_on "readline"
  end

  resource "crystal" do
    on_linux do
      url "https://github.com/crystal-lang/crystal/releases/download/1.0.0/crystal-1.0.0-1-linux-x86_64.tar.gz"
      version "1.0.0-1"
      sha256 "00211ca77758e99210ec40b8c5517b086d2ff9909e089400f6d847a95e5689a4"
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
    ENV.prepend_path "PKG_CONFIG_PATH", (Formula["openssl@1.1"].opt_lib/"pkgconfig")
    ENV.prepend_path "PKG_CONFIG_PATH", (Formula["pcre"].opt_lib/"pkgconfig")

    system "make", "build", "RELEASE=1"
    bin.install "bin/mstrap"
  end

  test do
    assert_match "mstrap is a tool for bootstrapping development machines",
      shell_output(bin/"mstrap --help")
  end
end
