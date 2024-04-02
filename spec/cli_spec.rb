describe Shaman::CLI do
  include Shaman::TestHelpers::Terminal
  include Shaman::TestHelpers::Command

  before { mock_terminal }

  it 'prints version' do
    mock_argv(['-v'])
    described_class.new.run

    expect(term_output.string).to eq("shaman #{Shaman::VERSION}\n")
  end
end
