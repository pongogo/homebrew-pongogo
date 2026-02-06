class Pongogo < Formula
  desc "AI agent knowledge routing for Claude Code"
  homepage "https://pongogo.com"
  url "https://files.pythonhosted.org/packages/f9/1a/545087095efd622b3ad5eb26c82c8591949907a52a15bf8b8e9ffd71118a/pongogo-0.3.3.tar.gz"
  sha256 "64724eb1a22fa1f22e5b2095114a804f56b5e83888f80ce97026c1caabdc1dc8"
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
