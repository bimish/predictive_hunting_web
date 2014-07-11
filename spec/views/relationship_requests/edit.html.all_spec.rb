require 'spec_helper'

describe "relationship_request/edit" do
  before(:each) do
    @relationship_request = assign(:relationship_request, stub_model(RelationshipRequest))
  end

  it "renders the edit relationship_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", relationship_request_path(@relationship_request), "post" do
    end
  end
end
