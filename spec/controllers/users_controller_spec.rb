require 'spec_helper'

describe Clearance::UsersController do
  describe "when signed out" do
    before { sign_out }

    describe "on GET to #new" do
      before { get :new }

      it { should respond_with(:success) }
      it { should render_template(:new) }
      it { should_not set_the_flash }
    end

    describe "on GET to #new with email" do
      before do
        @email = "a@example.com"
        get :new, :user => { :email => @email }
      end

      it "should set assigned user's email" do
        assigns(:user).email.should == @email
      end
    end

    describe "on POST to #create with valid attributes" do
      before do
        user_attributes = Factory.attributes_for(:user)
        @old_user_count = User.count
        post :create, :user => user_attributes
      end

      it { should assign_to(:user) }

      it "should create a new user" do
        User.count.should == @old_user_count + 1
      end

      it { should set_the_flash.to(/signed up/i) }
      it { should redirect_to_url_after_create }
    end
  end

  describe "A signed-in user" do
    before do
      @user = Factory(:user)
      sign_in_as @user
    end

    describe "GET to new" do
      before { get :new }
      it "redirects to the home page" do
        should redirect_to(root_url)
      end
    end

    describe "POST to create" do
      before { post :create, :user => {} }
      it "redirects to the home page" do
        should redirect_to(root_url)
      end
    end
  end
end
