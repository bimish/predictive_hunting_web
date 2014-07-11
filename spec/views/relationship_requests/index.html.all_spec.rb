require 'spec_helper'

describe "relationship_request/index" do
  before(:each) do
    assign(:relationship_request, [
      stub_model(RelationshipRequest),
      stub_model(RelationshipRequest)
    ])
  end

  it "renders a list of relationship_request" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
