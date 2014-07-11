require 'spec_helper'

describe "relationship_request/new" do
  before(:each) do
    assign(:relationship_request, stub_model(RelationshipRequest).as_new_record)
  end

  it "renders new relationship_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", relationship_requests_path, "post" do
    end
  end
end
