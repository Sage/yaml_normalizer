# frozen_string_literal: true

require 'spec_helper'

RSpec.describe YamlNormalizer::Ext::Namespaced do
  context 'when extending a Hash instances with Ext::Namespaced' do
    subject(:namespaced) { hash.extend(described_module).namespaced }

    let(:described_module) { described_class }
    let(:hash) { { b: { z: 20, x: 10 }, a: nil } }

    it 'does not modify the original object' do
      expect { namespaced }.not_to(change { hash })
    end

    it 'converts a Hash from a tree structure to a plain key-value' do
      expect(namespaced).to eql('b.z' => 20, 'b.x' => 10, 'a' => nil)
    end
  end

  it 'does not modify Ruby Core class Hash' do
    expect { {}.namespaced }.to raise_error(NoMethodError)
  end
end
