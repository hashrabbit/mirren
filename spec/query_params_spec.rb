require 'spec_helper'
module Mirren
  module Api
    RSpec.describe QueryParams do
      describe 'self.call' do
        context 'with an empty hash' do
          it 'returns an empty hash' do
            expect(QueryParams.call({})).to eq({})
          end
        end

        context 'with a hash of keys with no boolean values' do
          let(:hsh) { {foo: 1, bar: [2], baz: {a: 'b'}} }
          it 'returns a hash with identical key/value pairs' do
            expect(QueryParams.call(hsh)).to eq(hsh)
          end
        end

        context 'with a hash of keys with boolean values' do
          let(:hsh) do
            { a: 1,
              b: [:within, :array, true, false],
              c: true,
              d: false,
              e: {
                aa: :foo,
                bb: false,
                cc: true,
                dd: {},
                ee: {
                  aaa: true,
                  bbb: false,
                  ccc: "maybe"
                },
                ff: [:within, :array, {nested: :deep, aaa: true, bbb: false, ccc: 'and the rest'}]
              }
            }
          end

          let(:expected) do
            { a: 1,
              b: [:within, :array, 1, 0],
              c: 1,
              d: 0,
              e: {
                aa: :foo,
                bb: 0,
                cc: 1,
                dd: {},
                ee: {
                  aaa: 1,
                  bbb: 0,
                  ccc: "maybe"
                },
                ff: [:within, :array, {nested: :deep, aaa: 1, bbb: 0, ccc: 'and the rest'}]
              }
            }
          end

          it 'returns a hash with true as 1 and false as 0' do
            expect(QueryParams.call(hsh)).to eq(expected)
          end
        end
      end
    end
  end
end
