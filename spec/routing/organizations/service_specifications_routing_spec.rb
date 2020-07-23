require "rails_helper"

RSpec.describe Organizations::ServiceSpecificationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/organizations/service_specifications").to route_to("organizations/service_specifications#index")
    end

    it "routes to #new" do
      expect(get: "/organizations/service_specifications/new").to route_to("organizations/service_specifications#new")
    end

    it "routes to #show" do
      expect(get: "/organizations/service_specifications/1").to route_to("organizations/service_specifications#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/organizations/service_specifications/1/edit").to route_to("organizations/service_specifications#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/organizations/service_specifications").to route_to("organizations/service_specifications#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/organizations/service_specifications/1").to route_to("organizations/service_specifications#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/organizations/service_specifications/1").to route_to("organizations/service_specifications#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/organizations/service_specifications/1").to route_to("organizations/service_specifications#destroy", id: "1")
    end
  end
end
