class PluginsController < ApplicationController
  def index
    @plugins = Plugin.alphabetical_by_type
    @plugins.default = []
  end
end
