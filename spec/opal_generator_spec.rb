require 'spec_helper'

describe(Jekyll::Generators::Opal) do
  let(:output_dir)  { dest_dir("js") }
  let(:output_file) { dest_dir("js", "opal.js") }
  let(:site)        { fixture_site }

  it "knows the relative output file path" do
    expect(described_class::OPAL_LOCATION).to eql("js/opal.js")
  end

  it "knows where to output the file" do
    expect(subject.output_location(site)).to eql(output_file)
  end

  it "can build the opal stdlib" do
    expect(subject.opal_stdlib).to match("(Opal);")
  end

  context "when ensuring directory is there" do
    before(:each) do
      FileUtils.rm_r(output_dir) if File.directory?(output_dir)
      subject.ensure_directory(subject.output_location(site))
    end

    it "creates the proper output directory" do
      expect(File.directory?(output_dir)).to be_truthy
    end
  end

  context "for a fresh site" do
    before(:each) do
      FileUtils.rm_r(dest_dir) if File.directory?(dest_dir)
    end

    it "writes the file" do
      expect(subject.write_file(subject.output_location(site))).to eql(output_file)
      expect(File.file?(output_file)).to be(true)
    end

    it "adds the outputted file to the site.keep_files list" do
      expect(subject.generate(site)).not_to be_nil
      expect(site.keep_files).to eql(%w(.git .svn js/opal.js))
    end
  end

end