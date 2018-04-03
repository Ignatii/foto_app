RSpec.shared_examples ‘a successful interaction’ do
 let(:outcome) { described_class.run params }  it ‘should be present’ do
   expect(outcome.present?).to be(true)
 end  it ‘should be valid’ do
   expect(outcome.valid?).to be(true)
 end  it ‘should validate required params presence’ do
   params.keys.each do |k|
     expect(described_class.run(params.except(k)).errors).to include(k)
   end
 end
end