class Pongogo < Formula
  desc "AI agent knowledge routing for Claude Code"
  homepage "https://pongogo.com"
  url "https://files.pythonhosted.org/packages/4d/df/57f199dfccc4f2b0b38a57ec4253d342f984bd61c5127707f4be76c18ba8/pongogo-0.3.0.tar.gz"
  sha256 "ad319a41340c2b38f9f4c7a6a7d07406df15c4be212032880f207f44b15304d7"
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
