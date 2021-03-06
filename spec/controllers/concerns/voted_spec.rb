require 'rails_helper'

class MoviesController < ApplicationController
end

RSpec.describe Voted, type: :controller do

  with_model :Movie do
    table do |t|
      t.integer :author_id
    end

    model do
      include Votable
      belongs_to :author, class_name: "User"
    end
  end

  controller MoviesController do
    include Voted
    skip_authorization_check
  end

  before do
    routes.draw { patch :vote, to: "movies#vote"}
  end

  describe 'PATCH #vote' do
    let(:user) { create(:user) }
    let(:author) { create(:user) }
    let(:anon) { Movie.create!(author: author) }
    let(:voting) { patch :vote, params: { id: anon.id, vote: 1 }, format: :json }


    context 'by non-author voted resource' do
      before  { login(user) }

      it 'saves a new vote to given resource to DB' do
        expect { voting }.to change(anon.votes, :count).by(1)
      end

      it 'saves a new vote to logged user' do
        expect { voting }.to change(user.author_votes, :count).by(1)
      end

      it 'un-vote (twice same vote) should be delete vote' do
        anon.votes.create!(author: user, state: 1)
        expect { voting }.to change(Vote,	:count).by(-1)
      end

      it 'response should be json' do
        voting
        expect( response.header['Content-Type'] ).to include 'application/json'
      end

    end

    context 'by author voted resource' do
      before  { login(author) }

      it 'does not change votes count' do
        expect { voting }.to_not change(Vote, :count)
      end

      it 'response status should be 422' do
        voting
        expect( response.status ).to eq(422)
      end
    end

  end
end
