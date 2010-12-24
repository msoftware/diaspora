#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe Retraction do

  let(:user) { Factory.create(:user) }
  let(:person) { Factory(:person) }
  let(:aspect) { user.aspects.create(:name => "Bruisers") }
  let!(:activation) { user.activate_contact(person, aspect) }
  let!(:post) { user.post :status_message, :message => "Destroy!", :to => aspect.id }

  describe 'serialization' do
    it 'should have a post id after serialization' do
      retraction = Retraction.for(post)
      xml = retraction.to_xml.to_s
      xml.include?(post.guid.to_s).should == true
    end
  end

  describe 'dispatching' do
    it 'should dispatch a message on destroy' do
      MessageHandler.should_receive :add_post_request
      post.destroy
    end
  end

end
