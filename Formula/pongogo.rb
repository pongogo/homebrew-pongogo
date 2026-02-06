class Pongogo < Formula
  desc "AI agent knowledge routing for Claude Code"
  homepage "https://pongogo.com"
  url "https://files.pythonhosted.org/packages/b4/ae/577ebb0d225fd1ea1252f4abe5baa176398e02eeb2e20d7bb8e1ce78041c/pongogo-0.2.3.tar.gz"
  sha256 "708cbe0c77ebe53db71476fd56df4d547ec819e733bb9b2505e494b9a4e485a1"
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
