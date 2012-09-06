require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }
    
    describe "with invalid information" do
      
      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }
    
    describe "as correct user" do
      before { visit root_path }
      
      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe "pagination microposts" do
    before do
      31.times { FactoryGirl.create(:micropost, user: user) }
      visit root_path
    end

    it {should have_selector('div.pagination')}
    it "should list each microposts" do
      Micropost.paginate(page: 1).each do |micropost|
        page.should have_selector('li', text: micropost.content)
      end
    end
  end

  describe "delete link" do
    before do
      @micropost1 = FactoryGirl.create(:micropost, user: user)
      @other_user = FactoryGirl.create(:user)
      FactoryGirl.create(:micropost, user: @other_user)
    end
    
    it "should have delete link" do
      visit user_path(user)
      should have_link("delete")
    end

    it "should not have delete link" do
      visit user_path(@other_user)
      should_not have_link("delete")
    end
  end
end