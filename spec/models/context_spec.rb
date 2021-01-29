require 'spec_helper'

RSpec.describe Context do
  describe 'initialization' do
    it 'allows keyword init' do
      context = Context.new user: double(:user)
      expect(context.user).to be_present
    end

    it 'allows args to be omitted' do
      context = Context.new
      expect(context.user).to be_nil
    end
  end

  describe 'lazy, memoized, overridable readers' do
    let(:current_settings) { double :current_settings }
    let(:system_setting) { class_double('SystemSetting').as_stubbed_const }
    let(:context) { Context.new }

    it 'is lazy' do
      expect(system_setting).to receive(:current_settings) { current_settings }
      expect(context.system_settings).to be current_settings
    end

    it 'is memoized' do
      expect(system_setting).to receive(:current_settings).once { current_settings }
      context.system_settings
      context.system_settings
    end

    it 'can be overriden' do
      expect(system_setting).to receive(:current_settings).never
      context.system_settings = double(:override)
      context.system_settings
    end
  end

  describe 'can_admin?' do
    let(:context) { Context.new user: user, admin_param: admin_param }

    subject { context.can_admin? }

    context 'sysadmin' do
      let(:user) { instance_double 'User', admin_role?: false, sys_admin_role?: true }

      context '?admin not overriden' do
        let(:admin_param) { nil }
        it { is_expected.to be true }
      end

      context '?admin=false' do
        let(:admin_param) { 'false' }
        it { is_expected.to be false }
      end
    end

    context 'admin' do
      let(:user) { instance_double 'User', admin_role?: true, sys_admin_role?: false }

      context '?admin not overriden' do
        let(:admin_param) { nil }
        it { is_expected.to be true }
      end

      context '?admin=false' do
        let(:admin_param) { 'false' }
        it { is_expected.to be false }
      end
    end

    context 'neighbor' do
      let(:user) { instance_double 'User', admin_role?: false, sys_admin_role?: false }

      context '?admin not overriden' do
        let(:admin_param) { nil }
        it { is_expected.to be false }
      end

      context '?admin=false' do
        let(:admin_param) { 'false' }
        it { is_expected.to be false }
      end
    end

    context 'guest' do
      let(:user) { nil }

      context '?admin not overriden' do
        let(:admin_param) { nil }
        it { is_expected.to be_falsey }
      end

      context '?admin=false' do
        let(:admin_param) { 'false' }
        it { is_expected.to be_falsey }
      end
    end
  end
end
