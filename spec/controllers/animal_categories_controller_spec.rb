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

describe AnimalCategoriesController do

  # This should return the minimal set of attributes required to create a valid
  # AnimalCategory. As you add validations to AnimalCategory, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "animal_species" => "" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AnimalCategoriesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all animal_categories as @animal_categories" do
      animal_category = AnimalCategory.create! valid_attributes
      get :index, {}, valid_session
      assigns(:animal_categories).should eq([animal_category])
    end
  end

  describe "GET show" do
    it "assigns the requested animal_category as @animal_category" do
      animal_category = AnimalCategory.create! valid_attributes
      get :show, {:id => animal_category.to_param}, valid_session
      assigns(:animal_category).should eq(animal_category)
    end
  end

  describe "GET new" do
    it "assigns a new animal_category as @animal_category" do
      get :new, {}, valid_session
      assigns(:animal_category).should be_a_new(AnimalCategory)
    end
  end

  describe "GET edit" do
    it "assigns the requested animal_category as @animal_category" do
      animal_category = AnimalCategory.create! valid_attributes
      get :edit, {:id => animal_category.to_param}, valid_session
      assigns(:animal_category).should eq(animal_category)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new AnimalCategory" do
        expect {
          post :create, {:animal_category => valid_attributes}, valid_session
        }.to change(AnimalCategory, :count).by(1)
      end

      it "assigns a newly created animal_category as @animal_category" do
        post :create, {:animal_category => valid_attributes}, valid_session
        assigns(:animal_category).should be_a(AnimalCategory)
        assigns(:animal_category).should be_persisted
      end

      it "redirects to the created animal_category" do
        post :create, {:animal_category => valid_attributes}, valid_session
        response.should redirect_to(AnimalCategory.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved animal_category as @animal_category" do
        # Trigger the behavior that occurs when invalid params are submitted
        AnimalCategory.any_instance.stub(:save).and_return(false)
        post :create, {:animal_category => { "animal_species" => "invalid value" }}, valid_session
        assigns(:animal_category).should be_a_new(AnimalCategory)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        AnimalCategory.any_instance.stub(:save).and_return(false)
        post :create, {:animal_category => { "animal_species" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested animal_category" do
        animal_category = AnimalCategory.create! valid_attributes
        # Assuming there are no other animal_categories in the database, this
        # specifies that the AnimalCategory created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        AnimalCategory.any_instance.should_receive(:update).with({ "animal_species" => "" })
        put :update, {:id => animal_category.to_param, :animal_category => { "animal_species" => "" }}, valid_session
      end

      it "assigns the requested animal_category as @animal_category" do
        animal_category = AnimalCategory.create! valid_attributes
        put :update, {:id => animal_category.to_param, :animal_category => valid_attributes}, valid_session
        assigns(:animal_category).should eq(animal_category)
      end

      it "redirects to the animal_category" do
        animal_category = AnimalCategory.create! valid_attributes
        put :update, {:id => animal_category.to_param, :animal_category => valid_attributes}, valid_session
        response.should redirect_to(animal_category)
      end
    end

    describe "with invalid params" do
      it "assigns the animal_category as @animal_category" do
        animal_category = AnimalCategory.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        AnimalCategory.any_instance.stub(:save).and_return(false)
        put :update, {:id => animal_category.to_param, :animal_category => { "animal_species" => "invalid value" }}, valid_session
        assigns(:animal_category).should eq(animal_category)
      end

      it "re-renders the 'edit' template" do
        animal_category = AnimalCategory.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        AnimalCategory.any_instance.stub(:save).and_return(false)
        put :update, {:id => animal_category.to_param, :animal_category => { "animal_species" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested animal_category" do
      animal_category = AnimalCategory.create! valid_attributes
      expect {
        delete :destroy, {:id => animal_category.to_param}, valid_session
      }.to change(AnimalCategory, :count).by(-1)
    end

    it "redirects to the animal_categories list" do
      animal_category = AnimalCategory.create! valid_attributes
      delete :destroy, {:id => animal_category.to_param}, valid_session
      response.should redirect_to(animal_categories_url)
    end
  end

end
