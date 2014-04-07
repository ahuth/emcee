# Emcee

Emcee is an extension to the [Rails Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html).
It allows you to import and package [web components](http://www.w3.org/TR/components-intro/) exactly as
you would Javascript or CSS.

## Installation

Add Emcee to your Gemfile:

    gem 'emcee'

and then execute:

    $ bundle install

Finally, run:

    $ rails generate emcee:install

This will insert `<%= html_import_tag "application" %>` into your application layout. Also,
it will create 'elements' directories under '/assets' and '/vendor/assets'.

## Usage

Once installed, you will have a manifest file located at `/assets/elements/application.html`.
Use [sprockets directives](https://github.com/sstephenson/sprockets#sprockets-directives) to

In a development environment, all web components referenced in the manifest will be included as
seperate html imports. In production, they will be concatenated into one import.
include web components located in one of the assets directories.

When referencing web components, you must point to the html file, not the directory. For example,
if you have the following directory structure:
```
vendor
|- assets
  |- elements
    |- ui-tabs
       |- ui-tabs.html
```
You must reference this in the manifest file as:
```
*= require ui-tabs/ui-tabs
```

## Contributing

1. Fork it
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## Special Thanks

Special thanks to the [Polymer Project](http://www.polymer-project.org/), which Emcee
was designed to work with. They've designed an amazing piece of technology that
will change how web apps are made.
