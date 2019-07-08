# rspec spec/table_spec.rb
RSpec.describe Intermix::Table do
  describe '#initialize', :stubbed_client do
    subject { Intermix::Table.new(data) }

    context 'when data is nil' do
      let(:data) { nil }

      it 'throws an error' do
        expect { subject }.to raise_error(ArgumentError, 'data cannot be nil.')
      end
    end

    context 'when data is present' do
      let(:data) { stubbed_table.with_indifferent_access }

      it 'assigns the attributes correctly' do
        expect(subject.db_id).to eq('1')
        expect(subject.db_name).to eq('db1')
        expect(subject.schema_id).to eq(1)
        expect(subject.schema_name).to eq('public')
        expect(subject.table_id).to eq(1)
        expect(subject.table_name).to eq('events')
        expect(subject.stats_pct_off).to eq(0.12)
        expect(subject.size_pct_unsorted).to eq(0.13)
        expect(subject.row_count).to eq(123_456)
        expect(subject.sort_key).to eq('id')
      end
    end
  end

  describe '#full_name', :stubbed_client do
    subject { Intermix::Table.new(stubbed_table.with_indifferent_access) }

    it 'returns the schema name along with the table name' do
      expect(subject.full_name).to eq('"public"."events"')
    end
  end
end
