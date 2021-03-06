require File.expand_path('../../test_helper', __FILE__)

describe Message, 'concerning validations' do
  before do
    @message = messages(:patrick_hernandez)
  end
  
  it "should be valid with an author, room, and body" do
    @message.should.be.valid
  end
  
  it "should be invalid without a body" do
    @message.body = ''
    @message.should.not.be.valid
    @message.errors.on(:body).should.not.be.blank
  end
  
  it "should be invalid without an associated room" do
    @message.room = nil
    @message.should.not.be.valid
    @message.errors.on(:room_id).should.not.be.blank
  end
  
  it "should be invalid without an associated member" do
    @message.author = nil
    @message.should.not.be.valid
    @message.errors.on(:author_id).should.not.be.blank
  end
end

describe "A", Message do
  before do
    @message = messages(:patrick_hernandez)
  end
  
  it "should return it's author" do
    @message.author.should == members(:matt)
  end
  
  it "should return the room it was written in" do
    @message.room.should == rooms(:macruby)
  end
  
  it "should accept nested attributes for an attachment" do
    TMP.reset!
    
    Token.stubs(:generate).returns('556d2e8e')
    message = rooms(:macruby).messages.create!(:author => members(:lrz), :attachment_attributes => { :uploaded_file => rails_icon })
    message.should.be.attachment_message
    message.body.should == 'rails.png'
    original = message.attachment.original
    original.file_path.should == File.join(TMP, '55/6d/2e/8e/rails.png')
  end
end

describe Message do
  it "should return messages since a given id" do
    messages = Message.all
    Message.since(messages.first.id).should.equal_list messages[1..-1]
    Message.since(messages.second.id.to_s).should.equal_list messages[2..-1]
  end
  
  it "should return messages on a given date" do
    freeze_time!(Time.parse('01/01/2009'))
    messages = Message.all
    
    messages.last.update_attribute(:created_at, "2008-12-30")
    messages[1..2].each { |m| m.update_attribute(:created_at, "2008-12-31") }
    messages.first.update_attribute(:created_at, "2009-01-01")
    
    Message.find_created_on_date('2008', '12', '28').should.equal_list []
    Message.find_created_on_date('2008', '12', '30').should.equal_list [messages.last]
    Message.find_created_on_date('2008', '12', '31').should.equal_list messages[1..2]
    Message.find_created_on_date('2009', '1',  '1').should.equal_list  [messages.first]
    Message.find_created_on_date('2009', '1',  '2').should.equal_list  []
  end
  
  it "should return the 25 most recent messages" do
    room = rooms(:macruby)
    room.messages.delete_all
    messages = Array.new(26) { room.messages.create! :author => members(:lrz), :body => "foo" }
    room.reload.messages.recent.should.equal_list messages.last(25)
  end
end