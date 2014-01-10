require 'spec_helper'

describe 'epylog' do
  
  it { should contain_package('epylog') }
  
  it { should contain_file('/etc/epylog/epylog.conf') }
  
  it { should contain_file('/etc/cron.daily/epylog.cron') }
  
  it { should contain_file('/etc/epylog/weed_local.cf') }
  
end

