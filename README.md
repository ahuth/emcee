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

Once installed, you can include web components just like you would javascript files.
In the manifest file located at '/assets/elements/application.html', use asset pipeline
directives to specify what webcomponents you want imported.

Each specified component will be included in the html as an html import. Additionally,
if any components list their own dependencies internally with more html imports,
the asset pipeline will package those up as well. Any references to external CSS or
Javascript files will also be loaded and inserted inline with the component.

Finally, in production each component will be concatenated into one file and all
comments removed, in order to reduce http requests.

## Contributing

I'm still learning about Ruby, gems, and open source projects in general, and I
would love for you to contribute!

1. Fork it
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## Special Thanks

Special thanks to the [Polymer Project](http://www.polymer-project.org/), which Emcee
was designed to work with. They've designed an amazing piece of technology that
will change how web apps are made.
