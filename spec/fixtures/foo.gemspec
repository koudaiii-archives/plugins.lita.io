Gem::Specification.new do |spec|
  spec.name          = "foo"
  spec.version       = '0.0.1'
  spec.authors       = ["Bongo Wongo"]
  spec.email         = ["bongo@example.com"]
  spec.description   = %q{A Lita adapter for Foo}
  spec.summary       = %q{Foo summary}
  spec.homepage      = 'http://example.com/foo'
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "adapter" }

  spec.add_runtime_dependency "lita", ">= 3.0"
end
