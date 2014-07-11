require 'spec_helper'

describe "relationship_request/show" do
  before(:each) do
    @relationship_request = assign(:relationship_request, stub_model(RelationshipRequest))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
