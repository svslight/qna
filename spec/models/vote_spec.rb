require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :author }

  it { should validate_inclusion_of(:state).in_array([1, -1]) }


  it "has the module Authorable" do
    expect(described_class.include?(Authorable)).to eq true
  end

  describe "associations" do
    subject { FactoryBot.create(:vote) }
    it { should validate_uniqueness_of(:author_id).scoped_to([:votable_type, :votable_id]).case_insensitive }
  end

  describe '#twice?' do
    let!(:vote) { create(:vote) }

    it do
      expect(vote.twice?(vote.state)).to eq true
      vote.state = nil
      expect(vote.twice?(true)).to eq false
    end
  end

  describe '#voting(state)' do

    it "saved new vote" do
      vote = Vote.new(author: create(:user), votable: create(:question))
      expect { vote.voting(1) }.to change { Vote.count }.from(0).to(1)
      expect(Vote.all.first.state).to eq 1
    end

    it "changes the vote to opposite" do
      vote = Vote.create(author: create(:user), votable: create(:question), state: -1)
      expect { vote.voting(1) }.to change { vote.reload.state }.from(-1).to(1)
    end

    it "deletes a vote if same has already been" do
      vote = Vote.create(author: create(:user), votable: create(:question), state: 1)
      expect { vote.voting(1) }.to change { Vote.count }.from(1).to(0)
    end
  end
end
