[![Gem Version](https://badge.fury.io/rb/shaman_cli.svg)](https://badge.fury.io/rb/shaman_cli)

# Shaman

CLI for deploying builds to Tryoutapps.com

## Installation

Install it yourself as:

    $ gem install shaman_cli

Get your user token from `https://[TENANT].tryoutapps.com/users/me` and export it to environment variable `SHAMAN_TOKEN`.

    export SHAMAN_TOKEN=infnweoinfwi32r23jr2309j

Export your Tryoutapps tenant URL to the environement variable `SERVER_URL`

    export SERVER_URL=https://[TENANT].tryoutapps.com


## Usage
First make sure that you have created your `project` and the desired `environment` on you Tryoutapps tenant. This will allow you to see all your tenant independent projects in the shaman init prompt.

### Init

    $ shaman init

    Initialize your project

    Options:
      -s, --search STRING  Shrink project selection
      -f, --favorites      Show only favorites
      -p, --platform PLATFORM Choose platform
      -i, --project_id PROJECT Choose project id

Example of `.shaman.yml`

      ---
      production:
        :release_path: spec/files/test.ipa
        :token: Hu6vuqgEF3FzrmenDQ1kk86R


Explanation:

`release_path`      - this is the path to the release file
`token`             - This is the environment token for communicating with API

### Deploy

This will deploy your relese file to labs with with configs from .shaman.yml

    $ shaman deploy

    $ shaman deploy [environment]

    Deploy a release to specified environment

    Options:
      -m, --message MESSAGE             Changelog message
      -f, --file FILE                   Release path
      -t, --token TOKEN                 Use different user token
      -c, --config FILE                 Use different config file
      -g, --git                         Use git for message (overrides any manual settings!)
      -C, --commit COMMIT               Which commit to use instead of HEAD
      -n, --release_name RELEASE_NAME   Release name (ZIP platform only)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update
the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for
the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
