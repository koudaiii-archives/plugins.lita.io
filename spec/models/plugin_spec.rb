require 'rails_helper'

RSpec.describe Plugin do
  %w(name version requirements_list homepage).each do |attribute|
    it "requires the #{attribute} attribute" do
      expect(subject).not_to be_valid
      expect(subject.errors.full_messages).to include(
        "#{attribute.capitalize.sub('_', ' ')} can't be blank"
      )
    end
  end

  it 'requires a unique name' do
    described_class.create(
      name: 'lita-karma',
      version: '3.0.0',
      requirements_list: 'lita >= 4.0',
      homepage: 'https://github.com/jimmycuadra/lita-karma'
    )
    subject = described_class.new(name: 'lita-karma')
    expect(subject).not_to be_valid
    expect(subject.errors.full_messages).to include("Name has already been taken")
  end

  describe '#alphabetical_by_type' do
    it 'returns plugins in alphabetical order' do
      b = described_class.create!(
        name: 'baby pug',
        plugin_type: 'handler',
        version: 'x',
        requirements_list: 'x',
        homepage: 'x'
      )
      c = described_class.create!(
        name: 'cat with a flat face',
        plugin_type: 'handler',
        version: 'x',
        requirements_list: 'x',
        homepage: 'x'
      )
      a = described_class.create!(
        name: 'anteater',
        plugin_type: 'handler',
        version: 'x',
        requirements_list: 'x',
        homepage: 'x'
      )
      b2 = described_class.create!(
        name: 'baby guinea pig',
        plugin_type: 'adapter',
        version: 'x',
        requirements_list: 'x',
        homepage: 'x'
      )
      a2 = described_class.create!(
        name: 'aardvark',
        plugin_type: 'adapter',
        version: 'x',
        requirements_list: 'x',
        homepage: 'x'
      )

      expect(described_class.alphabetical_by_type['handler']).to eq([a, b, c])
      expect(described_class.alphabetical_by_type['adapter']).to eq([a2, b2])
    end
  end
end

