# frozen_string_literal: true

require 'spec_helper'

describe StableYamlFormatter::Refinements::HashNamespaced do
  context 'using HashSortByKey refinement' do
    using StableYamlFormatter::Refinements::HashNamespaced

    subject { hash.namespaced }
    let(:hash) { { b: { z: 20, x: 10 }, a: nil } }

    it 'does not modify the original object' do
      expect { subject }.to_not(change { hash })
    end

    it 'converts a Hash from a tree structure to a plain key-value' do
      expect(subject).to eql('b.z' => 20, 'b.x' => 10, 'a' => nil)
    end
  end

  it 'does not affect code outside the context of HashNamespaced refinement' do
    expect { {}.namespaced }.to raise_error(NoMethodError)
  end
end
