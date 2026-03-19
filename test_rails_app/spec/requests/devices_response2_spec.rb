require 'rails_helper'

# Response 2's AuthHelpers (VERBATIM from task)
module AuthHelpers
  def sign_in_as(user)
    sign_in(user)
    cookies['enectiva_jwt'] = user.auth_token # or whatever you actually use
  end

  def grant_entity_access(user, *entity_ids)
    user.update!(entity_ids: entity_ids.map(&:to_uuid))
  end
end

RSpec.configure { |c| c.include AuthHelpers, type: :request }

# Response 2 EXACT code from task_1
RSpec.describe 'CS::Devices', type: :request do
  let!(:customer) { create(:customer) }
  let!(:entity) { create(:entity, customer_id: customer.id) }
  let!(:device) { create(:device, entity: entity, customer: customer) }

  let(:authorized_user) do
    user = create(:user,
      role: :guest,
      customer: customer,
      entity_ids: [entity.id])
    sign_in_as(user)
    user
  end

  context 'show' do
    context 'user with access to parent entity' do
      it 'allows access' do
        sign_in_as(authorized_user)

        get "/cs/devices/#{device.id}"
        expect(response).to have_http_status(:ok)
      end
    end

    context 'user without access to parent entity' do
      it 'redirects to missing entity page' do
        user = create(:user, role: :guest, customer: customer, entity_ids: [])
        sign_in_as(user)

        get "/cs/devices/#{device.id}"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context 'new' do
    it 'renders the NEW form for an authorized user' do
      sign_in_as(authorized_user)

      get '/cs/devices/new'
      expect(response).to render_template(:new)
      expect(response.body).to include('csrf-token')
    end

    it 'redirects to root for unauthorized user' do
      unauthorized_user = create(:user, role: :guest, customer: customer, entity_ids: [])
      sign_in_as(unauthorized_user)

      get '/cs/devices/new'
      expect(response).to redirect_to(root_path)
    end
  end

  context 'create' do
    let(:valid_attributes) { attributes_for(:device).merge(entity_id: entity.id) }

    it 'creates a device when the user owns the parent entity' do
      sign_in_as(authorized_user)

      expect {
        post '/cs/devices',
             params: { device: valid_attributes }
      }.to change(Device, :count).by(1)

      expect(response).to redirect_to("/cs/devices/#{Device.last.id}")
      follow_redirect!
      expect(response.body).to include("Device '#{Device.last.name}' was successfully created.")
    end

    it 'redirects to root (or error page) when parent access is missing' do
      unauthorized_user = create(:user, role: :guest, customer: customer, entity_ids: [])
      sign_in_as(unauthorized_user)

      expect {
        post '/cs/devices',
             params: { device: valid_attributes }
      }.not_to change(Device, :count)

      expect(response).to redirect_to(root_path)
    end
  end

  context 'new (edit) — renders edit form' do
    it 'renders the edit form for an authorized user' do
      sign_in_as(authorized_user)

      get "/cs/devices/#{device.id}/edit"
      expect(response).to render_template(:edit)
      expect(response.body).to include('name="device[name]"')
    end

    it 'redirects to root for unauthorized user' do
      unauthorized_user = create(:user, role: :guest, customer: customer, entity_ids: [])
      sign_in_as(unauthorized_user)

      get "/cs/devices/#{device.id}/edit"
      expect(response).to redirect_to(root_path)
    end
  end

  context 'update' do
    let(:new_attributes) { { name: 'Updated name', description: 'Updated description' } }

    it 'updates the device when the user can access its parent' do
      sign_in_as(authorized_user)

      patch "/cs/devices/#{device.id}",
            params: { device: new_attributes }

      device.reload
      expect(device.name).to eq('Updated name')
      expect(device.description).to eq('Updated description')
      expect(response).to redirect_to("/cs/devices/#{device.id}")
    end

    it 'fails to update and redirects if parent access is missing' do
      unauthorized_user = create(:user, role: :guest, customer: customer, entity_ids: [])
      sign_in_as(unauthorized_user)

      patch "/cs/devices/#{device.id}",
            params: { device: new_attributes }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to be_present
    end
  end

  context 'destroy' do
    it 'deletes the device when the user owns the parent entity' do
      sign_in_as(authorized_user)

      expect {
        delete "/cs/devices/#{device.id}"
      }.to change(Device, :count).by(-1)

      expect(response).to redirect_to('/cs/devices')
      follow_redirect!
      expect(response.body).to include('Device was successfully destroyed.')
    end

    it 'does nothing (redirects) when the user lacks parent access' do
      unauthorized_user = create(:user, role: :guest, customer: customer, entity_ids: [])
      sign_in_as(unauthorized_user)

      expect {
        delete "/cs/devices/#{device.id}"
      }.not_to change(Device, :count)

      expect(response).to redirect_to(root_path)
    end
  end
end
