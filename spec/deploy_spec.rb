describe Shaman::Deploy do
  include Shaman::TestHelpers::Prompt
  include Shaman::TestHelpers::Terminal
  include Shaman::TestHelpers::Command

  before do
    test_prompt
    mock_terminal
  end

  context 'when SHAMAN_TOKEN environment variable is valid' do
    before do
      ENV['SHAMAN_TOKEN'] = '***'
    end

    it 'creates a release' do
      stub = stub_request(:post, 'https://infinum.tryoutapps.com/api/v1/releases')
             .to_return(status: 200, body: 'Successfuly deployed extra v1.2.3', headers: {})

      within_test_dir do
        cp_file_fixture('test.ipa')
        write_config({ 'default' => { release_path: 'test.ipa', token: 'xyz' } })
        expect do
          run_command('deploy', options: ['-m', 'New build', '-n', '1.2.3'])
        end.to raise_error(SystemExit)
      end

      expect(Shaman.prompt.output.string).to include('Successfuly deployed extra v1.2.3')
      expect(stub).to have_been_requested
    end
  end

  context 'when SHAMAN_TOKEN environment variable is invalid' do
    before do
      ENV['SHAMAN_TOKEN'] = '<invalid>'
    end

    it 'shows an error' do
      stub = stub_request(:post, 'https://infinum.tryoutapps.com/api/v1/releases')
             .to_return(status: 401, body: 'Invalid token', headers: {})

      within_test_dir do
        cp_file_fixture('test.ipa')
        write_config({ 'default' => { release_path: 'test.ipa', token: 'xyz' } })
        expect do
          run_command('deploy', options: ['-m', 'New build', '-n', '1.2.3'])
        end.to raise_error(SystemExit)
        expect(Shaman.prompt.output.string).to include('Failed to create a release: Invalid token')
      end
      expect(stub).to have_been_requested
    end
  end
end
