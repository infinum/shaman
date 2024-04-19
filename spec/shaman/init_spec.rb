# frozen_string_literal: true

require 'json'

describe Shaman::Init do
  include Shaman::TestHelpers::Prompt
  include Shaman::TestHelpers::Terminal
  include Shaman::TestHelpers::Command

  before do
    test_prompt
    mock_terminal
  end

  context 'when SHAMAN_TOKEN environment variable is not defined' do
    before do
      ENV['SHAMAN_TOKEN'] = nil
    end

    it 'shows an error' do
      expect { run_command('init') }.to exit_with_status

      expect(Shaman.prompt.output.string).to include("SHAMAN_TOKEN isn't defined")
    end
  end

  context 'when SHAMAN_TOKEN environment variable is defined' do
    before do
      ENV['SHAMAN_TOKEN'] = '***'
    end

    it 'creates config file' do
      reply('android', '1', 'tmp/test/production.zip', 'tmp/test/staging.zip')

      stub = stub_request(:get, 'https://infinum.tryoutapps.com/api/v1/projects')
             .with(query: { platform: 'android', token: '***' })
             .to_return(status: 200, body: JSON.dump(projects), headers: {})

      within_test_dir do
        run_command('init')
        expect(YAML.load_file('.shaman.yml')).to eq(
          'extra-production' => { release_path: 'tmp/test/production.zip', token: 'a123' },
          'extra-staging' => { release_path: 'tmp/test/staging.zip', token: 'b456' }
        )
      end

      expect(stub).to have_been_requested
    end

    context 'when invoked with -f' do
      it 'requests only favorite projects' do
        reply 'android', '1'

        stub = stub_request(:get, 'https://infinum.tryoutapps.com/api/v1/projects')
               .with(query: { favorites: true, platform: 'android', token: '***' })
               .to_return(status: 200, body: JSON.dump(projects), headers: {})
        within_test_dir { run_command('init', options: ['-f']) }

        expect(stub).to have_been_requested
      end
    end

    context 'when invoked with -s' do
      it 'filters projects by specified term' do
        reply 'android', '1'

        stub = stub_request(:get, 'https://infinum.tryoutapps.com/api/v1/projects')
               .with(query: { search: 'extra', platform: 'android', token: '***' })
               .to_return(status: 200, body: JSON.dump(projects), headers: {})
        within_test_dir { run_command('init', options: ['-s', 'extra']) }
        expect(stub).to have_been_requested
      end
    end

    context 'when invoked with -p' do
      it 'selects the platform' do
        reply '1'

        stub = stub_request(:get, 'https://infinum.tryoutapps.com/api/v1/projects')
               .with(query: { platform: 'ios', token: '***' })
               .to_return(status: 200, body: JSON.dump(projects), headers: {})

        within_test_dir { run_command('init', options: ['-p', 'ios']) }
        expect(stub).to have_been_requested
      end
    end

    context 'when invoked with -i' do
      it 'selects the project' do
        reply('android')
        stub = stub_request(:get, 'https://infinum.tryoutapps.com/api/v1/projects')
               .with(query: { platform: 'ios', token: '***' })
               .to_return(status: 200, body: JSON.dump(projects), headers: {})

        within_test_dir { run_command('init', options: ['-p', 'ios']) }
        expect(stub).to have_been_requested
      end
    end
  end

  context 'when SHAMAN_TOKEN environment variable is invalid' do
    before do
      ENV['SHAMAN_TOKEN'] = '<invalid>'
    end

    it 'shows an error' do
      reply('android')
      stub = stub_request(:get, 'https://infinum.tryoutapps.com/api/v1/projects')
             .with(query: { platform: 'android', token: '<invalid>' })
             .to_return(status: 401, body: 'Invalid token', headers: {})

      within_test_dir do
        expect { run_command('init') }.to exit_with_status
        expect(Shaman.prompt.output.string).to include('Failed to load projects: Invalid token')
      end
      expect(stub).to have_been_requested
    end
  end

  def projects
    [project_extra, project_guess_who]
  end

  def project_extra
    {
      id: 123,
      name: 'extra',
      environments: [
        { token: 'a123', name: 'extra-production', platform: 'android' },
        { token: 'b456', name: 'extra-staging', platform: 'android' }
      ]
    }
  end

  def project_guess_who
    {
      id: 456,
      name: 'guess-who',
      environments: [
        { token: 'c789', name: 'guess-show-production', platform: 'ios' },
        { token: 'dxyz', name: 'guess-who-staging', platform: 'ios' }
      ]
    }
  end
end
