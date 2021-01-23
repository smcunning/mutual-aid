require 'rails_helper'

RSpec.describe GlossaryPolicy do
  subject { GlossaryPolicy.new(user, :glossary) }
  let(:sys_admin) { FactoryBot.create(:user, :sys_admin) }
  let(:dispatcher) { FactoryBot.create(:user, :dispatcher) }

  context "user can edit glossary if they are" do
    context "an admin" do
      let(:user) { FactoryBot.create(:user, :admin) }
      it { is_expected.to permit_action(:update) }
    end

    context "a sys_admin" do
      let(:user) { FactoryBot.create(:user, :sys_admin) }
      it { is_expected.to permit_action(:update) }
    end

    context "a dispatcher" do
      let(:user) { FactoryBot.create(:user, :dispatcher) }
      it { is_expected.to permit_action(:update) }
    end
  end

  context "user cannot edit glossary if they are" do
    context "a neighbor" do
      let(:user) { FactoryBot.create(:user, :neighbor) }
      it { is_expected.not_to permit_action(:update) }
    end

    context "a volunteer" do
      let(:user) { FactoryBot.create(:user, :volunteer) }
      it { is_expected.not_to permit_action(:update) }
    end

    context "not logged in" do
      let(:user) { nil }
      it { is_expected.not_to permit_action(:update) }
    end
  end
end