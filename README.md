Jsonoid
=======
A simple serverless NoSQL (JSON) document storage system.

*At this point, you should consider it pre-alpha quality and shouldn't
even contemplate about using it in production.*

Getting Started
---------------

Install the `gem` via:

```bash
gem install jsonoid
```

or add it into your `Gemfile`:

```bash
gem 'jsonoid'
```

Then create an `initializer` in the likes of:

```ruby
Jsonoid.configure do |config|
  config.db = File.join(File.dirname(__FILE__), 'db')
end
```

Create a model and cruise away:

```ruby
class Post
  include Jsonoid::Document
  include Jsonoid::Timestamp

  before_save :add_byline

  field :title
  field :description
  field :author, :type => String
  field :score, :type => Integer

  protected

  def add_byline
    self.description += "\n#{self.author}" unless self.author.nil?
  end
end

post = Post.new(:title => 'Hello World')
post.description = 'The quick brown fox jumps over the lazy dog.'
post.author = 'Fox'
post.score = 10
post.save
```

```ruby
post = Post.find('2cfe7b2e885f225746264b3c6c0beb57')
post.destroy unless post.nil?
```

Profit :)

TODO
----
* tests (rspec)
* documentation
* index and where() support
* metric tons of other things :)

Contribute
----------
* Fork the project.
* Make your feature addition or bug fix.
* Do **not** bump the version number.
* Send me a pull request. Bonus points for topic branches.

License
-------
Copyright (c) 2013, Mihail Szabolcs

Jsonoid is provided **as-is** under the **MIT** license. For more information see
LICENSE.
