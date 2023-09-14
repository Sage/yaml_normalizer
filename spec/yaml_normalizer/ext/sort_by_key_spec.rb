# frozen_string_literal: true

require 'spec_helper'

RSpec.describe YamlNormalizer::Ext::SortByKey do
  context 'when extending a Hash with Ext::SortByKey' do
    subject(:sorted_hash) { hash.extend(described_module).sort_by_key(recursive: recursive) }

    let(:described_module) { described_class }
    let(:recursive) { true }
    let(:hash) { { b: { z: 20, x: 10, y: { b: 1, a: 2 } }, a: nil } }
    let(:expected) { { a: nil, b: { x: 10, y: { a: 2, b: 1 }, z: 20 } } }

    it 'does not modify the original object' do
      expect { sorted_hash }.not_to(change { hash })
    end

    context 'when keys have different types' do
      let(:hash) { { 1 => nil, two: :ok, false => {} } }
      let(:expected) { { 1 => nil, false => {}, two: :ok } }

      it 'sorts objects by their String representation' do
        expect(sorted_hash.inspect).to eql(expected.inspect)
      end
    end

    context 'when sorting by keys in first level only' do
      let(:recursive) { false }
      let(:expected) { { a: nil, b: { z: 20, x: 10, y: { b: 1, a: 2 } } } }

      it 'sorts the Hash but not its nested Hashes' do
        expect(sorted_hash.inspect).to eql(expected.inspect)
      end
    end

    context 'when sorting by key recursively' do
      it 'sorts the Hash and all nested Hashes' do
        expect(sorted_hash.inspect).to eql(expected.inspect)
      end
    end
  end

  it 'does not modify Ruby Core class Hash' do
    expect { {}.sort_by_key }.to raise_error(NoMethodError)
  end
end
