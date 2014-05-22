require 'spec_helper'
require 'chef/knife/openstack_group_list'
require 'chef/knife/cloud/openstack_service'
require 'support/shared_examples_for_command'

describe Chef::Knife::Cloud::OpenstackGroupList do
  it_behaves_like Chef::Knife::Cloud::Command, Chef::Knife::Cloud::OpenstackGroupList.new

  let (:instance) {Chef::Knife::Cloud::OpenstackGroupList.new}

  context "#validate!" do
    before(:each) do
      Chef::Config[:knife][:openstack_username] = "testuser"
      Chef::Config[:knife][:openstack_password] = "testpassword"
      Chef::Config[:knife][:openstack_auth_url] = "tsturl"
      instance.stub(:exit)
    end

    it "validate openstack mandatory options" do
      expect {instance.validate!}.to_not raise_error
    end

    it "raise error on openstack_username missing" do
      Chef::Config[:knife].delete(:openstack_username)
      instance.ui.should_receive(:error).with("You did not provide a valid 'Openstack Username' value.")
      expect { instance.validate! }.to raise_error(Chef::Knife::Cloud::CloudExceptions::ValidationError)
    end

    it "raise error on openstack_password missing" do
      Chef::Config[:knife].delete(:openstack_password)
      instance.ui.should_receive(:error).with("You did not provide a valid 'Openstack Password' value.")
      expect { instance.validate! }.to raise_error(Chef::Knife::Cloud::CloudExceptions::ValidationError)
    end

    it "raise error on openstack_auth_url missing" do
      Chef::Config[:knife].delete(:openstack_auth_url)
      instance.ui.should_receive(:error).with("You did not provide a valid 'Openstack Auth Url' value.")
      expect { instance.validate! }.to raise_error(Chef::Knife::Cloud::CloudExceptions::ValidationError)
    end
  end

  context "#list" do
    before(:each) do
      @security_groups = [TestResource.new({ "name" => "Unrestricted","description" => "testdescription", "security_group_rules" => [TestResource.new({"from_port"=>636, "group"=>{}, "ip_protocol"=>"tcp", "to_port"=>636, "parent_group_id"=>14, "ip_range"=>{"cidr"=>"0.0.0.0/0"}, "id"=>183})]})]
    end

    it "returns group list" do
      instance.ui.should_receive(:list).with(["Name", "Protocol", "From", "To", "CIDR", "Description", "Unrestricted", "tcp", "636", "636", "0.0.0.0/0", "testdescription"],:uneven_columns_across, 6)
      instance.list(@security_groups)
    end
  end
end
