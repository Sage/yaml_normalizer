# frozen_string_literal: true

require 'spec_helper'

describe StableYamlFormatter::Refinements::HashSortByKey do
  context 'using HashSortByKey refinement' do
    using StableYamlFormatter::Refinements::HashSortByKey

    subject { hash.sort_by_key(recursive) }
    let(:recursive) { true }
    let(:hash) { { b: { z: 20, x: 10 }, a: nil } }

    it 'does not modify the original object' do
      expect { subject }.to_not(change { hash })
    end

    context 'first level only' do
      let(:recursive) { false }
      it 'sorts first level keys only' do
        expect(subject.inspect).to eql({ a: nil, b: { z: 20, x: 10 } }.inspect)
      end
    end

    context 'recursive' do
      it 'sorts keys of all levels' do
        expect(subject.inspect).to eql({ a: nil, b: { x: 10, z: 20 } }.inspect)
      end
    end
  end

  it 'does not affect code outside the context of HashSortByKey refinement' do
    expect { {}.sort_by_key }.to raise_error(NoMethodError)
  end
end
