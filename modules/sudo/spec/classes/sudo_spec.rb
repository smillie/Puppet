require 'spec_helper'

describe 'sudo' do
  
  context 'debian' do
    let(:facts) { {:operatingsystem => 'Debian'} }
        
    it { should contain_package('sudo') }
    
    it do
      should contain_file('/etc/sudoers') \
      .with_content(/\/usr\/local\/sbin:\/usr\/local\/bin:\/usr\/sbin:\/usr\/bin:\/sbin:\/bin/)
    end
  end
  
  context 'centos' do
    let(:facts) { {:operatingsystem => 'CentOS'} }
    
    it do
      should contain_file('/etc/sudoers') \
        .with_content(/\/sbin:\/bin:\/usr\/sbin:\/usr\/bin/)
    end
  end
  
  context 'with sepcified sudoers' do
    let(:facts) { {:operatingsystem => 'CentOS'} }
    let(:params) { {:sudoers => '%group1'} }
    
    it do
      should contain_file('/etc/sudoers') \
        .with_content(/%group1 ALL=\(ALL:ALL\) ALL/)
    end
  end
  
end

