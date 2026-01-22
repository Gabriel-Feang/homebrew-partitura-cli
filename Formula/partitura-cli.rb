class PartituraCli < Formula
  desc "Terminal frontend for Partitura AI orchestration (includes backend)"
  homepage "https://partitura-ai.com"
  license "MIT"
  version "0.2.0"
  head "https://github.com/Gabriel-Feang/Partitura.git", branch: "feature/raycast"

  depends_on "go" => :build

  # ObjectBox C library for database storage
  resource "objectbox" do
    url "https://github.com/objectbox/objectbox-c/releases/download/v4.2.0/objectbox-macos-universal.zip"
    sha256 "7d867e1d8700154edd1bdc33902d6c56b34a4184435d62dfb2354b7ccdd3b4df"
  end

  def install
    # Install ObjectBox library first
    resource("objectbox").stage do
      lib.install "lib/libobjectbox.dylib" if OS.mac?
      lib.install "lib/libobjectbox.so" if OS.linux?
    end

    # Set library path for build
    ENV["CGO_LDFLAGS"] = "-L#{lib}"
    ENV["LIBRARY_PATH"] = lib.to_s
    ENV["LD_LIBRARY_PATH"] = lib.to_s
    ENV["DYLD_LIBRARY_PATH"] = lib.to_s

    # Build the backend
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"partitura", "./cmd/partitura"

    # Build the CLI
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-o", bin/"partitura-cli", "./cmd/partitura-cli"

    # Fix library paths on macOS
    if OS.mac?
      MachO::Tools.change_install_name(bin/"partitura",
        "@rpath/libobjectbox.dylib",
        "#{lib}/libobjectbox.dylib")
    end
  end

  def caveats
    <<~EOS
      partitura-cli is a terminal frontend for AI-powered coding assistance.

      Both the CLI and backend have been installed:
        - partitura-cli  (terminal UI)
        - partitura      (backend server)

      To authenticate, run:
        partitura-cli auth

      This will open your browser to sign in with your Partitura account.

      Then start chatting:
        partitura-cli

      The CLI will automatically start the backend when needed.
      For browser automation and visual debugging, use Partitura.app.
    EOS
  end

  test do
    assert_match "partitura-cli", shell_output("#{bin}/partitura-cli --help")
  end
end
