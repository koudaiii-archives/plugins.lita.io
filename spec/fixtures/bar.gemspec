Gem::Specification.new do |spec|
  spec.name          = "bar"
  spec.version       = '0.1.0'
  spec.authors       = ["Joe Blow"]
  spec.email         = ["joe@example.com"]
  spec.description   = %q{A Lita handler for Bar}
  spec.summary       = %q{Bar summary}
  spec.homepage      = 'http://example.com/bar'
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.add_runtime_dependency "lita", ">= 2.5", "!= 2.7"
end
