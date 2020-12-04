class Mstrap < Formula
  desc "Machine bootstrapping tool with a focus on conventions"
  homepage "https://mstrap.dev"
  url "https://github.com/maxfierke/mstrap/archive/v0.2.4.tar.gz"
  sha256 "6ddebd447fd5d89cf25583d6535d3ad37e60c8974205055c3a29a848153a7854"
  license "MIT"

  depends_on "bash" => :build
  # TODO: renable, once formula is fixed on Linux (Crystal needs update to work w/ LLVM 10)
  # depends_on "crystal" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build

  depends_on "libedit"
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "pcre"

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
    ENV.append_path "PKG_CONFIG_PATH", (Formula["openssl"].opt_lib/"pkgconfig")
    ENV["CRYSTAL_LIBRARY_PATH"] = buildpath/"crystal/lib/crystal/lib"

    system "make", "build", "RELEASE=1"
    bin.install "bin/mstrap"
  end

  test do
    assert_match "mstrap is a tool for bootstrapping development machines",
      shell_output(bin/"mstrap --help")
  end
end
