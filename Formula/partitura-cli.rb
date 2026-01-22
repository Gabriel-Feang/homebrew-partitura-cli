class PartituraCli < Formula
  desc "AI-powered coding assistant CLI with embedded MCP tools"
  homepage "https://partitura-ai.com"
  license "MIT"
  head "https://github.com/Gabriel-Feang/Partitura.git", branch: "feature/raycast"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"partitura-cli", "./cmd/partitura-cli"
  end

  def caveats
    <<~EOS
      To authenticate, run:
        partitura-cli auth

      This will open your browser to sign in with your Partitura account.

      Then start chatting:
        partitura-cli
    EOS
  end

  test do
    assert_match "partitura-cli", shell_output("#{bin}/partitura-cli --help")
  end
end
