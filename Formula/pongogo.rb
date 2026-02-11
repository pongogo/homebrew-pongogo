class Pongogo < Formula
  desc "AI agent knowledge routing for Claude Code"
  homepage "https://pongogo.com"
  url "https://files.pythonhosted.org/packages/3c/9e/9fde8bdff0015e027ae45e2f33280176274e8c3443922dc537f97921f9ee/pongogo-0.3.18.tar.gz"
  sha256 "c0107e04062b3ccb15595794ea8308486192d115a93f6abb03685c733898da12"
  license "MIT"

  depends_on "python@3.12"

  def install
    python3 = "python3.12"

    # Create virtualenv
    system python3, "-m", "venv", libexec

    # Install package with all dependencies from PyPI
    system libexec/"bin/pip", "install", "pongogo==#{version}"

    # Link the entry point scripts to bin
    bin.install_symlink Dir[libexec/"bin/pongogo*"]
  end

  test do
    system "#{bin}/pongogo", "--version"
  end
end
