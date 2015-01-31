require 'rails_helper'

describe PluginsController do
  let(:plugins) do
    HashWithIndifferentAccess.new(
      adapters: [instance_double('Plugin')],
      handlers: [instance_double('Plugin')],
      extensions: [instance_double('Plugin')],
      nil => [instance_double('Plugin')]
    )
  end

  before do
    allow(Plugin).to receive(:alphabetical_by_type).and_return(plugins)
  end

  describe '#index' do
    it 'returns a successful response' do
      get :index

      expect(response.status).to eq(200)
    end

    it 'renders the template' do
      get :index

      expect(response).to render_template(:index)
    end

    it 'loads plugins' do
      get :index

      expect(assigns(:plugins)).to eq(plugins)
    end

    it 'returns an empty array for plugins of an unknown type' do
      get :index

      expect(assigns(:plugins)['made up type']).to eq([])
    end
  end
end
