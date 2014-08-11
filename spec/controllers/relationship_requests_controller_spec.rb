require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe RelationshipRequestsController do

  # This should return the minimal set of attributes required to create a valid
  # RelationshipRequest. As you add validations to RelationshipRequest, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { {  } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RelationshipRequestsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all relationship_requests as @relationship_requests" do
      relationship_request = RelationshipRequest.create! valid_attributes
      get :index, {}, valid_session
      assigns(:relationship_request).should eq([relationship_request])
    end
  end

  describe "GET show" do
    it "assigns the requested relationship_request as @relationship_request" do
      relationship_request = RelationshipRequest.create! valid_attributes
      get :show, {:id => relationship_request.to_param}, valid_session
      assigns(:relationship_request).should eq(relationship_request)
    end
  end

  describe "GET new" do
    it "assigns a new relationship_request as @relationship_request" do
      get :new, {}, valid_session
      assigns(:relationship_request).should be_a_new(RelationshipRequest)
    end
  end

  describe "GET edit" do
    it "assigns the requested relationship_request as @relationship_request" do
      relationship_request = RelationshipRequest.create! valid_attributes
      get :edit, {:id => relationship_request.to_param}, valid_session
      assigns(:relationship_request).should eq(relationship_request)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new RelationshipRequest" do
        expect {
          post :create, {:relationship_request => valid_attributes}, valid_session
        }.to change(RelationshipRequest, :count).by(1)
      end

      it "assigns a newly created relationship_request as @relationship_request" do
        post :create, {:relationship_request => valid_attributes}, valid_session
        assigns(:relationship_request).should be_a(RelationshipRequest)
        assigns(:relationship_request).should be_persisted
      end

      it "redirects to the created relationship_request" do
        post :create, {:relationship_request => valid_attributes}, valid_session
        response.should redirect_to(RelationshipRequest.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved relationship_request as @relationship_request" do
        # Trigger the behavior that occurs when invalid params are submitted
        RelationshipRequest.any_instance.stub(:save).and_return(false)
        post :create, {:relationship_request => {  }}, valid_session
        assigns(:relationship_request).should be_a_new(RelationshipRequest)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        RelationshipRequest.any_instance.stub(:save).and_return(false)
        post :create, {:relationship_request => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested relationship_request" do
        relationship_request = RelationshipRequest.create! valid_attributes
        # Assuming there are no other relationship_request in the database, this
        # specifies that the RelationshipRequest created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        RelationshipRequest.any_instance.should_receive(:update).with({ "these" => "params" })
        put :update, {:id => relationship_request.to_param, :relationship_request => { "these" => "params" }}, valid_session
      end

      it "assigns the requested relationship_request as @relationship_request" do
        relationship_request = RelationshipRequest.create! valid_attributes
        put :update, {:id => relationship_request.to_param, :relationship_request => valid_attributes}, valid_session
        assigns(:relationship_request).should eq(relationship_request)
      end

      it "redirects to the relationship_request" do
        relationship_request = RelationshipRequest.create! valid_attributes
        put :update, {:id => relationship_request.to_param, :relationship_request => valid_attributes}, valid_session
        response.should redirect_to(relationship_request)
      end
    end

    describe "with invalid params" do
      it "assigns the relationship_request as @relationship_request" do
        relationship_request = RelationshipRequest.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        RelationshipRequest.any_instance.stub(:save).and_return(false)
        put :update, {:id => relationship_request.to_param, :relationship_request => {  }}, valid_session
        assigns(:relationship_request).should eq(relationship_request)
      end

      it "re-renders the 'edit' template" do
        relationship_request = RelationshipRequest.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        RelationshipRequest.any_instance.stub(:save).and_return(false)
        put :update, {:id => relationship_request.to_param, :relationship_request => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested relationship_request" do
      relationship_request = RelationshipRequest.create! valid_attributes
      expect {
        delete :destroy, {:id => relationship_request.to_param}, valid_session
      }.to change(RelationshipRequest, :count).by(-1)
    end

    it "redirects to the relationship_request list" do
      relationship_request = RelationshipRequest.create! valid_attributes
      delete :destroy, {:id => relationship_request.to_param}, valid_session
      response.should redirect_to(relationship_requests_url)
    end
  end

end