# frozen_string_literal: true

require 'spec_helper'

RSpec.describe YamlNormalizer::Ext::Nested do
  context 'when extending Hash instances with Ext::Nested' do
    subject(:nested) { hash.extend(described_module).nested }

    let(:described_module) { described_class }
    let(:hash) do
      { 'a.b.c' => 1, 'b.x' => 2,
        'b.y.one' => true, 'b.y.two' => nil,
        'no_dot' => 'ok', 3 => String, sym: 'ok', nil => 'nil', '' => 'empty' }
    end

    it 'does not modify the original object' do
      expect { nested }.not_to(change { hash })
    end

    it 'converts a Hash from a flat key-value pairs to a tree structure' do
      expect(nested).to eql('a' => { 'b' => { 'c' => 1 } },
                            'b' => { 'x' => 2, 'y' => { 'one' => true, 'two' => nil } },
                            'no_dot' => 'ok', '3' => String, 'sym' => 'ok', '' => 'empty')
    end

    it 'resets the default_proc' do
      expect(nested[:unknown]).to be_nil
    end

    it 'does not create unknown keys on access' do
      expect(nested.dig('a', 'unknown')).to be_nil
    end
  end

  it 'does not modify Ruby Core class Hash' do
    expect { {}.nested }.to raise_error(NoMethodError)
  end
end
