require "middleman-core"
require "middleman-ogp/version"

::Middleman::Extensions.register(:ogp) do
  require "middleman-ogp/extension"
  ::Middleman::OGP::OGPExtension
end
