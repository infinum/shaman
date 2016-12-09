[![Gem Version](https://badge.fury.io/rb/shaman_cli.svg)](https://badge.fury.io/rb/shaman_cli)

# Shaman

Cli for integrating with labs.infinum.co

## Installation

Install it yourself as:

    $ gem install shaman_cli

Get your user token from `https://labs.infinum.co/users/me` and export it to environment variable `SHAMAN_TOKEN`

    export SHAMAN_TOKEN=infnweoinfwi32r23jr2309j

## Usage

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
      -m, --message MESSAGE Changelog message
      -f, --file FILE      Release path
      -t, --token TOKEN    Use different user token
      -c, --config FILE    Use different config file
      -g, --git            Use git for message (overrides any manual settings!)
      -C, --commit COMMIT  which commit to use instead of HEAD


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).