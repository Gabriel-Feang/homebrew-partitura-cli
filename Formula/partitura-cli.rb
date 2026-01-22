class PartituraCli < Formula
  desc "Terminal frontend for Partitura AI orchestration backend"
  homepage "https://partitura-ai.com"
  license "MIT"
  version "0.2.0"
  head "https://github.com/Gabriel-Feang/Partitura.git", branch: "feature/raycast"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "-o", bin/"partitura-cli", "./cmd/partitura-cli"
  end

  def caveats
    <<~EOS
      partitura-cli is a terminal frontend for the Partitura backend.
      It connects to the same backend that Partitura.app uses.

      To authenticate, run:
        partitura-cli auth

      This will open your browser to sign in with your Partitura account.

      Then start chatting:
        partitura-cli

      Note: The CLI will auto-start the Partitura backend if installed.
      For browser automation and visual debugging, use Partitura.app.
    EOS
  end

  test do
    assert_match "partitura-cli", shell_output("#{bin}/partitura-cli --help")
  end
end
