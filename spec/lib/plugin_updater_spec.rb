require 'rails_helper'

RSpec.describe PluginUpdater do
  GEM_FILES = Dir[File.expand_path('../../fixtures/*.gem', __FILE__)]

  let(:response) do
    response = double("Faraday::Response")
    allow(response).to receive(:body).and_return(MultiJson.dump(%w(foo bar baz yanked)))
    response
  end

  before do
    allow(Faraday.default_connection).to receive(:get).and_return(response)
    allow(subject).to receive(:system) # Catch-all just in case.
    allow(subject).to receive(:system).with(/^gem fetch/) do
      FileUtils.cp(GEM_FILES, Dir.pwd)
    end
  end

  describe '#update' do
    it 'creates plugins with attributes from the gemspecs' do
      subject.update

      foo = Plugin.where(name: 'foo').first
      expect(foo.plugin_type).to eq('adapter')
      expect(foo.description).to eq('A Lita adapter for Foo')
      expect(foo.authors).to eq('Bongo Wongo')
      expect(foo.version).to eq('0.0.1')
      expect(foo.requirements_list).to eq('>= 3.0')
      expect(foo.homepage).to eq('http://example.com/foo')

      bar = Plugin.where(name: 'bar').first
      expect(bar.plugin_type).to eq('handler')
      expect(bar.description).to eq('A Lita handler for Bar')
      expect(bar.authors).to eq('Joe Blow')
      expect(bar.version).to eq('0.1.0')
      expect(bar.requirements_list).to eq('!= 2.7, >= 2.5')
      expect(bar.homepage).to eq('http://example.com/bar')

      baz = Plugin.where(name: 'baz').first
      expect(baz.plugin_type).to be_nil
      expect(baz.description).to eq('A Lita plugin for Baz')
      expect(baz.authors).to eq('Bongo Wongo, Joe Blow')
      expect(baz.version).to eq('1.2.3')
      expect(baz.requirements_list).to eq('~> 3.0.0')
      expect(baz.homepage).to eq('https://rubygems.org/gems/baz')
    end

    it 'updates the attributes on existing plugins from the gemspecs' do
      Plugin.create!(
        name: 'foo',
        plugin_type: 'handler',
        description: 'Unknown',
        version: '0.0.0',
        authors: 'Some Programmer',
        requirements_list: '1.0.0',
        homepage: 'http://example.com/asdf'
      )

      subject.update

      foo = Plugin.where(name: 'foo').first
      expect(foo.plugin_type).to eq('adapter')
      expect(foo.description).to eq('A Lita adapter for Foo')
      expect(foo.authors).to eq('Bongo Wongo')
      expect(foo.homepage).to eq('http://example.com/foo')
      expect(foo.requirements_list).to eq('>= 3.0')
    end
  end
end

