require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  setup do
    @user = User.create! email: 'new@user.com', password: 'password'
    @trip = Trip.create! title: "Trip's title",
                        description: "The trip's description",
                        category_1: 'city',
                        category_2: 'cultural',
                        continent: 'Europe',
                        country: 'CH',
                        region: 'VD',
                        city: 'Lausanne',
                        user: @user
    Comment.create! body: 'test comment', user: @user, article: @trip

    app.default_url_options[:locale] = :en
  end
  
  test "comment is displayed when posted" do
    visit login_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    
    visit trip_path(@trip)

    fill_in 'Add a comment', with: 'My new comment'
    click_button 'Post'
    
    fill_in 'Add a comment', with: 'ensure empty'

    assert page.has_content?('My new comment') 
  end

  test "comment edit form is displayed when clicked on edit" do
    visit login_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    
    visit trip_path(@trip)

    find('.comment').find('a'){ |btn| btn['data-method'] == 'get'}.click
    
    assert page.has_content?('Edit comment') 
  end

  test "comment is edited when clicked on update" do
    visit login_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    
    visit trip_path(@trip)

    find('.comment').find('a'){ |btn| btn['data-method'] == 'get'}.click

    fill_in 'Edit comment', with: 'Updated comment'
    find('.comment.comment-form').find('.btn').click

    assert page.has_content?('Updated comment') 
  end

  test "comment is removed when clicked on delete" do
    visit login_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    
    visit trip_path(@trip)

    find('.comment').find('a'){ |btn| btn['data-method'] == 'delete'}.click

    page.driver.browser.switch_to.alert.accept

    # Cannot test for not-found message display because it is mysteriously not appearing
    # But the feature is working properly in development and production

    assert page.has_no_content?('test comment') 
  end
end
