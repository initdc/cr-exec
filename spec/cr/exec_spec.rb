# frozen_string_literal: true

require "tempfile"

RSpec.describe Cr::Exec do
  it "has a version number" do
    expect(Cr::Exec::VERSION).not_to be nil
  end

  it "print lines" do
    Cr::Exec.run("sudo apt update")
  end

  it "return 0" do
    expect(Cr::Exec.code("uname")).to eq 0
  end

  it "accept multi string" do
    expect(Cr::Exec.code("uname -s")).to eq 0
  end

  it "return 127" do
    expect(Cr::Exec.code("unamea")).to eq 127
  end

  it "get Linux" do
    expect(Cr::Exec.output("uname")).to eq "Linux"
  end

  it "get Linux\n" do
    expect(Cr::Exec.output("uname", chomp: false)).to eq "Linux\n"
  end

  it "log to file" do
    tempfile = Tempfile.new(["test_", ".log"])
    Cr::Exec.run("uname", out: File.open(tempfile.path, "a+"))

    expect(tempfile.readlines).to eq ["Linux\n"]
    tempfile.delete
  end

  it "list file" do
    expect(Cr::Exec.each_line("ls spec")).to eq ["cr\n", "spec_helper.rb\n"]
  end

  it "list file with option" do
    expect(Cr::Exec.each_line("ls spec", chomp: true)).to eq ["cr", "spec_helper.rb"]
  end

  it "always return bool" do
    p system("unamea")
    expect(Cr::Exec.system?("unamea")).to eq false
  end
end
