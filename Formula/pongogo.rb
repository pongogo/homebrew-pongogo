class Pongogo < Formula
  desc "AI agent knowledge routing for Claude Code"
  homepage "https://pongogo.com"
  url "https://files.pythonhosted.org/packages/ae/93/315876511af838d0c8bb48ba9b127393823b63743ee2364706bd161ca71f/pongogo-0.3.20.tar.gz"
  sha256 "7b1f1157e27ed466efa154d257ed6658197b76e73d671dfb756fcc6e674eeb42"
  license "MIT"

  depends_on "python@3.12"

  def install
    python3 = "python3.12"

    # Create virtualenv
    system python3, "-m", "venv", libexec

    # Install package with all dependencies from PyPI
    system libexec/"bin/pip", "install", "pongogo==#{version}"

    # Remove unused cryptography Rust extension to prevent Homebrew
    # dylib fixup errors on macOS (insufficient Mach-O header padding).
    # Dependency chain: fastmcp -> authlib -> cryptography.
    # Pongogo does not use any authentication features from fastmcp.
    system libexec/"bin/pip", "uninstall", "-y",
      "cryptography", "cffi", "pycparser"

    # Link the entry point scripts to bin
    bin.install_symlink Dir[libexec/"bin/pongogo*"]
  end

  test do
    system "#{bin}/pongogo", "--version"
  end
end
