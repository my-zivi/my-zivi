require 'rails_helper'

RSpec.describe "organizations/service_specifications/show", type: :view do
  before(:each) do
    @organizations_service_specification = assign(:organizations_service_specification, Organizations::ServiceSpecification.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
