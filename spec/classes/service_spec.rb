require 'spec_helper'

describe 'sssd::service' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts){ os_facts }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to create_class('sssd::service') }
          unless  os_facts[:init_systems].include?('systemd')
            it { is_expected.to contain_file('/etc/init.d/sssd').with({
              :ensure  => 'file',
              :source  => 'puppet:///modules/sssd/sssd.sysinit',
              :notify  => 'Service[sssd]'
              })
            }
          end

          it { is_expected.to contain_service('nscd').with({
              :ensure => 'stopped',
              :enable => false,
              :notify => 'Service[sssd]'
            })
          }

          it { is_expected.to contain_service('sssd').with({
              :ensure => 'running',
              :enable => true
            })
          }
      end
    end
  end
end
