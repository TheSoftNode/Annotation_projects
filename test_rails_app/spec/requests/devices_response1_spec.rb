require 'rails_helper'

RSpec.describe "Devices Response 1", type: :request do
  # Original show test from the prompt
  context 'show' do
    context 'user with access to parent entity' do
      it 'allows access' do
        customer = create :customer
        entity = create :entity, customer_id: customer.id
        user = create :user, role: :guest, customer: customer, entity_ids: [entity.id]
        device = create :device, entity: entity, customer: customer

        cookies['enectiva_jwt'] = sign_in user
        get "/cs/devices/#{device.id}"

        expect(response).to have_http_status(:ok)
      end
    end

    context 'user without access to parent entity' do
      it 'redirects to missing entity page' do
        customer = create :customer
        entity = create :entity, customer_id: customer.id
        user = create :user, role: :guest, customer: customer, entity_ids: []
        device = create :device, entity: entity, customer: customer

        cookies['enectiva_jwt'] = sign_in user
        get "/cs/devices/#{device.id}"

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # Response 1 expanded code (VERBATIM)
  context 'new' do
    context 'user with access to parent entity' do
      it 'allows access to new form' do
        customer = create :customer
        entity = create :entity, customer_id: customer.id
        user = create :user, role: :guest, customer: customer, entity_ids: [entity.id]

        cookies['enectiva_jwt'] = sign_in user
        get "/cs/devices/new", params: { entity_id: entity.id }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("New Device") # Verify form content
      end
    end

    context 'user without access to parent entity' do
      it 'returns not found when accessing new form' do
        customer = create :customer
        entity = create :entity, customer_id: customer.id
        user = create :user, role: :guest, customer: customer, entity_ids: []

        cookies['enectiva_jwt'] = sign_in user
        get "/cs/devices/new", params: { entity_id: entity.id }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context 'create' do
    context 'user with access to parent entity' do
      it 'creates a new device' do
        customer = create :customer
        entity = create :entity, customer_id: customer.id
        user = create :user, role: :guest, customer: customer, entity_ids: [entity.id]
        device_params = {
          name: "New Device",
          entity_id: entity.id,
          customer_id: customer.id # Required if not inferred from user
        }

        cookies['enectiva_jwt'] = sign_in user
        post "/cs/devices", params: { device: device_params }

        expect(response).to have_http_status(:found) # Redirect after create
        expect(response).to redirect_to("/cs/devices/#{Device.last.id}")
        expect(Device.last.name).to eq("New Device")
      end
    end

    context 'user without access to parent entity' do
      it 'prevents device creation' do
        customer = create :customer
        entity = create :entity, customer_id: customer.id
        user = create :user, role: :guest, customer: customer, entity_ids: []
        device_params = {
          name: "Unauthorized Device",
          entity_id: entity.id,
          customer_id: customer.id
        }

        cookies['enectiva_jwt'] = sign_in user
        post "/cs/devices", params: { device: device_params }

        expect(response).to have_http_status(:not_found)
        expect(Device.where(name: "Unauthorized Device")).not_to exist
      end
    end
  end

  context 'update' do
    context 'user with access to parent entity' do
      it 'updates existing device' do
        customer = create :customer
        entity = create :entity, customer_id: customer.id
        user = create :user, role: :guest, customer: customer, entity_ids: [entity.id]
        device = create :device, entity: entity, customer: customer
        update_params = { name: "Updated Device Name" }

        cookies['enectiva_jwt'] = sign_in user
        patch "/cs/devices/#{device.id}", params: { device: update_params }

        expect(response).to have_http_status(:found) # Redirect after update
        expect(device.reload.name).to eq("Updated Device Name")
      end
    end

    context 'user without access to parent entity' do
      it 'prevents device update' do
        customer = create :customer
        entity = create :entity, customer_id: customer.id
        user = create :user, role: :guest, customer: customer, entity_ids: []
        device = create :device, entity: entity, customer: customer
        original_name = device.name
        update_params = { name: "Hacked Device" }

        cookies['enectiva_jwt'] = sign_in user
        patch "/cs/devices/#{device.id}", params: { device: update_params }

        expect(response).to have_http_status(:not_found)
        expect(device.reload.name).to eq(original_name) # Verify no change
      end
    end
  end

  context 'destroy' do
    context 'user with access to parent entity' do
      it 'deletes device successfully' do
        customer = create :customer
        entity = create :entity, customer_id: customer.id
        user = create :user, role: :guest, customer: customer, entity_ids: [entity.id]
        device = create :device, entity: entity, customer: customer

        cookies['enectiva_jwt'] = sign_in user
        delete "/cs/devices/#{device.id}"

        expect(response).to have_http_status(:found) # Redirect after destroy
        expect(Device.where(id: device.id)).not_to exist
      end
    end

    context 'user without access to parent entity' do
      it 'prevents device deletion' do
        customer = create :customer
        entity = create :entity, customer_id: customer.id
        user = create :user, role: :guest, customer: customer, entity_ids: []
        device = create :device, entity: entity, customer: customer

        cookies['enectiva_jwt'] = sign_in user
        delete "/cs/devices/#{device.id}"

        expect(response).to have_http_status(:not_found)
        expect(Device.where(id: device.id)).to exist # Verify still exists
      end
    end
  end
end
