# frozen_string_literal: true

require 'spec_helper'

describe YamlNormalizer::Ext::SortByKey do
  context 'extended Hash instances with "sort_by_key"' do
    subject { hash.extend(described_module).sort_by_key(recursive) }
    let(:described_module) { described_class }
    let(:recursive) { true }
    let(:hash) { { b: { z: 20, x: 10, y: { b: 1, a: 2 } }, a: nil } }
    let(:expected) { { a: nil, b: { x: 10, y: { a: 2, b: 1 }, z: 20 } } }

    it 'does not modify the original object' do
      expect { subject }.to_not(change { hash })
    end

    context 'first level only' do
      let(:recursive) { false }
      let(:expected) { { a: nil, b: { z: 20, x: 10, y: { b: 1, a: 2 } } } }
      it 'sorts first level keys only' do
        expect(subject.inspect).to eql(expected.inspect)
      end
    end

    context 'recursive' do
      it 'sorts keys of all levels' do
        expect(subject.inspect).to eql(expected.inspect)
      end
    end
  end

  it 'does not modify Ruby Core class Hash' do
    expect { {}.sort_by_key }.to raise_error(NoMethodError)
  end
end
