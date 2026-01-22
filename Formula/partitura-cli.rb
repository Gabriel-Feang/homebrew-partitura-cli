class PartituraCli < Formula
  desc "Terminal frontend for Partitura AI orchestration (includes backend)"
  homepage "https://partitura-ai.com"
  license "MIT"
  version "0.2.0"
  head "https://github.com/Gabriel-Feang/Partitura.git", branch: "feature/raycast"

  depends_on "go" => :build

  def install
    # Build the backend
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"partitura"), "./cmd/partitura"

    # Build the CLI
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}", output: bin/"partitura-cli"), "./cmd/partitura-cli"
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
    assert_match "partitura", shell_output("#{bin}/partitura --help 2>&1", 1)
  end
end
