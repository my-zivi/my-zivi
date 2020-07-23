require 'rails_helper'

RSpec.describe "organizations/service_specifications/edit", type: :view do
  before(:each) do
    @organizations_service_specification = assign(:organizations_service_specification, Organizations::ServiceSpecification.create!())
  end

  it "renders the edit organizations_service_specification form" do
    render

    assert_select "form[action=?][method=?]", organizations_service_specification_path(@organizations_service_specification), "post" do
    end
  end
end
