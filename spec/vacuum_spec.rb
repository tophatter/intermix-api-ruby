# rspec spec/vacuum_spec.rb
RSpec.describe Intermix::Vacuum do
  describe '#initialize', :stubbed_client do
    let(:delete_only) { false }
    let(:full) { true }
    let(:sort) { false }

    subject { Intermix::Vacuum.new(client: client, full: full, delete_only: delete_only, sort: sort) }

    context 'when client is nil' do
      let(:client) { nil }
      
      it 'throws an error' do
        expect { subject }.to raise_error(ArgumentError, 'client cannot be nil.')
      end
    end

    context 'invalid vacuum mode' do
      context 'full and delete_only' do
        let(:full) { true }
        let(:delete_only) { true }
        let(:sort) { false }

        let(:client) { stubbed_client }

        it 'throws an error' do
          expect { subject }.to raise_error(ArgumentError, 'invalid vacuum mode.')
        end
      end

      context 'full and sort' do
        let(:full) { true }
        let(:delete_only) { false }
        let(:sort) { true }

        let(:client) { stubbed_client }

        it 'throws an error' do
          expect { subject }.to raise_error(ArgumentError, 'invalid vacuum mode.')
        end
      end
    end

    context 'valid vacuum mode' do
      context 'when it is only full' do
        let(:full) { true }
        let(:delete_only) { false }
        let(:sort) { false }

        let(:client) { stubbed_client }

        it 'assigns the correct attributes' do
          expect { subject }.not_to raise_error

          expect(subject.client).to be_present

          expect(subject.full).to be_truthy
          expect(subject.delete_only).to be_falsey
          expect(subject.sort).to be_falsey
          expect(subject.analyze).to be_truthy

          expect(subject.stats_off_threshold).to eq(0.10)
          expect(subject.stats_off_threshold).to eq(0.10)

          expect(subject.admin_user).to eq('')
          expect(subject.host).to eq('')
          expect(subject.port).to eq(5439)
        end
      end
    end
  end

  describe '#generate_script', :stubbed_client do
    let(:stats_off_threshold) { 0.21 }
    let(:unsorted_threshold) { 0.22 }
    let(:threshold_met) do
      [
        stubbed_table.merge(table_name: 'table1', stats_pct_off: 0.45, size_pct_unsorted: 0.41), #included
        stubbed_table.merge(table_name: 'table2', stats_pct_off: 0.56, size_pct_unsorted: 0.78)  #included
      ]
    end
    let(:threshold_unmet) do
      [
        stubbed_table.merge(table_name: 'table3', stats_pct_off: 0.45, size_pct_unsorted: nil),  #excluded
        stubbed_table.merge(table_name: 'table4', stats_pct_off: 0.45, size_pct_unsorted: 0.20), #excluded
        stubbed_table.merge(table_name: 'table5', stats_pct_off: 0.20, size_pct_unsorted: 0.41), #excluded
      ]
    end
    let(:excluded_schema) do
      [
        threshold_met.first.merge(schema_name: Intermix::Vacuum::IGNORED_SCHEMAS.first)
      ]
    end

    subject { Intermix::Vacuum.new(client: stubbed_client, delete_only: true,
                                   stats_off_threshold: stats_off_threshold, unsorted_threshold: unsorted_threshold).generate_script }

    before do
      tables = [threshold_met + threshold_unmet + excluded_schema].flatten.map { |t| Intermix::Table.new(t.with_indifferent_access) }
      allow(stubbed_client).to receive(:tables).and_return(tables)
    end

    it 'generates the expected script' do
      verify(format: :txt) { subject }
    end
  end
end