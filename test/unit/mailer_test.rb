require File.expand_path('../../test_helper', __FILE__)

describe "Mailer", ActionMailer::TestCase do
  it "should render a reset password message" do
    member = members(:alloy)
    member.generate_reset_password_token!
    url = "http://test.host/password/#{member.reset_password_token}/edit"
    
    email = Mailer.create_reset_password_message(member, url)
    email.to.first.should == member.email
    email.body.should.include url
  end
  
  it "should send a member invitation message" do
    member = Member.create!(:email => 'new@example.com')
    url = "http://test.host/members/#{member.invitation_token}/edit"
    
    email = Mailer.create_member_invitation(member)
    email.to.should == %w{ new@example.com }
    email.body.should.include url
  end
end